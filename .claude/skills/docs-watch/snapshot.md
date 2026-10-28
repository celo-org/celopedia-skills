# docs-watch snapshot — facts we depend on

Baseline seeded: 2026-07-07 (from the repo's own reference files, not a fresh
live fetch — their own "Last updated" stamp is 2026-04-15, so treat this
snapshot as unverified against live sources until the first real run).

Last attempt: 2026-10-26 — PARTIAL BLOCK, wider than previous runs (403
connect_rejected on the CONNECT tunnel, confirmed persistent with a retry,
for every host below): `celopg.eco`, `docs.minipay.xyz` (same two blocked
on every run since 2026-08-24), plus — new this run — `minipay.to`,
`developer.minipay.to`, `link.minipay.xyz` (MiniPay's own submission/
deeplink hosts, previously reachable), `askbots.ai`/`www.askbots.ai`,
`api.x402.celo.org`/`x402.celo.org`, `ramp.ripio.com`, `bridge.ripio.com`,
`api.textilecredit.com`, `api.geckoterminal.com`, `li.quest`,
`moola.market`/`mm.moola.market`, `toucan.earth`, `mobius.money`.
Reachable: `docs.celo.org`, `api.llama.fi`, `forno.celo.org` — sources 1-4
were fully checked on these, and source 7's on-chain checks (Aave
`getReservesList`, CapyFi `eth_getCode` via `forno.celo.org`) ran fine, but
every third-party wFIAT API was blocked. **Worth flagging as an
environment/allowlist issue** — this run's allowlist was noticeably
narrower than the 2026-10-21/10-22 runs that reached all of those hosts
successfully. See PR for this run, `docs-watch/2026-10-26` branch.
**2026-10-28 review correction (ghozzza, on the first push of this
branch):** that first push was cut from `main` before #89 (the
2026-10-19 run below) merged, so it redid #89's `contribute-to-celo`
rename and stale-link fixes and re-bumped `SKILL.md` to a version #89 had
already taken — rebased onto `main` post-#89 and reduced to just this
run's actual new findings (the 9 new docs.celo.org pages, the Textile FX
refresh, and this blocked-sources list); `SKILL.md` now bumps
2.13.1 → 2.13.2. The reviewer also independently confirmed `toucan.earth`
returns 200 with a live site despite DefiLlama's `deadUrl: true` — see
section 4, Toucan is **not** flagged as needs-review below (that first
push's flag was a false positive, withdrawn).

Last attempt: 2026-10-19 — PARTIAL BLOCK (celopg.eco: gateway 403 to CONNECT
via curl, `getaddrinfo ENOTFOUND` via WebFetch — org egress policy denial,
not the site itself; docs.minipay.xyz: same 403 via curl, same ENOTFOUND
via WebFetch) — see PR for this run, `docs-watch/2026-10-19` branch.
Sources 1-4 (docs sitemap, contracts, network info, DefiLlama TVL) were
reachable and verified. Source 5 (grant programs) and source 6 (MiniPay
docs) were not reachable — their own reference files (`grants-funding.md`'s
Live/Past program table, and `minipay-docs-map.md` /
`minipay-requirements.md` / `minipay-common-mistakes.md` in full) were left
untouched. As in the 2026-10-16 correction round, one cross-link fix each
in `grants-funding.md` and (previously) `minipay-docs-map.md` used
source-1 sitemap data to repair a dead docs.celo.org link, not a
source-5/6 re-verification — that distinction matters because it means
neither file's own live-sourced content has been checked since, respectively,
2026-08-28 and 2026-09-10.

Previous run: 2026-10-05, corrected 2026-10-16 — see PR #81,
`docs-watch/2026-10-05` branch, for the full record of that run (a
docs.celo.org Home/Build restructuring caught a day late, a DefiLlama TVL
methodology bug found and fixed by human review, and the Moola
Market/Mobius Money "needs a working site" decisions below).

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
- Last verified: 2026-10-26 (originally 2026-10-05; re-verified 2026-10-16
  after a second live restructuring, 2026-10-19 after a third, and again
  this run for new pages)
- **2026-10-26 finding: 9 new pages, not a restructuring.** Diffed the
  full live `llms.txt` URL list against every URL currently in the file —
  three under `build/agents/*` (`ai-resources`, `agent-wallet` "Give Your
  Agent a Wallet and Test Funds", `askbots` — docs.celo.org now has its
  own AskBots page; the askbots.ai-sourced content in `ai-agents.md` is
  unchanged) and six under `build/tools/libraries-sdks/contractkit/*`
  (`contracts-wrappers-registry`, `data-encryption-key`,
  `migrating-to-viem`, `migrating-to-contractkit-v2`,
  `migrating-to-contractkit-v1`, `notes-web3-with-contractkit` — these
  are the same 6 ContractKit subpages the 2026-10-19 run's note at
  `docs-map.md` lines ~202-208 said were covered only by an index-page
  note, not individual rows; now added as rows). All 9 added to
  `docs-map.md`. No other live-vs-file deltas this run beyond the Celo
  CLI's 19 per-subcommand pages, still out of scope per that same note.
- **2026-10-19 finding: `contribute-to-celo/*` → `contribute/*` rename.**
  Diffed the live `llms.txt` (224 pages) against the file's own URL list
  and found every `contribute-to-celo/*` page 308-redirects to the same
  slug under `contribute/*` (spot-checked `index` and `builders`, both
  200 at the new path) — a bare prefix rename, no page additions or
  removals within that section. All 15 Contributing-section URLs in
  `docs-map.md` updated; "Regional DAOs" and "Attestation Service Release
  Process" re-confirmed absent under the new prefix too (404). The other
  39 live-vs-file URL deltas this diff turned up were pre-existing, already
  out of this file's tracked scope, not new drift: the Celo CLI's 19
  per-subcommand pages and 6 ContractKit migration/notes subpages, both
  already covered only by the index-page note at `docs-map.md` lines
  ~202-208, not by individual rows.
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

- Source: `docs.celo.org/build/tools/contracts/*` (was `tooling/contracts/*`
  before the 2026-10-06 restructuring; `contracts.md`'s own "Source:" link
  and its third-party-stablecoin cross-link were still pointing at the old
  path until this run — fixed, using source-1 data, not new contract-data
  drift)
- Last verified: 2026-10-26 (previously 2026-10-19, 2026-10-05)
- **2026-10-26: re-verified, no drift.** Spot-checked mainnet core,
  Mento, L1, and Uniswap V3/V4 addresses plus the Sepolia core/Mento/
  legacy-token subset against the live pages again — all unchanged from
  the 2026-10-19 re-verification below.
- **No address drift this run.** Re-verified address-by-address against
  live `core-contracts`, `stablecoin-contracts`, `l1-contracts`,
  `uniswap-contracts`: all 24 core protocol mainnet contracts, all 15 Mento
  stablecoins (mainnet + testnet), all 20 external/third-party stablecoins
  (mainnet; case-only differences on a handful are checksum formatting, not
  address changes — same as last run), all 31 L1 mainnet contracts + the
  7 tracked L1 Sepolia contracts, all Uniswap V3 (14) and V4 (7) mainnet
  contracts, and the 11-contract Sepolia core-protocol subset, unchanged.
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

- Source: `docs.celo.org/learn/network/overview` (was `build-on-celo/network-overview`
  before 2026-10-06; `network-info.md`'s own "Source:" link and its
  fee-currencies cross-link were still on the old paths until this run —
  fixed, using source-1 data)
- Last verified: 2026-10-26 (previously 2026-10-19, 2026-10-05)
- **2026-10-26: re-verified by raw-fetching both pages' `.md` source
  directly, no drift.** Chain IDs, RPC, and all 7 named fee-currency
  addresses plus the 15 Mento fee-currencies match. The live page still
  doesn't carry block time / L2 stack / data availability / fault-proof /
  migration-date facts that `network-info.md` states — consistent with
  the already-known fee-currency-table drop below, not new; nothing
  contradicts those facts, so left as-is.
- Mainnet chain ID: `42220`; Sepolia testnet chain ID: `11142220` — unchanged
- Public RPC: `https://forno.celo.org` — unchanged
- **No fact drift.** The live page (now at `learn/network/overview`) still
  only covers chain IDs / RPC / explorers, no fee-currency table — the
  canonical source for those stays `docs.celo.org/build/tools/contracts/fee-currencies`
  (was `tooling/contracts/fee-currencies`). All 7 named fee-currency
  addresses (USDm, EURm, USDC, USD₮, USA₮, WETH, XAUt0) re-verified
  against the live `fee-currencies` page at its current path, unchanged.
  The `FeeCurrencyDirectory` address itself isn't printed on that page (it
  only names the directory as the allowlist source) — unchanged from
  `contracts.md`'s tracked value, not independently re-confirmed there
  this run; same as last run.

