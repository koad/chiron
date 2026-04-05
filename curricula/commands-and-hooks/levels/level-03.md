---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 3
slug: commands-that-know-their-entity
title: "Commands That Know Their Entity — $ENTITY, .env, Cascade Variables"
status: authored
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

**Why this matters:** Commands that reconstruct `ENTITY_DIR` from `$HOME` are non-portable and fragile — they assume the `~/.<entity>` naming convention and break if the entity directory structure changes. Commands that use the cascade variables directly work correctly regardless of where the entity lives. This is a conformance requirement and a design discipline that separates portable commands from brittle ones.

---

## Knowledge Atoms

## Atom 3.1: What the Framework Provides — The Guaranteed Variable Set

Before a `command.sh` runs, the koad:io dispatcher loads the cascade environment and injects a set of guaranteed variables. These are available in every `command.sh` without any work by the command author. The operator does not need to set them, source them, or check if they exist — they are always there.

The guaranteed variables:

| Variable | Value | Example |
|----------|-------|---------|
| `$ENTITY` | Entity name (lowercase) | `juno` |
| `$ENTITY_DIR` | Absolute path to entity directory | `/home/koad/.juno` |
| `$ENTITY_HOME` | Entity's home subtree | `/home/koad/.juno/home/juno` |
| `$KOAD_IO_HOME` | Framework directory | `/home/koad/.koad-io` |

These come from the entity's `.env` file. When Juno's `.env` contains:

```env
ENTITY=juno
ENTITY_DIR=/home/koad/.juno
ENTITY_HOME=/home/koad/.juno/home/juno
```

...the dispatcher sources this file before running any command, making these values available to every script in `commands/`.

**Verify this yourself.** Add a debug echo to the practice `greet` command:

```bash
cat > ~/.practice/commands/greet/command.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo "Running as entity: $ENTITY"
echo "Entity directory: $ENTITY_DIR"

NAME="${1:-}"
if [[ -z "$NAME" ]]; then
  echo "Usage: practice greet <name>" >&2
  exit 64
fi

echo "Hello, $NAME! Greetings from $ENTITY."
EOF
```

But first, you need to configure the practice entity's `.env`. The gestation script writes a minimal two-line `.env`. Add the identity fields:

```bash
cat >> ~/.practice/.env << 'EOF'

ENTITY=practice
ENTITY_DIR=/home/koad/.practice
ENTITY_HOME=/home/koad/.practice/home/practice
EOF
```

Now invoke:

```bash
practice greet Alice
```

Expected output:
```
Running as entity: practice
Entity directory: /home/koad/.practice
Hello, Alice! Greetings from practice.
```

The variables are injected. Your command knows who it is.

**What you can do now:**
- Add the guaranteed variables echo to your practice `greet` command and confirm they resolve correctly
- Explain what would happen if you ran the command without configuring the practice entity's `.env` (the variables would be unset; with `set -u`, the script would exit on the first unset reference)
- Name all four guaranteed variables and their values for the practice entity

**Exit criterion for this atom:** The operator can list the four guaranteed variables, state where they come from, and demonstrate that they are available without additional setup in a command.

---

## Atom 3.2: The Cascade — Four Layers, Last Writer Wins

The framework does not load environment variables from one source. It loads them from four sources in sequence, where later layers override earlier ones. This is the **cascade**.

The four layers, from lowest to highest priority:

1. **Framework defaults** (`~/.koad-io/.env`) — Framework-wide configuration. Applies to all entities unless overridden.
2. **Entity `.env`** (`~/.entityname/.env`) — Entity-specific configuration. Overrides the framework defaults for this entity.
3. **Command `.env`** (`~/.entityname/commands/<cmd>/.env`) — Command-specific overrides. Loaded only for this command. Highest priority among files.
4. **Shell environment** — Variables already set in the calling shell. These override everything above.

The rule is **last writer wins**: each layer can override what the previous layer set, by setting the same variable name.

A concrete example:

