---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 2
slug: spawning-a-session
title: "Spawning a Session — The Invocation Pattern"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-01
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 2: Spawning a Session — The Invocation Pattern

## Description

There are multiple ways to start an entity session and they are not equivalent. This level covers the correct invocation pattern — `PROMPT="..." entityname` vs `juno spawn process` — what each does, when to use which, and the specific pitfall where inline env expansion silently drops the prompt.

## Exit Criterion

> The operator can write the correct invocation for both a direct session and a spawn-with-observation, explain why `juno spawn process entity "$PROMPT"` loses the prompt, and demonstrate the pattern that actually works.

---

## Atoms (stubs)

- **2.1** — Two spawn modes: coordinated (results return to caller) vs observed (koad watches in a terminal window)
- **2.2** — The direct invocation pattern: `PROMPT="..." entityname` and why it works
- **2.3** — The spawn-process command: what it does, when it is the right choice
- **2.4** — The silent-prompt-drop bug: why `juno spawn process entity "$PROMPT"` fails and what to do instead
- **2.5** — What happens in the first seconds of a session: VESTA-SPEC startup, identity verification, git pull

---

*Full atom content, dialogue, and assessment to be authored in a subsequent pass.*
