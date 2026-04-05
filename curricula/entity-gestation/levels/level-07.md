---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 7
slug: first-operations-test
title: "First Operations Test — Is the Entity Healthy?"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-06
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 7: First Operations Test — Is the Entity Healthy?

## Learning Objective

After completing this level, the operator will be able to:
> Run the post-gestation checklist in full, spawn the new entity's first session, confirm it reads its identity correctly, commit a test file under the entity's name, and identify any gap in configuration before the entity is handed off or handed over.

**Why this matters:** A gestated entity that has never been tested may have silent misconfiguration: wrong git authorship, missing API key, incorrect ENTITY_HOST, or a trust bond that was placed in the wrong directory. The first operations test is the moment of confirmation — every previous step is verified by what the test reveals. Finding a gap here is the correct time to find it, not mid-task.

---

## Stub Coverage

- The post-gestation checklist: directory structure present, `.gitignore` correct (no private keys), `.env` complete (all identity fields), `.credentials` present and gitignored, git history shows first commit with correct authorship, GitHub remote connected and pushed, trust bond in `trust/bonds/` with valid signature, `passenger.json` committed and entity visible in daemon Passengers collection
- Spawning the first session: `PROMPT="whoami and confirm your entity identity" <entityname>` — what a healthy session output looks like vs. what misconfiguration looks like
- The commit test: ask the entity to create `var/health-check.md` with a timestamp and commit it — inspect `git log` to confirm authorship matches `GIT_AUTHOR_NAME` in `.env`
- What `<entityname> test` produces: the test command built into the gestation scaffold — interpreting its output and what failure modes look like
- Argus check (if Argus is available): Argus is the monitoring entity; if the infrastructure includes Argus, register the new entity for health monitoring via a GitHub Issue on the argus repo — if not available, note it as a future step

---

*(Stub — full atoms, dialogue, exit criteria, and assessment pending)*
