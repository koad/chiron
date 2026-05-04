# PRIMER: Chiron

Chiron is the curriculum architect for the koad:io ecosystem. He designs structured, progressive learning paths that Alice and other curriculum-capable entities deliver to humans — not a librarian or lecturer, but a pedagogically rigorous teacher who sequences knowledge from where a learner is to where they need to be. Chiron authors content; Alice delivers it; Vulcan builds the progression tracking.

---

## Current State

**Gestation:** Complete (2026-03-30). Entity is operational on wonderland.
**Repository:** `keybase://team/kingofalldata.entities.chiron/self`

### Curricula Registry (as of 2026-04-18)

49 curricula authored across 16 entities. See `curricula/REGISTRY.md` for the authoritative index.

**Core tracks authored (sample):**

| Slug | Title | Status | Levels |
|------|-------|--------|--------|
| `alice-onboarding` | koad:io Human Onboarding — 13-Level Sovereignty Path | active | 13+1e |
| `entity-operations` | Entity Operations — Running a Sovereign AI Agent | review | 8 |
| `advanced-trust-bonds` | Advanced Trust Bonds — Cryptographic Authorization | review | 10 |
| `sovereign-sigchain` | Sovereign Sigchain — Publishing Your Identity on IPFS | review | 7 |
| `sovereign-profiles` | Sovereign Profiles — Publishing Your Public Face | review | 6 |
| `entity-gestation` | Entity Gestation — Creating a Sovereign AI Agent | review | 8 |
| `kingdoms-operations` | Kingdoms Operations — Running Multiple Communities | in-progress | 7 |

Per-entity curricula live in entity-local `curricula/` directories (argus, salus, janus, iris, vulcan, vesta, aegis, muse, sibyl, mercury, veritas, juno).

### What's Complete
- Curriculum architecture standard: VESTA-SPEC-025 (Curriculum Bubble Spec)
- `alice-onboarding`: 13 mandatory levels + 1 optional elective, active delivery
- Per-Entity Curriculum Architecture Standard: chiron-std-002 v1.0.0
- Full Sovereignty Track: sovereign-sigchain → sovereign-profiles → community-infrastructure
- Builder Path: entity-gestation → commands-and-hooks → multi-entity-orchestration
- Per-entity curricula for 12 entities (argus, salus, janus, iris, vulcan, vesta, aegis, muse, sibyl, mercury, veritas, juno)
- Multi-entity curriculum authorship confirmed: any entity exposing `mark_sight_visited` + `save_learner_state` (VESTA-SPEC-137) gets the curriculum surface

---

## Active Work

- `kingdoms-operations`: in-progress — Level 0 complete, Levels 1–6 exit criteria authored; full atom authoring pending (delivery: Rooty)
- `adas-operations`: scaffolded — SPEC.md and level stubs; full atom authoring pending
- `community-infrastructure`: scaffolded — awaiting kingdoms-operations atoms before delivery sequencing

Work arrives as briefs at `~/.chiron/briefs/` (Juno-filed) or via MCP intake. GitHub Issues on `koad/chiron` are for external/public curriculum feedback only.

---

## Blocked

- `kingdoms-operations` atoms (levels 1–6): authoring in progress — no external gate
- Alice feedback loop depends on progression tracking software (Vulcan, not yet started)

---

## Key Files

| File | Purpose |
|------|---------|
| `ENTITY.md` | Canonical identity, role, scope |
| `README.md` | Entity overview and commission instructions |
| `curricula/REGISTRY.md` | All authored curricula — canonical index |
| `curricula/alice-onboarding/` | The primary active curriculum (template for all others) |
| `memories/001-identity.md` | Core identity context |
| `memories/002-operational-preferences.md` | How Chiron operates |
| `commands/` | Entity commands |
