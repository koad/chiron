---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 2
slug: your-first-command
title: "Your First Command — Writing a Working Shell Command"
status: scaffold
prerequisites:
  curriculum_complete:
    - entity-gestation
  level_complete:
    - commands-and-hooks/level-01
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 2: Your First Command — Writing a Working Shell Command

## Learning Objective

After completing this level, the operator will be able to:
> Create a `commands/<name>/command.sh` file in a live entity directory, give it the correct shebang and error handling, invoke it successfully via `<entity> <name>`, and handle the case where an expected argument is missing.

**Why this matters:** The gap between understanding commands and authoring them is crossed exactly once — the first time. This level closes that gap with a minimal, working, testable command. Everything in Levels 3–7 builds on having done this.

---

## Knowledge Atoms

## Atom 2.1: Gestating a Practice Entity

<!-- SCAFFOLD: Before writing any commands, the operator gestates a throwaway entity for exercises — e.g., `koad-io gestate practice` or `juno gestate practice`. This entity is a sandbox: any mistakes made here are cheap to undo (delete the entity, re-gestate). Cover why using a production entity (Juno, Vulcan) for these exercises is inadvisable — a broken hook or command in Juno affects Juno's operation. The practice entity is kept for the entire curriculum (Levels 2–7) and can be deleted when Level 7 is complete. Cover the gestation command and verify the result: `~/.practice/` exists, wrapper at `~/.koad-io/bin/practice` exists, entity can be invoked. This atom is hands-on setup, not conceptual. -->

---

## Atom 2.2: The Minimal command.sh — Shebang, Error Handling, Echo

<!-- SCAFFOLD: Write the simplest possible working command. Cover the three required elements: (1) shebang `#!/usr/bin/env bash`, (2) error handling `set -euo pipefail`, (3) something observable (an echo). Walk through why `set -euo pipefail` is the correct default: `-e` exits on error, `-u` exits on unset variable reference, `-o pipefail` propagates pipe failures. Operators who omit this write commands that silently swallow errors and produce confusing results. Create `~/.practice/commands/hello/command.sh`, make it executable, invoke it via `practice hello`, observe the output. The command does one thing: echo a greeting. -->

---

## Atom 2.3: Making It Executable — chmod +x Is Not Optional

<!-- SCAFFOLD: The single most common authoring mistake is forgetting `chmod +x command.sh`. A command.sh that is not executable is discovered correctly by the resolution algorithm but fails silently or with a cryptic error. Cover what happens when you try to invoke a non-executable command.sh: the error message, the exit code. Cover `chmod +x` as the fix. Introduce the pattern of always setting the executable bit immediately after creating the file — before writing any content. Some operators prefer `chmod +x command.sh && echo "done"` as their creation pattern. Make this a habit, not an afterthought. -->

---

## Atom 2.4: Handling Arguments — Positional Parameters and the Missing Argument Case

<!-- SCAFFOLD: Most commands take arguments. Cover `$1`, `$2`, `${1:-}` (default empty), and the pattern for failing cleanly when a required argument is missing. Show the standard pattern from VESTA-SPEC-006: `ACTION="${1:-}"` followed by `if [[ -z "$ACTION" ]]; then echo "Usage: ..." >&2; exit 64; fi`. Explain exit code 64 (EX_USAGE — standard Unix convention for bad usage). Walk through adding argument handling to the practice command: require a name argument, echo a personalized greeting, exit 64 with usage message if the name is missing. Invoke with and without the argument to observe both paths. -->

---

## Atom 2.5: Adding a README.md — Documentation Is Part of the Command

<!-- SCAFFOLD: A command without documentation is incomplete. Cover the README.md format: brief description, usage block (with the actual invocation syntax), arguments table, examples, exit codes. Write a minimal README.md for the practice `hello` command. Explain why this matters at scale: when an entity has 15 commands, operators cannot remember every syntax. A consistent README.md format across all commands is what makes `ls ~/.entity/commands/` useful rather than a list of opaque directory names. Also: commands are products — if they are shared via gene inheritance, the README.md is what the inheriting entity's operator reads first. -->

---

## Exit Criterion

The operator can:
- Create a command directory with the correct structure (`command.sh` + `README.md`)
- Write a `command.sh` with correct shebang, `set -euo pipefail`, and a working body
- Set the executable bit and invoke the command successfully
- Handle a missing required argument with a usage message and exit 64
- Write a README.md that documents purpose, usage, arguments, and exit codes

**Verification question:** "You create `~/.practice/commands/greet/command.sh` and try to invoke `practice greet`. Nothing happens and there is no error. What is the most likely cause?"

Expected answer: `command.sh` is not executable. Run `chmod +x ~/.practice/commands/greet/command.sh`.

---

## Assessment

**Question:** "You see `set -euo pipefail` at the top of every command.sh. What does each flag do and why does it matter?"

**Acceptable answers:**
- "-e: exit on any error. -u: exit on unset variable reference. -o pipefail: propagate pipe failures. Together they prevent commands from silently swallowing errors that would otherwise produce wrong results without any indication of failure."

**Red flag answers (indicates level should be revisited):**
- "It makes the script run faster" — incorrect
- "You can omit it if your script is simple" — acceptable to be lenient on simple cases, but the spec recommends it universally

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

<!-- SCAFFOLD: This level is hands-on from Atom 2.1. The operator should be at a terminal for the entire level. Alice guides but does not type — the operator writes the command.sh themselves with Alice's narration.

The practice entity is the most important setup decision in this curriculum. Make sure the operator understands why it exists and what happens to it at the end of Level 7 (it can be deleted or kept as a reference). An operator who skips the practice entity and writes directly into Juno will eventually break something and lose confidence.

`chmod +x` is worth dwelling on. It trips every operator at least once, usually during Level 2 itself. Having experienced the missing-executable-bit failure here — in a safe environment — means they will recognize and fix it instantly in production.

The README.md atom is short by design. The format is introduced here; it will be reinforced at Level 3 when the operator adds entity-awareness to their command. Do not make operators write elaborate documentation for the practice command — a minimal README.md is sufficient. -->

---

### Bridge to Level 3

Your command works. But it is stateless — it does not know which entity it is running inside, and it does not use anything from the entity's configuration. Level 3 teaches commands that know their context: reading `$ENTITY`, `$ENTITY_DIR`, and the cascade environment variables that the framework provides automatically.
