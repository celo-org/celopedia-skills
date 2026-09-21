# docs-watch snapshot — facts we depend on

Baseline seeded: 2026-07-07 (from the repo's own reference files, not a fresh
live fetch — their own "Last updated" stamp is 2026-04-15, so treat this
snapshot as unverified against live sources until the first real run).

Last attempt: 2026-09-21 — PARTIAL BLOCK (celopg.eco: connection refused by
the sandbox's org egress policy, same as 2026-08-24; docs.minipay.xyz: same
egress-policy denial, newly blocked this run — see PR for the run's
docs-watch/2026-09-21 branch). Sources 1-4 (docs sitemap, contracts, network
info, DefiLlama TVL) were reachable and verified; sources 5 (grant programs)
and 6 (MiniPay docs) were not — `grants-funding.md`, `minipay-requirements.md`,
`minipay-common-mistakes.md`, and their sections below were left untouched
this run. `minipay-docs-map.md` did get one mechanical edit sourced from
docs.celo.org (not docs.minipay.xyz) — see its section below.

## 1. Docs sitemap (`docs-map.md`)

- Source: `docs.celo.org/llms.txt`
- Last verified: 2026-09-21
- ~229 pages total as of this count (down from ~264 — see below). Biggest
  finding: **the `/legacy/` tree added just last run (~40 pages) is gone
  again**, lasting about a month. It didn't just disappear — its PoS/
  validator content was promoted into a new mainline **Staking** subsection
  under `home/protocol/staking/*` (8 pages), and everything else collapsed
  into one new **About Celo L1** page (`home/celo-l1`) plus `legacy/faq` →
  `operate/operators/faq`. Also: **the entire `/infra-partners/*` tree was
  renamed to `/operate/*`**, and **`/specs/*` was renamed to
  `/operate/specification/*`** (both confirmed via clean 308 redirects, old
  URLs still resolve, just not listed in the sitemap anymore). MiniPay's
  `build-on-celo/build-on-minipay/{quickstart,code-library,deeplinks,
  prerequisites/ngrok-setup}` all collapsed into the single `overview` page
  (docs.celo.org side only — `docs.minipay.xyz` keeps the full tree, but
  that source was blocked this run, see top of file). "Thirdweb SDK"
  (`tooling/libraries-sdks/thirdweb-sdk`) merged into the dev-environments
  "Thirdweb Overview" page. "Regional DAOs" (`contribute-to-celo/daos`) is
  gone, redirecting to the section index rather than a replacement. New
  pages added: `home/protocol/metadata`, `build-with-ai/{self-agent-id,
  mcp/celina}`, `build-on-celo/{build-with-usat,build-on-socialconnect}`,
  `home/bridged-tokens/{bridging-celo-from-ethereum,
  withdrawing-celo-to-ethereum}`, `tooling/oracles/wit-oracle`,
  `tooling/wallets/ledger/eip712-workaround`,
  `tooling/overview/migrate/from-ethereum`, and 6 new ContractKit pages
  (3 migration guides + registry/wrappers, data-encryption-key, web3-compat
  notes). Celo CLI subcommand count corrected to 19 (was miscounted as 18
  last run — no actual page change). Unchanged since 2026-08-24: Fee
  Abstraction subsection, `stablecoin-contracts` rename, `fee-currencies`
  page, MultiBaas dev environment, "Agent Skills"/"Code of Conduct"/
  "Exchange Assets"/standalone "Faucet" tooling page all still absent.

## 2. Contract addresses (`contracts.md`)

- Source: `docs.celo.org/tooling/contracts/*`
- Last verified: 2026-09-21
- Core protocol contracts (mainnet + Celo Sepolia): all addresses verified
  unchanged against `core-contracts`, `stablecoin-contracts`, `l1-contracts`,
  `uniswap-contracts`.
- Registry address: `0x000000000000000000000000000000000000ce10`
- Mento stablecoins tracked: 15 (USDm, EURm, BRLm, XOFm, KESm, NGNm, COPm,
  GBPm, CHFm, JPYm, AUDm, CADm, GHSm, PHPm, ZARm) — all mainnet + testnet
  addresses verified unchanged, including USDm/EURm on Celo Sepolia.
