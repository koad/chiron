---
type: curriculum-decisions
curriculum_slug: commands-and-hooks
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Pedagogical Decisions — commands-and-hooks

This document records the reasoning behind significant choices in how this curriculum is structured. It is an internal design document for Chiron and Alice — not learner-facing content.

---

## Decision 1: Commands-first ordering

**Decision:** Teach commands (Levels 1–3) before hooks (Levels 4–6).

**Alternatives considered:**
- Parallel introduction (explain both concepts at Level 0, then alternate between them in later levels)
- Hooks-first (since hooks are the more fundamental mechanism — they are the entity's front door)

**Reasoning:**

Commands are operator-initiated; hooks are system-initiated. Operators arrive at this curriculum as operators — people who invoke entities. Starting with the mechanism they already use (invoking commands) and teaching them to author that same mechanism minimizes the conceptual jump.

Hooks require understanding two invocation modes (interactive and non-interactive), the PID lock protocol, base64 encoding, and SSH path initialization. Presenting this before the operator has any experience writing scripts in the koad:io context would overload Level 1. Commands establish the pattern — `command.sh`, cascade variables, `set -euo pipefail` — in a low-stakes context. Hooks then build on that pattern rather than introducing it simultaneously with complex protocols.

The risk of commands-first is that operators might come away thinking hooks are "just more complex commands." Level 4's opening (the conceptual distinction lecture) mitigates this by explicitly naming the difference: commands are pull (operator reaches in), hooks are push (system calls out). That framing is delivered after the operator has written a command and knows concretely what they mean.

---

## Decision 2: Conceptual level (Level 0) before mechanics

**Decision:** Level 0 is entirely conceptual — no scripts, no directory listings, just the distinction between commands and hooks as mental models.

**Alternatives considered:**
- Start with directory listings and derive the concept from structure
- Merge Level 0 with Level 1 (skip the standalone conceptual level)

**Reasoning:**

The entity-gestation curriculum demonstrated that operators who run the command without understanding what it produces cannot evaluate success. The same principle applies here: operators who start writing commands and hooks before understanding the pull/push distinction conflate the two mechanisms and write commands where hooks belong, and vice versa.

Level 0's job is narrow: install the correct mental model before any implementation begins. It uses three analogies — commands as shortcuts (reach in), hooks as trained responses (system calls out), and the Unix signal/syscall split as a familiar analogy — to make the distinction sticky.

This level is short by design. An operator who has worked with Juno's command system already has the intuition; they just have not formalized it. Level 0 formalizes. Level 1 operationalizes.

---

## Decision 3: PID lock gets its own level (Level 6)

**Decision:** Level 6 is dedicated to hook internals (PID lock, ordering, conflict handling), separated from Level 5 (writing a basic hook).

**Alternatives considered:**
- Fold PID lock into Level 5 as a "safety section"
- Defer PID lock to Level 7 (the integration level)

**Reasoning:**

The PID lock pattern has five distinct steps: check file existence, read PID, test with `kill -0`, write own PID, register `trap`. Each step has a rationale that is non-obvious to someone who has not seen it before. Folding these five steps into a level that also introduces the hook contract and the interactive/non-interactive split produces a level that is 60% longer than peers and cognitively overloaded.

Deferring to Level 7 would mean the integration exercise (command + hook together) includes a mechanism the operator has not been taught yet. That breaks the "each level introduces exactly one new concept" principle.

Level 6 also covers stale lock detection (`kill -0` semantics), `/tmp` as lockfile location (auto-cleared on reboot, always writable), and why the interactive path does not lock. These are not obvious consequences of the basic PID lock introduction — they are the edge cases that operators hit in practice and need to understand to debug.

---

## Decision 4: Base64 encoding taught at Level 6, not Level 5

**Decision:** The base64 encoding pattern is introduced at Level 6 (hook internals) rather than Level 5 (writing a hook).

**Alternatives considered:**
- Introduce base64 at Level 5 alongside the non-interactive path
- Defer base64 to Level 7 (integration)

**Reasoning:**

Level 5 introduces the hook skeleton: prompt detection, the two branches (interactive and non-interactive), the SSH command structure. That is already substantial. Base64 is a transport-layer concern — it solves the shell quoting problem that arises when you actually use the non-interactive path with real prompts. The operator who has just written their first hook does not yet have enough experience with the quoting problem to feel its necessity.

Level 6 introduces base64 in the context of "things that can go wrong and how to prevent them" — alongside PID lock (concurrency), ordering (multiple hooks), and PATH initialization (SSH non-interactive shell). These are all operational safeguards, not structural requirements. Grouping them together signals their category to the learner: these are the safety patterns, distinct from the structural skeleton.

The Linux vs macOS portability concern (`-w0` flag) is a detail that belongs here — it is a cross-platform safeguard, not a conceptual introduction.

---

## Decision 5: Level 7 is synthesis, not a new concept

**Decision:** Level 7 introduces no new commands or hook mechanics. Its job is to combine what was learned in Levels 1–6 into a working end-to-end skill.

**Alternatives considered:**
- Introduce signed hook policy blocks (VESTA-SPEC-033) as a new concept at Level 7
- Make Level 7 a reference-level covering advanced patterns (multiple hooks, conditional execution, logging)

**Reasoning:**

Operators who reach Level 7 have been told that commands and hooks work together, but have only written them independently. The integration exercise — author a command that writes a task file, author a hook that reads and executes it, invoke the entity and watch it work — makes the relationship concrete. This is the moment the curriculum's central claim (commands and hooks are complementary mechanisms, not parallel alternatives) becomes lived experience rather than assertion.

Signed hook policy blocks (VESTA-SPEC-033) are introduced as a brief awareness atom ("this is what Juno's hook has, here is why") rather than a full authoring exercise. Authoring and verifying GPG-signed blocks belongs to advanced-trust-bonds. Showing them in Level 7 closes the loop with what the operator saw in Juno's `executed-without-arguments.sh` without requiring a full treatment.

Advanced patterns (conditional execution, logging, multiple hooks) are deferred because this curriculum's scope is "author your first command and hook correctly." Advanced patterns belong to a future `entity-customization` curriculum that can assume this foundation.

---

## Decision 6: Hands-on exercises use a fresh test entity, not Juno

**Decision:** Exercises throughout this curriculum are performed in a dedicated practice entity (e.g., `test-entity` gestated at the start of Level 2), not in an operator's production entities.

**Alternatives considered:**
- Read Juno's commands and hooks throughout, but write exercises in a scratch entity
- Allow operators to use any entity they choose for exercises

**Reasoning:**

The exercises in this curriculum write `command.sh` files and `executed-without-arguments.sh` hooks into live entity directories. Operators who do this in Juno (or any other production entity) risk breaking the entity's behavior if they make a mistake. The PID lock exercise in Level 6 requires testing lock acquisition and stale lock detection — if an operator accidentally corrupts Juno's lockfile path, Juno's non-interactive invocations fail until it is corrected.

A dedicated practice entity isolates the risk. The operator gestates a throwaway entity at the start of Level 2, uses it for all exercises through Level 7, and optionally destroys it afterward. This also reinforces a lesson from entity-gestation: entities are cheap to create and cheap to destroy. The practice of gestating a sandbox entity for risky operations is itself good operational hygiene.

---

## What This Curriculum Defers

**Multiple hooks per entity:** The `hooks/` directory can contain hooks for events other than `executed-without-arguments`. VESTA-SPEC-009 (Hooks Catalog) enumerates other hook types. This curriculum covers only `executed-without-arguments.sh` — it is the canonical invocation hook and the one most operators need first. Other hook types belong in a future `advanced-hooks` curriculum.

**Global commands (`~/.koad-io/commands/`):** The curriculum teaches entity-layer commands in depth and introduces the global layer conceptually at Level 1. Writing a new global command that works across all entities is a framework-contributor operation, not an entity-operator operation. Deferred.

**Command composition (commands calling commands):** A command that invokes another command via `koad-io` is a legitimate pattern but introduces recursion concerns and discovery-order subtleties. Deferred to advanced use.

**Daemon worker system superseding hooks:** VESTA-SPEC-020 Section 8 documents the daemon worker system that will eventually replace the hook invocation model. This curriculum teaches the current hook architecture, which remains canonical. When the daemon migration occurs, a curriculum update will be needed. Alice should surface the future state briefly at Level 4 (hook types) to prevent learners from over-investing in the hook model if they are building for the medium term.
