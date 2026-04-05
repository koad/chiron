---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 1
slug: the-commands-directory
title: "The commands/ Directory — Structure, Naming, Execution"
status: authored
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

When you invoke `juno status`, the koad:io framework does not run anything immediately. It first searches for a `command.sh` file that should handle that request. It searches in a specific order, and it uses the first match it finds.

The three layers, in priority order:

1. **Entity layer** — `~/.entityname/commands/` — Commands defined by this specific entity. Highest priority.
2. **Local layer** — `./commands/` — Commands in the current working directory. For project-specific shortcuts.
3. **Framework layer** — `~/.koad-io/commands/` — Commands built into the koad:io framework. Available to all entities.

The rule: **search in order, use the first match**. The moment the framework finds a matching `command.sh` in any layer, it stops searching and runs that file. Entity commands shadow local commands. Local commands shadow framework commands. Framework commands are the fallback.

**Tracing an example manually:**

```
juno commit self
```

The framework searches for `commit/self/command.sh`:
1. Check `~/.juno/commands/commit/self/command.sh` — does it exist? YES → run it, stop searching.

If Juno's entity layer did not have that file:
2. Check `./commands/commit/self/command.sh` — does it exist? (Probably no) → continue.
3. Check `~/.koad-io/commands/commit/self/command.sh` — does it exist? (Possibly) → run it if found.

If none of the three layers have a match → exit 127 (command not found).

**Why entity-first matters:** If the framework adds a new `status` command to `~/.koad-io/commands/`, entities that have their own `status` command in `~/.entityname/commands/` are unaffected. The entity's version takes precedence. This is how entities customize behavior without forking the framework: override specific commands at the entity layer, inherit everything else from the framework.

**What you can do now:**
- Run `ls ~/.juno/commands/` and identify which commands Juno defines at the entity layer
- Run `ls ~/.koad-io/commands/` and identify which commands the framework defines
- For the command `juno commit self`, trace the three-layer search manually and name the exact file that executes

**Exit criterion for this atom:** The operator can recite the three layers in priority order and trace the resolution path for any given invocation, naming the exact file that would execute.

---

## Atom 1.2: Directory-as-Namespace — How Subcommands Map to Directories

The command namespace is a directory tree. Each segment of a multi-word command maps to a directory level. This is not a naming convention — it is the resolution algorithm itself. The framework constructs a filesystem path from the command words and looks for `command.sh` at that path.

```
juno status
  └─ commands/status/command.sh

juno commit self
  └─ commands/commit/self/command.sh

juno spawn process entity
  └─ commands/spawn/process/command.sh
```

You can see the entire command namespace by traversing the directory tree:

```bash
ls ~/.juno/commands/          # top-level commands: commit, spawn, status, ...
ls ~/.juno/commands/spawn/    # spawn subcommands: process, ...
ls ~/.juno/commands/commit/   # commit subcommands: self, ...
```

The namespace is human-readable because it is the filesystem. There is no registry, no manifest, no configuration file listing commands. The directory tree is the command tree.

**The deepest-match rule:** Within any layer, the framework uses the deepest matching path. If both `commands/commit/command.sh` and `commands/commit/self/command.sh` exist, invoking `juno commit self` uses `commands/commit/self/command.sh`. The parent `command.sh` is not called. The most specific match wins.

This means `commands/commit/command.sh` acts as a handler for `juno commit` alone — it runs when no further subcommand is provided. It is not a dispatcher that receives "self" as an argument and routes internally; the framework handles routing by directory depth.

**Practical implication:** When designing a command namespace, create a `command.sh` at the top level of a group only if you want `juno <group>` (with no subcommand) to do something useful — a usage message, a status summary, or a default action. Do not create a top-level `command.sh` expecting it to receive subcommand names as arguments.

**What you can do now:**
- Run `ls ~/.juno/commands/commit/` — does a `command.sh` exist there, or only a `self/` subdirectory?
- Predict what happens when you run `juno spawn` with no further arguments (is there a `commands/spawn/command.sh`?)
- Draw the directory tree for a hypothetical entity with commands `nova report`, `nova report daily`, and `nova report weekly`

