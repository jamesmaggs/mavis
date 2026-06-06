# Architecture Decision Records

Architectural decisions for Mavis, recorded in
[MADR](https://adr.github.io/madr/) (streamlined) format. ADRs capture
*architectural* decisions with live alternatives we weighed — not routine
process or methodology choices.

| # | Decision | Status |
|---|----------|--------|
| [0001](0001-railway-config-as-code-over-full-iac.md) | Railway config-as-code over full infrastructure-as-code | Accepted |
| [0002](0002-javalin-web-framework.md) | Javalin as the web framework | Accepted |
| [0003](0003-maven-and-java-25-lts.md) | Maven and Java 25 LTS | Accepted |
| [0004](0004-tessl-skill-distribution.md) | Tessl for agent-skill distribution | Accepted |
| [0005](0005-mise-reproducible-toolchain.md) | mise for a reproducible toolchain | Accepted |
| [0006](0006-dockerfile-deploy-over-railpack.md) | Dockerfile deploy over Railpack | Accepted |

## Conventions

- Files are `NNNN-kebab-title.md`, numbered sequentially from 0001.
- `Status`: Proposed → Accepted → Superseded-by-NNNN / Deprecated.
- Sections: Context & drivers → Considered options → Decision → Consequences.
- A future authoring skill will target this exact template.
