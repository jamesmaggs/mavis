# Allium obligation status

Tracks which obligations in [`mavis.allium`](mavis.allium) are implemented. The
spec is the authoritative source of truth and is kept intact; unbuilt
obligations are *aspirational* (Allium's own classification), not overdue.

**Gating policy.** `allium check` (spec validity) gates from day one.
Per-obligation conformance — `propagate`-seeded tests, then `weed`
cross-checks — switches on *as each obligation is implemented*. The
walking-skeleton infrastructure steps (hello-world, echo, Redis, htmx) sit
*below* the spec's domain abstraction and are therefore ungated by it.

Legend: ⬜ not-started · 🟦 in-progress · ✅ done

## Walking skeleton (below the spec — infra, not domain obligations)

| Step | Description | Status |
|------|-------------|--------|
| 1 | Hello-world Javalin app deployed to Railway via CI | ✅ done |
| 2 | Accept input and echo it | ⬜ |
| 3 | Redis persistence + hexagonal seam | ⬜ |
| 4 | htmx frontend | ⬜ |

## Entities

| Entity | Status |
|--------|--------|
| Account | ⬜ |
| User | ⬜ |
| Dialogue | ⬜ |
| Message | ⬜ |
| Brain | ⬜ |
| LoginCode | ⬜ |
| Session | ⬜ |

## Rules

| Rule | Status |
|------|--------|
| UserCreated | ⬜ |
| AnonymousArrival | ⬜ |
| UserSendsInput | ⬜ |
| UserResets | ⬜ |
| SignInWithMerge | ⬜ |
| SignInWithFreshStart | ⬜ |
| ResumeAccountFoldingHistory | ⬜ |
| UserSignsOut | ⬜ |
| ResumeAccount | ⬜ |
| RequestsLoginCode | ⬜ |
| DeliversLoginCode | ⬜ |
| SubmitsLoginCode | ⬜ |

## Invariants

| Invariant | Status |
|-----------|--------|
| UserHasIdentity | ⬜ |
| OneBrainPerUser | ⬜ |
| OneDialoguePerUser | ⬜ |
| InputReplyPairing | ⬜ |
| AccountUniquePerUser | ⬜ |
| AccountEmailUnique | ⬜ |

## Surfaces & contracts

| Item | Status |
|------|--------|
| MavisConversation (surface) | ⬜ |
| AccountSignIn (surface) | ⬜ |
| MailDelivery (surface) | ⬜ |
| LoginCodeMailer (contract) | ⬜ |
