# 0005. mise for a reproducible toolchain

- Status: Accepted
- Date: 2026-06-06

## Context and drivers

The build depends on specific Java and Maven versions ([ADR 0003](0003-maven-and-java-25-lts.md)).
For determinism, those versions must be pinned, committed, and identical across
developer machines and CI — not "whatever Java happens to be installed".

## Considered options

- **mise** — polyglot version manager; a committed `mise.toml` pins tools, with
  a GitHub Action (`jdx/mise-action`) for CI and detection by Railpack.
- **asdf** — similar, but slower and without first-class CI/Railpack integration.
- **SDKMAN!** — Java/Maven-focused, less polyglot, weaker automation story.
- **System/manually-installed Java** — zero config, zero reproducibility.

## Decision

Pin Java and Maven in a committed `mise.toml`. Use it locally and in CI (via
`jdx/mise-action`), so `mise.toml` is the single source of toolchain truth.

## Consequences

- Contributors and CI build with an identical toolchain.
- A one-time `mise trust` step is required for the project config.
- New machines need mise installed.
- Note: the deploy image pins its toolchain separately in the Dockerfile (see
  [ADR 0006](0006-dockerfile-deploy-over-railpack.md)); the two are kept in
  lockstep.
