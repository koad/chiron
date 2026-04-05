---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 0
slug: what-gestation-produces
title: "What Gestation Produces — The Anatomy of a New Entity"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete: []
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 0: What Gestation Produces — The Anatomy of a New Entity

## Learning Objective

After completing this level, the operator will be able to:
> Walk through every directory and file that `koad-io gestate` creates, explain why each one exists, and distinguish which files are committed to git versus gitignored from the moment of creation.

**Why this matters:** Operators who run the gestation command without understanding its output cannot evaluate whether it succeeded or reason about what they are configuring in subsequent steps. Understanding the anatomy of a gestated entity is the prerequisite for everything that follows.

---

## Stub Coverage

- The standard directory structure: `id/`, `bin/`, `etc/`, `lib/`, `man/`, `res/`, `ssl/`, `usr/`, `var/`, `proc/`, `home/`, `media/`, `archive/`, `keybase/` — what each directory is for
- The files created at gestation: `.gitignore`, `KOAD_IO_VERSION`, `.env` (minimal skeleton), and the entity wrapper command in `~/.koad-io/bin/<entity>`
- The gitignore rules written by the gestation script: private keys in `id/`, SSL private material in `ssl/`, runtime files in `proc/` and `var/`, the entity home cache
- Why the entity directory mirrors a Unix filesystem layout (`bin/`, `etc/`, `lib/`) — the sovereignty analogy: the entity has its own rootfs-like home
- The KOAD_IO_VERSION file: what it records (GESTATED_BY, GESTATE_VERSION, BIRTHDAY, NAME) and why it is the entity's birth certificate

---

*(Stub — full atoms, dialogue, exit criteria, and assessment pending)*
