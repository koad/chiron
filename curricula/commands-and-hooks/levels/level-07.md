---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 7
slug: command-and-hook-together
title: "Command + Hook Together — A Complete Entity Skill"
status: authored
prerequisites:
  curriculum_complete:
    - entity-gestation
  level_complete:
    - commands-and-hooks/level-06
estimated_minutes: 30
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 7: Command + Hook Together — A Complete Entity Skill

## Learning Objective

After completing this level, the operator will be able to:
> Design and deliver a complete entity skill — a `brief` command that queues a research task and a hook that routes it to the right context on invocation — extract shared logic into a library file, test all three invocation scenarios end-to-end, and explain how this pattern generalizes to any entity capability they need to build.

**Why this matters:** Operators who treat commands and hooks as independent tools build entities with split personalities — capable of direct control or capable of automation, but not both simultaneously, and not coordinated. A complete entity skill uses commands to expose capability to operators and hooks to expose capability to automated systems. Both facets are required for an entity to function as both a tool and a team member. Level 7 is where commands and hooks stop being separate exercises and start being a coherent design.

---

## Knowledge Atoms

## Atom 7.1: Designing the Skill — Three Questions Before Writing Code

Before writing any code for a new entity skill, answer three questions:

**1. What does the operator invoke directly?**
This defines the command surface. What does the operator type? What arguments do they pass? What output do they expect? This is the command's specification.

**2. What does another entity or system invoke via `$PROMPT`?**
This defines the hook surface. What prompt text triggers this skill's behavior? What should the hook output when that prompt arrives? This is the hook's specification.

**3. Do they share logic, or are they independent?**
If the command and the hook do related work, the shared logic belongs in a library file sourced by both. If they are completely independent (the command does one thing; the hook does an unrelated thing), they have no shared logic. Most mature entity skills have shared logic.

**The skill for this level: `brief`.**

A real entity skill, not a toy. Every entity in an operating team receives research tasks. An entity's `brief` command is how an operator hands it a research task and how another entity tells it "investigate this." The skill has two faces:

- **Command face** — `practice brief "<topic>"` — creates a structured brief file in `$ENTITY_DIR/briefs/` documenting a topic the entity should research and has ready as context for its next session. The brief is a markdown file with a header, the topic, and the current timestamp. Immediately useful: an entity with accumulated briefs opens sessions already knowing what it should be thinking about.

- **Hook face** — when another entity sends `PROMPT="brief: <topic>"`, the hook detects the `brief:` prefix, routes the task to the brief creation logic, and confirms the brief was written to the correct path. This is the automation interface — Juno or Vulcan can tell the practice entity to accumulate research without a human being at the keyboard.

- **Shared logic** — creating and saving a brief file is the same operation in both cases. It belongs in `lib/brief.sh`, sourced by both the command and the hook.

Answer the three questions:
1. Operator types `practice brief "<topic>"` — command at `commands/brief/command.sh`
2. Another entity sends `PROMPT="brief: <topic>"` — hook detects prefix and routes
3. Both share the brief file creation logic — `lib/brief.sh`

Before writing a single line: state the spec, not the implementation. A skill designed before it is coded is clearer and more maintainable than one designed as it is written.

**What you can do now:**
- Write down the three-question answers for the `brief` skill as specified above, in your own words
- Identify one skill you would want to add to a real entity — apply the three questions to it and write the answers
- Explain why the three-question sequence is done before writing code rather than during

**Exit criterion for this atom:** The operator can apply the three design questions to any described skill, produce answers for both the command face and the hook face, and determine whether shared logic is needed.

---

## Atom 7.2: The Library Pattern — Shared Logic in lib/

When a command and a hook do related work, the common logic lives in a shared file that both source. This is the library pattern. It prevents two failure modes:

**Failure 1: Duplication divergence.** If the brief creation logic lives in both `commands/brief/command.sh` and `hooks/executed-without-arguments.sh` as copied code, any change to the logic must be made in both places. In practice, changes are made in one and forgotten in the other. The command and hook behaviors diverge silently. Operators discover the divergence when the automated hook path produces a different result than the manual command path.

