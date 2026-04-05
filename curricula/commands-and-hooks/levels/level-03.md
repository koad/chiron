---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 3
slug: commands-that-know-their-entity
title: "Commands That Know Their Entity — $ENTITY, .env, Cascade Variables"
status: scaffold
prerequisites:
  curriculum_complete:
    - entity-gestation
  level_complete:
    - commands-and-hooks/level-02
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 3: Commands That Know Their Entity — $ENTITY, .env, Cascade Variables

## Learning Objective

After completing this level, the operator will be able to:
> Write a command that reads `$ENTITY`, `$ENTITY_DIR`, and other cascade variables correctly — using only what the framework provides, without reconstructing paths from `$HOME`.

**Why this matters:** Commands that reconstruct `ENTITY_DIR` from `$HOME` are non-portable and fragile — they assume the `~/.<entity>` naming convention and break if the entity directory structure changes. Commands that use the cascade variables directly work correctly regardless of where the entity lives. This is a conformance requirement in VESTA-SPEC-006 and a design discipline that separates portable commands from brittle ones.

---

## Knowledge Atoms

## Atom 3.1: What the Framework Provides — The Guaranteed Variable Set

<!-- SCAFFOLD: Before a command.sh runs, the dispatcher loads the cascade and injects guaranteed variables. Cover the full set from VESTA-SPEC-006: `$ENTITY` (entity name, e.g., `juno`), `$ENTITY_DIR` (absolute path to entity directory), `$ENTITY_HOME` (entity's home subtree), `$KOAD_IO_HOME` (framework directory). These are available in every command.sh without any work by the command author. The operator does not need to set them, source them, or check if they exist — they are always there. Make the operator verify this by adding `echo "Running as: $ENTITY from $ENTITY_DIR"` to their practice command and invoking it. -->

---

## Atom 3.2: The Cascade — Four Layers, Last Writer Wins

<!-- SCAFFOLD: The cascade loads environment variables in order: (1) `~/.koad-io/.env` (framework defaults), (2) `~/.entityname/.env` (entity overrides), (3) `~/.entityname/commands/<cmd>/.env` (command-local overrides), (4) ad-hoc exports from parent environment. Each layer overrides the previous. Cover what this means in practice: an entity can override a framework default by setting the same variable in its own `.env`. A command can override an entity setting by setting the same variable in its own `.env`. This cascade is why operators should never hard-code values that already exist in the cascade — the cascade is the configuration system; commands should read from it. -->

---

## Atom 3.3: The Conformance Rule — Use the Cascade, Do Not Reconstruct

<!-- SCAFFOLD: VESTA-SPEC-006 §2.2 states explicitly: commands MUST use `$ENTITY_DIR` as provided, not reconstruct it from `$HOME`. Show the anti-pattern: `ENTITY_DIR="$HOME/.$ENTITY"`. Explain why it is wrong: (1) assumes the `~/.<entity>` naming convention, (2) loses the benefits of centralized environment management, (3) breaks if the entity directory structure changes. Show the correct pattern: just use `$ENTITY_DIR` directly — it is already set. Then show a real example: a command that reads `~/.entity/memories/MEMORY.md` should use `"$ENTITY_DIR/memories/MEMORY.md"`, not `"$HOME/.$ENTITY/memories/MEMORY.md"`. This is a one-sentence rule but operators who miss it write fragile commands. -->

---

## Atom 3.4: Writing an Entity-Aware Command — Reading from the Entity Directory

<!-- SCAFFOLD: Hands-on atom. Update the practice command to do something entity-aware: read a file from `$ENTITY_DIR`, or report the entity's identity. A good exercise: write a `status` command that reads `$ENTITY_DIR/KOAD_IO_VERSION` and prints the entity's birth date and gestating parent. This command is genuinely useful and demonstrates both `$ENTITY_DIR` usage and file reading in bash. Walk through writing it, making it executable, and invoking it. The operator should be able to trace: (1) `practice status` → (2) resolution finds `~/.practice/commands/status/command.sh` → (3) dispatcher injects `$ENTITY_DIR=/home/koad/.practice` → (4) command reads `$ENTITY_DIR/KOAD_IO_VERSION`. -->

---

## Atom 3.5: Command-Local .env — When Commands Need Their Own Configuration

<!-- SCAFFOLD: The optional `.env` file in a command directory is the highest-priority cascade layer. Cover when to use it: commands that connect to an external service (need an endpoint URL), commands with configurable timeouts, commands that have different behavior in development vs production. Cover when NOT to use it: variables already in the entity's `.env` should stay there (the command inherits them). The command `.env` is for command-specific configuration only. Distinguish from the entity `.env` and the framework `.env`. Write a simple example: a command that uses a `MY_COMMAND_TIMEOUT` variable defaulted to 30 seconds in the command `.env`. Show how the entity `.env` or parent environment could override it. -->

---

## Exit Criterion

The operator can:
- List the four cascade layers in order and state which has the highest priority
- Identify the guaranteed variables available in any command.sh without additional setup
- Write a command that reads `$ENTITY_DIR` without reconstructing it from `$HOME`
- Explain the VESTA-SPEC-006 conformance rule and state the anti-pattern it prohibits
- Determine whether a variable should live in the entity `.env`, command `.env`, or neither

**Verification question:** "You are writing a command for Alice that reads her memories from her memories directory. Write the one-line bash expression to get the path to `memories/MEMORY.md`."

Expected answer: `"$ENTITY_DIR/memories/MEMORY.md"` — uses the cascade-provided `$ENTITY_DIR` directly.

---

## Assessment

**Question:** "A command in Juno's directory contains the line `ENTITY_DIR=\"$HOME/.$ENTITY\"`. What is wrong with this, and how do you fix it?"

**Acceptable answers:**
- "It reconstructs `ENTITY_DIR` from `$HOME`, which is the anti-pattern prohibited by VESTA-SPEC-006. The fix is to delete that line and use `$ENTITY_DIR` directly — the framework already provides it."

**Red flag answers (indicates level should be revisited):**
- "Nothing is wrong with it — it works" — technically true in most current configurations, but fails the conformance rule and breaks under directory structure changes
- "Change `$HOME` to the absolute path" — the problem is reconstruction, not the variable used

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

<!-- SCAFFOLD: The conformance rule (Atom 3.3) is the most important lesson in this level. It is short — one rule, one anti-pattern, one fix — but operators who skip it write commands that silently work in their setup and break in others. Make it explicit: this is a spec requirement, not a style preference.

The hands-on command in Atom 3.4 should feel useful, not contrived. Reading `KOAD_IO_VERSION` and printing the entity's birth information is a real command operators might want. If Alice has observed the operator asking questions about their entities in earlier levels, this is a good place to connect those questions to a concrete command that answers them.

Atom 3.5 (command-local `.env`) is deliberately brief. Most commands do not need a command-level `.env`. Introduce the mechanism, give one example, move on. Operators who over-use command-level `.env` files end up with configuration spread across too many layers. The preference is: entity `.env` for entity-scope configuration, command `.env` only for command-specific overrides that do not belong at the entity level. -->

---

### Bridge to Level 4

Your commands are entity-aware and conformant. Now it is time to cross to the other side of the pull/push distinction. Level 4 opens the `hooks/` directory: when hooks fire, what types of hooks exist, and how `executed-without-arguments.sh` fits into the invocation lifecycle.