- The 2026-08-24 testnet USDm/EURm flag (legacy-address mismatch) is
  **resolved** — `contracts.md` now correctly documents Celo Sepolia's
  separate USDm/EURm deployments (distinct from legacy cUSD/cEUR) with a
  dated verification note; this run re-confirmed those addresses live and
  found no further drift. Nothing left open on this source.

## 3. Network info (`network-info.md`)

- Source: `docs.celo.org/build-on-celo/network-overview`, `docs.celo.org/tooling/contracts/fee-currencies`
- Last verified: 2026-09-21
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
- Last verified: 2026-09-21
- Categories tracked: DEXes (10), Lending (3; Morpho Blue), Yield/Liquidity
  mgmt (6), Stablecoins (2), Liquid Staking (1), Derivatives (1), RWA (7),
  Payments/Streaming (1), plus Governance section — all counts unchanged
  since 2026-08-24, no adds/removals to the tracked list this run.
- Moola Market (`mm.moola.market`) still shows real TVL (~$1.2M) on
  DefiLlama's Celo protocol list, same as last run, but its site is still
  unreachable from this sandbox — can't distinguish a real outage from an
  org egress-policy block this time (both `mm.moola.market` and
  `moola-market.com` were rejected at the proxy with the same 403 as
  celopg.eco/docs.minipay.xyz below). No action taken; worth a manual check
  next time this sandbox isn't blocking it.
- Uniswap V4 still has no separate DefiLlama TVL entry on Celo (contracts
  confirmed live via `uniswap-contracts` docs page) — unchanged, no action.
- Fixed the MiniPay quickstart/code-library/deeplinks links in "Building for
  MiniPay" to point at the (now-consolidated) docs.celo.org overview page
  and docs.minipay.xyz — see docs sitemap section above.

## 5. Grant programs (`grants-funding.md`)

- Source: `www.celopg.eco/programs` (status changes frequently — this file
  is explicitly a stale-prone cache per its own header)
- **Not verified this run, again** — `celopg.eco` returned the same
  connection-rejected/403 from the sandbox's org egress policy (not the
  site itself) as the 2026-08-24 run; see PR docs-watch/2026-09-21.
- Currently-Live programs tracked (as of 2026-05-18, unverified since):
  Proof of Ship S2, Prezenti Anchor Round (through 2026-06-30), Prezenti
  Frontier Pool S2 (through 2026-06-30), GoodBuilders Season 3 (through
  2026-05-18), Celo Builder Fund (year-round through 2026-12-31).
- Note: several of the above end dates are now well in the past relative to
  this run (2026-09-21) — likely flipped to "Past" but still unconfirmed,
  two runs in a row. Re-check status on the next run once celopg.eco is
  reachable from this sandbox; consider flagging the persistent egress
  block itself if a third consecutive run is also blocked.

## 6. MiniPay docs (`minipay-docs-map.md`, `minipay-requirements.md`, `minipay-common-mistakes.md`)

- Source: `docs.minipay.xyz` (page tree, submission page, best-practices page,
  deeplinks page)
- Last verified: 2026-09-10 — **not reachable this run** (2026-09-21):
  `docs.minipay.xyz` returned the same connection-rejected/403 from the
  sandbox's org egress policy as `celopg.eco` (source 5), newly blocked
  where it wasn't on 2026-09-10. Nothing below was re-verified; the facts
  and dates are carried over unchanged from the last successful check.
  One cross-reference fix *was* made from the docs.celo.org side this run
  (see docs sitemap section above and the "External" note): the
  `docs.celo.org` mirror of Quickstart/Code Library/Deeplinks collapsed
  into a single Overview page, so `minipay-docs-map.md`'s "External:
  Build-on-MiniPay on docs.celo.org" table was corrected to match — that
  edit didn't require touching docs.minipay.xyz itself.
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
  the docs page). Not re-checked this run (blocked, see above) — last
  confirmed 200 on 2026-09-10.
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