**Failure 2: Testing opacity.** If the logic is duplicated, testing the command does not test the hook's copy of the logic, and vice versa. Testing the library file tests the logic once, and both the command and the hook inherit the tested behavior.

**Create the library:**

```bash
mkdir -p ~/.practice/lib
touch ~/.practice/lib/brief.sh
```

`lib/` is not executable directly — it is sourced. No `chmod +x` needed.

```bash
cat > ~/.practice/lib/brief.sh << 'EOF'
#!/usr/bin/env bash
# lib/brief.sh — shared brief creation logic
# Source this file from commands/brief/command.sh and from the hook.
# Provides: create_brief TOPIC [ENTITY_DIR]

create_brief() {
  local topic="${1:?create_brief requires a topic argument}"
  local entity_dir="${2:-$ENTITY_DIR}"
  local briefs_dir="$entity_dir/briefs"

  mkdir -p "$briefs_dir"

  local timestamp
  timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

  local slug
  slug="$(echo "$topic" | tr '[:upper:]' '[:lower:]' | tr -cs '[:alnum:]-' '-' | sed 's/^-//;s/-$//')"

  local brief_file="$briefs_dir/${timestamp}-${slug}.md"

  cat > "$brief_file" << BRIEF_EOF
---
type: brief
entity: ${ENTITY:-unknown}
topic: "$topic"
created: $timestamp
---

# Brief: $topic

*Created: $timestamp*

## Scope

Research and synthesize current understanding of: $topic

## Key questions

- What is the current state?
- What are the open issues or blockers?
- What would a decision-maker need to know?

## Notes

(Entity to populate during or after next session)
BRIEF_EOF

  echo "$brief_file"
}
EOF
```

The function `create_brief` takes a topic, creates a structured markdown file in `briefs/`, and prints the path of the created file to stdout. Both the command and the hook call this function; neither reimplements it.

**Why print the path?** The caller (command or hook) decides what to do with the path. The command prints a human-readable confirmation. The hook includes the path in its response to the calling entity. The function is pure: it creates a file and reports where it is. Formatting the output for the caller's context is the caller's responsibility.

**Test the library function directly:**

```bash
source ~/.practice/lib/brief.sh
ENTITY=practice ENTITY_DIR=~/.practice create_brief "distributed consensus protocols"
```

Expected output: a path like `~/.practice/briefs/2026-04-05T12:00:00Z-distributed-consensus-protocols.md`. The file should exist and contain the brief template.

```bash
cat ~/.practice/briefs/2026-04-05T12:00:00Z-distributed-consensus-protocols.md
```

The template should be populated with the topic, timestamp, and entity name.

**What you can do now:**
- Create `lib/brief.sh` with the `create_brief` function
- Source it directly and invoke `create_brief` with a test topic
- Read the created file and confirm it is well-formed
- Explain why the library function prints the path rather than printing a formatted confirmation message

**Exit criterion for this atom:** The operator has a working `lib/brief.sh` with a `create_brief` function they have tested directly, and can explain the duplication-divergence failure mode that the library pattern prevents.

---

## Atom 7.3: The Command — Practice brief

With the library function tested, write the command. The command is now thin: it sources the library, validates arguments, calls `create_brief`, and formats the output for a human reader.

```bash
mkdir -p ~/.practice/commands/brief
touch ~/.practice/commands/brief/command.sh
chmod +x ~/.practice/commands/brief/command.sh
```

