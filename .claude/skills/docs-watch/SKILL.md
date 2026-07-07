---
name: docs-watch
description: Check docs.celo.org and other live sources for drift against this repo's cached reference files (contracts, network info, docs sitemap, ecosystem, grants) and fix or flag it. Use when asked to check docs updates, run the docs watch, or on the scheduled weekly run.
---

# celopedia-skills docs upstream watch

Goal: detect when the facts mirrored into `skills/celopedia-skill/references/`
have drifted from their live sources, and either fix the drift directly
(mechanical changes) or flag it for a human (ambiguous/high-stakes changes) —
following the process already documented in this repo's `README.md`
("Contributing" section: check docs.celo.org → update the file → bump
version → open a PR).

## Sources checked

| # | Source | Fetch command (see `live-data-sources.md` for more) | Reference file |
|---|---|---|---|
| 1 | Docs sitemap | `curl -s https://docs.celo.org/llms.txt` | `docs-map.md` |
| 2 | Contract addresses | `https://docs.celo.org/tooling/contracts/core-contracts` + `token-contracts` + `l1-contracts` + `uniswap-contracts` (WebFetch) | `contracts.md` |
| 3 | Network info | `https://docs.celo.org/build-on-celo/network-overview` (WebFetch) | `network-info.md` |
| 4 | Ecosystem / TVL | `curl -s https://api.llama.fi/protocols \| jq '[.[] \| select(.chains[]? == "Celo")]'` | `ecosystem.md` |
| 5 | Grant programs | `curl -s https://www.celopg.eco/programs` (WebFetch) | `grants-funding.md` |

## Procedure

1. **Load the snapshot** at `.claude/skills/docs-watch/snapshot.md` — the
   facts we currently rely on, with the date each was last verified.

2. **Fetch each source** above and extract the same facts the corresponding
   reference file documents (page list, address table, chain params,
   protocol list, program status table).

3. **Diff** each source against both the snapshot and the current content of
   its reference file.

4. **Classify every delta:**
   - `no action` — cosmetic/unrelated (e.g. a docs page's prose changed but
     not its existence or URL).
   - `reference update` — mechanical, unambiguous fact change: a sitemap page
     added/removed/renamed, a DeFi protocol added/removed from the Celo chain
     list, a grant program's Live/Past status flipped, a new fee-currency
     token added. For these:
     1. Edit the reference file directly with the corrected fact.
     2. Bump `version` in `skills/celopedia-skill/SKILL.md` (patch bump for
        pure data refresh).
     3. Open a PR against `main` titled like `chore(docs): refresh <file> —
        <one-line summary>`, following the README's Contributing steps.
   - `needs review` — anything ambiguous or high-stakes (a contract address
     that doesn't match, a chain ID / fee-currency address change, anything
     touching `contracts.md` core protocol addresses or `network-info.md`
     chain IDs). For these: do **not** edit the file. Open a GitHub issue in
     `celo-org/celopedia-skills` describing exactly what was observed vs.
     what's cached, and why it needs a human to confirm before changing.

5. **Write the report** to `.claude/skills/docs-watch/reports/report-<YYYY-MM-DD>.md`
   and commit it directly to `main` (a plain log entry, not something that
   needs review) — this is the durable location, since a `.context/` file
   would not survive between separate runs of a scheduled routine. One
   section per source: deltas found, classification, and any PR/issue links
   opened. Put a one-line "action needed?" summary at the top — if anything
   is `needs review`, say so first.

6. **Update the snapshot** with newly-verified facts and today's date. Keep
   it small — only the facts checked above, not a full copy of the reference
   files.

## Notes

- `live-data-sources.md` already documents the priority order (live API >
  official docs > hardcoded references > ecosystem directory) — this skill
  exists to keep the "hardcoded references" tier honest, not to replace live
  lookups elsewhere.
- Never guess a contract address or chain parameter to "fix" a `needs
  review` item — that tier exists specifically so factual corrections to
  security-sensitive data always get a human's eyes first.
