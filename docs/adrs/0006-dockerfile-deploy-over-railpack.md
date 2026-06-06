# 0006. Dockerfile deploy over Railpack

- Status: Accepted
- Date: 2026-06-06

## Context and drivers

Railway builds via Railpack (zero-config) or an explicit Dockerfile. Railpack's
Java provider defaults to **Java 21** and selects the JDK via
`RAILPACK_JDK_VERSION`; it also reads a project `mise.toml`, but the two
behaviours conflict in the docs. We target **Java 25** ([ADR 0003](0003-maven-and-java-25-lts.md)),
where a silent fallback to 21 would fail at runtime.

Drivers: a deterministic, correct-on-first-try deploy of the walking skeleton;
explicit-over-magic; no gamble on Railpack's auto-detection for a bleeding-edge
Java version.

## Considered options

- **Explicit multi-stage Dockerfile** with pinned tags
  (`maven:3.9.16-eclipse-temurin-25` → `eclipse-temurin:25.0.3_9-jre-noble`).
  Fully deterministic; toolchain pinned in two places.
- **Railpack + `mise.toml`.** Single source of truth, near-zero config, but
  risks Railpack defaulting to Java 21 → runtime failure.
- **Dockerfile that provisions via mise.** Deterministic *and* single-source,
  but a slower, more complex build.

## Decision

Use an **explicit multi-stage Dockerfile** with pinned image tags that match the
mise toolchain. Railway is told to build it via `railway.toml`
(`builder = "DOCKERFILE"`).

## Consequences

- The deploy build is fully deterministic and verified working on Java 25.
- The toolchain is pinned in two places (`mise.toml` for dev/CI, the Dockerfile
  for deploy); they must be kept in lockstep — a known, accepted wart.
- Docker is now part of the project's mental model.
