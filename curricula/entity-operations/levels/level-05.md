---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 5
slug: committing-entity-work
title: "Committing Entity Work"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-04
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 5: Committing Entity Work

## Description

Every entity is its own git author. This level covers the correct commit pattern — who the author should be, when to commit vs when to wait for human review, the always-commit-and-push default, and how to read a commit message to verify an entity did what it claimed. It also covers the PR protocol: when new work goes through a PR rather than a direct push.

## Exit Criterion

> The operator can run a commit in an entity directory with the correct author identity, explain why `git log --format="%an %ae"` shows the entity name rather than their own, identify what categories of work require a PR rather than a direct push, and push the result.

---

## Atoms (stubs)

- **5.1** — Author identity in entity commits: entity name, entity email, and why this matters for attribution
- **5.2** — The always-commit-and-push default: when to commit immediately and when not to
- **5.3** — Reading a commit message: what to verify before accepting entity work as done
- **5.4** — The PR protocol: new features and modifications to shared files go through PRs, not direct pushes
- **5.5** — What to do after a push: verify remote, check gh run status if CI is present

---

*Full atom content, dialogue, and assessment to be authored in a subsequent pass.*
