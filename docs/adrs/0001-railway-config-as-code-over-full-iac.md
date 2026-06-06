# 0001. Railway config-as-code over full infrastructure-as-code

- Status: Accepted
- Date: 2026-06-06

## Context and drivers

Mavis deploys to Railway, and we want infrastructure committed and reproducible.
Railway offers two declarative layers: mature **config-as-code** (`railway.toml`,
build/deploy settings for one service) and a brand-new, **experimental
infrastructure-as-code** (`railway.ts` + a TypeScript SDK) that can provision
services, databases, env vars and domains. There is also a community Terraform
provider.

Drivers: determinism and reproducibility; not adopting experimental tooling
before there is anything to provision; avoiding a Node toolchain in a Java repo.

## Considered options

- **`railway.toml` + documented manual provisioning.** Mature; build/deploy in
  code; service/Redis/secrets created manually and documented.
- **Full `railway.ts` IaC now.** Maximally declarative, but one day old and
  experimental, and drags a Node/TypeScript toolchain into the Java monolith.
- **Community Terraform provider.** Real plan/apply IaC, language-neutral, but
  unofficial with feature gaps.

## Decision

Use `railway.toml` for build/deploy configuration. Provision the project,
service, environment variables and tokens manually, documenting every step under
`docs/` (see the [Railway provisioning runbook](../runbooks/railway-provisioning.md)).
Revisit full IaC (`railway.ts`) as a later migration once it has settled.

## Consequences

- Build/deploy settings are reproducible in code; provisioning is manual but
  recorded, so it is repeatable.
- Env vars (e.g. `PORT`) and tokens live outside the repo by necessity.
- A clear migration path to full IaC remains open when the DSL matures.