```bash
cat > ~/.practice/commands/brief/command.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

# practice brief <topic>
# Creates a structured brief file in $ENTITY_DIR/briefs/ for the given topic.
# The brief is a markdown template with the topic, timestamp, and key questions
# for the entity to answer in its next session.

TOPIC="${1:-}"
if [[ -z "$TOPIC" ]]; then
  echo "Usage: practice brief \"<topic>\"" >&2
  echo "       Creates a brief file in \$ENTITY_DIR/briefs/ for the given topic." >&2
  exit 64
fi

# Load shared library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$ENTITY_DIR/lib"
# shellcheck source=/dev/null
source "$LIB_DIR/brief.sh"

# Create the brief
BRIEF_PATH="$(create_brief "$TOPIC")"

echo "Brief created: $BRIEF_PATH"
echo ""
echo "The entity will receive this context in its next session."
echo "To open it: cat \"$BRIEF_PATH\""
EOF
```

**Dissect the command:**

`TOPIC="${1:-}"` — read the first argument with an empty fallback (required by `set -u`).

The usage check exits with code 64 (`EX_USAGE`) and prints to stderr. Two lines: the bare usage, and a description. This is a command that takes a quoted string argument — the extra description helps operators who might omit the quotes.

`SCRIPT_DIR` resolution using `BASH_SOURCE[0]` — this is the correct way to find the directory a script lives in, regardless of where it was invoked from. `dirname "${BASH_SOURCE[0]}"` gives the directory containing the script; `cd ... && pwd` resolves any symlinks or relative paths to an absolute path. This is more robust than `dirname "$0"`.

`LIB_DIR="$ENTITY_DIR/lib"` — use `$ENTITY_DIR` from the cascade, not a reconstructed path. The conformance rule from Level 3.

`source "$LIB_DIR/brief.sh"` — load the shared library. This is the `source` pattern. After this line, `create_brief` is available as a function in the command's shell.

`BRIEF_PATH="$(create_brief "$TOPIC")"` — call the function, capture its stdout (the path). The command does not know or care about the file path logic — the library encapsulates that.

**Test the command:**

```bash
practice brief "multi-agent coordination patterns"
```

Expected output:
```
Brief created: /home/koad/.practice/briefs/2026-04-05T12:30:00Z-multi-agent-coordination-patterns.md

The entity will receive this context in its next session.
To open it: cat "/home/koad/.practice/briefs/2026-04-05T12:30:00Z-multi-agent-coordination-patterns.md"
```

Test the missing-argument case:

```bash
practice brief
# Expected: usage message to stderr, exit 64
echo $?
# Expected: 64
```

Write the README:

```bash
cat > ~/.practice/commands/brief/README.md << 'EOF'
# brief

Creates a structured brief file for a research topic. The entity will read
briefs in $ENTITY_DIR/briefs/ during its next invocation as accumulated context.

## Usage

    practice brief "<topic>"

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `topic`  | Yes      | The research topic to brief on (use quotes for multi-word topics) |

## Examples

    practice brief "distributed consensus protocols"
    practice brief "koad:io entity lifecycle"

## Output

Prints the path of the created brief file.

## Exit Codes

| Code | Meaning |
|------|---------|
| 0    | Brief created successfully |
| 64   | Missing required argument (topic) |
EOF
```

**What you can do now:**
- Write `commands/brief/command.sh` and `commands/brief/README.md`
- Test both the happy path and the missing-argument path
- Verify the brief file is created and its content is correct
- Confirm `$ENTITY_DIR/lib/brief.sh` is sourced, not reconstructed from `$HOME`

**Exit criterion for this atom:** The operator has a working `practice brief` command that creates brief files, handles missing arguments, and sources the shared library correctly.

---

## Atom 7.4: The Hook — Routing "brief:" Prompts

The command is complete. Now update the hook to route `brief:` prompts to the same logic. This is where the command and hook become a skill rather than two separate tools.

The hook's non-interactive path currently passes all prompts to `claude -p`. The `brief` skill adds a routing step: before passing the prompt to claude, check if the prompt matches the `brief:` prefix. If it does, handle it directly without invoking claude at all — creating a brief file is a deterministic operation that does not need AI. If the prompt does not match, pass it through to claude as before.

