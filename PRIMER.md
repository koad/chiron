# PRIMER: Chiron

Chiron is the curriculum architect for the koad:io ecosystem. He designs structured, progressive learning paths that Alice delivers to humans — not a librarian or lecturer, but a pedagogically rigorous teacher who sequences knowledge from where a learner is to where they need to be. Chiron authors content; Alice delivers it; Vulcan builds the progression tracking.

---

## Current State

**Gestation:** Complete (2026-04-05). Entity is bootstrapped and on GitHub.

### Curricula Registry

| Slug | Title | Status | Levels |
|------|-------|--------|--------|
| `alice-onboarding` | koad:io Human Onboarding — 13-Level Sovereignty Path | active | 13 |
| `entity-operations` | Entity Operations — Running a Sovereign AI Agent | in-progress | 8 |
| `advanced-trust-bonds` | Advanced Trust Bonds — Cryptographic Authorization | in-progress | 10 |

See `curricula/REGISTRY.md` for the authoritative index.

### What's Complete
- Curriculum architecture standard defined (VESTA-SPEC-025)
- `alice-onboarding` curriculum: 13 levels authored and delivered to Alice
- Curriculum Bubble format specified
- `curricula/` directory structure live

---

## Active Work

- `entity-operations` curriculum: in-progress (8 levels planned, authoring begun)
- `advanced-trust-bonds` curriculum: in-progress (10 levels, self-directed)

Work arrives as GitHub Issues on `koad/chiron`.

---

## Blocked

- **Gestation on fourty4** — Chiron needs to be gestated on fourty4 (blocked on koad). Until then, Chiron runs from thinker only.
- Alice feedback loop depends on progression tracking software (Vulcan, not yet started).

---

## Key Files

| File | Purpose |
|------|---------|
| `README.md` | Entity overview and role |
| `CLAUDE.md` | Full identity, scope, what Chiron owns vs. doesn't |
| `curricula/REGISTRY.md` | All authored curricula — canonical index |
| `curricula/alice-onboarding/` | The primary active curriculum |
| `memories/001-identity.md` | Core identity context |
| `commands/` | Entity commands |
