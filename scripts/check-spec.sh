#!/usr/bin/env bash
# Spec validity gate: every Allium spec under docs/ must pass `allium check`.
# The spec is the authoritative source of truth, so an invalid spec must fail
# the build. Run from the Maven `validate` phase, where allium (pinned in
# mise.toml as github:juxt/allium-tools) is already on PATH.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

specs="$(find docs -type f -name '*.allium' | sort)"
if [ -z "$specs" ]; then
  echo "spec check: no .allium files found, nothing to check."
  exit 0
fi

rc=0
while IFS= read -r spec; do
  echo "── allium check: $spec"
  allium check "$spec" >/dev/null || rc=1
done <<EOF
$specs
EOF

if [ "$rc" -eq 0 ]; then
  echo "✓ spec check: all Allium specs valid"
else
  echo "✘ spec check FAILED" >&2
fi
exit "$rc"
