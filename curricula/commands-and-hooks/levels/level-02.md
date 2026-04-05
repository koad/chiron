---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 2
slug: your-first-command
title: "Your First Command — Writing a Working Shell Command"
status: authored
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

Before writing any commands, gestate a throwaway entity specifically for this curriculum's exercises. Call it `practice`:

```bash
koad-io gestate practice
```

This entity is your sandbox. Any mistakes here are cheap to undo. A broken command in `~/.practice/` has no consequences. A broken command in `~/.juno/` affects Juno's operation and may need to be debugged or reverted before Juno can function. The practice entity costs nothing to create and can be deleted when Level 7 is complete.

After gestation, verify the setup:

```bash
ls ~/.practice/          # entity directory exists
ls ~/.koad-io/bin/practice  # wrapper command exists
practice                 # invoking it should produce framework output (no hook yet)
```

If `practice` is not found as a command, the wrapper at `~/.koad-io/bin/practice` may not be on your `$PATH`. Confirm `~/.koad-io/bin` is in `$PATH`:

```bash
echo $PATH | tr ':' '\n' | grep koad-io
```

The practice entity is used for the hands-on exercises in Levels 2 through 7. Keep it throughout the curriculum. Do not use Juno, Vulcan, or any production entity for these exercises.

**What you can do now:**
- Run `koad-io gestate practice` and confirm the directory exists
- Invoke `practice` and note the output (no commands or hooks yet — the framework reports this)
- Confirm `~/.koad-io/bin/practice` exists and is executable

**Exit criterion for this atom:** The operator has a working `~/.practice/` entity with a functional wrapper command and can invoke `practice` from the shell.

---

## Atom 2.2: The Minimal command.sh — Shebang, Error Handling, Echo

Create the simplest possible working command. Three elements are required:

**1. The shebang — line 1, always**
```bash
#!/usr/bin/env bash
```
This tells the OS which interpreter to use. `#!/usr/bin/env bash` is the portable form — it finds `bash` on the `$PATH` rather than assuming it is at a fixed path like `/bin/bash`. Some systems (macOS notably) have an old bash at `/bin/bash` and a newer one installed elsewhere. Always use the portable shebang.

**2. Strict error handling — line 2, always**
```bash
set -euo pipefail
```
Three flags:
- `-e`: exit immediately if any command fails (non-zero exit code)
- `-u`: exit if any variable is referenced before being set (catches typos like `$ENTTY_DIR`)
- `-o pipefail`: if a command in a pipeline fails, the pipeline fails; without this, `false | true` exits 0

Together these flags prevent commands from silently swallowing errors and producing wrong results without any indication of failure. Without them, a script that fails halfway through may appear to succeed. Make this line a reflex — it is the first thing after the shebang, always.

**3. Something observable**
```bash
echo "hello from the practice entity"
```

Now create the command. The full sequence:

```bash
mkdir -p ~/.practice/commands/hello
cat > ~/.practice/commands/hello/command.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo "hello from the practice entity"
EOF
chmod +x ~/.practice/commands/hello/command.sh
```

Invoke it:

```bash
practice hello
```

Expected output:
```
hello from the practice entity
```

That is a complete, working command. It has a correct shebang, strict error handling, does one observable thing, and returns exit 0 (the implicit success exit code from `echo`).

**What you can do now:**
- Create `~/.practice/commands/hello/command.sh` with the three elements above
- Make it executable with `chmod +x`
- Invoke `practice hello` and confirm the output

**Exit criterion for this atom:** The operator can create a minimal `command.sh`, make it executable, and invoke it successfully.

---

## Atom 2.3: Making It Executable — chmod +x Is Not Optional

The executable bit is a Unix permission flag that tells the OS this file can be run directly. Without it, `command.sh` is text that describes a script, not an executable script. The resolution algorithm finds the file correctly — it searches by path, not by permissions — but when the framework tries to execute it, the OS refuses.

The failure mode is confusing because it looks like the command does not exist:

```bash
# command.sh exists but is not executable
practice hello
# Error: permission denied
# or: command exits with no output and a non-zero code
```

Fix:
```bash
chmod +x ~/.practice/commands/hello/command.sh
```

Verify:
```bash
ls -la ~/.practice/commands/hello/command.sh
# Should show: -rwxr-xr-x (note the 'x' bits)
```

The `x` in the permission string means executable. Three `x` bits appear in a fully open executable: user, group, and other. `chmod +x` sets the executable bit for all three simultaneously.

**Make `chmod +x` your creation reflex.** Before writing any content in a new `command.sh`, set the executable bit. The workflow:

```bash
mkdir -p ~/.practice/commands/<name>
touch ~/.practice/commands/<name>/command.sh
chmod +x ~/.practice/commands/<name>/command.sh
# now open and write the content
```

Setting the bit before writing content means you can never forget it — the file is already executable before you start. This eliminates the most common error in command authoring.

**What you can do now:**
- Remove the executable bit from your practice command: `chmod -x ~/.practice/commands/hello/command.sh`
- Try to invoke `practice hello` — observe the error
- Re-add the executable bit: `chmod +x ~/.practice/commands/hello/command.sh` — invoke again and confirm it works

**Exit criterion for this atom:** The operator has deliberately caused and fixed the non-executable error, and can explain the executable bit, how to verify it, and the creation workflow that prevents forgetting it.

---

## Atom 2.4: Handling Arguments — Positional Parameters and the Missing Argument Case

Most commands take arguments. Bash provides positional parameters `$1`, `$2`, etc. for the arguments passed to the script. When you run `practice greet Alice`, inside `command.sh`, `$1` is `"Alice"`.

The standard argument-handling pattern:

