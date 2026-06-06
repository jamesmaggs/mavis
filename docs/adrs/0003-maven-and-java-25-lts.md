# 0003. Maven and Java 25 LTS

- Status: Accepted
- Date: 2026-06-06

## Context and drivers

We need a build tool and a Java version. The project's overarching value is
determinism and agent-legibility: configuration an agent can edit predictably
and a reviewer can audit.

## Considered options

- **Maven.** Declarative `pom.xml` — build config as *data*. Reproducible,
  auditable, strong Railway/Railpack support.
- **Gradle (Kotlin or Groovy DSL).** A build *program* — more flexible and
  faster incrementally, but imperative and harder to edit predictably or audit.
- Java version: **25 (current LTS, Sept 2025)** vs 21 (older LTS).

## Decision

Use **Maven** on **Java 25 LTS**. A declarative pom is the most deterministic,
agent-legible build configuration; Java 25 is the current LTS with records,
pattern matching and virtual threads.

## Consequences

- Build configuration is declarative data, predictable to edit and review.
- Modern language features with long-term support.
- Gradle's flexibility and incremental-build speed are forgone — acceptable for
  a small monolith.
- The toolchain is pinned via mise (see [ADR 0005](0005-mise-reproducible-toolchain.md)).