- `~/.koad-io/.env` sets `KOAD_IO_ENTITY_HARNESS=opencode` (the framework default)
- `~/.juno/.env` sets `KOAD_IO_ENTITY_HARNESS=claude` (Juno overrides to use Claude Code)
- When Juno's commands run, `$KOAD_IO_ENTITY_HARNESS` is `claude`, not `opencode`

Another example: API keys:

- `~/.koad-io/.env` might have `ANTHROPIC_API_KEY=sk-ant-framework-key`
- `~/.juno/.credentials` sets `ANTHROPIC_API_KEY=sk-ant-juno-key` (Juno uses her own key)
- Juno's commands see `sk-ant-juno-key`; the framework default is shadowed

The cascade is the configuration system. Commands should read from it rather than duplicating values. If a value is already in the entity's `.env`, a command should use the variable — not hard-code or recompute the value.

**Debugging the cascade:**

```bash
# See what git will actually use for author identity
cd ~/.juno && git var GIT_AUTHOR_IDENT

# See a specific variable after loading the entity env
source ~/.practice/.env && echo $ENTITY_DIR
```

**What you can do now:**
- Examine `~/.koad-io/.env` and identify variables it sets as framework defaults
- Examine `~/.juno/.env` and identify variables that override framework defaults
- Explain what happens to `KOAD_IO_ENTITY_HARNESS` when it is set in the framework `.env` but also in the entity `.env`

**Exit criterion for this atom:** The operator can state the four cascade layers in priority order, explain why the entity `.env` overrides the framework `.env`, and name the highest-priority source.

---

## Atom 3.3: The Conformance Rule — Use the Cascade, Do Not Reconstruct

This is the most important rule in this level. It is one sentence:

**Commands MUST use `$ENTITY_DIR` as provided by the cascade. They MUST NOT reconstruct it from `$HOME`.**

The anti-pattern looks like this:

```bash
# WRONG — do not do this
ENTITY_DIR="$HOME/.$ENTITY"
```

This reconstruction appears in many scripts written by operators who have not seen the rule. It works in most current configurations because entities do live at `~/.<entity>`. But it is wrong for three reasons:

1. **It assumes the naming convention.** The `~/.<entity>` path is the current default. If the framework changes the default, or if an entity is placed at a non-standard path, this reconstruction produces a wrong path silently.

2. **It defeats the cascade.** If someone sets `ENTITY_DIR` to a custom path in the entity's `.env` — for example, an entity that lives at `/srv/entities/juno` — a command that reconstructs the path ignores that configuration. The framework went to the trouble of providing `$ENTITY_DIR` precisely so commands do not need to know where entities live.

3. **It creates maintenance debt.** Every command that reconstructs the path must be updated if the path structure changes. Commands that use `$ENTITY_DIR` directly require no changes.

The correct pattern — use the variable directly:

```bash
# CORRECT — use what the cascade provides
cat "$ENTITY_DIR/KOAD_IO_VERSION"
ls "$ENTITY_DIR/commands/"
```

No reconstruction. No assumptions. The cascade provides the correct path; use it.

A real example. A command that reads Juno's memories:

```bash
# WRONG
cat "$HOME/.juno/memories/MEMORY.md"

# ALSO WRONG (only works when ENTITY=juno is already set)
cat "$HOME/.$ENTITY/memories/MEMORY.md"

# CORRECT
cat "$ENTITY_DIR/memories/MEMORY.md"
```

The correct form works regardless of which entity runs it, regardless of where the entity lives, and regardless of who calls it.

**What you can do now:**
- Audit the practice commands you have written so far — do any of them hard-code paths? Replace any hard-coded paths with cascade variables
- Find and read `~/.juno/commands/status/command.sh` — does it use `$ENTITY_DIR` or hard-code `~/.juno`? (Note: the status command uses `cd ~/.juno` — this is a production script that predates the conformance rule; real-world scripts are not always perfectly conformant)
- Write the one-line bash expression to get the path to `KOAD_IO_VERSION` in the current entity's directory

**Exit criterion for this atom:** The operator can state the anti-pattern, explain all three reasons it is wrong, and rewrite any reconstructed path as a cascade variable usage.

---

## Atom 3.4: Writing an Entity-Aware Command — Reading from the Entity Directory