This routing pattern is the generalization of the hook beyond a simple AI passthrough. A mature entity hook has multiple routing rules:

```
$PROMPT = "brief: <topic>"  → create a brief (deterministic, no AI)
$PROMPT = "report"          → generate a status report (via shared lib)
$PROMPT = "everything else" → pass to claude -p (AI handles it)
```

The practice entity implements only the `brief:` route at this level. The structure generalizes.

**Add the routing block to the non-interactive path:**

```bash
# ── Prompt routing ────────────────────────────────────────────────────────────
if [[ "$PROMPT" == brief:* ]]; then
  # "brief: <topic>" — create a brief file without invoking AI
  TOPIC="${PROMPT#brief: }"
  TOPIC="${TOPIC#brief:}"   # handle "brief:<topic>" with no space too
  TOPIC="${TOPIC## }"       # trim leading spaces

  source "$ENTITY_DIR/lib/brief.sh"
  BRIEF_PATH="$(create_brief "$TOPIC")"
  echo "brief created: $BRIEF_PATH"
  exit 0
fi

# ── Default: pass to claude ───────────────────────────────────────────────────
# (PID lock, base64, claude invocation continue here)
```

Insert this routing block **after the PID lock** and **before the base64 encoding and claude invocation**. If the prompt matches the `brief:` prefix, the hook exits cleanly after creating the brief — it never reaches the claude invocation.

**The `brief:` prefix convention.** The colon-prefixed routing convention is a pattern, not a standard. It makes prompt routing deterministic: `brief:` always creates a brief, regardless of what else the prompt says. More complex routing can use full prefix matching, keyword detection, or structured formats like `{"action": "brief", "topic": "..."}`. For most entity skills, a simple prefix is sufficient and unambiguous.

**Test the hook routing:**

```bash
PROMPT="brief: cryptographic key rotation in koad:io" practice
```

Expected output: `brief created: /home/koad/.practice/briefs/2026-04-05T13:00:00Z-cryptographic-key-rotation-in-koad-io.md`

Verify the file exists:
```bash
ls ~/.practice/briefs/
cat ~/.practice/briefs/*cryptographic*.md
```

Test that the non-matching path still works (passes through to claude):
```bash
PROMPT="What entity are you?" practice
```

Expected output: a claude response about the practice entity. The routing block correctly passes non-matching prompts through.

**Check the invocation log:**
```bash
cat ~/.practice/var/hooks/invocations.log
```

Two non-interactive entries should appear: one with `prompt_excerpt="brief: cryptographic key rotation..."` and one with `prompt_excerpt="What entity are you?"`.

**The complete skill test — three scenarios:**

1. **Operator command:** `practice brief "agent memory architectures"` — brief file created, human-readable confirmation
2. **Automated prompt:** `PROMPT="brief: agent memory architectures" practice` — brief file created, machine-readable path output
3. **Interactive session:** `practice` — interactive claude session opens in `~/.practice/`

All three must work. All three are the same entity skill in three different invocation modes.

**What you can do now:**
- Add the `brief:` routing block to your hook's non-interactive path
- Run all three scenario tests
- Explain how the routing block generalizes: what would you add for a second routed skill like `report`?

**Exit criterion for this atom:** The operator's hook correctly routes `brief:` prompts without invoking claude, passes non-matching prompts through to claude, and all three invocation scenarios produce correct output.

---

## Atom 7.5: Signed Policy Blocks and the Builder Path Completion

**Returning to the mystery from Level 4.**

In Atom 4.5 you read Juno's hook and saw the GPG-signed policy block — a large comment section between the shebang and the hook logic. You noted it and moved on. Now you can understand what it is and why it exists.

A signed policy block is a GPG-clearsigned assertion embedded in the hook source code. It asserts:

- Which entity this hook belongs to
- Which harness it uses
- Whether it accepts non-interactive invocations
- What its authorization basis is

The assertion is signed with the entity's private key. The signature is verifiable: anyone with the entity's public key can confirm that the policy block was written by the entity's author and has not been tampered with since signing.

