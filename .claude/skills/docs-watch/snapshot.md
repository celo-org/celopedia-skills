# docs-watch snapshot — facts we depend on

Baseline seeded: 2026-07-07 (from the repo's own reference files, not a fresh
live fetch — their own "Last updated" stamp is 2026-04-15, so treat this
snapshot as unverified against live sources until the first real run).

Last attempt: 2026-10-05 — PARTIAL BLOCK (celopg.eco: EGRESS_BLOCKED via
WebFetch, 403 connect_rejected via curl — org egress policy denial, not the
site itself; docs.minipay.xyz: same, 403 connect_rejected on the CONNECT
tunnel) — see PR for the run's docs-watch/2026-10-05 branch. Sources 1-4
(docs sitemap, contracts, network info, DefiLlama TVL) were reachable and
verified, with substantial drift found and fixed. Source 5 (grant programs)
and source 6 (MiniPay docs) were not reachable — `grants-funding.md`,
`minipay-docs-map.md`, `minipay-requirements.md`, and `minipay-common-mistakes.md`
were left untouched this run.

## 1. Docs sitemap (`docs-map.md`)

- Source: `docs.celo.org/llms.txt`
- Last verified: 2026-10-05
- **Major restructuring since 2026-08-24.** The `infra-partners/*` top-level
  section was renamed wholesale to `operate/*` (node operators, notices,
  hardfork archive all moved prefix). The standalone `/specs/*` section from
  the last run was folded into `operate/specification/*` — it no longer
  exists as its own top-level section. The entire ~40-page `/legacy/` tree
  (Legacy Overview, Legacy L1 Architecture, What's Changed? L1→L2, etc.) is
  **gone** — replaced by a single consolidated `home/celo-l1` ("About Celo
  L1") page; the Cel2 FAQ that used to live at `legacy/faq` moved to
  `operate/operators/faq`. "Migrating a Celo L1 Node (legacy)"
  (`operators/migrate-node`) no longer appears in the live sitemap.
  New pages: Celina (`build-with-ai/mcp/celina`), Self Agent ID
  (`build-with-ai/self-agent-id`), x402 endpoint discovery
  (`build-with-ai/x402-get-discovered`), Build with USA₮
  (`build-with-usat`), Introduction to SocialConnect
  (`build-on-socialconnect`), Metadata and Claims
  (`home/protocol/metadata`), a new Staking subtree
  (`home/protocol/staking/*`: index, locked-celo, validator-elections,
  validator-groups, voting, key-management/{summary,detailed,key-rotation}),
  and a Wit Oracle tooling page (`tooling/oracles/wit-oracle`).
  `docs-map.md` has been rewritten to match; see the PR diff for the full
  page-by-page detail.

## 2. Contract addresses (`contracts.md`)

- Source: `docs.celo.org/tooling/contracts/*`
- Last verified: 2026-10-05
- Core protocol contracts (mainnet): 20 tracked — all addresses verified
  unchanged against `core-contracts`, `stablecoin-contracts`, `l1-contracts`,
  `uniswap-contracts`.
- Mento stablecoins tracked: 15 — all mainnet + testnet addresses verified
  unchanged.
- External/third-party stablecoins (mainnet): all 20 tracked tokens verified
  unchanged (case differences in some live-page addresses are checksum
  formatting only, not address changes).
- L1 (Ethereum) contracts, Uniswap V3/V4 mainnet: all verified unchanged.
- **Resolved from last run's flag:** the 2026-08-24 snapshot flagged
  Sepolia USDm/EURm as possibly colliding with the legacy cUSD/cEUR
  addresses in `contracts.md`. On inspection, `contracts.md` already has
  this correct (USDm/EURm and legacy cUSD/cEUR are four distinct, correctly
  separated testnet addresses) — matches the live `stablecoin-contracts`
  page exactly. No fix was needed; this flag is now closed.
- **Fixed this run:** `contracts.md`'s Testnet Tokens table was missing the
  legacy Celo Brazilian Real (cREAL) Sepolia address
  (`0x13d68A1Bf4a8cB7d9feF54EF70401871b666269c`, from the live
  `core-contracts` page's `StableTokenBRL` entry) — added, alongside the
  already-tracked legacy cUSD/cEUR testnet rows.
- Not tracked (pre-existing, out of scope, not new drift): several testnet-
  only core/L1 contracts (e.g. `EpochManagerEnabler`, `FeeHandler`,
  `ScoreManager` on Sepolia) and the new Uniswap V4 Celo Sepolia deployment
  exist live but were never part of this file's curated testnet subset —
  not flagged as drift, just noting the gap for a future scope decision.

## 3. Network info (`network-info.md`)

- Source: `docs.celo.org/build-on-celo/network-overview`
- Last verified: 2026-10-05
- Mainnet chain ID: `42220`; Sepolia testnet chain ID: `11142220` — unchanged
- Public RPC: `https://forno.celo.org` — unchanged
- **No fact drift.** Note: the live `network-overview` page itself dropped
  its fee-currency table (it now only covers chain IDs / RPC / explorers);
  the canonical source for fee-currency addresses is now
  `docs.celo.org/tooling/contracts/fee-currencies`, which `network-info.md`
  already cites inline for the full allowlist — so no edit was needed. All
  7 named fee-currency addresses (USDm, EURm, USDC, USD₮, USA₮, WETH,
  XAUt0) and the `FeeCurrencyDirectory` address were individually verified
  against the live `fee-currencies` page and are unchanged.

## 4. Ecosystem / TVL (`ecosystem.md`)

- Source: DefiLlama (`api.llama.fi/protocols`), docs.celo.org, celo.org/ecosystem
- Last verified: 2026-10-05
- **Added this run** (DefiLlama-listed on Celo, not previously tracked,
  TVL above noise level): vfat.io (Yield Aggregator, ~$39.7M TVL), Prime
  Protocol (Lending, ~$353K TVL), Textile FX (DEX, ~$1.8M TVL), AutoRange
  (DEX, ~$504K TVL), Mobius Money (DEX, ~$355K TVL), UNCX Network V3
  (Token Locker, ~$34M TVL — added to the "Other" table since it doesn't
  fit an existing category).
- **Flagged, not fixed** (needs review — see PR): Moola Market reappears in
  DefiLlama's Celo Lending list (~$1.25M TVL) after being removed from
  `ecosystem.md` in an earlier run for having an unreachable site. This
  sandbox's egress proxy blocks `moola.market`/`mm.moola.market` outright
  this run too, so site reachability still can't be independently
  confirmed from here — possibly the same was true last time. Needs a
  human check from an unrestricted network.
- Not re-added (TVL too low to distinguish from dead/test deployments,
  no action): Symmetric, DONASWAP V2, Tegisto, Poof Cash, Chee Finance, and
  ~15 other DefiLlama-listed Celo protocols under roughly $100K TVL.
- Feather's DefiLlama category changed from "Lending" to "Risk Curators" —
  treated as a DefiLlama taxonomy change, not an ecosystem fact change; no
  action taken.
- Categories unchanged otherwise: DEXes (core list), Stablecoins, Liquid
  Staking, Derivatives, RWA, Payments/Streaming, Governance — all verified
  present on live DefiLlama with no removals.

## 5. Grant programs (`grants-funding.md`)

- Source: `www.celopg.eco/programs` (status changes frequently — this file
  is explicitly a stale-prone cache per its own header)
- **Not verified this run** — `celopg.eco` is blocked by this sandbox's
  network egress proxy (`EGRESS_BLOCKED` via WebFetch; `403 connect_rejected`
  on the CONNECT tunnel via curl) — an org policy denial, not a site-side
  failure. Same blocker as the 2026-08-24 run (then reported as a 403).
- Currently-Live programs tracked (as of 2026-05-18, unverified since):
  Proof of Ship S2 (file itself now also independently notes Proof of Ship
  has been sunset — contradicts its own "Live" framing, pre-existing
  inconsistency, not new), Prezenti Anchor Round (through 2026-06-30),
  Prezenti Frontier Pool S2 (through 2026-06-30), GoodBuilders Season 3
  (through 2026-05-18), Celo Builder Fund (year-round through 2026-12-31),
  plus Agents at Work Hackathon and Prezenti Season 3 added since.
- Note: several of the above end dates are now well in the past relative to
  this run (2026-10-05) — very likely flipped to "Past" but still
  unconfirmed two runs running. Re-check status as soon as celopg.eco is
  reachable from this environment — this is the second consecutive blocked
  attempt, worth raising as an environment/allowlist issue if it recurs
  again.

## 6. MiniPay docs (`minipay-docs-map.md`, `minipay-requirements.md`, `minipay-common-mistakes.md`)

- Source: `docs.minipay.xyz` (page tree, submission page, best-practices page,
  deeplinks page)
- **Not verified this run** — `docs.minipay.xyz` is blocked by this
  sandbox's network egress proxy (`EGRESS_BLOCKED` via WebFetch; `403
  connect_rejected` on the CONNECT tunnel via curl, same as celopg.eco) —
  an org policy denial, not a site-side failure. This is a new blocker;
  the 2026-09-10 run reached this source fine.
- Facts as last verified 2026-09-10 (unchanged below, not re-checked this
  run): page tree (Getting Started, Installation, Guides, Reference,
  Custom Methods), deeplinks (`add_cash`, `browse`, `discover`, `receipt`,
  `qr`, `invite_friends`, `balance`), submission URLs
  (`minipay.to/mini-apps`, `developer.minipay.to/mini-app-listing`), and
  the full listing-policy checklist cached in `minipay-requirements.md`
  (USDT mandatory, no non-native tokens, no CELO in UI, zero-click connect,
  no message signing, no address exposure, no arbitrary withdrawals,
  pre-flight balance check, UI copy rules, 360×640 viewport, SVG/WebP,
  PageSpeed score, URL/origin manifest, Celoscan verification + sample
  tx hashes, in-app support link, 24h SLA, footer legal/about links,
  operator disclaimer, whitelisting integrity, dependency security).
- Re-check all of this as soon as `docs.minipay.xyz` is reachable from this
  environment.