Hands-on: write a command that uses `$ENTITY_DIR` to read a real file from the entity directory. A useful one: a `status` command that reads `KOAD_IO_VERSION` and reports the entity's birth date and gestating parent.

This command is genuinely useful — not a contrived exercise. Every entity has a `KOAD_IO_VERSION` file. Any entity that inherits this command from its mother will immediately be able to run `<entity> whois` and get accurate information about itself.

```bash
mkdir -p ~/.practice/commands/whois
cat > ~/.practice/commands/whois/command.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

VERSION_FILE="$ENTITY_DIR/KOAD_IO_VERSION"

if [[ ! -f "$VERSION_FILE" ]]; then
  echo "Error: $VERSION_FILE not found" >&2
  exit 1
fi

echo "Entity: $ENTITY"
echo "Directory: $ENTITY_DIR"
echo ""
cat "$VERSION_FILE"
EOF
chmod +x ~/.practice/commands/whois/command.sh
```

Invoke:
```bash
practice whois
```

Expected output:
```
Entity: practice
Directory: /home/koad/.practice

GESTATED_BY=mary
GESTATE_VERSION=1854ba3
BIRTHDAY=26:04:05:...
NAME=practice
```

Now trace what happened:
1. `practice whois` → framework searches `~/.practice/commands/whois/command.sh` → found
2. Dispatcher loads cascade: `~/.koad-io/.env`, then `~/.practice/.env` → `$ENTITY=practice`, `$ENTITY_DIR=/home/koad/.practice`
3. `command.sh` runs: `VERSION_FILE="/home/koad/.practice/KOAD_IO_VERSION"` → file exists → contents printed

Every step is deterministic and portable. The command works correctly for any entity that has a `KOAD_IO_VERSION` file — which is every entity in the koad:io ecosystem.

**Extend it:** Add git log output to make the command genuinely useful as a quick-identity check:

```bash
# After the cat "$VERSION_FILE" line, add:
echo ""
echo "Recent commits:"
git -C "$ENTITY_DIR" log --oneline -3 2>/dev/null || echo "(no git history)"
```

**What you can do now:**
- Create the `whois` command in your practice entity
- Invoke `practice whois` and verify it reads `KOAD_IO_VERSION` correctly
- Trace the full execution path: invocation → resolution → cascade load → variable injection → script execution → file read

**Exit criterion for this atom:** The operator can write a command that reads `$ENTITY_DIR` correctly, invoke it successfully, and trace the complete execution path from invocation to output.

---

## Atom 3.5: Command-Local .env — When Commands Need Their Own Configuration

The optional `.env` file inside a command directory is the highest-priority cascade layer. It overrides both the entity `.env` and the framework `.env` for any variables it sets. Most commands do not need it. When it is appropriate, it is powerful.

**When to use a command `.env`:**

- The command connects to an external service, and the endpoint URL should be configurable per-command (not shared with other commands)
- The command has a timeout or threshold that differs from the entity-level default
- The command is used in both development and production, and the two environments need different values for a command-specific variable

Example: a command that posts to an API endpoint:

```bash
# ~/.practice/commands/post/command.sh
#!/usr/bin/env bash
set -euo pipefail

ENDPOINT="${POST_ENDPOINT:-https://api.example.com/v1}"
MESSAGE="${1:?Usage: practice post <message>}"

curl -s -X POST "$ENDPOINT" -d "message=$MESSAGE"
```

```env
# ~/.practice/commands/post/.env
POST_ENDPOINT=https://staging.example.com/v1
```

The command `.env` sets a staging endpoint as the default for this command. The entity `.env` does not need to know about `POST_ENDPOINT`. If the operator wants to override it for a specific run, they can export `POST_ENDPOINT=https://...` in their shell before invoking.

**When NOT to use a command `.env`:**

- Variables that are already in the entity `.env` should stay there. Do not duplicate them.
- Variables that should be available to all the entity's commands belong in the entity `.env`, not in each individual command `.env`.
- Secrets (API keys, tokens) belong in `.credentials`, not in any `.env` file.

