---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 2
slug: configuring-env
title: "Configuring `.env` — Identity, Runtime, and the MOTHER Relationship"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-01
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 2: Configuring `.env` — Identity, Runtime, and the MOTHER Relationship

## Learning Objective

After completing this level, the operator will be able to:
> Expand the minimal `.env` skeleton that gestation produces into a complete entity identity declaration, explain what each field controls at runtime, and confirm whose name will appear on commits before any git operation runs.

**Why this matters:** The gestation script writes a minimal `.env` — just enough to bind the entity's name and bind address. Everything else — git authorship, harness selection, home directory paths, ENTITY_HOST — must be added before the entity first commits or first runs. An entity that runs before `.env` is complete will produce misattributed commits and may run from the wrong directory or on the wrong machine.

---

## Stub Coverage

- The minimal `.env` that gestation produces: `KOAD_IO_BIND_IP` and `METEOR_PACKAGE_DIRS` only — what is missing and why the script does not write more
- The required identity fields to add: `ENTITY`, `ENTITY_DIR`, `ENTITY_HOME`, `GIT_AUTHOR_NAME`, `GIT_AUTHOR_EMAIL`, `KOAD_IO_ENTITY_HARNESS`, `ENTITY_HOST`
- The MOTHER field: `GESTATED_BY` is recorded in `KOAD_IO_VERSION`; the `.env` should reference the entity's lineage for operators reading it cold
- The `.credentials` file: what secrets go here (ANTHROPIC_API_KEY, GITHUB_TOKEN), confirming it is in `.gitignore` before the first `git add`
- The cascade environment model: framework `.env` → entity `.env` → shell environment — which wins and how to debug a value that is not what you expect

---

*(Stub — full atoms, dialogue, exit criteria, and assessment pending)*
