# Ripio wFIAT on Celo — how to get each token, bridges, and yield

> Sources: on-chain reads (forno.celo.org, Blockscout), ramp.ripio.com API, bridge.ripio.com/developers,
> Textile RFQ API, LI.FI, GeckoTerminal / DexScreener, DefiLlama, Morpho API, BCRA API
> Last verified: 2026-10-21
>
> **Liquidity figures change daily — sometimes hourly.** Re-run the commands in _Re-verify_ before
> telling a builder a route works for a given size. Addresses are in `contracts.md`.

The six Ripio wFIAT tokens (wARS, wBRL, wMXN, wCOP, wPEN, wCLP) share one address on every EVM chain
and have 18 decimals. Getting them **on Celo** is uneven: two are easy, one is Textile-only, and three
have no market on Celo at all.

---

## Quick answer by token

| Token | Easiest way on Celo | Works from anywhere? | Notes |
|---|---|---|---|
| wARS | Swap USDT/USDC/USAT → wARS (Uniswap, Sushi, via LI.FI / Jumper) | Yes | LI.FI: 10 USDT → ~16,122 wARS (Sushi). Textile buy side is shallow (tens of USDT) |
| wBRL | Swap on Uniswap / LI.FI, or Textile | Yes | Textile buy side up to ~87k USDT |
| wCOP | Textile (USDT → wCOP) | Yes | Not in Textile's address-book docs but live in its RFQ API; up to ~5.1k USDT. No DEX pool, no LI.FI route |
| wMXN | Ripio Ramp (MX/AR/BR/CO + KYC) or Ripio Bridge from another chain | No | Textile pair listed with **zero** buy depth; no DEX pool on Celo |
| wPEN | Ripio Ramp or Ripio Bridge | No | Ramp is not sold in Peru; ~$1.5k of liquidity on any chain (Ethereum) |
| wCLP | Ripio Ramp or Ripio Bridge | No | Ramp is not sold in Chile; <$7k per pool on Ethereum/BSC/Base/Polygon |

**Builder outside LatAm:** buy USDT on an exchange → send to Celo (Layerswap supports
exchange → Celo directly) → swap to wARS / wBRL (DEX) or wCOP / wBRL (Textile). There is no
realistic path to wMXN, wPEN, or wCLP without a LatAm bank account or existing holdings on another chain.

**Demo amounts:** the Google Cloud Web3 faucet gives USAT on Celo mainnet after a one-time Self
verification; 1 USAT swaps to ~1,615 wARS via LI.FI.

Supply snapshot on Celo (2026-10-21): wARS ~281M (~$173k), wBRL ~3.85M (~$760k), wCOP ~34.5M (~$11k),
wCLP ~1.0M (~$1k), wMXN ~13.2k (~$725), wPEN ~603 (~$180). For wMXN, wPEN, and wCLP every pool on every
chain is under ~$8k with near-zero volume — tell builders to use small amounts.

---

## Paths in detail

### Textile (permissionless onchain FX)

- RFQ marketplace on Celo: quote an **exact size**, makers fill within ~60 s. **No partial fills** — if
  no maker covers the full size you get no quote; retry smaller. Taker fee 1 bps. Pay with USDT.
- Live Celo pairs vs USDT (RFQ API, 2026-10-21): wARS, wBRL, wCOP, cNGN, USDC, USAT, CELO, EURm and
  others. wMXN is listed with zero buy depth. wPEN and wCLP are absent.
- Most wFIAT depth comes from one maker wallet, so available size moves day to day.
- App: https://app.textilecredit.com · Docs: https://docs.textilecredit.com

### DEX swaps on Celo (Uniswap, Sushi, via LI.FI)

- Uniswap v3 wARS/USDT 0.01%: `0x5D8ef8B839be522b9E3d60a51EDB5837CD0b2391` (~$108k TVL)
- Uniswap v3 wBRL/USDT 0.01%: `0x01c3cf91cdf7B34181C7eC8566c0236951FEA40F` (~$29k TVL)
- Uniswap v4 wARS/USDC and USDC/wBRL pools exist with larger TVL and low volume.
- LI.FI returns same-chain routes into wARS and wBRL only; **no route** for wMXN, wCOP, wPEN, wCLP.

### Ripio Ramp widget (fiat ↔ wFIAT)

- URL: `https://ramp.ripio.com/?country=AR&chain=42220&token=WARS&amount=10000&address=0x...`
  (off-ramp: `https://ramp.ripio.com/off-ramp`).