**The preference hierarchy:**
1. Shell environment → for per-invocation overrides
2. Command `.env` → for command-specific configuration that varies by deployment
3. Entity `.env` → for entity-wide configuration
4. Framework `.env` → for framework-wide defaults

Most commands operate with only layers 3 and 4. Add a command `.env` only when a command genuinely needs configuration that is distinct from the entity's general configuration.

**What you can do now:**
- Identify a hypothetical configuration value that belongs in the command `.env` vs. the entity `.env`
- Explain in one sentence: what would happen if a command `.env` sets a variable that is already set in the entity `.env`?
- Look at `~/.juno/commands/spawn/process/` — is there a command-level `.env`? What would justify adding one?

**Exit criterion for this atom:** The operator can state when a command `.env` is appropriate, when it is not, and explain the override semantics — command `.env` wins over entity `.env` wins over framework `.env`.

---

## Exit Criterion

The operator can:
- List the four cascade layers in order and state which has the highest priority
- Identify the guaranteed variables available in any command.sh without additional setup
- Write a command that reads `$ENTITY_DIR` without reconstructing it from `$HOME`
- Explain the conformance rule and state the anti-pattern it prohibits
- Determine whether a variable should live in the entity `.env`, command `.env`, or neither

**Verification question:** "You are writing a command for Alice that reads her memories from her memories directory. Write the one-line bash expression to get the path to `memories/MEMORY.md`."

Expected answer: `"$ENTITY_DIR/memories/MEMORY.md"` — uses the cascade-provided `$ENTITY_DIR` directly.

---

## Assessment

**Question:** "A command in Juno's directory contains the line `ENTITY_DIR=\"$HOME/.$ENTITY\"`. What is wrong with this, and how do you fix it?"

**Acceptable answers:**
- "It reconstructs `ENTITY_DIR` from `$HOME`, which is the anti-pattern. The fix is to delete that line and use `$ENTITY_DIR` directly — the framework already provides it via the cascade."
- "It assumes the `~/.<entity>` naming convention. If the entity ever moves or the convention changes, this silently produces a wrong path. Replace it with `$ENTITY_DIR`."

**Red flag answers (indicates level should be revisited):**
- "Nothing is wrong with it — it works" — technically true in most current configurations, but fails the conformance rule and is fragile
- "Change `$HOME` to the absolute path" — the problem is reconstruction, not the variable used; hard-coding the absolute path is even worse

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

The conformance rule in Atom 3.3 is the most important lesson in this level. It is short — one rule, one anti-pattern, one fix — but operators who skip it write commands that silently work in their setup and break in others. Make it explicit: this is not a style preference; it is a portability requirement. The command that works on thinker but breaks when cloned to fourty4 is always the one that hard-codes `$HOME/.$ENTITY`.

The hands-on command in Atom 3.4 should feel useful, not contrived. Reading `KOAD_IO_VERSION` and printing the entity's birth information is a real command operators will want. It is also a command that demonstrates the anti-pattern problem vividly: a `whois` command that hard-codes `~/.practice/KOAD_IO_VERSION` instead of `$ENTITY_DIR/KOAD_IO_VERSION` only works for the practice entity. One that uses `$ENTITY_DIR` can be inherited by any entity and immediately report accurate information. The inheritance use case makes the rule concrete.

Atom 3.5 (command-local `.env`) is deliberately brief. Most commands do not need a command-level `.env`. Introduce the mechanism, give one example, move on. Operators who over-use command-level `.env` files end up with configuration spread across too many layers. The preference is: entity `.env` for entity-scope configuration, command `.env` only for command-specific overrides that genuinely do not belong at the entity level.

By the end of this level, the operator has three working commands in `~/.practice/commands/`: `hello`, `greet`, and `whois`. The `whois` command uses `$ENTITY_DIR` correctly, reads a real file, and produces useful output. This is the milestone: not just a command that works, but a command that knows where it lives and reads from its environment without reconstruction.

---

### Bridge to Level 4

Your commands are entity-aware and conformant. Now it is time to cross to the other side of the pull/push distinction. Level 4 opens the `hooks/` directory: when hooks fire, what types of hooks exist, and how `executed-without-arguments.sh` fits into the invocation lifecycle.
