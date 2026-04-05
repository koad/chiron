---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 1
slug: the-commands-directory
title: "The commands/ Directory — Structure, Naming, Execution"
status: scaffold
prerequisites:
  curriculum_complete:
    - entity-gestation
  level_complete:
    - commands-and-hooks/level-00
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 1: The commands/ Directory — Structure, Naming, Execution

## Learning Objective

After completing this level, the operator will be able to:
> Trace the full resolution path for any `<entity> <command> [subcommand]` invocation through all three discovery layers, predict which `command.sh` will execute, and explain why an entity command shadows a framework command of the same name.

**Why this matters:** The three-layer discovery system is what makes commands both composable and overridable. An operator who does not understand the resolution order cannot predict what will run, cannot debug a command that is being silently shadowed, and cannot design commands that work correctly across the entity/framework boundary.

---

## Knowledge Atoms

## Atom 1.1: The Three-Layer Discovery Order

<!-- SCAFFOLD: Introduce the three layers in priority order: (1) Entity layer — `~/.entityname/commands/`, (2) Local layer — `./commands/` (working directory), (3) Framework layer — `~/.koad-io/commands/`. The rule is: search in order, use the first match. Entity commands shadow local and framework commands. Cover the two rules from VESTA-SPEC-006: Rule 1 (layer precedence — entity overrides) and Rule 2 (deepest match within a layer — `commit/self/command.sh` is used before `commit/command.sh` if both exist). Make the operator practice tracing resolution manually: given `juno commit self`, walk the three layers and identify which file would be executed. -->

---

## Atom 1.2: Directory-as-Namespace — How Subcommands Map to Directories

<!-- SCAFFOLD: Each level of command nesting maps to a directory level. `juno commit` → `commands/commit/command.sh`. `juno commit self` → `commands/commit/self/command.sh`. `juno spawn process entity` → `commands/spawn/process/command.sh`. This is not arbitrary — it means the namespace is visible as a directory tree. An operator can `ls ~/.juno/commands/` and see all top-level commands. `ls ~/.juno/commands/spawn/` shows all spawn subcommands. Cover the deepest-match rule: if both `commit/command.sh` and `commit/self/command.sh` exist, `juno commit self` uses `commit/self/command.sh`. The parent `command.sh` is not called. -->

---

## Atom 1.3: The Required Files — command.sh, README.md, .env

<!-- SCAFFOLD: A command directory has one required file (`command.sh`) and two optional files (`README.md`, `.env`). Cover each. `command.sh` must be executable (`chmod +x`), must use `#!/usr/bin/env bash` as its shebang, and must return a meaningful exit code. `README.md` documents purpose, arguments, and examples — optional but expected for any command shared with other operators. `.env` is a command-scoped environment override loaded last (highest priority in the cascade) — rarely needed but available for commands that require their own configuration. Emphasize: without `chmod +x`, the command will not execute. This is the most common authoring mistake. -->

---

## Atom 1.4: Reading Existing Commands — Juno's commit/self and spawn/process

<!-- SCAFFOLD: Ground the structure in real examples the operator can read on disk. Walk through `~/.juno/commands/commit/self/command.sh` — what does it do, how does it use cascade variables, what is its shebang, does it have a README? Then walk through `~/.juno/commands/spawn/process/command.sh`. The goal is not to fully understand these scripts yet (that is Level 3's job) — it is to see the pattern in practice: directory name = command name, command.sh is the executable, the structure is predictable. This reading exercise builds confidence that the format is approachable before the operator has written any code. -->

---

## Atom 1.5: When Command Discovery Fails — The 127 Exit

<!-- SCAFFOLD: If no `command.sh` is found in any layer after exhaustive search, the dispatcher exits with status 127 (command not found) and prints the three paths it searched. Cover what this output looks like and how to diagnose it. The three most common causes: (1) the `command.sh` file is missing or misnamed, (2) the `commands/` directory does not exist in any search layer, (3) the `command.sh` file exists but is not executable. Distinguish between "command not found" (127) and "command found but errored" (non-zero exit from command.sh itself). An operator who sees 127 should check the three search paths; an operator who sees a different error should look at what the command.sh emitted. -->

---

## Exit Criterion

The operator can:
- Recite the three discovery layers in priority order
- Trace the resolution path for a given invocation (e.g., `vesta report daily`) and name the file that would execute
- Explain why `~/.juno/commands/commit/self/command.sh` is used instead of `~/.koad-io/commands/commit/self/command.sh` if both exist
- State the three files in a command directory, which is required, and what each is for
- Diagnose a "command not found" exit 127

**Verification question:** "You invoke `alice build report`. The file `~/.alice/commands/build/command.sh` exists. The file `~/.alice/commands/build/report/command.sh` also exists. Which one runs?"

Expected answer: `~/.alice/commands/build/report/command.sh` — deepest match wins within a layer.

---

## Assessment

**Question:** "You add a new command to `~/.koad-io/commands/status/command.sh` (the framework layer). Juno already has `~/.juno/commands/status/command.sh`. What happens when you run `juno status`?"

**Acceptable answers:**
- "Juno's own `status` command runs — the entity layer has priority over the framework layer, so the new framework command is shadowed."
- "The entity layer wins. `~/.juno/commands/status/command.sh` is used. The framework version is ignored for Juno."

**Red flag answers (indicates level should be revisited):**
- "Both run" — only one command.sh executes per invocation
- "The framework command runs because it was added later" — priority is by layer, not by recency

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

<!-- SCAFFOLD: The discovery order is the central lesson. Make the operator trace it manually at least twice before moving on — once with a command that exists only in the entity layer, once with a command that exists only in the framework layer. The muscle memory of "entity first, then local, then framework" needs to be installed before Level 2, where they will be creating files in `commands/`.

The deepest-match rule trips operators who expect the parent `command.sh` to run when a subcommand match exists. Make this explicit with a concrete example from Juno's spawn tree.

The reading exercise (Atom 1.4) is important — operators who have never opened a `command.sh` before Level 2 experience Level 2 as intimidating. Having read two real examples in Level 1 makes Level 2 feel like a known pattern, not a new one. -->

---

### Bridge to Level 2

You understand the structure and discovery rules. Level 2 is where you write your first command from scratch — a real working `command.sh` that can be invoked, handles missing arguments, and returns a meaningful exit code.
