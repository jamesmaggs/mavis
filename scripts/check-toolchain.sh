#!/usr/bin/env bash
# Toolchain lockstep sensor.
#
# The JDK and Maven versions are pinned in two places by deliberate decision
# (see docs/adrs/0006-dockerfile-deploy-over-railpack.md): mise.toml drives
# local dev + CI, and the Dockerfile base images drive the deploy build. This
# check fails the moment those drift apart.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

mise="mise.toml"
dockerfile="Dockerfile"

# --- read the mise pins ---
mise_java="$(sed -nE 's/^[[:space:]]*java[[:space:]]*=[[:space:]]*"([^"]+)".*/\1/p' "$mise" | head -1)"
mise_maven="$(sed -nE 's/^[[:space:]]*maven[[:space:]]*=[[:space:]]*"([^"]+)".*/\1/p' "$mise" | head -1)"
[ -n "$mise_java" ]  || { echo "✘ lockstep: could not read java from $mise"  >&2; exit 1; }
[ -n "$mise_maven" ] || { echo "✘ lockstep: could not read maven from $mise" >&2; exit 1; }

# --- normalise the Temurin version to the Docker tag form ---
# temurin-25.0.3+9.0.LTS  ->  base=25.0.3  build=9  major=25  full=25.0.3_9
raw="${mise_java#temurin-}"     # 25.0.3+9.0.LTS
base="${raw%%+*}"               # 25.0.3
buildpart="${raw#*+}"           # 9.0.LTS
build="${buildpart%%.*}"        # 9
major="${base%%.*}"             # 25
full="${base}_${build}"         # 25.0.3_9

# --- expected Dockerfile base-image tags ---
build_img="maven:${mise_maven}-eclipse-temurin-${major}"   # build stage: maven + java major
runtime_img="eclipse-temurin:${full}-"                     # runtime stage: full java version (flavour suffix may vary)

rc=0
if ! grep -qF "$build_img" "$dockerfile"; then
  echo "✘ lockstep: build image out of sync with mise.toml" >&2
  echo "    mise.toml pins: java=$mise_java  maven=$mise_maven" >&2
  echo "    expected Dockerfile build stage to use: $build_img" >&2
  echo "    found: $(grep -E '^FROM .*maven:' "$dockerfile" || echo '(no maven build stage)')" >&2
  rc=1
fi
if ! grep -qF "$runtime_img" "$dockerfile"; then
  echo "✘ lockstep: runtime image out of sync with mise.toml" >&2
  echo "    mise.toml pins: java=$mise_java" >&2
  echo "    expected Dockerfile runtime stage to use: ${runtime_img}<flavour>" >&2
  echo "    found: $(grep -E '^FROM eclipse-temurin:' "$dockerfile" || echo '(no temurin runtime stage)')" >&2
  rc=1
fi

if [ "$rc" -eq 0 ]; then
  echo "✓ toolchain lockstep: mise.toml and Dockerfile agree (java ${full}, maven ${mise_maven})"
fi
exit "$rc"
