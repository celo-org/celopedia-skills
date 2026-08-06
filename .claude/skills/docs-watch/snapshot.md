# docs-watch snapshot — facts we depend on

Baseline seeded: 2026-07-07 (from the repo's own reference files, not a fresh
live fetch — their own "Last updated" stamp is 2026-04-15, so treat this
snapshot as unverified against live sources until the first real run).

Last attempt: none yet (baseline only) — updated by every run, including
blocked ones, per `SKILL.md` step 6. A `BLOCKED` value here means the most
recent run couldn't reach one or more sources; check the linked PR for
which ones.

## 1. Docs sitemap (`docs-map.md`)

- Source: `docs.celo.org/llms.txt`
- Sections tracked: Getting Started, Build on MiniPay, Build with AI
  (incl. x402, 8004, MCP), Build with Ecosystem, Protocol, Tooling (Dev
  Environments, Libraries & SDKs, Contracts, Infrastructure, Wallets, Other),
  Managing Assets, Infrastructure Partners, Hardforks & Notices (Jello,
  Jovian, Isthmus, Ice Cream/EigenDA v2)
- ~150 pages total as of last count

## 2. Contract addresses (`contracts.md`)

- Source: `docs.celo.org/tooling/contracts/*`
- Core protocol contracts (mainnet): 20 tracked (Registry, Accounts,
  CeloToken/GoldToken, Election, EpochManager, EpochRewards, Escrow,
  FederatedAttestations, FeeCurrencyDirectory, FeeHandler, Freezer,
  Governance, GovernanceSlasher, LockedCelo/LockedGold,
  MentoFeeHandlerSeller, OdisPayments, Reserve, ScoreManager, SortedOracles,
  Validators, UniswapFeeHandlerSeller, Attestations)
- Registry address: `0x000000000000000000000000000000000000ce10`
- Mento stablecoins tracked: 15+ (USDm, EURm, BRLm, XOFm, KESm, NGNm, COPm,
  GBPm, CHFm, JPYm, AUDm, CADm, GHSm, PHPm, ...)

## 3. Network info (`network-info.md`)

- Source: `docs.celo.org/build-on-celo/network-overview`
- Mainnet chain ID: `42220`; Sepolia testnet chain ID: `11142220`
- Public RPC: `https://forno.celo.org`
- L2 stack: OP Stack + EigenDA v2 DA + ZK fault proofs (Succinct SP1, Jello
  hardfork); L1→L2 migration block 31,056,500 (2025-03-26)
- Fee-currency (gas abstraction) tokens: USDm, EURm (token == adapter),
  USDC, USDT (adapter ≠ token address — 6→18 decimal adapters)
- `FeeCurrencyDirectory`: `0x15F344b9E6c3Cb6F0376A36A64928b13F62C6276`
- `eth_getLogs` range limit: ~50,000 blocks

## 4. Ecosystem / TVL (`ecosystem.md`)

- Source: DefiLlama (`api.llama.fi/protocols`, `/v2/chains`), docs.celo.org,
  celo.org/ecosystem
- Categories tracked: DEXes (7), Lending (3), Yield/Liquidity mgmt (5),
  Stablecoins (2), Liquid Staking (1), Derivatives (1), RWA (6),
  Payments/Streaming (1), plus Governance section
- Notable recent additions already reflected: Uniswap V4 (Oct 2025), Carbon
  DeFi (canonical name — not "Carbon"), Mento V3

## 5. Grant programs (`grants-funding.md`)

- Source: `www.celopg.eco/programs` (status changes frequently — this file
  is explicitly a stale-prone cache per its own header)
- Currently-Live programs tracked: Prezenti Anchor Round (through
  2026-06-30), GoodBuilders Season 3 (through 2026-05-18), Celo Builder Fund
  (year-round through 2026-12-31)
- Note: Prezenti and GoodBuilders end dates are in the past relative to a
  post-2026-06-30 run — check status flip to "Past" on the next run.