**Exit criterion for this atom:** The operator can map any multi-word command to its directory path, state the deepest-match rule, and explain what a top-level `command.sh` in a subcommand group does.

---

## Atom 1.3: The Files in a Command Directory — command.sh, README.md, .env

A command directory contains up to three files:

**`command.sh`** (required)
The executable shell script that runs when the command is invoked. It must:
- Be executable (`chmod +x command.sh`) — the single most common authoring mistake is forgetting this
- Begin with `#!/usr/bin/env bash` as the shebang
- Return a meaningful exit code (0 for success, non-zero for failure)

Without the executable bit, the resolution algorithm finds the file but the OS refuses to run it. The error is not immediately obvious ("permission denied" or a silent failure, depending on the shell). Make `chmod +x` the first step after creating `command.sh`, before writing any content.

**`README.md`** (optional but expected)
Documents the command for future operators (and future you). The minimal format:
```
# command-name

Brief description.

## Usage
<entity> <command> [arguments]

## Arguments
- `arg1` — what it does

## Exit Codes
- 0: success
- 64: bad usage
```

This is optional in the sense that the command runs without it. It is expected in the sense that any command shared via gene inheritance or deployed in a production entity should be documented. Commands without README files are opaque to inheriting entities.

**`.env`** (optional, rarely needed)
A command-scoped environment override. Loaded last in the cascade — highest priority. Use it for configuration specific to this command that should not live in the entity's main `.env`. Example: a command that connects to a staging API endpoint might use a command-level `.env` to set `API_ENDPOINT=https://staging.example.com`. Most commands do not need this file at all.

**Summary:**
| File | Required? | Purpose |
|------|-----------|---------|
| `command.sh` | Yes | The command itself; must be executable |
| `README.md` | No (but expected) | Documentation for operators |
| `.env` | No | Command-specific configuration overrides |

**What you can do now:**
- Run `ls ~/.juno/commands/spawn/process/` — which of the three files are present?
- Check whether `~/.juno/commands/spawn/process/command.sh` is executable: `ls -la ~/.juno/commands/spawn/process/command.sh`
- Explain what you would put in a command `.env` vs. the entity `.env`

**Exit criterion for this atom:** The operator can name the three command directory files, state which is required, explain the executable bit requirement, and state when a command `.env` is appropriate.

---

## Atom 1.4: Reading Existing Commands — Juno's commit/self and spawn/process

Before writing a command, read two real ones. The pattern becomes obvious immediately.

**`~/.juno/commands/commit/self/command.sh`:**

```bash
#!/usr/bin/env bash

# Juno Self-Commit Command
# Juno commits her own repository at ~/.juno/

cd ~/.juno || exit 1

PROMPT="
You are Juno. You are committing changes to YOUR OWN repository at ~/.juno/
...
"

opencode --model "${OPENCODE_MODEL:-opencode/big-pickle}" run "$PROMPT"
```

What this shows:
- Shebang on line 1
- Comment describing the command
- A `cd` to a specific directory with `|| exit 1` (exits cleanly if the directory is missing)
- A variable assignment for the prompt content
- A single command invocation using the prompt

Notice that this command does not use `set -euo pipefail`. It is a simpler script that handles its own error cases. Level 2 will cover both patterns.

**`~/.juno/commands/spawn/process/command.sh`:**

This command is more sophisticated. Key patterns to notice:
```bash
#!/usr/bin/env bash
set -euo pipefail
# juno spawn process <entity> ["prompt"]

ENTITY_NAME="${1:?Usage: juno spawn process <entity> [--window] [prompt]}"
shift
```

- `set -euo pipefail` — strict error handling from the first line
- `${1:?...}` — the `:?` operator causes bash to exit with an error message if `$1` is unset or empty; this is how required arguments are enforced
- `shift` — removes the first argument from `$@` so the remainder can be processed

