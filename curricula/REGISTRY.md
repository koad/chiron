# Curriculum Registry

Chiron's canonical index of all authored curricula in the koad:io ecosystem.

**Authority:** Chiron  
**Format:** VESTA-SPEC-025 (Curriculum Bubble Spec)  
**Last updated:** 2026-04-05 (daemon-operations added)

---

## Active Curricula

| Slug | Title | Status | Levels | Version | Commissioned By |
|------|-------|--------|--------|---------|----------------|
| `alice-onboarding` | koad:io Human Onboarding — 13-Level Sovereignty Path | active | 13 | 1.3.0 | Juno (koad/chiron#1) |
| `entity-operations` | Entity Operations — Running a Sovereign AI Agent | in-progress | 8 | 0.1.0 | Juno (koad/chiron#1) |
| `advanced-trust-bonds` | Advanced Trust Bonds — Cryptographic Authorization in Practice | in-progress | 10 | 0.1.0 | Chiron (self-directed) |
| `daemon-operations` | Daemon Operations — The Kingdom Hub in Practice | in-progress | 7 | 0.1.0 | Chiron (self-directed) |

---

## Status Definitions

| Status | Meaning |
|--------|---------|
| `placeholder` | Directory created; SPEC.md not yet authored |
| `in-progress` | Authoring begun; not all levels complete |
| `review` | All levels authored; awaiting Alice review before delivery |
| `active` | Delivered by Alice; feedback loop open |
| `stable` | Delivered, revised, no open feedback issues |
| `deprecated` | Superseded by a newer curriculum; do not deliver |

---

## Prerequisite Graph

```
alice-onboarding (no prerequisites — this is the ecosystem entry point)
  → entity-operations (requires: alice-onboarding complete)
    → advanced-trust-bonds (requires: entity-operations complete)
      → daemon-operations (requires: advanced-trust-bonds complete)
    → [future: multi-entity-orchestration] (requires: entity-operations complete)
```

---

## Notes

- `alice-onboarding` v1.3.0 updated 2026-04-05. 13 levels, 60 atoms, ~4.5 hours estimated delivery.
- Level 0 (The First File) added 2026-04-05 in response to koad/chiron#3 (Iris recommendation). Zero-threshold PRIMER.md entry. No terminal, no account, no installation.
- Status: `active` — Alice reviewed v1.1.0 as APPROVE WITH NOTES; Level 0 addition is additive and does not require re-review before delivery.
- Delivery: Alice (kingofalldata.com)
- Progression system: Vulcan — see koad/vulcan for implementation issue
- Level titles revised from VESTA-SPEC-025 Section 6.1 placeholder titles. Validated per VESTA-SPEC-026 OQ-002.

- `entity-operations` v0.1.0 scaffolded 2026-04-05. 8 levels, 38 atoms estimated, ~3.5 hours estimated delivery.
- Prerequisite: alice-onboarding complete. Audience: operators who understand entities conceptually and are ready to run them.
- Status: `in-progress` — structure and level stubs committed; full atom authoring and dialogue pending.
- Last updated: 2026-04-05

- `advanced-trust-bonds` v0.1.0 scaffolded 2026-04-05. 10 levels, 48 atoms estimated, ~5.5 hours estimated delivery.
- Prerequisite: entity-operations complete. Audience: operators who can run entities and want to understand the cryptographic authorization layer — bond creation, GPG mechanics, key distribution, chain verification, revocation, signed code blocks.
- Status: `in-progress` — structure and level stubs committed; full atom authoring and dialogue pending.
- Last updated: 2026-04-05

- `daemon-operations` v0.1.0 scaffolded 2026-04-05. 7 levels, 35 atoms estimated, ~3.5 hours estimated delivery.
- Prerequisite: advanced-trust-bonds complete. Audience: operators who can run entities and manage trust bonds, ready to understand the daemon — the kingdom hub that adds real-time coordination, browser integration, and entity presence on top of the durable GitHub Issues layer.
- Status: `in-progress` — structure and level stubs committed; full atom authoring and dialogue pending.
- Last updated: 2026-04-05
