#!/usr/bin/env bash
# Pins the Phase 1 audit greps in references/migrating-from-another-chain.md.
#
# The patterns are read out of the markdown, so the test checks what ships, not a
# copy. Each pattern runs from inside fixture/ and its hit set (file:line) must equal
# expected/pN.txt exactly: every genuine hit found, every decoy left out.
#
# Run from anywhere:  tests/migration-audit/test.sh   (needs ripgrep: `rg`)
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
doc="$here/../../skills/celopedia-skill/references/migrating-from-another-chain.md"

command -v rg >/dev/null || { echo "ripgrep (rg) is required" >&2; exit 2; }

# The `rg ...` lines inside the ```bash fence under "## Phase 1".
patterns=()
while IFS= read -r line; do
  patterns+=("$line")
done < <(
  awk '
    /^## Phase 1/ { in_phase = 1; next }
    in_phase && /^## / { exit }
    in_phase && /^```bash/ { in_fence = 1; next }
    in_phase && /^```/ { in_fence = 0 }
    in_phase && in_fence && /^rg / { print }
  ' "$doc"
)

# Names in order: expected/pN.txt is the Nth pattern. A new or removed pattern changes
# the count and fails here until a fixture and an expected file are added for it.
names=(
  distinctive-chain-ids
  noisy-chain-ids
  rpc-and-explorer-hosts
  chain-object-imports
  native-gas-assumptions
  native-payout-idiom
  user-facing-eth
  toolchain-config
)

fail=0
if [ "${#patterns[@]}" -ne "${#names[@]}" ]; then
  echo "FAIL: found ${#patterns[@]} rg patterns in Phase 1, test pins ${#names[@]}" >&2
  fail=1
fi

for i in "${!names[@]}"; do
  n=$((i + 1))
  name="${names[$i]}"
  pattern="${patterns[$i]:-}"
  [ -n "$pattern" ] || continue
  # rg exits 1 on no match; the diff below is the assertion, so tolerate it.
  # </dev/null: with no path argument and a pipe on stdin, rg searches stdin, not the
  # directory (caught when a CI-style pipe made a pattern hang).
  actual="$(cd "$here/fixture" && eval "$pattern" </dev/null | cut -d: -f1,2 | sort || true)"
  expected="$(sort "$here/expected/p$n.txt")"
  if [ "$actual" = "$expected" ]; then
    echo "ok   p$n $name ($(printf '%s\n' "$expected" | grep -c . || true) hits)"
  else
    echo "FAIL p$n $name" >&2
    diff <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") | sed 's/^/     /' >&2 || true
    fail=1
  fi
done

exit "$fail"