## 4. Ecosystem / TVL (`ecosystem.md`)

- Source: DefiLlama (`api.llama.fi/protocols`, `api.llama.fi/protocol/<slug>`),
  docs.celo.org, celo.org/ecosystem
- Last verified: 2026-10-26 (TVL methodology corrected 2026-10-16)
- **2026-10-26: Textile FX TVL refreshed.** Read `chainTvls.Celo` directly
  from the bulk `/protocols` response (no need to hit `/protocol/<slug>`
  individually — that response already carries the per-chain breakdown):
  ~$860K → **~$1.35M** (reviewer independently confirmed $1,346,979 on
  `api.llama.fi/protocols` at review time). Updated in `ecosystem.md`.
  Everything else already tracked above the ~$100K floor checked
  unchanged in substance (Uniswap V3 $3.68M, Aave V3 $3.01M, Mento V2
  $1.41M, stCELO $1.28M, Ubeswap V2 $788K, Feather $551K, Morpho Blue
  $541K, Mento V3 $508K, Superfluid $444K, Curve DEX $272K, TheDeep
  $252K, ICHI $230K, SushiSwap $218K, Untangled Vault $144K) — no numbers
  cited for these to go stale. AutoRange ($55K) and Velodrome V3 ($81K)
  stay below/at the floor; Mobius Money ($345K, still `deadUrl: true`)
  stays excluded.
