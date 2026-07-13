---
name: docs-watch
description: Check docs.celo.org and other live sources for drift against this repo's cached reference files (contracts, network info, docs sitemap, ecosystem, grants) and fix or flag it. Use when asked to check docs updates, run the docs watch, or on the scheduled weekly run.
---

# celopedia-skills docs upstream watch

Goal: detect when the facts mirrored into `skills/celopedia-skill/references/`
have drifted from their live sources, and surface every finding — mechanical
fixes and ambiguous/high-stakes flags alike — in **one reviewable pull
request per run**, opened against `celo-org/celopedia-skills:main` (the
canonical upstream repo, not a fork), so a human can approve, edit, or
close it. This builds on the process already documented in this repo's
`README.md` ("Contributing" section: check docs.celo.org → update the file
→ bump version → open a PR) but replaces its own ad hoc reports/issues with
a single PR as the one place everything gets reviewed.

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
     not its existence or URL). Not mentioned in the PR.
   - `reference update` — mechanical, unambiguous fact change: a sitemap page
     added/removed/renamed, a DeFi protocol added/removed from the Celo chain
     list, a grant program's Live/Past status flipped, a new fee-currency
     token added. Edit the reference file directly with the corrected fact,
     on the run's branch (see step 5) — do not commit or PR per-item.
   - `needs review` — anything ambiguous or high-stakes (a contract address
     that doesn't match, a chain ID / fee-currency address change, anything
     touching `contracts.md` core protocol addresses or `network-info.md`
     chain IDs). Do **not** edit the file — never guess a fix for these.
     Instead, write a clearly-marked entry describing exactly what was
     observed vs. what's cached, for the "Needs review" section of the PR
     body (step 5).

5. **Every run ends one of three ways** — always distinguishable from each
   other by whether/how a PR shows up, since this skill never writes report
   files:

   - **Drift found** (any `reference update` and/or `needs review` delta):
     open **one** pull request for the whole run.
     1. Create a branch off `main` (e.g. `docs-watch/<YYYY-MM-DD>`).
     2. Apply all `reference update` edits on that branch, and bump
        `version` in `skills/celopedia-skill/SKILL.md` (patch bump for a
        pure data refresh) if any reference file changed.
     3. Update the snapshot (step 6) on the same branch.
     4. Push the branch directly to `celo-org/celopedia-skills` (this
        checkout has push access — no fork needed) and open the PR:
        `gh pr create --repo celo-org/celopedia-skills --base main --head <branch> --title "docs-watch: weekly refresh — <date>" --body "..."`
     5. The PR body is the report — no separate report file. Structure it
        as: a one-line "what changed" summary at the top, one section per
        source with its deltas and classification, a clearly separated
        **Needs review** section for anything requiring human judgment
        (the reviewer approves, pushes edits, or closes the PR), and the
        mechanical edits already applied in the diff.
     6. **One PR covers the whole run** — don't split `reference update`
        and `needs review` findings into separate PRs.

   - **Blocked** (one or more sources unreachable — network error, 403,
     timeout, etc. — so deltas couldn't be assessed for those sources): open
     a small pull request too, so a blocked run is never silently
     indistinguishable from a clean one.
     1. Branch off `main` (e.g. `docs-watch/blocked-<YYYY-MM-DD>`), and only
        edit the "Last attempt" line in `snapshot.md` (step 6) — no
        reference files, no version bump, since nothing was actually
        verified.
     2. Push and open the PR with title `docs-watch: blocked — <date>` and
        a body listing exactly which sources failed and how (status code /
        error), plus which sources (if any) *did* succeed this run.
     3. This PR is informational, not something to merge for content —
        the reviewer's real fix is the underlying blocker (e.g. a network
        egress allow-list). Merging just records the attempt; closing
        without merging is equally fine.

   - **Clean** (every source reachable, every delta `no action`): do not
     open a PR or commit anything — stay completely silent. End with a
     short summary in the final message instead.

6. **Update the snapshot**, on whichever branch step 5 used:
   - On a **drift-found** or **clean** run where sources were reachable:
     update the per-source facts with newly-verified values and set
     `Last verified: <date>` for each source checked.
   - On a **blocked** run: leave the per-source facts untouched (they
     weren't actually re-verified), and only update the top-of-file
     `Last attempt: <date> — BLOCKED (<hosts>)` line.
   - Keep the file small — only the facts checked above, not a full copy of
     the reference files.

## Notes

- `live-data-sources.md` already documents the priority order (live API >
  official docs > hardcoded references > ecosystem directory) — this skill
  exists to keep the "hardcoded references" tier honest, not to replace live
  lookups elsewhere.
- Never guess a contract address or chain parameter to "fix" a `needs
  review` item — that tier exists specifically so factual corrections to
  security-sensitive data always get a human's eyes first.