Reading both commands, the pattern is visible: shebang, optional strict mode, comment block, argument parsing, body. Level 2 teaches this pattern from scratch. You already know what the output looks like.

**What you can do now:**
- Read `~/.juno/commands/status/command.sh` — how does it handle the case where `cd ~/.juno` fails?
- Identify which arguments `spawn/process/command.sh` accepts and how it validates them
- State what `set -euo pipefail` does (you will learn why in Level 2; for now, notice its presence)

**Exit criterion for this atom:** The operator can read any `command.sh` file and identify the shebang, argument handling pattern, and error handling approach.

---

## Atom 1.5: When Command Discovery Fails — The 127 Exit

If the framework searches all three layers and finds no `command.sh` that matches the invocation, it exits with status 127 and reports the paths it searched.

Exit code 127 is the Unix standard for "command not found." It is distinct from a command that was found but failed — a failing command exits with its own non-zero code (often 1), not 127. This distinction matters for debugging:

- **Exit 127** → the command was not found; check the three discovery layers
- **Any other non-zero exit** → the command was found and ran, but something went wrong inside it; look at the command's output

**The three most common causes of exit 127:**

1. **File is missing or misnamed.** The `command.sh` file does not exist at the path the framework expects. Check that the directory structure is correct: `commands/<name>/command.sh`, not `commands/<name>.sh` or `commands/command.sh`.

2. **Wrong layer.** The command exists in the entity layer, but you are in a directory where the local layer shadows it, or vice versa. Run `ls ~/.entityname/commands/<name>/` to confirm the entity-layer file exists.

3. **File is not executable.** The `command.sh` exists at the correct path but `chmod +x` was not run. The resolution algorithm finds the file but the OS refuses to execute it. Depending on the shell and the framework version, this may produce a "permission denied" message or a silent 127.

**Diagnosing a 127:**

```bash
# Check all three layers manually
ls ~/.entityname/commands/<name>/command.sh 2>/dev/null && echo "entity layer: found"
ls ./commands/<name>/command.sh 2>/dev/null && echo "local layer: found"
ls ~/.koad-io/commands/<name>/command.sh 2>/dev/null && echo "framework layer: found"

# If found: check executable bit
ls -la ~/.entityname/commands/<name>/command.sh
```

If the file exists but is not executable, `chmod +x` fixes it immediately. If the file is in the wrong location, move it to the correct path (or create a new file at the correct path and copy the content).

**What you can do now:**
- Attempt to invoke a command that does not exist: `juno doesnotexist` — observe the exit code and message
- Take a real command you can see in `ls ~/.juno/commands/`, temporarily rename `command.sh` to `cmd.sh`, and observe what happens when you invoke it; rename it back
- Practice the diagnostic sequence above on one of Juno's commands

**Exit criterion for this atom:** The operator can state the three common causes of exit 127, distinguish a "not found" failure from a "found but failed" failure, and run the diagnostic sequence to locate a missing or non-executable command file.

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

The discovery order is the central lesson. Make the operator trace it manually at least twice before moving on — once with a command that exists only in the entity layer, once with a command that exists only in the framework layer. The muscle memory of "entity first, then local, then framework" needs to be installed before Level 2, where they will be creating files in `commands/`.

The deepest-match rule trips operators who expect the parent `command.sh` to run when a subcommand match exists. Make this explicit with a concrete example from Juno's spawn tree: `juno spawn process` is distinct from `juno spawn`, and the framework routes them to different files.

The reading exercise in Atom 1.4 is important — operators who have never opened a `command.sh` before Level 2 experience Level 2 as intimidating. Having read two real examples in Level 1 makes Level 2 feel like a known pattern, not a new one.

The 127 exit code section deserves a brief live demonstration: try invoking a nonexistent command and let the operator see the actual error message. Seeing it once means they will recognize it immediately in the field.

---

### Bridge to Level 2

You understand the structure and discovery rules. Level 2 is where you write your first command from scratch — a real working `command.sh` that can be invoked, handles missing arguments, and returns a meaningful exit code.
