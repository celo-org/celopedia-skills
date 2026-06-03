# Wallet Fork Patterns on Celo

> Source: Celo wallet integration notes
> Last updated: 2026-06-03

Patterns and gotchas that recur when shipping a Celo wallet **forked from Valora**, especially around adding new tokens before upstream backends catch up.

---

## USAT price feed gap

USAT (Tether America USD, `0xD2ab3C9A02DBBAB236BfEC45D1d755DF4267F771`) launched on Celo April 2026. Token is verified on-chain (symbol `USAT`, decimals 6) and the address is already in Valora's `address-metadata` JSON, but **no upstream price oracle indexes the Celo contract address**. The result: USAT silently disappears from display in any Valora-derived wallet.

### Symptom

Any wallet that consumes `https://api.mainnet.valora.xyz/getTokensInfoWithPrices` returns:

```json
{
  "address": "0xD2ab3C9A02DBBAB236BfEC45D1d755DF4267F771",
  "symbol": "USAT",
  "decimals": 6,
  "priceUsd": "NaN"
}
```

Wallet token selectors typically filter out tokens with `priceUsd == NaN`, so USAT disappears even when the user has a real balance.

### Root cause: no upstream feed maps the Celo contract

Audit of available price sources (snapshot 2026-06-03):

| Source | Has USAT? | Indexes Celo contract? | Endpoint | Notes |
|---|---|---|---|---|
| Valora backend (`api.mainnet.valora.xyz`) | yes (metadata) | yes | `getTokensInfoWithPrices` | returns `priceUsd: NaN` because upstream lookup fails |
| CoinGecko free tier | yes (coin id `usa`) | **no, only Ethereum contract** | `api.coingecko.com/api/v3/simple/price?ids=usa&vs_currencies=usd` | $0.998 at audit time; rate-limited at 10-30 calls/min |
| CoinMarketCap public data API | yes (slug `tether-usat`) | partial | `api.coinmarketcap.com/data-api/v3/.../latest?slug=tether-usat` | undocumented public API, may break |
| DefiLlama (`coins.llama.fi`) | no | Ethereum only | n/a | does not know the Celo contract |
| Mento | no | n/a | n/a | USAT is not a Mento stable |
| MEXC CEX | yes (USAT/USDT pair, ~$58k/day vol) | n/a | scraping / WS | not viable as a wallet feed |

The Valora `priceUsd: NaN` is downstream of CoinGecko: Valora's price service queries by `{chain}:{contract}` and CoinGecko only indexes the Ethereum contract for coin id `usa`. Until CoinGecko (or another oracle Valora consumes) adds the Celo address, the gap remains.

### Wallet-side workaround

For USD-pegged stablecoins regulated under the GENIUS Act (USAT is backed by short-term T-bills + cash, supervised by Anchorage Digital), real price is ~$0.998, within ~0.2% of `1.00`. Acceptable rounding error for balance display.

Post-process the Valora backend response on the wallet side:

```ts
// Hardcode priceUsd = 1.00 for known USD-pegged stables when upstream returns NaN.
// Remove each entry when the upstream gap closes (see wallet-fork-patterns.md).
const USD_PEGGED_FALLBACK: Record<string, string> = {
  '0xD2ab3C9A02DBBAB236BfEC45D1d755DF4267F771': '1.00', // USAT, CoinGecko coin id 'usa' lacks Celo contract
};

function patchUsdPeggedNaN(tokens: Token[]): Token[] {
  return tokens.map(t => {
    if (t.priceUsd === 'NaN' && USD_PEGGED_FALLBACK[t.address]) {
      return { ...t, priceUsd: USD_PEGGED_FALLBACK[t.address] };
    }
    return t;
  });
}
```

Tag the hardcoded address with a TODO referencing this file so the entry is removed when upstream resolves.

### Upstream fix paths (highest leverage first)

1. **CoinGecko coin-update request**: ask CoinGecko to add the Celo contract `0xD2ab3C9A02DBBAB236BfEC45D1d755DF4267F771` to coin id `usa` (currently only Ethereum is indexed). Form: https://www.coingecko.com/en/coins_form -> "Update existing coin". **This unblocks all Valora-forked wallets at once** since most price backends consume CoinGecko by `{chain}:{contract}`.
2. **Valora wallet issue**: file at https://github.com/valora-xyz/wallet/issues asking which upstream oracle is expected to cover USAT. Frame as: "USAT in address-metadata returns NaN in `getTokensInfoWithPrices`, which price source is missing?".
3. **Celo Forum**: https://forum.celo.org under Builders/Wallets, for ecosystem-wide visibility across Mento, RedStone-Celo, Pyth-Celo, and wallet teams. Useful when the same gap pattern affects more than one wallet/token.

---

## Generalizable pre-flight: any Valora-fork wallet adding a new Celo token

The USAT gap will recur as new stablecoins and tokens ship on Celo. The recurring pattern: token deploys, wallet wants to display balances, upstream price oracle has not indexed the Celo contract yet.

Pre-flight checklist before integrating any new token:

1. **Token metadata in Valora's `address-metadata`**: check https://github.com/valora-xyz/address-metadata/blob/main/src/data/mainnet/celo-tokens-info.json. If missing entirely, open a PR. Maintainers explicitly do not promise review timing.
2. **Price feed in Valora backend**: `curl https://api.mainnet.valora.xyz/getTokensInfoWithPrices | jq '.["<chainPrefix>:<address>"]'`. If `priceUsd: NaN` or missing, upstream oracle gap (see USAT pattern above).
3. **CoinGecko Celo contract indexing**: `curl https://api.coingecko.com/api/v3/coins/<slug>` and look for `platforms.celo`. Common gap: coin exists but only `platforms.ethereum` is populated. File a CoinGecko coin-update request.
4. **Plan the wallet-side workaround** for the window between deployment and upstream indexing:
   - USD-pegged stablecoin: hardcode `1.00` (rounding error under 0.2%).
   - Non-USD stablecoin or volatile token: derive price from an on-chain Uniswap V3 pool (read tick and compute spot) or skip display until upstream resolves.

---

## Other recurring wallet-fork constraints (snapshot)

Reference list of upstream-controlled surfaces that any Valora-fork wallet inherits and cannot diverge from without forking the backend:

- **Token list source**: `valora-xyz/address-metadata` (community-maintained JSON, no SLA on PR review).
- **Price/metadata feed**: `api.mainnet.valora.xyz/getTokensInfoWithPrices` (closed-source backend; no control over which upstream oracles it queries).
- **Dapp list source**: `valora-xyz/dapp-list` (also community-maintained JSON).
- **NFT list source**: `valora-xyz/nft-list`.
- **OFAC SDN address list**: `valora-xyz/ofac-sdn-list` (filtering compliance, shared across all forks).

When upstream needs more than a metadata PR (e.g. a missing price source, a backend bug), the fork wallet has two options: implement a wallet-side patch like the USAT example above, or stand up its own backend service mirroring the Valora API shape. The patch path is almost always cheaper for one-off gaps.
