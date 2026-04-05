---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 3
slug: git-initialization-and-github
title: "Git Initialization and GitHub Setup"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-02
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 3: Git Initialization and GitHub Setup

## Learning Objective

After completing this level, the operator will be able to:
> Initialize the gestated entity directory as a git repository, create the GitHub repo, connect the remote, make the first commit with correct authorship, and push — so the entity's history begins with a clean, attributed record.

**Why this matters:** The entity directory is not a git repo at gestation time — the gestation script creates the files but does not run `git init`. The operator must do this, and must do it after configuring `.env`, so that the very first commit is attributed correctly. A misattributed first commit is cosmetically fixable but operationally embarrassing: it is the entity's birth record.

---

## Stub Coverage

- `git init` inside `~/.entityname/`: why this is a manual step and not part of the gestation script
- Setting local git config: `git config user.name` and `git config user.email` scoped to the entity directory — why this reinforces `.env` but does not replace it
- Creating the GitHub repo via `gh repo create`: naming convention, visibility (public is the default for team entities — entities are products), and linking the remote
- The first commit: what to stage (`git add -A` minus gitignored files), the commit message convention (`gestation: initial entity scaffold`), and confirming authorship before pushing
- Verifying the push: checking `github.com/<owner>/<entityname>` shows the correct structure, the KOAD_IO_VERSION birth certificate is visible, and no private keys appear in the tree

---

*(Stub — full atoms, dialogue, exit criteria, and assessment pending)*
