# Feedback & issue routing

Walks a user through reporting a bug or proposing a feature for the Celo
developer tools — without leaving their editor — and **routes** it to the
right repo. Default output is a GitHub **issue**; for small fixes to sources
we can edit (this skill's reference files and the Celo docs), offer a **pull
request** instead. Files via the GitHub CLI (`gh`), with a prefilled
browser-form fallback when `gh` is unavailable.

Use this when the user says things like "report a bug", "request a feature",
"something's wrong in the docs / this skill", "file an issue", or "give
feedback".

## 1. Route — pick the destination repo

Map the feedback to exactly one target using this table. If it's ambiguous,
ask the user to pick.

| Feedback is about | Target repo | Default action |
|---|---|---|
| The Celopedia skill itself (its content / reference files) | `celo-org/celopedia-skills` | Issue; **offer a PR** for a small reference-file fix |
| Celo docs (docs.celo.org) | `celo-org/docs` | Issue; **offer a PR** for a small doc fix |
| Celo Composer (scaffolding / templates) | `celo-org/celo-composer` | Issue |
| x402 SDK / attribution tags / ERC-8021 | `celo-org/attribution-tags` | Issue |
| x402 facilitator / gateway / payment infra | `celo-org/x402-facilitator` | Issue |

Routing hints:
- Wrong/outdated fact **in this skill's answer or reference files** →
  `celo-org/celopedia-skills`.
- Wrong/outdated content **on docs.celo.org** → `celo-org/docs`.
- Anything about `npx @celo/celo-composer`, templates, or scaffolding →
  `celo-org/celo-composer`.
- x402: the SDK, `@celo/attribution-tags`, attribution/data-suffix, ERC-8021
  → `celo-org/attribution-tags`; the running facilitator, gateway, Docker
  image, or payment infra → `celo-org/x402-facilitator`. If unclear which of
  the two, ask.

## 2. Collect — fill the template

First check whether the target repo already publishes its own issue forms and
mirror them if so:

```bash
gh api "repos/<target>/contents/.github/ISSUE_TEMPLATE" -q '.[].name' 2>/dev/null
```

If that returns templates, follow their fields. Otherwise use the generic
templates below — ask the user only for the fields that are still blank.

**Bug report**

```markdown
### What happened
<observed behavior>

### Expected
<what should have happened>

### Steps to reproduce
1. <step>
2. <step>

### Environment
<tool + version, OS, network (mainnet/alfajores), links>

### Additional context
<logs, screenshots, references>
```

**Feature request**

```markdown
### Problem / motivation
<what's missing or painful today>

### Proposed solution
<what you'd like>

### Alternatives considered
<optional>

### Additional context
<optional>
```

## 3. Confirm — privacy gate (always)

Before filing anything, show the user the drafted **title**, **body**, and the
**target repo**, and get explicit confirmation.

The draft must be public-safe. Strip anything private into neutral phrasing:
- No personal names ("a user reported" / "the partner team", not "X said").
- No references to private calls, meetings, transcripts, or internal reviews.
- No verbatim quotes from pasted source material.
- No private dates (public dates like a release are fine).

## 4. File — issue (default)

```bash
gh issue create \
  --repo <target> \
  --title "<title>" \
  --body "<body>" \
  --label bug        # or: enhancement — omit if the label doesn't exist on the repo
```

`gh issue create` prints the new issue URL — surface it to the user.

## 5. File — pull request (small fixes only)

Only for `celo-org/celopedia-skills` (this repo's reference files) and
`celo-org/docs`, and only for small, unambiguous edits. This reuses the PR
pattern from `.claude/skills/docs-watch/SKILL.md` and the README "Contributing"
flow (check the current value → edit the file → bump the version → open a PR).

```bash
# from a checkout/fork of the target repo
git checkout -b feedback/<short-slug>
# apply the edit; for celopedia-skills, also bump `version` in
# skills/celopedia-skill/SKILL.md if a reference file changed
git commit -am "<summary>"
git push -u origin feedback/<short-slug>
gh pr create --repo <target> --base main \
  --head <fork-owner>:feedback/<short-slug> \
  --title "<summary>" --body "<what changed and why>"
```

For anything ambiguous or high-stakes (a contract address, a chain param,
security-sensitive data) do **not** guess a fix — file an issue instead and
describe observed-vs-expected.

## 6. Fallback — no `gh` / not authenticated

If `gh` is missing or `gh auth status` fails, don't block. Build a prefilled
browser URL and hand it to the user to submit manually.

```bash
gh auth status   # if this fails, use the browser fallback
```

Prefilled new-issue link (URL-encode title and body):

```
https://github.com/<target>/issues/new?title=<url-encoded-title>&body=<url-encoded-body>
```

If the repo has issue forms, point the user at the chooser instead:

```
https://github.com/<target>/issues/new/choose
```

## Notes

- One piece of feedback → one destination. If a report spans two tools, file
  the primary one and mention the other in the body.
- Confirm the exact repo slug with `gh repo view <target>` if a file/route ever
  looks stale — slugs can change.