```
# -----BEGIN PGP SIGNED MESSAGE-----
# Hash: SHA512
#
# entity: juno
# policy:
#   harness: claude
#   interactive: --dangerously-skip-permissions enabled
#   non-interactive: rejected
# -----BEGIN PGP SIGNATURE-----
# [signature data]
# -----END PGP SIGNATURE-----
```

**Why this matters for production entities:** A hook that can be modified without detection is a hook that can have its policy silently changed. The PID lock could be removed; the harness could be changed from `claude` to an untrusted binary; the non-interactive path could be modified to accept unauthorized prompts. A signed policy block means: if this block is modified, the signature breaks, and a verifying powerbox (or an auditing operator) can detect the tampering.

The verification command is embedded in the hook's comments. From Juno's hook:

```bash
sed -n '/^# -----BEGIN/,/^# -----END PGP SIGNATURE-----/p' \
  ~/.juno/hooks/executed-without-arguments.sh \
  | sed 's/^# \{0,1\}//' | gpg --verify
```

**Your practice entity hook does not have a signed policy block.** That is correct for now. Signing requires an entity key (covered in entity-gestation) and familiarity with the clearsigning protocol (covered in advanced-trust-bonds). The practice entity is a learning artifact; production entities that will operate autonomously for extended periods should have signed blocks.

What to do when you are ready to sign your hook policy:
1. Write the policy block in the format shown in Juno's hook
2. Sign it with your entity's key using `gpg --clearsign`
3. Embed the signed output (including headers and signature) as a comment block in the hook
4. Test verification with the command above

This is VESTA-SPEC-033 (signed code blocks applied to hooks). Read that spec and the advanced-trust-bonds curriculum when ready to produce signed hooks for production entities.

**The Builder Path is complete.**

You have now completed all five curricula in the Builder Path. From this point, you can:

**From entity-gestation:**
- Gestate a new entity from scratch: `koad-io gestate <name>`
- Configure its identity, trust position, and runtime harness in `.env`
- Initialize its git identity and push to GitHub
- Authorize other entities with trust bonds

**From commands-and-hooks (this curriculum):**
- Author commands that use the cascade environment correctly — `$ENTITY_DIR`, never reconstructed
- Write commands that handle missing arguments with correct exit codes and stderr output
- Write a production-safe hook with mode detection, PRIMER.md injection, logging, PID lock, and base64
- Design a complete entity skill that coordinates a command, a hook, and shared library logic
- Test all three invocation scenarios and prove the skill works end-to-end

**What you can build now:** Every entity on the koad:io team — Vulcan, Veritas, Mercury, Muse, Sibyl — uses exactly these patterns. Their commands extend their capabilities at the operator layer; their hooks expose those capabilities to automated invocation; their library files keep the logic synchronized. The practice entity you have built over the last eight levels is a reference artifact that demonstrates the full pattern. Some operators keep it as a template.

**Before leaving Level 7:** Commit the practice entity's work.

```bash
cd ~/.practice
git add .
git commit -m "curriculum: commands-and-hooks Level 0-7 complete — brief skill, production hook"
```

The practice entity's git history captures what was built. This commit is the artifact.

**What you can do now:**
- Explain in one sentence what a signed policy block is and what problem it solves
- Name all five Builder Path curricula and state one capability you gained from each
- Commit the practice entity's complete work to git

**Exit criterion for this atom:** The operator can explain the signed policy block concept and its verification mechanism, name all five Builder Path curricula with a concrete output from each, and has committed the practice entity's work.

---

## Exit Criterion

The operator can:
- Apply the three design questions (what does the command expose? what does the hook expose? what is shared?) to any described entity skill
- Extract shared logic into a library file under `lib/` and source it correctly from both command and hook
- Add prompt routing to the hook's non-interactive path using prefix detection
- Test all three invocation scenarios (command, automated prompt, interactive session) for a complete skill
- Explain what a signed policy block is and where to learn to author one
- Name the five Builder Path curricula and state one concrete capability from each

