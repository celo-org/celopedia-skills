#!/usr/bin/env bash
# Collects usage proxies for the Celopedia skills repo and appends them to
# stats/traffic-history.json (+ regenerates stats/SUMMARY.md).
#
# Sources:
#   - GitHub traffic API (14-day rolling window — the whole reason this runs weekly)
#   - skills.sh install counters (all-time, scraped from the public page; best-effort)
#
# Requires: gh (authenticated with Administration: read — traffic endpoints 403 otherwise), jq, curl, perl.
set -euo pipefail

REPO="${STATS_REPO:-celo-org/celopedia-skills}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STATS_DIR="$ROOT/stats"
HISTORY="$STATS_DIR/traffic-history.json"
SUMMARY="$STATS_DIR/SUMMARY.md"

mkdir -p "$STATS_DIR"
[ -s "$HISTORY" ] || printf '{"repo":"%s","daily":{},"runs":[]}\n' "$REPO" > "$HISTORY"

overview=$(gh api "repos/$REPO")
clones=$(gh api "repos/$REPO/traffic/clones")
views=$(gh api "repos/$REPO/traffic/views")
paths=$(gh api "repos/$REPO/traffic/popular/paths")
referrers=$(gh api "repos/$REPO/traffic/popular/referrers")

# --- skills.sh install counters (best-effort: the page is an RSC payload and may change) ---
installs_total=null
installs_skills='{}'
if page=$(curl -fsSL --max-time 30 "https://skills.sh/$REPO" 2>/dev/null); then
  total=$(grep -oE '[0-9]+<!-- --> total installs' <<<"$page" | grep -oE '^[0-9]+' | head -1 || true)
  [ -n "$total" ] && installs_total=$total
  # Join Next.js RSC streaming chunks (a chunk boundary can split a row mid-pattern),
  # then drop JSON escaping so one regex works regardless of nesting depth.
  flat=$(perl -0777 -pe 's/"\]\)<\/script>\s*<script>self\.__next_f\.push\(\[1,"//g' <<<"$page" | tr -d '\\')
  # Skill names come from the page's own links (the local checkout may not
  # contain every listed skill, e.g. docs-watch lives outside skills/ here).
  names=$(grep -oE "\"/?(www\.skills\.sh/)?$REPO/[A-Za-z0-9._-]+\"" <<<"$flat" \
    | sed -E "s|.*$REPO/||; s|\"||g" | grep -v '^opengraph-image' | sort -u || true)
  [ -n "$names" ] || names=$(ls "$ROOT/skills" 2>/dev/null || true)
  for name in $names; do
    n=$(perl -0777 -ne 'while (/'"$name"'"\}\]\}\].{0,500}?"children":"([0-9]+)"/gs) { print "$1\n"; }' <<<"$flat" | head -1 || true)
    if [ -n "$n" ]; then
      installs_skills=$(jq --arg k "$name" --argjson v "$n" '. + {($k): $v}' <<<"$installs_skills")
    fi
  done
fi
installs_json=$(jq -n --argjson total "$installs_total" --argjson skills "$installs_skills" \
  '{total: $total, skills: $skills}')

run_entry=$(jq -n \
  --argjson overview "$overview" \
  --argjson clones "$clones" \
  --argjson views "$views" \
  --argjson referrers "$referrers" \
  --argjson paths "$paths" \
  --argjson installs "$installs_json" \
  '{
    run_at: (now | todate),
    stars: $overview.stargazers_count,
    forks: $overview.forks_count,
    clones_14d: {count: $clones.count, uniques: $clones.uniques},
    views_14d: {count: $views.count, uniques: $views.uniques},
    installs: $installs,
    referrers: $referrers,
    paths: ($paths | map({path, count, uniques}))
  }')

# Merge daily arrays (upsert by date, keeping the max — GitHub revises recent days upward).
merged=$(jq \
  --argjson clones "$clones" \
  --argjson views "$views" \
  --argjson run "$run_entry" '
  def nmax(a; b): if a == null then b elif b == null then a elif a > b then a else b end;
  def upsert(kind; arr):
    reduce arr[] as $d (.;
      ($d.timestamp[:10]) as $day
      | .daily[$day][kind] = {
          count:   nmax(.daily[$day][kind].count;   $d.count),
          uniques: nmax(.daily[$day][kind].uniques; $d.uniques)
        });
  .daily = (.daily // {})
  | upsert("clones"; ($clones.clones // []))
  | upsert("views";  ($views.views  // []))
  # Upsert runs by day too (keep the latest per date) so a re-run or manual
  # workflow_dispatch on the same day does not duplicate the snapshot row.
  | .runs = (((.runs // []) + [$run]) | group_by(.run_at[:10]) | map(max_by(.run_at)))
  | .daily = (.daily | to_entries | sort_by(.key) | from_entries)
' "$HISTORY")
printf '%s\n' "$merged" > "$HISTORY"

# --- SUMMARY.md ---
monthly=$(jq -r '
  .daily | to_entries | group_by(.key[:7]) | map(
    "| " + .[0].key[:7]
    + " | " + (length | tostring)
    + " | " + ((map(.value.clones.count // 0) | add) | tostring)
    + " | " + ((map(.value.clones.uniques // 0) | add) | tostring)
    + " | " + ((map(.value.views.count // 0) | add) | tostring)
    + " | " + ((map(.value.views.uniques // 0) | add) | tostring)
    + " |") | join("\n")
' "$HISTORY")

snapshots=$(jq -r '
  .runs[-12:] | map(
    "| " + .run_at[:10]
    + " | " + ((.installs.total // "—") | tostring)
    + " | " + ((.installs.skills // {}) | to_entries | map(.key + ": " + (.value | tostring)) | join(", "))
    + " | " + (.stars | tostring)
    + " | " + (.forks | tostring)
    + " |") | join("\n")
' "$HISTORY")

latest=$(jq -r '.runs | last |
  "Last run: " + .run_at
  + " — installs: " + ((.installs.total // "unknown") | tostring)
  + ", stars: " + (.stars | tostring)
  + ", forks: " + (.forks | tostring)' "$HISTORY")

cat > "$SUMMARY" <<EOF
# Celopedia skills — usage stats

Auto-generated by \`scripts/collect_traffic_stats.sh\` (weekly GitHub Action). Do not edit by hand.

$latest

## Monthly traffic

"Cloner days" / "visitor days" sum the per-day unique counts, so they are an
upper bound on distinct users for the month (the same user on two days counts twice).

| Month | Days covered | Clones | Cloner days | Views | Visitor days |
|---|---|---|---|---|---|
$monthly

## Snapshots (skills.sh all-time install counters — last 12 runs)

| Date | Total installs | Per skill | Stars | Forks |
|---|---|---|---|---|
$snapshots
EOF

echo "Updated $HISTORY and $SUMMARY"
