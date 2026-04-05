---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 4
slug: reading-entity-output
title: "Reading Entity Output"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-03
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 4: Reading Entity Output

## Description

Entity output is not a reply — it is a record of actions taken. This level teaches the operator to distinguish between conversational output, committed files, git log as the definitive record, and error output that requires intervention. It also covers the specific anti-pattern of `cat`-ing full output files vs using `tail`, `git log`, and `--output-format=json`.

## Exit Criterion

> The operator can, given a completed entity session, check git log to confirm what was done, identify whether a committed file is the output or a log, read the tail of an output file without loading the full content, and describe at least two signals that indicate the session failed.

---

## Atoms (stubs)

- **4.1** — Git log as the definitive record: if it is not committed, it did not happen
- **4.2** — Conversational output vs file output: what to look for and where
- **4.3** — Reading output without drowning: `tail -20`, `--output-format=json .result`, `git log --oneline`
- **4.4** — Recognizing session failure: exit without commit, error in last output lines, no files changed
- **4.5** — What to do with output you cannot parse: re-read CLAUDE.md, check the task prompt, look at git diff

---

*Full atom content, dialogue, and assessment to be authored in a subsequent pass.*
