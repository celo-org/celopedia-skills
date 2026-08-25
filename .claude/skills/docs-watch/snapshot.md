# docs-watch snapshot — facts we depend on

Baseline seeded: 2026-07-07 (from the repo's own reference files, not a fresh
live fetch — their own "Last updated" stamp is 2026-04-15, so treat this
snapshot as unverified against live sources until the first real run).

Last attempt: 2026-08-24 — PARTIAL BLOCK (celopg.eco: 403, org egress policy
denial — see PR for the run's docs-watch/2026-08-24 branch). Sources 1-4
(docs sitemap, contracts, network info, DefiLlama TVL) were reachable and
verified; source 5 (grant programs) was not — `grants-funding.md` and its
section below were left untouched this run.

## 1. Docs sitemap (`docs-map.md`)

- Source: `docs.celo.org/llms.txt`
- Last verified: 2026-08-24
- ~264 pages total as of last count (up from ~150) — major restructuring:
  new top-level `/specs/` section (15 pages), new `/legacy/` tree (~40
  pages, pre-L2 docs), Fee Abstraction split into its own 3-page subsection
  under `build-on-celo/fee-abstraction/*` (was one page under
  `tooling/overview/fee-abstraction`, now removed), `tooling/contracts/
  token-contracts` renamed to `stablecoin-contracts`, new `fee-currencies`
  contracts page, `infra-partners/notices/*` hardfork pages moved under an
  `archive/` prefix, `infra-partners/integration/*` subtree removed
  entirely, Celo CLI gained an 18-page subcommand reference, MultiBaas dev
  environment added, new AI pages (Use Docs with AI, MPP, Celopedia).
  "Agent Skills", "Code of Conduct", "Exchange Assets", and the standalone
  "Faucet" tooling page were removed from the sitemap.

## 2. Contract addresses (`contracts.md`)

- Source: `docs.celo.org/tooling/contracts/*`
- Last verified: 2026-08-24
- Core protocol contracts (mainnet): 20 tracked — all addresses verified
  unchanged against `core-contracts`, `stablecoin-contracts`, `l1-contracts`,
  `uniswap-contracts`.
- Registry address: `0x000000000000000000000000000000000000ce10`
- Mento stablecoins tracked: 15 (USDm, EURm, BRLm, XOFm, KESm, NGNm, COPm,
  GBPm, CHFm, JPYm, AUDm, CADm, GHSm, PHPm, ZARm) — all mainnet + testnet
  addresses verified unchanged, **except** flagged below.
- **Flagged, not fixed** (needs review — see PR): on Celo Sepolia testnet,
  the live `stablecoin-contracts` page now lists USDm and EURm at different
  addresses than our cached testnet table (which match the *legacy* cUSD/
  cEUR addresses, also still live under those legacy names). Do not trust
  `contracts.md`'s testnet USDm/EURm rows until a human resolves this.

## 3. Network info (`network-info.md`)

- Source: `docs.celo.org/build-on-celo/network-overview`
- Last verified: 2026-08-24
- Mainnet chain ID: `42220`; Sepolia testnet chain ID: `11142220` — unchanged
- Public RPC: `https://forno.celo.org` — unchanged
- Fee-currency (gas abstraction) tokens: mechanically expanded — WETH and
  XAUt0 (Tether Gold) added as new fee currencies; USAT (Tether America USD)
  also added; full mainnet allowlist is now 20 tokens (all 14 Mento
  currencies + USDm/EURm/USDC/USDT/USAT/WETH/XAUt0). `builder-guide.md`'s
  canonical fee-currency table is now stale but out of this skill's tracked
  scope — flagged for follow-up, not edited.
- `FeeCurrencyDirectory`: `0x15F344b9E6c3Cb6F0376A36A64928b13F62C6276` — unchanged

## 4. Ecosystem / TVL (`ecosystem.md`)

- Source: DefiLlama (`api.llama.fi/protocols`), docs.celo.org, celo.org/ecosystem
- Last verified: 2026-08-24
- Categories tracked: DEXes (10, +Uniswap V2/Velodrome V2/SushiSwap), Lending
  (3; "Morpho V1" renamed to "Morpho Blue" — Moola Market was added then
  removed on review, its site (`mm.moola.market`) is unreachable), Yield/
  Liquidity mgmt (6, +Autofarm), Stablecoins (2), Liquid Staking (1),
  Derivatives (1), RWA (7, +Tether Gold), Payments/Streaming (1), plus
  Governance section
- Uniswap V4 has no separate DefiLlama TVL entry on Celo right now (still
  listed — contracts confirmed live via `uniswap-contracts` docs page, so
  treated as a DefiLlama indexing quirk, not a removal; no action taken).

## 5. Grant programs (`grants-funding.md`)

- Source: `www.celopg.eco/programs` (status changes frequently — this file
  is explicitly a stale-prone cache per its own header)
- **Not verified this run** — `celopg.eco` returned a 403 from the sandbox's
  org egress policy (not the site itself); see PR docs-watch/2026-08-24.
- Currently-Live programs tracked (as of 2026-05-18, unverified since):
  Proof of Ship S2, Prezenti Anchor Round (through 2026-06-30), Prezenti
  Frontier Pool S2 (through 2026-06-30), GoodBuilders Season 3 (through
  2026-05-18), Celo Builder Fund (year-round through 2026-12-31).
- Note: several of the above end dates are now in the past relative to this
  run (2026-08-24) — likely flipped to "Past" but unconfirmed. Re-check
  status on the next run once celopg.eco is reachable.
