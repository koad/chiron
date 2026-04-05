---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 6
slug: passenger-json
title: "passenger.json — Registering with the Daemon"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-05
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 6: passenger.json — Registering with the Daemon

## Learning Objective

After completing this level, the operator will be able to:
> Author a `passenger.json` for the new entity, explain what each field declares, place the file correctly in the entity directory, and confirm the daemon picks it up — so the entity appears in the Passengers collection and can be selected as the active companion.

**Why this matters:** An entity without a `passenger.json` is invisible to the daemon. It cannot be selected as the active companion, it will not appear in the desktop widget, and URL context from the Dark Passenger extension will never reach it. The passenger.json is the entity's registration card with the real-time layer. It is the last configuration step before the first operations test.

---

## Stub Coverage

- The `passenger.json` format: required fields (`name`, `slug`, `entity_dir`, `color`, `description`), optional fields (`icon`, `website`, `github`), and the relationship to the `ENTITY` variable in `.env`
- Where the file lives: in the entity directory root (`~/.entityname/passenger.json`), committed to git — it is public configuration, not a secret
- How the daemon discovers it: `passenger.reload` DDP method re-scans entity directories and re-populates the Passengers collection from `passenger.json` files; the operator can trigger this from the admin PWA or via `juno` command
- Confirming registration: open `localhost:9568` (the admin PWA), look for the new entity in the Passengers collection — name, slug, and color should match the file
- Why passenger.json must be committed: other machines and operators need the same registration configuration; a `passenger.json` that exists only on one machine breaks portability

---

*(Stub — full atoms, dialogue, exit criteria, and assessment pending)*
