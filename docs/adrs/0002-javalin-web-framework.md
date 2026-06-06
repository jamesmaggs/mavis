# 0002. Javalin as the web framework

- Status: Accepted
- Date: 2026-06-06

## Context and drivers

Mavis is a Java monolith following hexagonal architecture with deep, loosely
coupled modules (see `AGENTS.md`). The web layer should be a thin *adapter*
around a framework-free domain core, so the domain (the Markov brain) can be
tested in pure isolation.

Drivers: explicit-over-magic; determinism and verifiability; keeping the domain
free of framework concerns; ease of correct reasoning for an agent.

## Considered options

- **Javalin.** Minimal, explicit routing on embedded Jetty. No annotation or
  classpath-scanning magic. You wire dependencies yourself.
- **Spring Boot.** Batteries included and the densest agent training data, but
  autowiring/component-scanning/proxies make behaviour emerge implicitly and
  tend to leak into the domain.
- **Plain JDK `HttpServer`.** Zero dependencies, but you rebuild routing and
  templating and outgrow it quickly.
- **Quarkus / Micronaut.** Compile-time DI, less reflection than Spring, but
  still impose framework conventions and a larger config surface.

## Decision

Use **Javalin**. The web layer stays a thin hexagonal adapter; the domain never
imports the framework; wiring is explicit.

## Consequences

- No magic DI — dependencies are wired by hand (a feature for deep modules and
  deterministic verification).
- The domain core is framework-free and unit-testable without HTTP.
- Less off-the-shelf machinery and a thinner training-data corpus than Spring;
  we accept that in exchange for explicitness.
