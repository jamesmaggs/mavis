# 0004. Tessl for agent-skill distribution

- Status: Accepted
- Date: 2026-06-06

## Context and drivers

This repo is also a proving ground for a model-agnostic harness for agent-driven
engineering. The deterministic parts (Maven, CI, `allium check`) are portable by
nature; the lock-in risk lives in the *inferential* layer — agent "skills",
which are otherwise encoded per-tool (`.claude/`, `.cursor/`, etc.).

Drivers: keep the inferential layer model-agnostic; house reusable harness
skills separately from the project; avoid per-tool drift and lock-in.

## Considered options

- **Tessl** — a package manager for agent skills, installable across Claude
  Code / Cursor / Copilot / Gemini, with versioning and security scanning.
- **Portable Markdown playbooks + thin per-tool wrappers** maintained by hand.
- **Native per-tool skills**, kept in sync manually.
- **Deterministic-only**, with no encoded inferential procedures.

## Decision

Distribute reusable agent skills via **Tessl**, sourced from a separate,
version-pinned skills repository. Use Tessl for **skill distribution only** —
Allium remains the sole authoritative specification; do not adopt Tessl's own
spec framework.

## Consequences

- A dev-machine `@tessl/cli` dependency (global tool, not a project dependency).
- Skills install across tools, so the inferential layer stays model-agnostic.
- Skill *source* stays as portable Markdown in our own repo, so the harness
  degrades gracefully to manual install if Tessl is ever dropped.
- Two "spec" systems are deliberately avoided: Allium owns all domain truth.