- **2026-10-26: Toucan Protocol checked, false positive — no action.**
  DefiLlama shows `deadUrl: true` and an empty `url` for it (Celo TVL
  still ~$159K), the same signal that excluded Mobius Money/Prime
  Protocol on 2026-10-16. This sandbox's egress proxy blocks
  `toucan.earth` outright (confirmed with a retry), so an earlier push of
  this branch flagged it as needs-review rather than guessing. The
  2026-10-28 reviewer checked from an unrestricted network and found
  `toucan.earth` returns 200 with a live site ("Carbon credit market
  infrastructure") — DefiLlama's `deadUrl` flag is wrong for this one.
  Toucan stays in `ecosystem.md`'s RWA table unchanged; this flag is now
  closed.
- **2026-10-19: no TVL-driven addition or removal.** Pulled
  `currentChainTvls.Celo` for all 85 DefiLlama protocols listing Celo as a
  chain, plus every protocol this file already tracks. Nothing currently
  listed has dropped off DefiLlama's Celo chain list or fallen out of its
  category; nothing crossing the ~$100K Celo-TVL floor is missing from the
  file (the two candidates that do clear it, Moola Market ~$1.12M and
  Mobius Money ~$350K, are the same two already excluded as of the
  2026-10-16 review for an unreachable site — unchanged this run, not
  re-flagged below since nothing new to decide).
- **Finding: `ecosystem.md`'s own docs.celo.org cross-links were stale**
  (`tooling/*` and `build-on-celo/*` paths, pre-dating the 2026-10-06
  restructuring that `docs-map.md` already captured) — missed by the
  2026-10-16 run, which only fixed `minipay-docs-map.md`'s links. Fixed
  using source-1 data: all Oracles/Indexers/Bridges/Wallets/SDK/Dev-env
  links moved to `build/tools/*`, the stablecoin-build-guide link to
  `build/build-with-local-stablecoin`, the MiniPay quickstart links
  consolidated to the single `build/mini-apps/overview` page (the separate
  quickstart/code-library/deeplinks pages they pointed at no longer exist,
  per `docs-map.md`), and the AI & Agent Infrastructure links to
  `build/agents/*`. Two rows pointed at pages confirmed gone outright
  (not moved) rather than just renamed — "Thirdweb SDK" under Developer
  SDKs & Libraries, and "Agent Skills" under AI & Agent Infrastructure —
  dropped, each with a one-line note, matching how `docs-map.md` already
  treats both removals.
- **Observed, no action: Uniswap V4's DefiLlama `chains` list omits
  Celo.** `/protocols` shows `uniswap-v4`'s tracked chains without Celo,
  even though `contracts.md`'s Uniswap V4 mainnet addresses were
  independently re-verified live against `docs.celo.org` this same run
  (section 2) — so the V4 deployment itself is real, DefiLlama simply
  isn't attributing TVL to it on this chain yet. `ecosystem.md` already
  lists Uniswap V4 on the strength of the docs.celo.org contract listing,
  not DefiLlama, so this is a DefiLlama coverage gap, not an ecosystem fact
  to change — noted for whoever next wonders why a TVL-sourced lookup
  for "uniswap-v4" comes back chainless.
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
  Lending list (~$1.09M-1.25M TVL across recent runs) after being removed
  from `ecosystem.md` in an earlier run for having an unreachable site.
  This sandbox's egress proxy still blocks `moola.market`/`mm.moola.market`
  outright (re-confirmed 2026-10-26), so site reachability can't be
  independently confirmed from here — but the 2026-10-16 reviewer checked
  from an unrestricted network and found `moola.market` returns 200 while
  `mm.moola.market` still doesn't connect. Leaving Moola out remains the
  right call; a human can swap in the working domain if they want it back
  in.
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
- **Not verified this run (third consecutive block)** — `celopg.eco` is
  blocked by this sandbox's network egress proxy (gateway 403 to CONNECT
  via curl; `getaddrinfo ENOTFOUND` via WebFetch) — an org policy denial,
  not a site-side failure. Same blocker as 2026-08-24 (then a 403) and
  2026-10-05 (then `EGRESS_BLOCKED`/403). Its `docs.celo.org` cross-link
  was still fixed this run using source-1 data (see top of file) — that is
  not a celopg.eco re-verification.
