---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 1
slug: running-the-command
title: "Running the Command — `koad-io gestate <name>`"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-00
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 1: Running the Command — `koad-io gestate <name>`

## Learning Objective

After completing this level, the operator will be able to:
> Run `koad-io gestate <name>` (or invoke it as `<mother> gestate <name>`), interpret every line of output it produces, and explain what the MOTHER relationship means and what it inherits.

**Why this matters:** The gestation command is the entry point for creating any entity. Running it correctly — from the right directory, with the right invocation — determines what the new entity inherits. Running it incorrectly (wrong parent, wrong name, wrong machine) produces a result that must be discarded and re-run.

---

## Stub Coverage

- The two invocation forms: `koad-io gestate <name>` (immaculate conception, MOTHER=mary) vs. `<existing-entity> gestate <name>` (inherits genes from the invoking entity)
- The `--full` flag: what it adds (dhparam generation at 2048 and 4096 bits), why it is time-consuming, and when to use it
- What the MOTHER relationship copies from the invoking entity: `skeletons/`, `packages/`, `commands/`, `recipes/`, `assets/`, `cheats/`, `hooks/`, `docs/`, and the mother's four public keys into `id/`
- The name convention: lowercase, no spaces, short — why naming matters for paths, wrapper commands, and public identity
- Pre-flight checks: the target directory must not already exist; the command aborts cleanly if `~/.entityname` is present

---

*(Stub — full atoms, dialogue, exit criteria, and assessment pending)*
