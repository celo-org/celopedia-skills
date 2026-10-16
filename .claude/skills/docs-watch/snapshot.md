# docs-watch snapshot — facts we depend on

Baseline seeded: 2026-07-07 (from the repo's own reference files, not a fresh
live fetch — their own "Last updated" stamp is 2026-04-15, so treat this
snapshot as unverified against live sources until the first real run).

Last attempt: 2026-10-05, corrected 2026-10-16 — PARTIAL BLOCK (celopg.eco:
EGRESS_BLOCKED via WebFetch, 403 connect_rejected via curl — org egress
policy denial, not the site itself; docs.minipay.xyz: same, 403
connect_rejected on the CONNECT tunnel) — see PR #81,
docs-watch/2026-10-05 branch. Sources 1-4 (docs sitemap, contracts, network
info, DefiLlama TVL) were reachable and verified, with substantial drift
found and fixed. Source 5 (grant programs) and source 6 (MiniPay docs) were
not reachable — `grants-funding.md`, `minipay-docs-map.md`,
`minipay-requirements.md`, and `minipay-common-mistakes.md` were left
untouched (the `minipay-docs-map.md` edit on 2026-10-16, below, only
corrected dead docs.celo.org cross-links using source-1 data, not a
source-6 re-verification).

**2026-10-16 correction round:** a human review on PR #81 (ghozzza) found
two real bugs in the 2026-10-05 run and one process violation, all fixed
on the same branch:
1. The `ecosystem.md` additions used each protocol's **total cross-chain**
   DefiLlama TVL (the `/protocols` list's `.tvl` field) instead of its
   **Celo-specific** TVL (`.currentChainTvls.Celo` from
   `/protocol/<slug>`). Re-checked against `chainTvls.Celo`: UNCX Network
   V3 is **$0** on Celo (not ~$34M), vfat.io **~$14.8K** (not ~$39.7M),
   Prime Protocol **~$237** and DefiLlama-flagged `deadUrl` (not ~$353K),
   AutoRange **~$64K** (not ~$504K) — all four now below this run's own
   ~$100K floor and removed. Textile FX **~$860K** on Celo (not ~$1.8M,
   which was its 5-chain total) — kept, figure corrected.
2. Mobius Money has real Celo TVL (~$349K) but its domain
   (`mobius.money`) now redirects to an unrelated site and DefiLlama
   marks its URL dead — removed per the same "needs a working site" bar
   applied to Moola Market below.
3. The "Needs review — Moola Market" note had been written directly into
   `ecosystem.md` — SKILL.md step 5 puts needs-review items in the PR
   body only, never in the shipped reference file. Moved out of
   `ecosystem.md`; stays in the PR body. The reviewer independently
   confirmed from an unrestricted network that `moola.market` returns 200
   but `mm.moola.market` still doesn't connect — leaving Moola out is
   still the right call, just documented in the right place now.

The reviewer also caught that docs.celo.org restructured **again** on
2026-10-06 (the day after the original run) — see section 1 below — and
flagged `docs-map.md:135-140`, a duplicate empty "L2 Specification" stub
left over from an earlier edit pass that pointed at a heading that no
longer existed; deleted. `api-reference/openapi.json` returns 404
(pre-existing, confirmed, not blocking).

## 1. Docs sitemap (`docs-map.md`)

- Source: `docs.celo.org/llms.txt`
- Last verified: 2026-10-16 (originally 2026-10-05; re-verified and
  rewritten again 11 days later after a second live restructuring — see
  below)
- **2026-08-24–09-10 restructuring** (stable, unaffected by what follows):
  `infra-partners/*` → `operate/*` wholesale (node operators, notices,
  hardfork archive); the old `/specs/*` section folded into
  `operate/specification/*`; the ~40-page `/legacy/*` tree replaced by a
  single consolidated page (now at `learn/celo-l1`, see below); Cel2 FAQ
  moved to `operate/operators/faq`; "Migrating a Celo L1 Node (legacy)"
  removed from the sitemap.
- **2026-10-06 restructuring** (one day after the 2026-10-05 run — missed
  then, caught and fixed on 2026-10-16): `home/*` → `learn/*` wholesale;
  `build-on-celo/*` and `tooling/*` merged into a single `build/*` tree
  (AI/agent pages → `build/agents/*`; everything under old `tooling/*` →
  `build/tools/*`). Network Information and L2 Architecture moved from
  `build-on-celo/*` into `learn/network/*`, not into `build/*` with the
  rest of the old build-on-celo pages — easy to get wrong. The 5-page
  MiniPay subtree under `build-on-celo/build-on-minipay/*` collapsed to a
  single `build/mini-apps/overview` page; `minipay-docs-map.md`'s
  docs.celo.org cross-links were updated to match (its `docs.minipay.xyz`
  content itself is unverified this run — see section 6). "Thirdweb SDK"
  (`tooling/libraries-sdks/thirdweb-sdk/index`) was removed outright, not
  moved. "Regional DAOs" (`contribute-to-celo/daos`) and "Attestation
  Service Release Process"
  (`contribute-to-celo/release-process/attestation-service`) are also gone
  from the live sitemap.
- New pages (both restructurings combined): Celina, Self Agent ID, x402
  endpoint discovery, Build with USA₮, Introduction to SocialConnect,
  Metadata and Claims, a Staking subtree (index, locked-celo,
  validator-elections, validator-groups, voting,
  key-management/{summary,detailed,key-rotation}), a Wit Oracle page, and
  **Agent Vault** (`build/agents/agent-vault`, added 2026-10-15 — card
  payments and logins for agents via MCP/SDK/HTTP API using mock tokens).
- `docs-map.md` has been rewritten from scratch against the current
  `llms.txt` (patching an already-stale file compounds errors faster than
  it fixes them); see the PR diff for full page-by-page detail. Also fixed:
  a duplicate, empty "## L2 Specification" stub left at the old
  `docs-map.md:135-140` by an earlier edit pass, pointing at a heading
  ("Infrastructure → Operate") that didn't exist and duplicating the real
  "Operate — L2 Specification" section — deleted.
- `api-reference/openapi.json` returns 404 — confirmed, pre-existing,
  unrelated to either restructuring, not blocking.

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

- Source: DefiLlama (`api.llama.fi/protocols`, `api.llama.fi/protocol/<slug>`),
  docs.celo.org, celo.org/ecosystem
- Last verified: 2026-10-05, TVL methodology corrected 2026-10-16
- **Added and kept** (DefiLlama-listed on Celo, verified against
  `currentChainTvls.Celo`, above the ~$100K floor): Textile FX (DEX,
  ~$860K TVL on Celo).
- **Added on 2026-10-05, removed on 2026-10-16 review** (the original
  figures were each protocol's total cross-chain `.tvl`, not its Celo
  share — see the correction note at the top of this file): vfat.io
  (Celo TVL is actually ~$14.8K, not ~$39.7M), Prime Protocol (~$237, not
  ~$353K, and DefiLlama marks its URL dead), AutoRange (~$64K, not
  ~$504K), UNCX Network V3 (**$0 on Celo**, not ~$34M — it has no Celo
  TVL at all; the original number was its cross-chain total).
- **Considered, not added:** Mobius Money — real Celo TVL (~$349K) but its
  domain (`mobius.money`) now redirects to an unrelated site and DefiLlama
  marks its URL dead; same bar as Moola Market below.
- **Needs review (PR body only — not written into `ecosystem.md` itself,
  per SKILL.md step 5):** Moola Market reappears in DefiLlama's Celo
  Lending list (~$1.25M TVL) after being removed from `ecosystem.md` in an
  earlier run for having an unreachable site. This sandbox's egress proxy
  still blocks `moola.market`/`mm.moola.market` outright, so site
  reachability can't be independently confirmed from here — but the
  2026-10-16 reviewer checked from an unrestricted network and found
  `moola.market` returns 200 while `mm.moola.market` still doesn't
  connect. Leaving Moola out remains the right call; a human can swap in
  the working domain if they want it back in.
- Not re-added (TVL too low to distinguish from dead/test deployments,
  no action): Symmetric, DONASWAP V2, Tegisto, Poof Cash, Chee Finance, and
  ~15 other DefiLlama-listed Celo protocols under roughly $100K TVL on
  Celo specifically.
- Feather's DefiLlama category changed from "Lending" to "Risk Curators" —
  treated as a DefiLlama taxonomy change, not an ecosystem fact change; no
  action taken.
- Categories unchanged otherwise: DEXes (core list), Stablecoins, Liquid
  Staking, Derivatives, RWA, Payments/Streaming, Governance — all verified
  present on live DefiLlama with no removals.
- **Process note for future runs:** always read `currentChainTvls.Celo`
  from `api.llama.fi/protocol/<slug>`, never the `/protocols` list's
  `.tvl` field, when deciding whether a protocol's *Celo* footprint
  clears the inclusion floor — the aggregate field silently includes every
  other chain the protocol is deployed on.

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
