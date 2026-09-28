# docs-watch snapshot — facts we depend on

Baseline seeded: 2026-07-07 (from the repo's own reference files, not a fresh
live fetch — their own "Last updated" stamp is 2026-04-15, so treat this
snapshot as unverified against live sources until the first real run).

Last attempt: 2026-09-28 — PARTIAL BLOCK (celopg.eco: 403 and
docs.minipay.xyz: 403, both org egress policy denials — see PR for the run's
docs-watch/2026-09-28 branch). Sources 1-4 (docs sitemap, contracts, network
info, DefiLlama TVL) were reachable and verified; source 5 (grant programs)
and source 6 (MiniPay docs) were not — `grants-funding.md`,
`minipay-requirements.md`, `minipay-common-mistakes.md`, and their sections
below were left untouched this run (the docs.celo.org side of the MiniPay
map *was* checked, via source 1 — see §6).

Previous attempt: 2026-08-24 — PARTIAL BLOCK (celopg.eco: 403, org egress
policy denial). Sources 1-4 were reachable and verified; source 5 was not.

## 1. Docs sitemap (`docs-map.md`)

- Source: `docs.celo.org/llms.txt`
- Last verified: 2026-09-28
- ~228 pages total (down from ~264 — see consolidation below, not a real
  content loss). **`infra-partners/*` and the top-level `/specs/*` section
  both merged into one new `/operate/*` tree**: notices → `operate/notices/*`,
  node-operator guides → `operate/operators/*`, L2 spec pages →
  `operate/specification/*`. Old paths 308-redirect, confirmed on-sample.
  **The entire ~40-page `/legacy/*` tree (added just last run) has already
  been replaced** by a single new page, `home/celo-l1` — old `/legacy/*`
  URLs redirect there, and `/legacy/faq` redirects to the new
  `operate/operators/faq`. **MiniPay pages on docs.celo.org shrank to one**:
  `build-on-minipay/quickstart`, `code-library`, `deeplinks`, and
  `prerequisites/ngrok-setup` are gone from the sitemap — all four
  308-redirect to `build-on-minipay/overview`, which now points out to
  `docs.minipay.xyz` for everything else (fixed the stale mirror table in
  `minipay-docs-map.md` and the dead links in `ecosystem.md`; see §6 — the
  docs.minipay.xyz side itself is unverified this run, blocked). New:
  a 7-page **Staking** subsection under `home/protocol/staking/*` (not
  previously tracked at all), `home/protocol/metadata`, two new
  Bridging-CELO-from/to-Ethereum guides, `build-with-ai/self-agent-id`,
  `build-with-ai/mcp/celina`, `build-with-usat`, `build-on-socialconnect`,
  `tooling/oracles/wit-oracle`, `tooling/overview/migrate/from-ethereum`.
  thirdweb consolidated to one page (`tooling/dev-environments/thirdweb`);
  the separate "Thirdweb SDK" libraries-sdks page is gone. Also found and
  fixed two long-stale dead links unrelated to this run's diff:
  `docs.celo.org/legacy/protocol/identity/odis-use-case-...` and
  `docs.celo.org/developer/contractkit/data-encryption-key` in
  `odis-socialconnect.md`, both now pointing at their live redirect targets.

## 2. Contract addresses (`contracts.md`)

- Source: `docs.celo.org/tooling/contracts/*`
- Last verified: 2026-09-28
- Core protocol contracts (mainnet + Sepolia testnet), all Mento stablecoin
  addresses (mainnet + testnet), all external/third-party stablecoin
  addresses, all L1 bridge contracts (mainnet + Sepolia), and Uniswap V3/V4
  mainnet addresses — **every address checked matched the live pages
  exactly, zero drift.**
- **Previously flagged item now resolved, no longer needs review**: last
  run flagged a mismatch between our cached testnet USDm/EURm addresses and
  the live `stablecoin-contracts` page. Re-checked this run against the
  live `stablecoin-contracts` and `fee-currencies` pages — `contracts.md`'s
  testnet table already carries the correct, separate USDm/EURm vs. legacy
  cUSD/cEUR addresses and matches live exactly. Someone fixed this since
  the last run; dropping the flag.
- **Added** (new, not previously tracked): a Uniswap V4 Celo Sepolia
  testnet address table — the live `uniswap-contracts` page now lists a
  full V4 Sepolia deployment that wasn't there (or wasn't tracked) before.

## 3. Network info (`network-info.md`)

- Source: `docs.celo.org/build-on-celo/network-overview`, cross-checked
  against `docs.celo.org/tooling/contracts/fee-currencies`
- Last verified: 2026-09-28
- Mainnet chain ID: `42220`; Sepolia testnet chain ID: `11142220` — unchanged
- Public RPC: `https://forno.celo.org` — unchanged
- Fee-currency (gas abstraction) allowlist: re-verified against the live
  `fee-currencies` contracts page — still exactly 20 tokens (14 Mento
  currencies + USDm/EURm/USDC/USDT/USAT/WETH/XAUt0), all addresses
  unchanged, including the USDC/USDT/USAT/XAUt0 adapter addresses.
  `builder-guide.md`'s canonical fee-currency table remains stale but out of
  this skill's tracked scope — still flagged for follow-up, not edited.
- `FeeCurrencyDirectory`: `0x15F344b9E6c3Cb6F0376A36A64928b13F62C6276` — unchanged
- Note: the live `network-overview` page itself no longer carries a
  Fee-Accepted Tokens table at all (that content lives solely on the
  `fee-currencies` contracts page now) — `network-info.md`'s own table is
  still accurate, just sourced from the contracts page rather than
  network-overview from here on.

