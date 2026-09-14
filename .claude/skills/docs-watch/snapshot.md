# docs-watch snapshot — facts we depend on

Baseline seeded: 2026-07-07 (from the repo's own reference files, not a fresh
live fetch — their own "Last updated" stamp is 2026-04-15, so treat this
snapshot as unverified against live sources until the first real run).

Last attempt: 2026-09-14 — PARTIAL BLOCK (celopg.eco: 403, org egress policy
denial — same failure mode as the 2026-08-24 run; two runs in a row now —
see PR for the run's docs-watch/2026-09-14 branch). Sources 1-4 (docs
sitemap, contracts, network info, DefiLlama TVL) were reachable and
verified; source 5 (grant programs) was not — `grants-funding.md` and its
section below were left untouched this run.

## 1. Docs sitemap (`docs-map.md`)

- Source: `docs.celo.org/llms.txt`
- Last verified: 2026-09-14
- ~224 pages total (down from ~264) — another major restructuring: the
  top-level `/specs/` section (itself new as of the last run) and the
  entire `infra-partners/*` tree were both folded into a single new
  `/operate/*` prefix (`operate/specification/*`, `operate/operators/*`,
  `operate/notices/*`), which also gained a new `operate/operators/faq`
  page. MiniPay lost its Quickstart/Code Library/Deeplinks/ngrok-setup
  pages (only `build-on-minipay/overview` remains). "Regional DAOs"
  (`contribute-to-celo/daos`) and the standalone "Thirdweb SDK" page were
  removed; `tooling/dev-environments/thirdweb/overview` lost its
  `/overview` suffix. New pages: "About Celo L1", "Metadata and Claims", a
  new non-legacy "Staking" subsection (8 pages: overview, Locked CELO,
  validator elections/groups, voting, key management ×3), SocialConnect
  intro, "Build with USAT", 2 new AI pages (Celina, Self Agent ID), 2 new
  bridging how-tos (bridge/withdraw CELO from/to Ethereum), a Witnet oracle
  guide, a Celo-for-Ethereum-devs migration guide, and a Ledger EIP-712
  workaround. ContractKit gained 6 unlisted pages (same curation approach
  as the CLI subcommand pages). CLI subcommand reference is actually 19
  pages, not 18 as previously recorded (pre-existing miscount, now fixed).

## 2. Contract addresses (`contracts.md`)

- Source: `docs.celo.org/tooling/contracts/*`
- Last verified: 2026-09-14
- Core protocol contracts (mainnet + Sepolia testnet): all 20 tracked
  addresses verified unchanged against `core-contracts`, `stablecoin-
  contracts`, `l1-contracts`, `uniswap-contracts`, `fee-currencies`.
- Registry address: `0x000000000000000000000000000000000000ce10`
- Mento stablecoins tracked: 15 — all mainnet + testnet addresses verified
  unchanged.
- **Previously flagged item now resolved**: last run flagged the Celo
  Sepolia testnet USDm/EURm addresses as needing review (they appeared to
  duplicate the legacy cUSD/cEUR addresses). `contracts.md` now correctly
  shows USDm/EURm as separate deployments from legacy cUSD/cEUR on
  testnet, matching live `stablecoin-contracts` exactly — someone resolved
  this between runs. No outstanding needs-review item here.
- **Reference update applied**: added a new "Uniswap V4 (Celo Sepolia
  Testnet)" address table — Uniswap V4 is now also deployed on Sepolia
  (previously only on mainnet), at different addresses than the existing
  V3-on-Alfajores table.

## 3. Network info (`network-info.md`)

- Source: `docs.celo.org/build-on-celo/network-overview`, `tooling/contracts/fee-currencies`
- Last verified: 2026-09-14
- Mainnet chain ID: `42220`; Sepolia testnet chain ID: `11142220` — unchanged
- Public RPC: `https://forno.celo.org` — unchanged
- Fee-currency (gas abstraction) tokens: all 20 mainnet allowlist addresses
  (14 Mento currencies + USDm/EURm/USDC/USDT/USAT/WETH/XAUt0) verified
  unchanged against live `fee-currencies` docs page. `builder-guide.md`'s
  canonical fee-currency table remains stale but is still out of this
  skill's tracked scope — not re-flagged, same as last run.
- `FeeCurrencyDirectory`: `0x15F344b9E6c3Cb6F0376A36A64928b13F62C6276` — unchanged
- No drift — `network-info.md` required no edits this run.

## 4. Ecosystem / TVL (`ecosystem.md`)

- Source: DefiLlama (`api.llama.fi/protocols`), docs.celo.org, celo.org/ecosystem
- Last verified: 2026-09-14
- Re-checked all tracked categories (DEXes, Lending, Yield/Liquidity mgmt,
  Stablecoins, Liquid Staking, Derivatives, RWA, Payments/Streaming,
  Governance, Other) against the current DefiLlama Celo-chain protocol
  list (86 protocols total). Every tracked entry still matches; no new
  protocol crossed into "notable" territory and none of the tracked ones
  dropped off. Moola Market and Uniswap V4's DefiLlama-indexing quirk
  remain as previously noted, unchanged.
- No drift — `ecosystem.md` required no edits this run.

## 5. Grant programs (`grants-funding.md`)

- Source: `www.celopg.eco/programs` (status changes frequently — this file
  is explicitly a stale-prone cache per its own header)
- **Not verified this run (second run in a row)** — `celopg.eco` returned a
  403 from the sandbox's org egress policy again (not the site itself,
  confirmed via `curl -v` and the proxy's own recent-failures log); see PR
  docs-watch/2026-09-14. Same failure as the 2026-08-24 run — this looks
  like a persistent egress allow-list gap rather than a transient outage,
  worth a human adding `celopg.eco` to the allow-list rather than waiting
  for it to resolve on its own.
- Note: unlike the snapshot's own facts below (last touched 2026-05-18,
  now stale), `grants-funding.md` itself was independently updated by a
  human on 2026-08-28 with current program data (Agents at Work Hackathon,
  Prezenti Season 3, Celo Builder Fund, etc.) — the file is more current
  than this snapshot section suggests. This section still can't be
  refreshed from live data until celopg.eco is reachable again, so it is
  left as-is rather than guessed at.
