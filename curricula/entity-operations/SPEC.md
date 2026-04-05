---
type: curriculum-bubble
id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
slug: entity-operations
title: "Entity Operations — Running a Sovereign AI Agent"
description: "After completing all 8 levels, the operator can spawn an entity session, assign it a task, read its output, manage its memory, and understand what is happening at each step — including what to do when things go wrong."
version: 0.1.0
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
owned_by: kingofalldata.com
signature: (pending — signed by Chiron on first authoring commit)

prerequisites:
  - alice-onboarding

audience: "Humans who have completed alice-onboarding. They understand what entities are, can navigate an entity directory, understand trust bonds conceptually, and have made a sovereignty commitment. They have not yet operated an entity hands-on — they have never spawned a session, assigned a task, or read entity output."
estimated_hours: 3.5

level_count: 8
atom_count_total: 38

is_shared: true
shared_with: ["*"]
license: cc-by

commissioned_by: https://github.com/koad/chiron/issues/1
---

# Curriculum: Entity Operations — Running a Sovereign AI Agent

## Overview

This curriculum takes a learner from "I understand what an entity is" to "I can actually run one." It is the practical complement to alice-onboarding. Where onboarding built conceptual fluency, this curriculum builds operational fluency — the hands-on ability to spawn, direct, observe, and maintain an entity.

The curriculum covers the full operator loop: before a session (environment, memory, identity), during a session (spawning, tasking, reading output), and after a session (committing work, updating memory, managing issues). It also covers the error cases that new operators encounter most: session failures, permission gaps, stale context, and output you cannot parse.

Alice delivers this curriculum conversationally. Each level ends with a hands-on exercise — the learner performs an action and reports back what happened. This is not a passive curriculum. By Level 7, the operator has run at least one real entity session and can describe what they did.

## Entry Prerequisites

The learner has completed alice-onboarding (v1.0.0 or later) and can:
- Navigate an entity directory and describe what they find
- Explain what trust bonds are and why they are signed
- Describe the two-layer architecture (framework + entity)
- Articulate the sovereignty commitment they made at Level 12 of onboarding

The learner cannot yet:
- Spawn an entity session
- Assign a task in a form an entity can act on
- Read entity output and know what it means
- Manage entity memory or issues

## Completion Statement

After completing all 8 levels, the operator will be able to:
- Verify their environment is ready before spawning a session
- Spawn an entity session using the correct invocation pattern
- Write a task prompt that gives an entity what it needs to act
- Read entity output — know what is a result, what is a log, what is an error
- Commit entity work correctly, with proper authorship and push
- Read and update entity memory files
- File a GitHub Issue to assign work or report a finding
- Describe what to do when a session fails or produces unexpected output

---

## Level Summary

| # | Title | Atoms | Minutes |
|---|-------|-------|---------|
| 0 | Before the Session — Environment Check | 4 | 20 |
| 1 | Identity in the Environment — .env and .credentials | 5 | 25 |
| 2 | Spawning a Session — The Invocation Pattern | 5 | 25 |
| 3 | Writing a Good Task Prompt | 5 | 25 |
| 4 | Reading Entity Output | 5 | 25 |
| 5 | Committing Entity Work | 5 | 25 |
| 6 | Memory — What the Entity Remembers | 5 | 20 |
| 7 | GitHub Issues as the Communication Protocol | 4 | 20 |

Full level content lives in `levels/`. See VESTA-SPEC-025 for the loading contract and progressive disclosure rules.

---

## Curriculum Changelog

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-04-05 | Initial scaffolding by Chiron. 8 levels, 38 atoms estimated. Commissioned by Juno. |

---

## References

- Commissioned by: https://github.com/koad/chiron/issues/1
- Prerequisite: alice-onboarding v1.0.0+
- Delivered by: Alice (kingofalldata.com)
- Progression system: Vulcan — see koad/vulcan for implementation
- Format authority: Vesta (VESTA-SPEC-025)

---

**Signature:**
```
(Pending — Chiron to sign with ed25519 key on first delivery)
```
Signed by: chiron@kingofalldata.com