- **"No credentials needed" applies to the builder, not the buyer.** The end user completes KYC with
  Ripio (Sumsub, ID + liveness selfie) and pays through a local rail. This is the most common source of
  confusion.
- Countries: **AR, BR, MX, CO only** (`/api/countries`). Peru and Chile return `Country not supported`.
- Celo is offered in all four countries with CELO, USDC, USDT and all six wFIAT.
- Pay-in: AR CVU / Mercado Pago · BR PIX · MX SPEI/CLABE · CO PSE, Bre-B, Bancolombia/Nequi.
- Not a realistic route for non-residents: it needs a local payment account and matching ID.

### Ripio Ramps API (businesses)

REST API (OAuth2) for companies embedding on/off-ramps for their own customers; same four countries and
same per-customer KYC. Access via https://platform.ripio.com. For hackathons, use the widget URL instead.
Docs: https://docs.ripio.com/ramps-api/overview/introduction

### Ripio app (retail exchange)

Operates in AR, BR, MX, CL, CO, Uruguay, Spain, US with country-bound KYC. Many Argentine builders buy
wARS here. **Unverified:** whether the app withdraws each wFIAT directly to Celo — confirm with Ripio
before recommending it as a Celo route.

---

## Bridges

### Ripio Bridge — the only bridge that moves wFIAT between chains

- https://bridge.ripio.com · developer docs: https://bridge.ripio.com/developers
- Issuer-run **burn-and-mint** (not CCIP/LayerZero/Hyperlane): call
  `depositForBridge(token, amount, destChainId, recipient, clientDepositId)` on BridgeDeposit
  `0x465e642387d3d73a57CDc1368fFA53A800bA5D47` (same address on every chain); Ripio mints on the
  destination after finality. ~15 minutes. Wallet only, no KYC mentioned.
- Chains: Ethereum, Base, World Chain, BSC, Polygon, Gnosis, Celo, HyperEVM (wARS/wBRL only), Arc.
  Routes into Celo confirmed on-chain from Ethereum, Base, and BSC.
- Fixed fee per route, taken from the amount (on-chain `routeConfigs`):

  | Token | To L2s / sidechains | To Ethereum |
  |---|---|---|
  | wARS | 15 | 1,500 |
  | wBRL | 0.08 | 8 |
  | wMXN | 0.27 | 27 |
  | wCOP | 57 | 5,700 |
  | wPEN | 0.05 | 5 |
  | wCLP | 13 | 1,300 |

  Roughly $0.01 to an L2 and $1 to Ethereum. Daily mint cap per token per chain; deposits above it queue.
- Status: `GET https://bridge.ripio.com/api/operations/{txHash}?chainId=<id>`

### General bridges into Celo (stablecoins only, no wFIAT)

| Bridge | Moves to Celo | Use it for |
|---|---|---|
| Layerswap | USDT, USDC, USAT, CELO | Direct from Binance, OKX, Bybit, Coinbase, Kraken and other exchanges — best for non-LatAm builders |
| LayerZero / Stargate | USDT (Celo USDT is USDT0), USAT, CELO | USDT from any USDT0 chain |
| LI.FI / Jumper | Stablecoins cross-chain + swap into wARS/wBRL on Celo | One-step bridge + swap |
| Squid | USDT, USDC, USAT, Mento tokens, BRLA | Cross-chain swaps |
| Relay | USDC, CELO | Fast USDC |
| Superbridge | Native OP Stack bridge from Ethereum | ETH-side assets |

Across has no Celo routes. Full list: https://docs.celo.org/tooling/bridges/bridges

---

## Yield on wFIAT

**No protocol on Celo pays meaningful yield on any wFIAT today.**

- Aave v3 on Celo lists only USDC, USDT, WETH, USDm, CELO, EURm (`getReservesList` on Pool
  `0x3E59A31363E2ad014dcbc521c4a0d5757d9f3402`).
