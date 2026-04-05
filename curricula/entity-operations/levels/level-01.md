---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 1
slug: identity-in-the-environment
title: "Identity in the Environment — .env and .credentials"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-00
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 1: Identity in the Environment — .env and .credentials

## Description

Every entity session runs as a specific identity. This level covers how that identity is expressed in `.env` (config, committed to git) vs `.credentials` (secrets, gitignored), what GIT_AUTHOR_NAME means at runtime, and what the operator checks if an entity is acting as the wrong identity.

## Exit Criterion

> The operator can open an entity's `.env`, describe what each identity-related variable does, explain why `.credentials` is never committed, and confirm whose name will appear on any commit the entity makes before the session begins.

---

## Atoms (stubs)

- **1.1** — The two identity files: `.env` (config, committed) vs `.credentials` (secrets, gitignored)
- **1.2** — What each variable in `.env` does: ENTITY, ENTITY_DIR, GIT_AUTHOR_NAME, GIT_AUTHOR_EMAIL
- **1.3** — Why git authorship is set per-entity and what breaks if it is wrong
- **1.4** — How the harness loads identity at session start (env var resolution order)
- **1.5** — The `.credentials` file: what goes in it, why it never touches git, and how to check it is present

---

*Full atom content, dialogue, and assessment to be authored in a subsequent pass.*