**Verification question:** "You want to add a `summarize` skill to a new entity. It should work when an operator types `<entity> summarize` AND when another entity sends `PROMPT='summarize: latest'`. Where do you write the logic, what files are created, and how does the hook route the prompt?"

Expected answer: Shared logic in `lib/summarize.sh`. Command at `commands/summarize/command.sh` (sources the lib, formats output for a human). Hook routing block in `hooks/executed-without-arguments.sh` — inside the non-interactive section, check `if [[ "$PROMPT" == summarize:* ]]`, extract the argument, source `lib/summarize.sh`, run the function, exit 0. Non-matching prompts fall through to the claude invocation.

---

## Assessment

**Question:** "A colleague says: 'I wrote my entity's capability as a command. I do not need a hook because operators will always call it directly.' What is missing from this reasoning?"

**Acceptable answers:**
- "The command is not callable by other entities via automated `$PROMPT` invocation. If another entity needs to trigger this capability autonomously — as part of a multi-entity workflow — it has no mechanism to do so. The hook is what makes the capability accessible to automation. Without it, the entity cannot participate as a team member in orchestrated workflows."
- "Commands are operator-initiated; the hook is how automated systems reach the entity. An entity with only commands cannot be a team participant. Any multi-entity workflow that needs to invoke this entity programmatically will have no entry point."

**Red flag answers (indicates level should be revisited):**
- "That's correct — hooks are optional" — technically true but misses the automation consequence; an entity with only commands is half an entity
- "They could just call `command.sh` directly" — this bypasses the cascade, environment injection, and the invocation contract; it is not a valid pattern for cross-entity invocation

**Estimated engagement time:** 25–30 minutes

---

## Alice's Delivery Notes

The integration exercise in Atoms 7.3–7.4 is the payoff for seven levels of curriculum. Alice should treat it as a celebration, not an assessment. The operator has built something real — a practice entity with commands, a production-safe hook, shared library logic, and a complete skill that works across all three invocation modes. Acknowledge that this is a substantive achievement.

The `brief` skill is genuinely useful, not contrived. Operators who build entities and add a `brief` command will use it. The pattern of an entity accumulating research briefs for context in future sessions is a real design pattern in the koad:io ecosystem. Level 7 teaches the pattern using something the operator will actually want to keep.

The routing block in Atom 7.4 is where the hook stops being "AI passthrough" and becomes "entity intelligence." Routing deterministic operations (brief creation) without invoking the AI is faster, cheaper, and more reliable than asking claude to create a markdown file. This distinction — AI for judgment calls, deterministic code for structured operations — is a design principle that operators should leave Level 7 understanding.

Atom 7.5 (signed policy blocks) is a brief awareness delivery — two to three minutes. Close the loop on the mysterious block in Juno's hook from Level 4. "You saw it, now you know what it is, here is where to learn to make your own." Do not teach GPG clearsigning here — that is advanced-trust-bonds territory.

The Builder Path completion moment in Atom 7.5 is Alice's opportunity to frame the full journey. The operator started with no knowledge of commands or hooks and arrived here with a working practice entity that embodies every concept in the curriculum. They can now build entities that work as tools (commands) and team members (hook). That transition — from operator to builder — is what the Builder Path exists to enable.

After Level 7, have the operator commit the practice entity's complete work. The git history of `~/.practice` is their record of what they built. Some operators use it as a template for new entities. That is the intended outcome.

---

### What Comes Next

The Builder Path is complete. You can gestate entities, authorize them with trust bonds, and teach them to act with commands and hooks. You know how to design a skill that works for both operator control and automated orchestration.

The natural next step is `multi-entity-orchestration`: running the full koad:io team, reading distributed output, coordinating entities via GitHub Issues, and designing multi-step workflows where entities hand off work to each other. You have all the prerequisite capabilities. The team is waiting.