- Morpho has no wFIAT markets or vaults on Celo.
- Uniswap v3 wARS/USDT LP on Celo: ~0.04% APY (DefiLlama).
- **CapyFi is not deployed on Celo.** It is a Compound v2 fork on Ethereum, Base, World Chain, and
  LaChain (https://docs.capyfi.com/networks); its contracts have no code on Celo and its app configures
  chains 1, 480, 8453 only. Treat "CapyFi on Celo" claims as planned until a deployment appears.

Where wARS yield exists (2026-10-21):

| Chain | Protocol | APY | Size | Driver |
|---|---|---|---|---|
| Ethereum | Morpho vault "KPK wARS Yield" `0xb5ce3CA2C774b72955C25875022FdD91f7a7B938` | ~24.5% | ~$6.3M | ~0.1% organic + Merkl rewards renewed every ~3 days by an unidentified funder |
| Ethereum | CapyFi caWARS `0xf80eeec09f417Fa7FCc4A848Ef03af9dF2658d7B` | ~12.7% | ~$507k supplied | Organic borrow demand (60% utilization) |
| Ethereum | Morpho market wARS/USDC | ~11.9% | ~$52k | Organic |
| World Chain | Morpho "Re7 WARS" | ~26% | ~$120k | Mostly WLD rewards |
| Base | CapyFi caWARS | ~1.7% | ~$30k | Low utilization |

wBRL earns ~0.16% on CapyFi; other wFIAT have no yield venue of meaningful size.

CapyFi notes: caTokens (8 decimals); supply = `approve` + `mint(amount)`, withdraw =
`redeemUnderlying(amount)`; wARS/wBRL collateral factor is 0 (lend only); oracle is Chainlink's ARS/USD
fiat feed (a wARS de-peg is invisible to it); admin is a 4-of-7 Safe that can enable a whitelist.

**Benchmarks to show users (BCRA, 2026-10-19):** CPI 33.4% YoY (1.9% in September), plazo fijo 30 days
~21.2% TNA. Both wARS yields sit below inflation and bank deposits — never present wARS yield as an
inflation hedge.

### Pattern: a Celo wFIAT product with a yield sleeve

1. Keep user balances and payments on Celo; hold a Celo buffer sized for expected redemptions (the Celo
   wARS pool is only ~$110k).
2. Bridge treasury capital Celo → Ethereum with the Ripio Bridge (~15 min, 1,500 wARS fee).
3. On Ethereum, a Safe/smart account supplies to the Morpho KPK vault (ERC-4626 `deposit`/`redeem`) and
   CapyFi caWARS (keep under ~10% of the market; check `getCash()` before withdrawing).
4. Rebalance from CapyFi `supplyRatePerBlock` and Morpho `netApy`; claim Merkl rewards on a schedule.
5. Withdraw → bridge back (round trip ~30 min).

Risks: reward subsidy can drop to ~0.1% at any renewal; small markets can lock withdrawals above the
80% utilization kink; wARS is upgradeable with pause/blocklist roles; the bridge is Ripio-operated;
reserves sit in Argentine banks without deposit insurance.

---

## x402

The hosted Celo facilitator lists **all six wFIAT** as Permit2 assets (verified 2026-10-21 via
`/supported`). See `ai-agents.md` → x402 for integration.

---

## Re-verify

```bash
# x402 assets
curl -s https://api.x402.celo.org/supported | jq -r '[.kinds[]|select(.network=="eip155:42220")|.extra.supportedAssets[]|"\(.symbol):\(.assetTransferMethod)"]|unique|join(" ")'

# Ripio Ramp countries and Celo tokens per country
curl -s https://ramp.ripio.com/api/countries | jq -r '.countries[].code'
curl -s https://ramp.ripio.com/api/countries/AR/networks

# Textile Celo depth (sellToken -> buyToken, maxSellAmount in sellToken base units)
curl -s "https://api.textilecredit.com/v2/rfq/levels?chainId=42220" | jq -r '.data.pairs[] | "\(.sellToken) -> \(.buyToken) max=\(.maxSellAmount)"'

# DEX pools for a token on Celo
curl -s https://api.geckoterminal.com/api/v2/networks/celo/tokens/0x0dc4f92879b7670e5f4e4e6e3c801d229129d90d/pools

# Same-chain route USDT -> wARS (10 USDT)
curl -s "https://li.quest/v1/quote?fromChain=42220&toChain=42220&fromToken=0x48065fbBE25f71C9282ddf5e1cD6D6A887483D5e&toToken=0x0dc4f92879b7670e5f4e4e6e3c801d229129d90d&fromAmount=10000000&fromAddress=0x000000000000000000000000000000000000dEaD" | jq '{tool, toAmount: .estimate.toAmount}'

# wFIAT yield pools across chains
curl -s https://yields.llama.fi/pools | jq '[.data[] | select(.symbol | test("WARS|WBRL|WMXN|WCOP|WPEN|WCLP"))] | map({chain, project, symbol, apy, tvlUsd})'

# CapyFi on Celo? (empty "0x" = not deployed)
curl -s -X POST https://forno.celo.org -H 'content-type: application/json' -d '{"jsonrpc":"2.0","id":1,"method":"eth_getCode","params":["0x0b9af1fd73885aD52680A1aeAa7A3f17AC702afA","latest"]}'
```
