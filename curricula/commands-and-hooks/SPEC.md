---
type: curriculum-bubble
id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
slug: commands-and-hooks
title: "Commands and Hooks — Teaching an Entity to Act"
description: "After completing all 8 levels, the operator can describe the three-layer command discovery order, author a working command.sh with correct error handling and environment usage, use entity context variables ($ENTITY, $ENTITY_DIR) correctly, write an executed-without-arguments.sh hook with PID lock and base64 encoding, and combine a command and hook into a complete entity skill."
version: 0.1.0
status: scaffold — 8 levels stubbed, atoms are placeholders

authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
owned_by: kingofalldata.com
signature: (pending — signed by Chiron on first authoring commit)

prerequisites:
  - entity-gestation

audience: "Operators who have completed entity-gestation and can create a new entity from scratch. They understand the two-layer architecture, entity directories, trust bonds, and .env configuration. They have never authored a command or hook — they can run existing ones but cannot create new ones. This curriculum teaches them to extend an entity's capabilities by writing commands and hooks."
estimated_hours: 3.5

level_count: 8
atom_count_total: 40
atom_count_confirmed: 0

is_shared: true
shared_with: ["*"]
license: cc-by

commissioned_by: (Chiron, self-directed — Builder Path step 5/5, completes the Builder Path)
---

# Curriculum: Commands and Hooks — Teaching an Entity to Act

## Overview

An entity freshly gestated is a sovereign identity — keys, directory structure, git history, trust bonds. But it does nothing that it was not already taught to do by its mother or by the framework. Commands and hooks are how you teach an entity to act.

This curriculum covers the two mechanisms by which entity behavior is defined: the commands system (operator-reachable shortcuts defined in `commands/`) and the hook architecture (system-callable entry points defined in `hooks/`). Understanding both — and the distinction between them — is the threshold between running a preconfigured entity and building one of your own.

Operators who complete this curriculum can author commands that respond to operator invocation, write hooks that fire correctly on entity invocation, use entity context variables properly, apply the PID lock and base64 patterns from VESTA-SPEC-020, and combine a command and a hook into a coherent entity skill. The final level delivers exactly that: a complete working skill authored from scratch.

Alice delivers this curriculum conversationally. Every level includes a hands-on exercise in a live entity directory.

## Entry Prerequisites

The learner has completed `entity-gestation` and can:
- Create a new entity using `koad-io gestate <name>`
- Configure `.env` with correct identity and runtime fields
- Explain the three-layer discovery system conceptually
- Navigate any entity's `commands/` and `hooks/` directories
- Explain what a trust bond authorizes

The learner cannot yet:
- Author a `command.sh` from scratch
- Trace the three-layer command resolution algorithm step by step
- Write a functioning `executed-without-arguments.sh` hook
- Apply the PID lock pattern correctly
- Use `$ENTITY`, `$ENTITY_DIR`, and related cascade variables in a script

## Completion Statement

After completing all 8 levels, the operator will be able to:
- Explain the conceptual distinction between commands (operator reaches in) and hooks (system calls out)
- Describe the three-layer command discovery order and predict which `command.sh` will execute for a given invocation
- Author a `command.sh` with correct shebang, error handling, and cascade variable usage
- Write a command that reads `$ENTITY` and `$ENTITY_DIR` from the cascade environment without reconstructing them
- Explain when hooks fire and what types of hooks exist in the koad:io system
- Write an `executed-without-arguments.sh` that handles both interactive and non-interactive invocation correctly
- Apply the PID lock pattern (acquire, write PID, stale detection, trap-on-exit)
- Apply the base64 encoding pattern for prompt transport across SSH
- Combine a command and a hook into a complete entity skill that can be tested end-to-end

---

## Level Summary

| # | Title | Atoms (est.) | Minutes (est.) |
|---|-------|--------------|----------------|
| 0 | Commands vs Hooks — The Conceptual Distinction | 5 | 25 |
| 1 | The commands/ Directory — Structure, Naming, Execution | 5 | 25 |
| 2 | Your First Command — Writing a Working Shell Command | 5 | 25 |
| 3 | Commands That Know Their Entity — $ENTITY, .env, Cascade Variables | 5 | 25 |
| 4 | The hooks/ Directory — When Hooks Fire, Hook Types | 5 | 25 |
| 5 | Writing a Hook — Inject Context, Guard, Log | 5 | 25 |
| 6 | Hook Internals — Ordering, Conflicts, the PID Lock Pattern | 5 | 25 |
| 7 | Command + Hook Together — A Complete Entity Skill | 5 | 25 |

