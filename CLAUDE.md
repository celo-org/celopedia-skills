# CLAUDE.md — celopedia-skills

> Repo-owned. Keep it LEAN: a router. Shared rules are imported below and synced from pm-kit — don't restate them here. Every Claude session (local, Cowork, CI action) reads this.

## What this project is

The Celopedia skill: a comprehensive, installable agent skill for building on Celo — ecosystem intelligence, developer tools, DeFi protocols, MiniPay integration, AI agent infrastructure, governance, grants, and verified contract addresses. Consumed by developers and AI agents via `npx skills add celo-org/celopedia-skills` (Codex/OpenClaw) or copied under `.claude/skills/` for Claude Code. The published skill content IS the product — there is no app or server.

## Commands

**There is no build, no test suite, and no package manager here** — no `package.json`,
no `Makefile`. The published markdown IS the artifact, so "does it build" is not a
question this repo can answer. Verify content by reading it and by checking claims at
their source (see Gotchas).

The only executable things in the repo:

- `scripts/generate_minipay_live_apps.py` — rebuilds the MiniPay live-apps list; edit
  the generator, never its output
- `scripts/collect_traffic_stats.sh` — weekly usage snapshot; run by
  `.github/workflows/usage-stats.yml`, writes to the `stats` branch

If you add a runner, update this section and `.github/workflows/` in the same PR.

## Architecture pointers

- `skills/celopedia-skill/` — the skill itself: SKILL.md plus reference files; this is what installs into agents
- `scripts/` — content generators (e.g. `generate_minipay_live_apps.py` builds the live-apps list)
- `.github/workflows/celopedia-skill-tag.yml` — tags skill releases from the `version:` in `SKILL.md`
- `.github/workflows/issue-priority-label.yml` — turns the issue forms' Priority/Size dropdowns into labels
- `.claude/skills/` — local mirror so sessions in this repo load the skill

## Team rules (shared, synced — read them)

@.claude/shared/engineering-rules.md

Money/security diffs additionally run: @.claude/shared/money-path-checklist.md
Before a real-money / real-send path goes public, it runs in production behind tester mode: @.claude/shared/tester-mode-pattern.md

The ten you must never violate, even without reading the above:
1. Never push to `main`. Branch `<handle>/<issue>-<slug>` → PR → squash. Title = the commit on `main` (Conventional Commits, scoped, outcome).
2. One concern per PR, one fix-unit per issue, one priority per issue.
3. Every change ships the test that fails on pre-fix code, through the seam it touches (route/CLI/component), and any prose guarantee is tested on its failure path. State the mutation count in the PR.
4. `Closes #N` only if every acceptance box is met; otherwise `Refs #N`. After merge, check what actually closed.
5. Every claim in an issue/PR/review is evidence-backed: commands + output, `file:line`. "Confirmed" means you ran it. Measured over reasoned — thresholds and constants pinned in a test, not a comment.
6. Say what the PR does NOT do (with numbers). Say what it actually does, even beyond the ticket. Flag judgement calls and bundled product changes for the maintainer.
7. On review feedback: reproduce first, fix, audit your own fix, report what it taught. Answer every point FIXED / NOT-FIXED / DISAGREE-with-measurement; never a silent push; never delete a wrong claim — strike it through.
8. Use only existing labels: `bug` `enhancement` `chore` `priority:critical|high|medium|low` `size:S|M|L` `status: triage`. Never invent labels. Priority and Size are set by the issue form's dropdowns and applied automatically by `.github/workflows/issue-priority-label.yml`; add them by hand only when filing outside the form.
9. Ask before anything outward-facing or irreversible (external repos, posting, deleting, force-pushing shared branches). Propose, never execute.
10. No secrets in diffs. New env vars → `.env.example` + runbook, in the same PR.

Use the plugin commands: `/file-issue`, `/write-pr`, `/review-pr`, `/post-merge`, `/close-pr`.

## Product context

- Team board: https://github.com/orgs/celo-org/projects/209

## Gotchas

- Facts in skill content must be verified at the source (contract addresses via explorer/`eth_call`, not memory) — wrong addresses in an installed skill propagate to every consumer agent
- Claude Code only discovers skills under `.claude/skills/` — `npx skills add` alone is not enough (see README install options)
- Generated sections (e.g. MiniPay live apps) are rebuilt by `scripts/` — edit the generator, not the output
