# MAVIS: Affable Verbal Interaction Simulator

Mavis is a chatterbot in the style of those developed mostly in the 1980s and 90s. Mavis simulates real conversation by breaking down input sentences and using them to generate nonsensical responses.

You can find out more about the history of chatterbots here: https://www.simonlaven.com

This repository is also a proving ground for a **model-agnostic harness for spec-driven, agent-assisted engineering**. The aim: an agent drives, but **every output is verifiable** and results are **as deterministic as possible**.

## Source of truth

- **Specification (authoritative):** [`docs/allium/mavis.allium`](./docs/allium/mavis.allium) — an [Allium](https://juxt.github.io/allium/) spec. Behaviour starts here; code is derived from and verified against it.
- **Implementation status:** [`docs/allium/status.md`](./docs/allium/status.md) — which spec obligations are built.
- **Architecture decisions:** [`docs/adrs/`](./docs/adrs/) — MADR records of choices with live alternatives.
- **Runbooks:** [`docs/runbooks/`](./docs/runbooks/).

## How we work

- **Spec is authoritative.** Change behaviour in the spec first; `allium check` validates it. Per-obligation conformance (`propagate`-seeded tests, then `weed` cross-checks) switches on as each obligation is built.
- **Verifiable at every step.** A change clears cheap, deterministic checks before expensive or inferential ones. Today the gate is `mvn verify`; rungs (static analysis, spec conformance, agent review) join the ladder only when they have something to verify.
- **Explicit over magic.** Prefer explicit wiring and configuration to framework auto-detection ([ADR 0002](./docs/adrs/0002-javalin-web-framework.md), [ADR 0006](./docs/adrs/0006-dockerfile-deploy-over-railpack.md)).
- **Walking skeleton, small steps, trunk-based.** Tiny commits to `main`.
- **Model-agnostic.** Harness infrastructure is tool-neutral (`AGENTS.md`, portable Markdown). Reusable agent skills are distributed via Tessl from a separate repo ([ADR 0004](./docs/adrs/0004-tessl-skill-distribution.md)).

## Build, test, run

The toolchain is pinned via [mise](https://mise.jdx.dev) ([ADR 0005](./docs/adrs/0005-mise-reproducible-toolchain.md)): Java 25 LTS + Maven.

```sh
mise install                                   # provision the pinned toolchain (first run: mise trust)
mise exec -- mvn verify                        # build + test (the local gate)
mise exec -- mvn -DskipTests package \
  && java -jar target/mavis.jar                # run locally (listens on $PORT, else 7070)
```

## Commits & CI

- **Atomic commits:** one semantic decision per commit; tests committed with the code they test.
- **[Conventional Commits](https://www.conventionalcommits.org):** `type(scope): description`, lowercase imperative, ≤72 chars.
- A commit authored by a specific agent attributes it with a `Co-Authored-By` trailer (authorship, not harness infrastructure).
- **CI** (`.github/workflows/ci.yml`): push to `main` → `verify` (build + test) gates `deploy`. GitHub Actions owns the deploy pipeline; Railway auto-deploy is off ([ADR 0001](./docs/adrs/0001-railway-config-as-code-over-full-iac.md)).

## Tech Stack

- Java 25 LTS, Maven, [Javalin](https://javalin.io) web framework ([ADR 0002](./docs/adrs/0002-javalin-web-framework.md), [ADR 0003](./docs/adrs/0003-maven-and-java-25-lts.md))
- htmx frontend
- Deployed on Railway via a committed multi-stage Dockerfile ([ADR 0006](./docs/adrs/0006-dockerfile-deploy-over-railpack.md))
- Redis for persistent brain
- Potentially a relational DB for account details?

## Architectural Guidelines

- Hexagonal architecture; deep modules, loosely coupled. The web layer is a thin adapter around a framework-free domain core.
- Input sentences are broken down and the words stored in a markov chain.
