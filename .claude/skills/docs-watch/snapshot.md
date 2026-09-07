# docs-watch snapshot — facts we depend on

Baseline seeded: 2026-07-07 (from the repo's own reference files, not a fresh
live fetch — their own "Last updated" stamp is 2026-04-15, so treat this
snapshot as unverified against live sources until the first real run).

Last attempt: 2026-09-07 — PARTIAL BLOCK (celopg.eco: 403, org egress policy
denial — same failure mode as the 2026-08-24 run — see PR for the
docs-watch/2026-09-07 branch). Sources 1-4 (docs sitemap, contracts,
network info, DefiLlama TVL) were reachable and verified; source 5 (grant
programs) was not — `grants-funding.md` and its section below were left
untouched this run (note: it was refreshed independently of this skill by
PR #60 on 2026-08-06, so it isn't as stale as the "not verified since"
framing below might suggest).

## 1. Docs sitemap (`docs-map.md`)

- Source: `docs.celo.org/llms.txt`
- Last verified: 2026-09-07
- ~224 pages total (down from ~264 two weeks ago, but that's a restructure,
  not real shrinkage) — another major restructuring: the `infra-partners/*`
  prefix (notices + operators) was renamed to `operate/*`, and `specs/*`
  was renamed to `operate/specification/*`. The entire `/legacy/` tree
  added just two weeks ago (~40 pre-L2 pages) is gone again — "Legacy
  Overview"/"Legacy L1 Architecture" look superseded by a new "About Celo
  L1" page (`home/celo-l1`), "Cel2 FAQ" moved to `operate/operators/faq`,
  but "What's Changed? (L1→L2)" and the rest of the unenumerated pre-L2
  tree have no found replacement — treat as gone, not moved. Also: MiniPay
  quickstart/code-library/deeplinks/ngrok-setup pages collapsed into the
  Overview page; a new 7-page `home/protocol/staking/*` subsection; new
  AI pages (Self Agent ID, Celina); new `build-with-usat` and
  `build-on-socialconnect` pages; `tooling/dev-environments/thirdweb/
  overview` renamed to `.../thirdweb` and absorbed the standalone
  "Thirdweb SDK" page; "Regional DAOs" removed.

## 2. Contract addresses (`contracts.md`)

- Source: `docs.celo.org/tooling/contracts/*`
- Last verified: 2026-09-07
- Core protocol contracts (mainnet + Sepolia testnet), all Mento
  stablecoins, all external stablecoins/tokens, Uniswap V4 (mainnet),
  Uniswap V3 (mainnet + Alfajores testnet), and all L1 contracts (mainnet +
  the previously-tracked Sepolia subset) verified byte-for-byte unchanged.
- Registry address: `0x000000000000000000000000000000000000ce10` — unchanged
- **New this run**: Uniswap V4 has been deployed to Celo Sepolia testnet
  (wasn't there before) — added its 7-contract table to `contracts.md`.
- **Still flagged, not fixed** (needs review, carried over unchanged from
  2026-08-24 — see PR): on Celo Sepolia testnet, the live
  `stablecoin-contracts` page still lists USDm/EURm at different addresses
  than the Registry's `StableToken`/`StableTokenEUR` entries (which still
  resolve to the *legacy* cUSD/cEUR addresses). Unresolved; do not trust
  `contracts.md`'s testnet USDm/EURm rows until a human resolves this.

## 3. Network info (`network-info.md`)

- Source: `docs.celo.org/build-on-celo/network-overview`
- Last verified: 2026-09-07
- Mainnet chain ID: `42220`; Sepolia testnet chain ID: `11142220` — unchanged
- Public RPC: `https://forno.celo.org` — unchanged
- Mainnet fee-currency allowlist (20 tokens) and all `feeCurrency` adapter
  addresses verified unchanged, including the WETH/XAUt0/USAT tokens added
  last run. `builder-guide.md`'s stale fee-currency table remains
  out-of-scope/unedited (still flagged for follow-up, unchanged).
- `FeeCurrencyDirectory`: `0x15F344b9E6c3Cb6F0376A36A64928b13F62C6276` — unchanged

## 4. Ecosystem / TVL (`ecosystem.md`)

- Source: DefiLlama (`api.llama.fi/protocols`), docs.celo.org, celo.org/ecosystem
- Last verified: 2026-09-07
- All previously-tracked protocols still present on Celo per DefiLlama,
  modulo DefiLlama's own category relabeling (e.g. Feather: "Lending" →
  "Risk Curators"; PoolTogether V3: "Other" → "Yield Lottery") — cosmetic,
  no action. Moola Market (`moola.market` / `mm.moola.market`) is still
  unreachable (curl: connection failure) despite nonzero DefiLlama TVL —
  same unresolved state as 2026-08-24, still not added.
- **New DefiLlama indexing quirk**: "Tether Gold" no longer lists Celo among
  its DefiLlama chains (same pattern as the existing Uniswap V4 note) — but
  XAUt0 is confirmed live on Celo mainnet as a fee currency
  (`contracts.md`/`network-info.md`), so treated as an indexing gap, not a
  real removal. Documented in `ecosystem.md`; no table changes made.
- Did not add any of the many sub-$1M-TVL long-tail protocols DefiLlama
  lists on Celo (Textile FX, Mobius Money, AutoRange, Symmetric, Ubeswap V3,
  DONASWAP V2, YieldWolf, Magik Farm, Numoen, ImmortalX, etc.) — consistent
  with this file's existing curated-not-exhaustive scope.

## 5. Grant programs (`grants-funding.md`)

- Source: `www.celopg.eco/programs` (status changes frequently — this file
  is explicitly a stale-prone cache per its own header)
- **Not verified this run** — `celopg.eco` returned a 403 from the sandbox's
  org egress policy (not the site itself); confirmed via both WebFetch
  (EGRESS_BLOCKED) and raw curl (`connect_rejected`, org policy) — see PR
  docs-watch/2026-09-07.
- File content unchanged from its 2026-08-06 refresh (PR #60, outside this
  skill's own run history) — not re-verified here. Re-check status on the
  next run once celopg.eco is reachable from this sandbox.