## 4. Ecosystem / TVL (`ecosystem.md`)

- Source: DefiLlama (`api.llama.fi/protocols`), docs.celo.org, celo.org/ecosystem
- Last verified: 2026-09-28
- Categories tracked: DEXes (11, +Textile FX — real Celo TVL on DefiLlama,
  ~$1.8M, multi-chain credit/lending-style DEX), Lending (3, unchanged),
  Yield/Liquidity mgmt (6, unchanged), Stablecoins (2), Liquid Staking (1),
  Derivatives (1), RWA (7), Payments/Streaming (1), plus Governance section
  — all previously-tracked protocols re-confirmed present on Celo via
  DefiLlama.
- Moola Market: still has real DefiLlama TVL (~$1.2M) but its site
  (`moola.market`) is still unreachable from this sandbox (same finding as
  last run) — left out per the standing decision, not re-added.
- Uniswap V4 still has no separate DefiLlama TVL entry on Celo (unchanged
  from last run — still treated as a DefiLlama indexing quirk given
  contracts are confirmed live via `uniswap-contracts`; no action taken).
- A handful of very-low-TVL DefiLlama entries on Celo (Symmetric, AutoRange,
  Mobius Money, DONASWAP V2, each under ~$500K or near-zero) were not added
  — `ecosystem.md` is a curated directory, not a full DefiLlama mirror.

## 5. Grant programs (`grants-funding.md`)

- Source: `www.celopg.eco/programs` (status changes frequently — this file
  is explicitly a stale-prone cache per its own header)
- **Not verified this run either** — `celopg.eco` again returned a 403 from
  the sandbox's org egress policy (`connect_rejected`, same as last run);
  see PR docs-watch/2026-09-28.
- Currently-Live programs tracked (as of 2026-05-18, unverified since):
  Proof of Ship S2, Prezenti Anchor Round (through 2026-06-30), Prezenti
  Frontier Pool S2 (through 2026-06-30), GoodBuilders Season 3 (through
  2026-05-18), Celo Builder Fund (year-round through 2026-12-31).
- Note: several of the above end dates are now well in the past relative to
  this run (2026-09-28) — likely flipped to "Past" but unconfirmed for two
  runs in a row now. Re-check status once celopg.eco is reachable.

## 6. MiniPay docs (`minipay-docs-map.md`, `minipay-requirements.md`, `minipay-common-mistakes.md`)

- Source: `docs.minipay.xyz` (page tree, submission page, best-practices page,
  deeplinks page)
- **Not verified this run** — `docs.minipay.xyz` returned a 403 from the
  sandbox's org egress policy (`connect_rejected`), so none of the page
  tree, deeplinks, or policy checklist below was re-checked this run; see PR
  docs-watch/2026-09-28. The docs.celo.org *mirror* of MiniPay content was
  checked (via source 1, reachable) — see §1 above; that check found the
  docs.celo.org side lost its Quickstart/Code Library/Deeplinks/Ngrok-Setup
  pages and fixed the stale references in `minipay-docs-map.md` and
  `ecosystem.md`, but that's a docs.celo.org fact, not a docs.minipay.xyz
  one. Facts below are carried over unverified from 2026-09-10.
- Last verified (docs.minipay.xyz itself): 2026-09-10
- **Page tree** as cached in `minipay-docs-map.md`: Getting Started (overview,
  why-minipay, availability, quick-start), Installation (project-setup,
  setup-react, test-in-minipay, faq), Guides (wallet-connection,
  ui-and-container, smart-contracts, best-practices, deployment,
  submit-your-miniapp), Reference (technical-references overview, deeplinks,
  retrieve-balance, send-transaction, gas-estimation, phone-number-lookup),
  Custom Methods (overview, get-exchange-rate, scan-qr-code, request-contact).
  Note the flat `getting-started/` prefix on the Guides pages — a move to a
  `guides/` prefix would be a structural change worth catching (bare
  `/guides/*.html` paths currently 404).
- **Deeplinks** (host `link.minipay.xyz`): `add_cash` (opt.
  `?tokens=USDm,USDC,USDT`), `browse?url=`, `discover`, `receipt?tx=[&celebrate]`,
  `qr`, `invite_friends`, `balance`. `minipay.opera.com` does **not** resolve —
  if it reappears anywhere in the references, that's a regression.
- **Submission URLs**: `https://minipay.to/mini-apps` (Stage 1 intake, cached)
  and `https://developer.minipay.to/mini-app-listing` (same form as linked from
  the docs page). Both returned 200 as of the 2026-09-10 verification.
- **Listing policy currently cached** in `minipay-requirements.md` — treat any
  divergence as `needs review`, never an auto-edit:
  USDT support mandatory · no non-native tokens · no CELO in UI · zero-click
  connect · no `personal_sign` / `eth_signTypedData` · no display/copy/share of
  wallet addresses · no withdrawals to arbitrary external addresses ·
  pre-flight balance check against amount + network fee · pending/success/failure
  transaction states · UI copy rules (Network fee / Deposit / Withdraw /
  Stablecoin) · 360×640 minimum viewport · SVG/WebP assets · PageSpeed score
  submitted · URL/origin manifest · contracts verified on Celoscan + sample tx
  hashes · in-app support link · 24h critical-fix SLA · ToS + Privacy + Support
  + About + How to Use in footer/menu · operator disclaimer (not Opera/MiniPay) ·
  whitelisting integrity (frozen addresses/signatures/URLs post-approval) ·
  dependency security (pinned versions, 7-day minimum age, `ignore-scripts=true`,
  committed lockfile, frozen CI installs).
