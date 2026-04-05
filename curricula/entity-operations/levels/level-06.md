---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 6
slug: memory
title: "Memory — What the Entity Remembers"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-05
estimated_minutes: 20
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 6: Memory — What the Entity Remembers

## Description

Entity memory is not automatic — it is explicit, file-based, and committed. This level covers the two memory layers (long-term entity memories in `memories/` committed to git, and session behavior in `~/.claude`), how MEMORY.md serves as the index, when to update memory vs when to leave it alone, and what happens to memory across harness switches.

## Exit Criterion

> The operator can open an entity's `memories/` directory, read MEMORY.md, identify which files represent active context, add a new memory entry correctly (file + MEMORY.md index line), and commit it with the entity as author.

---

## Atoms (stubs)

- **6.1** — Two memory layers: `memories/` (long-term, committed, entity-owned) vs `~/.claude` (session behavior, not committed)
- **6.2** — MEMORY.md as index: one line per file, the pattern, why the index matters for context loading
- **6.3** — When to write a new memory: significant findings, preference changes, resolved blockers
- **6.4** — Adding a memory correctly: new file in `memories/`, index entry in MEMORY.md, commit immediately
- **6.5** — Memory across harness switches: what carries over (committed files), what does not (session state)

---

*Full atom content, dialogue, and assessment to be authored in a subsequent pass.*