```bash
NAME="${1:-}"
if [[ -z "$NAME" ]]; then
  echo "Usage: practice greet <name>" >&2
  exit 64
fi

echo "Hello, $NAME!"
```

Line by line:
- `NAME="${1:-}"` — assign `$1` to `NAME`; the `:-` default makes it empty string (not unset) if no argument was given. This is required because `set -u` would otherwise error on an unset `$1`.
- `if [[ -z "$NAME" ]]` — check if NAME is empty (no argument provided)
- `echo "Usage: ..." >&2` — print usage message to stderr (not stdout); usage errors go to stderr
- `exit 64` — exit with code 64, the Unix standard for bad usage (`EX_USAGE` in `sysexits.h`)

Exit code 64 is meaningful: it tells the caller exactly what went wrong — the command was called incorrectly. A caller that inspects exit codes can distinguish bad usage (64) from command failure (1) from command not found (127).

**The stronger form for required arguments:**

```bash
NAME="${1:?Usage: practice greet <name>}"
```

The `:?` operator causes bash to print the message and exit immediately if `$1` is unset or empty. This is more concise but less flexible — you cannot customize what happens after the check. Use `:-` with an explicit `if` block when you need to do something beyond printing a message. Use `:?` for the simplest cases.

**Update the practice command:**

```bash
cat > ~/.practice/commands/greet/command.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

NAME="${1:-}"
if [[ -z "$NAME" ]]; then
  echo "Usage: practice greet <name>" >&2
  exit 64
fi

echo "Hello, $NAME! Greetings from the practice entity."
EOF
chmod +x ~/.practice/commands/greet/command.sh
```

Test both paths:

```bash
practice greet Alice       # should print greeting
practice greet             # should print usage message to stderr and exit 64
echo $?                    # should print 64
```

**What you can do now:**
- Create `~/.practice/commands/greet/command.sh` with argument handling
- Test both the happy path (name provided) and the error path (name missing)
- Confirm that the usage message goes to stderr (redirect stdout: `practice greet 2>/dev/null` — the usage message should disappear since it goes to stderr, not stdout)

**Exit criterion for this atom:** The operator can write an argument-handling block with a usage message and exit 64, test both code paths, and explain the difference between `${1:-}` and `${1:?}`.

---

## Atom 2.5: Adding a README.md — Documentation Is Part of the Command

A command without documentation is incomplete. Not incomplete in the sense that it will not run — it will. Incomplete in the sense that anyone who encounters it six months from now (including you) has no context for what it does, how to call it, or what to expect.

The README.md format for a command:

```markdown
# greet

Prints a personalized greeting from the practice entity.

## Usage

```
practice greet <name>
```

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `name`   | Yes      | Name of the person to greet |

## Examples

```bash
practice greet Alice
# → Hello, Alice! Greetings from the practice entity.
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0    | Greeting printed successfully |
| 64   | Missing required argument (`name`) |
```

Write this file:

```bash
cat > ~/.practice/commands/greet/README.md << 'EOF'
# greet

Prints a personalized greeting from the practice entity.

## Usage

practice greet <name>

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `name`   | Yes      | Name of the person to greet |

## Examples

    practice greet Alice
    # → Hello, Alice! Greetings from the practice entity.

## Exit Codes

| Code | Meaning |
|------|---------|
| 0    | Greeting printed successfully |
| 64   | Missing required argument (name) |
EOF
```

**Why this matters at scale:** When an entity grows to fifteen commands, no operator can remember every syntax. The directory structure tells you the commands exist; the README.md tells you how to use them. Consistent README.md format across all commands also matters for gene inheritance: when another entity inherits `commands/` from a mother, the README.md files are what the inheriting entity's operator reads first. A commands directory with no README.md files is a library with no titles.

**What you can do now:**
- Write `README.md` for the practice `greet` command following the format above
- Read `~/.juno/commands/spawn/process/` — does it have a README.md? What does it document?
- Write a README.md for the `hello` command you created in Atom 2.2 (it is brief, but the practice is valuable)

**Exit criterion for this atom:** The operator can write a minimal README.md for any command following the standard format, including usage, arguments, examples, and exit codes.

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
- "You can omit it if your script is simple" — acceptable to be lenient on simple scripts, but the spec recommends it universally; any production command should have it

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

This level is hands-on from Atom 2.1. The operator should be at a terminal for the entire level. Alice guides but does not type — the operator writes the command.sh themselves with Alice's narration guiding the sequence.

The practice entity is the most important setup decision in this curriculum. Make sure the operator understands why it exists: a broken command in a production entity like Juno costs real debugging time; a broken command in `~/.practice/` costs nothing. Operators who skip the practice entity and write directly into Juno will eventually break something and lose confidence. Do not let them skip this step.

`chmod +x` is worth dwelling on in Atom 2.3. The exercise of deliberately causing the failure — removing the executable bit, observing the error, re-adding it — is the fastest way to install the reflex. An operator who has experienced this failure once in a safe context will not make it in a production context. The deliberate failure exercise takes ninety seconds and prevents hours of debugging.

The README.md atom is short by design. The format is introduced here; it will be reinforced at Level 3 when the operator adds entity-awareness to their command. Do not make operators write elaborate documentation for the practice command — the minimal format above is sufficient. The goal is to establish the habit: documentation is part of the command, not an optional extra.

At the end of this level, the operator has two working commands in `~/.practice/commands/`: `hello` and `greet`. Both have README.md files. Both handle their cases correctly. This is the foundation for Level 3.

---

### Bridge to Level 3

Your command works. But it is stateless — it does not know which entity it is running inside, and it does not use anything from the entity's configuration. Level 3 teaches commands that know their context: reading `$ENTITY`, `$ENTITY_DIR`, and the cascade environment variables that the framework provides automatically.
