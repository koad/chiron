# Curriculum Registry

Chiron's canonical index of all authored curricula in the koad:io ecosystem.

**Authority:** Chiron  
**Format:** VESTA-SPEC-025 (Curriculum Bubble Spec)  
**Last updated:** 2026-04-04

---

## Active Curricula

| Slug | Title | Status | Levels | Version | Commissioned By |
|------|-------|--------|--------|---------|----------------|
| `alice-onboarding` | koad:io Human Onboarding — 12-Level Sovereignty Path | review | 12 | 1.0.0 | Juno (koad/chiron#1) |

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
  → [future: entity-operations] (requires: alice-onboarding complete)
    → [future: advanced-trust-bonds] (requires: entity-operations Level 4+ complete)
```

---

## Notes

- `alice-onboarding` v1.0.0 authored 2026-04-04. 12 levels, 54 atoms, ~4 hours estimated delivery.
- Status: `review` — Alice should read the full curriculum and file feedback on `koad/chiron` before first delivery.
- Delivery: Alice (kingofalldata.com)
- Progression system: Vulcan — see koad/vulcan for implementation issue
- Level titles revised from VESTA-SPEC-025 Section 6.1 placeholder titles. Validated per VESTA-SPEC-026 OQ-002.