- Currently-Live programs tracked (as of 2026-05-18, unverified since):
  Proof of Ship S2 (file itself now also independently notes Proof of Ship
  has been sunset — contradicts its own "Live" framing, pre-existing
  inconsistency, not new), Prezenti Anchor Round (through 2026-06-30),
  Prezenti Frontier Pool S2 (through 2026-06-30), GoodBuilders Season 3
  (through 2026-05-18), Celo Builder Fund (year-round through 2026-12-31),
  plus Agents at Work Hackathon and Prezenti Season 3 added since.
- Note: several of the above end dates are now well in the past relative to
  this run (2026-10-19) — very likely flipped to "Past" but still
  unconfirmed three runs running. Re-check status as soon as celopg.eco is
  reachable from this environment — this is the third consecutive blocked
  attempt; worth raising as an environment/allowlist issue if a fourth
  occurs.
- **2026-10-26: fourth consecutive blocked attempt** — same `403
  connect_rejected`, confirmed with a retry. See the environment/
  allowlist flag at the top of this file.

## 6. MiniPay docs (`minipay-docs-map.md`, `minipay-requirements.md`, `minipay-common-mistakes.md`)

- Source: `docs.minipay.xyz` (page tree, submission page, best-practices page,
  deeplinks page)
- **Not verified this run (second consecutive block)** — `docs.minipay.xyz`
  is blocked by this sandbox's network egress proxy (gateway 403 to
  CONNECT via curl; `getaddrinfo ENOTFOUND` via WebFetch, same as
  celopg.eco) — an org policy denial, not a site-side failure. Same
  blocker as the 2026-10-05 run; the 2026-09-10 run reached this source
  fine.
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
  environment — this is now two consecutive blocked attempts for this
  source specifically.
- **2026-10-26: still blocked, and wider** — same `403 connect_rejected`
  for `docs.minipay.xyz`, confirmed with a retry, plus — new this run —
  `minipay.to`, `developer.minipay.to`, and `link.minipay.xyz` (the
  submission-form and deeplink hosts, previously reachable even while
  `docs.minipay.xyz` itself was blocked) are now also blocked. Facts
  below remain unchanged from 2026-09-10, three runs blocked running.

## 7. wFIAT access (`wfiat-access.md`)

- Sources: x402 `/supported` + `/api/config`, `ramp.ripio.com/api/countries`,
  Textile `v2/rfq/levels?chainId=42220`, GeckoTerminal, LI.FI, Aave v3 Pool
  `getReservesList`, CapyFi Comptroller `eth_getCode` on Celo
- Last verified: 2026-10-22 for everything below (seeded from PR #92's
  checks). **2026-10-26: partially blocked.** `forno.celo.org` on-chain
  reads succeeded — Aave `getReservesList` and the CapyFi `eth_getCode`
  check both re-ran clean and match the facts below, unchanged — but
  every third-party API this section depends on (`api.x402.celo.org`,
  `ramp.ripio.com`, `bridge.ripio.com`, `api.textilecredit.com`,
  `api.geckoterminal.com`, `li.quest`) returned `403 connect_rejected`,
  confirmed with a retry. So the liquidity/route/x402-asset facts below
  are unverified this run and still dated 2026-10-22; no edits made —
  nothing contradicts them, there's just no live confirmation this time.
- x402 mainnet assets: USDC, USDT, USAT (eip3009); wARS, wBRL, wMXN, wCOP,
  wPEN, wCLP, cNGN (permit2). `eip2612GasSponsoring`: true for the six
  wFIAT, false for cNGN and the eip3009 assets.
- Ripio Ramp countries: AR, BR, MX, CO. PE and CL → "Country not supported".
  Celo (42220) offers CELO, USDC, USDT and all six wFIAT.
- Textile Celo buy side (USDT → token): wARS non-zero (tens of USDT), wBRL
  ~87.7k USDT, wCOP ~5.1k USDT, wMXN zero. wPEN, wCLP not listed.
- LI.FI same-chain route from USDT: wARS, wBRL yes; wMXN, wCOP, wPEN, wCLP no.
- Celo DEX pools: wARS (Uniswap v3/v4), wBRL (Uniswap v3/v4); none for the
  other four.
- Aave v3 Celo reserves: USDC, USDT, WETH, USDm, CELO, EURm (no wFIAT).
  CapyFi Comptroller `0x0b9af1fd73885aD52680A1aeAa7A3f17AC702afA` on Celo:
  no code.