Full level content lives in `levels/`. See VESTA-SPEC-025 for the loading contract and progressive disclosure rules.

---

## Exit Criteria

The operator can:
1. Invoke `<entity> <command>` and trace the full resolution path through all three layers
2. Create a `commands/<name>/command.sh` that uses `$ENTITY_DIR` correctly and handles a missing argument
3. Explain what `executed-without-arguments.sh` does when `$PROMPT` is set vs. when it is not
4. Implement the PID lock acquire/release pattern from memory, including stale lock detection
5. Explain base64 encoding in the hook: why it is needed, what the encode/decode pattern is, and the Linux vs macOS portability concern
6. Deliver a working command + hook pair in a live entity directory that can be tested by invoking the entity with a prompt

---

## Design Rationale

### Why 8 Levels Instead of 7

The roadmap entry for this curriculum estimated 7 levels and 35 atoms. This spec expands to 8 levels and 40 atoms for one reason: separating Level 6 (hook internals — PID lock, ordering) from Level 5 (writing the hook). The PID lock pattern is nontrivial — it has five distinct sub-steps (check, read, kill-0, write, trap) — and collapsing it with the basic hook authoring produces an overloaded level. Learners who misunderstand the PID lock pattern write hooks that corrupt shared state under concurrent invocation. The separation is pedagogically justified.

### Why `entity-gestation` Is the Prerequisite

`entity-gestation` rather than `entity-operations` is the prerequisite because:
- This curriculum writes files into entity directories. An operator who has not gestated an entity has no appropriate sandbox to write commands and hooks into.
- The cascade variable contract (`$ENTITY`, `$ENTITY_DIR`, etc.) is introduced in entity-gestation Level 2 (`.env` configuration). Commands and hooks use these variables throughout — operators who have not seen the cascade do not know what they are reading.
- Trust bonds are relevant at Level 7 (signed hook blocks). entity-gestation Level 5 introduced trust bonds from the receiving side. Level 7 builds on that.

An operator who completed `entity-operations` but not `entity-gestation` could take this curriculum with a fresh entity gestated specifically for practice. The prerequisite is the capability, not the curriculum badge — but `entity-gestation` is the canonical path to that capability.

### Why Commands Before Hooks

Commands are simpler to introduce first: they are invoked explicitly by the operator, they live in a predictable directory, and they have a clear input/output model. Hooks add complexity: they fire implicitly, they must handle two invocation modes (interactive and non-interactive), and they carry the full burden of the PID lock and base64 protocols.

Teaching hooks before commands would require explaining the hook contract (complex) before the operator has any experience writing shell commands in the koad:io context (simple). The current order minimizes cognitive load: commands establish the pattern, hooks extend it.

### Level 7 as Integration

The final level is deliberately a synthesis level, not a new concept. By Level 6, the operator can write commands and hooks independently. Level 7's job is to show them working together — a command that enqueues a task, a hook that processes it, an entity that can be invoked and does something real. Operators who do not see this combination often treat commands and hooks as independent tools rather than complementary mechanisms. Level 7 corrects that.

---

## Specs Covered

| Spec | Coverage |
|------|---------|
| VESTA-SPEC-006 | Commands system — three-layer discovery, resolution, execution environment, naming, subcommand patterns — fully covered across Levels 1–3 |
| VESTA-SPEC-020 | Hook architecture — invocation contract, non-interactive path, interactive path, PID lock, base64 encoding, PATH initialization — fully covered across Levels 4–6 |
| VESTA-SPEC-033 | Signed code blocks — introduced at Level 7 (the hook policy block pattern) |

---

## Curriculum Changelog

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-04-05 | Initial scaffolding by Chiron. 8 levels, 40 atoms estimated. Self-directed — Builder Path step 5/5. |

---

## References

- Prerequisite: entity-gestation v1.0.0+
- Delivered by: Alice (kingofalldata.com)
- Progression system: Vulcan — see koad/vulcan for implementation
- Format authority: Vesta (VESTA-SPEC-025)
- Builder Path position: Final step (step 5 of 5 in the Builder Path sequence)

---

**Signature:**
```
(Pending — Chiron to sign with ed25519 key on first delivery)
```
Signed by: chiron@kingofalldata.com
