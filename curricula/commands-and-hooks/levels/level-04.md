---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 4
slug: the-hooks-directory
title: "The hooks/ Directory — When Hooks Fire, Hook Types"
status: authored
prerequisites:
  curriculum_complete:
    - entity-gestation
  level_complete:
    - commands-and-hooks/level-03
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 4: The hooks/ Directory — When Hooks Fire, Hook Types

## Learning Objective

After completing this level, the operator will be able to:
> Describe when `executed-without-arguments.sh` fires, explain why it is the most important hook for most entities, list the other hook types that exist in the koad:io system, and explain what happens when a hook is absent versus when one is present.

**Why this matters:** Operators who do not understand when hooks fire write hook logic in the wrong places or, worse, write hooks that are never triggered by the scenarios they were designed for. Understanding the invocation lifecycle is prerequisite to writing a hook that does what you intend.

---

## Knowledge Atoms

## Atom 4.1: The Hook Invocation Lifecycle — From Command Name to Hook Execution

Every entity in the koad:io system is reachable by its name. When you type `practice` at a terminal, a chain of events unfolds before anything visible happens. Understanding that chain is how you reason about hooks.

The full lifecycle of a bare entity invocation (no arguments):

```
practice
  └─ wrapper: ~/.koad-io/bin/practice
       Sets ENTITY=practice, calls koad-io dispatcher
  └─ dispatcher: koad-io
       Receives: entity=practice, arguments=[]
       Step 1: look for a subcommand match — arguments=[] → no subcommand
       Step 2: command discovery finds nothing to dispatch
       Step 3: look for hooks/executed-without-arguments.sh in:
         - ~/.practice/hooks/executed-without-arguments.sh  → found? run it
         - ~/.koad-io/hooks/executed-without-arguments.sh   → fallback if not found
  └─ hook: ~/.practice/hooks/executed-without-arguments.sh
       Receives: ENTITY=practice, ENTITY_DIR, full cascade env
       Runs to completion
```

The key transition is at Step 2: the dispatcher completes command discovery and finds no command to run. At that point — and only at that point — it falls through to the hook. Commands and hooks do not compete; hooks only fire when command discovery comes up empty.

"Bare entity name" means this: `practice` with nothing after it. The moment you add a subcommand — `practice status`, `practice greet Alice` — you are in the command path, not the hook path. The hook does not fire on command invocations. This is absolute.

Verify by running two things back to back:
```bash
practice hello         # runs commands/hello/command.sh — hook does not fire
practice               # no arguments — hook fires (or framework default fires)
```

The log in `var/hooks/` that you will add in Level 5 will prove this empirically. For now, install the understanding: **the hook fires on bare invocation, and only on bare invocation**.

**What you can do now:**
- Trace the invocation lifecycle for `juno` (bare) and `juno commit self` side by side
- State at which step in the lifecycle the hook fires and why command discovery runs first
- Explain why adding a command `commands/report/command.sh` to your practice entity does not change what `practice` (bare) does

**Exit criterion for this atom:** The operator can trace the full lifecycle from entity wrapper to hook execution, name every step, and explain why `practice status` does not fire the hook.

---

## Atom 4.2: executed-without-arguments.sh — The Front Door

`executed-without-arguments.sh` is named for exactly what fires it: the entity being executed without arguments. It is the hook that every entity that can be invoked by automated systems needs. It is the most important hook in the koad:io system, and most entities have exactly one hook — this one.

Its name is a contract, not a convention. The koad:io dispatcher looks for this exact filename. A file named `invoked.sh` or `default.sh` or `main.sh` will not be found. The filename is the event identifier — and the event name is `executed-without-arguments`.

The hook has a specific responsibility: it must handle **two distinct invocation scenarios** correctly. Both arrive at the same front door.

**Scenario 1: A human types `juno` at the terminal.**

The operator wants an interactive session. They expect a terminal to open, Claude Code to start, and the session to wait for their input. This is the interactive path. The hook must detect this scenario and launch an interactive session.

**Scenario 2: Another entity or script sets `PROMPT="review the latest commit"` and invokes `juno`.**

The automation wants a result. It does not want an interactive terminal — that would hang indefinitely. It expects the entity to run the prompt and return the result on stdout, then exit. This is the non-interactive path. The hook must detect this scenario, run the prompt without human interaction, and exit cleanly with the result on stdout.

The same file handles both. The detection mechanism is the presence or absence of a prompt — Level 5 covers the exact detection logic. The point here is the two-path requirement: a hook that only handles one scenario will fail in the other.

**The consequence of getting this wrong:**

A hook that only implements the interactive path will hang indefinitely when invoked with a prompt. The caller waits for output that never comes. The entity appears to be running but produces nothing. This failure mode is silent and difficult to diagnose without knowing about the two-path requirement.

A hook that only implements the non-interactive path will run the prompt path when a human invokes it bare — not launching a terminal, but trying to read a prompt from somewhere and running it headlessly. The human gets unexpected output or an error.

Both paths are required. Both are tested. Neither is optional.

**The future state caveat:** This two-path hook architecture is the current production pattern (VESTA-SPEC-020). A daemon worker system is under development — when it arrives, hooks will evolve into a daemon interface and tasks will be queued rather than invoked directly. The skills learned in Levels 4–6 transfer directly to that model; the pattern changes, not the concepts. Learn the current architecture knowing it is well-designed and in active production use.

**What you can do now:**
- State in one sentence what event fires `executed-without-arguments.sh`
- Describe both invocation scenarios the hook must handle, and what goes wrong if each is missing
- Read `~/.juno/hooks/executed-without-arguments.sh` lines 49–74 and identify which lines handle the interactive path and which handle the non-interactive path

**Exit criterion for this atom:** The operator can name the two invocation scenarios, describe what the correct behavior is for each, and explain what the failure mode looks like when the hook only handles one.

---

## Atom 4.3: Other Hook Types — The Hooks Catalog (VESTA-SPEC-009)

`executed-without-arguments.sh` is the canonical hook, but the hook system is extensible. The koad:io system catalogs additional hook event types in VESTA-SPEC-009. Each event type has a corresponding filename — the filename is how the dispatcher knows which file to run for which event.

The catalog includes hook types for other lifecycle moments. Examples from VESTA-SPEC-009:

| Event | Hook filename | When it fires |
|-------|---------------|---------------|
| Entity invoked without arguments | `executed-without-arguments.sh` | Any bare invocation |
| Entity spawned by another entity | `spawned.sh` | When `juno spawn process <entity>` fires this entity |
| Pre-commit lifecycle | `pre-commit.sh` | Before a git commit in the entity directory |
| Post-spawn confirmation | `post-spawn.sh` | After spawning completes |
| Message received | `message-received.sh` | When the daemon (future) delivers a message |

This curriculum does not teach every hook type — there are many, and most entities only need `executed-without-arguments.sh`. What this atom instills is the pattern: **hooks are an extensible system, not a single fixed file**. If you need to respond to a different event, look up the event's canonical filename in VESTA-SPEC-009 and create that file in your entity's `hooks/` directory.

The dispatch mechanism is the same for all hook types. The dispatcher finds the event, looks for the matching filename, and runs it. The authoring pattern is identical: shebang, strict mode, event-specific logic. There is no registration step, no manifest to update. The file's existence in `hooks/` with the correct name is the registration.

**What is not a hook:** Shell scripts you write yourself that you plan to `source` from inside a hook are not hooks — they are library files. A hook is a file in `hooks/` with a name that matches a dispatcher event. A file at `hooks/my-helper.sh` that you source manually is not a hook; it will never be called by the dispatcher. Only files with dispatcher-recognized event names function as hooks.

**What you can do now:**
- Run `ls ~/.juno/hooks/` and confirm there is exactly one file there; note its name
- Run `ls ~/.koad-io/hooks/` and identify what the framework provides as a fallback hook
- Read the first few lines of the framework fallback to understand what happens when an entity has no entity-level hook

**Exit criterion for this atom:** The operator can explain that hooks are an extensible, event-named system; name the spec that catalogs hook types; and state what makes a file a hook versus a helper script.

---

## Atom 4.4: Framework Default vs Entity Override — What Happens Without a Hook

When an entity has no `hooks/executed-without-arguments.sh`, the dispatcher does not give up. It falls back to the framework default at `~/.koad-io/hooks/executed-without-arguments.sh`. This is the same three-layer logic as commands: entity-level overrides framework-level.

The framework default is a working hook. It reads the cascade environment, handles both interactive and non-interactive paths, and launches the harness configured in `KOAD_IO_ENTITY_HARNESS`. For most freshly gestated entities, this default is sufficient — the entity launches correctly with no custom hook.

An entity-level hook **replaces** the framework default entirely. This is not additive — the entity hook does not run after the framework hook, and the framework hook does not run as a fallback if part of the entity hook succeeds. The entity hook is the complete hook. Whatever the entity hook does not do, does not happen.

This replacement model is important to understand when authoring. When you write your first entity-level hook, you are not adding to the framework default's behavior — you are taking over completely. If the framework default handled something you need (like PRIMER.md injection), you must include that logic in your entity hook. Nothing is inherited automatically.

**The most common debugging scenario at Level 5:** You write a hook, invoke the entity, and see the framework default behavior — not your hook's behavior. This means one of three things:

1. **Your hook file is in the wrong location.** Check that the file is at `~/.practice/hooks/executed-without-arguments.sh`, not at `~/.practice/executed-without-arguments.sh` or `~/.practice/hooks/hook.sh`.
2. **Your hook is not executable.** The dispatcher finds the file but the OS refuses to run it. `chmod +x ~/.practice/hooks/executed-without-arguments.sh`.
3. **Your hook exits immediately with an error.** If the hook has `set -euo pipefail` and an early command fails, it exits before doing anything visible — and the framework default does not re-fire; you just see nothing.

Run the diagnostic before writing any hook logic:

```bash
# Verify the hook file exists at the correct path
ls -la ~/.practice/hooks/executed-without-arguments.sh

# Verify it is executable (look for 'x' in permission bits)
ls -la ~/.practice/hooks/executed-without-arguments.sh
# Expected: -rwxr-xr-x

# Smoke test: write a one-line hook and confirm it fires
echo '#!/usr/bin/env bash' > ~/.practice/hooks/executed-without-arguments.sh
echo 'echo "hook fired"' >> ~/.practice/hooks/executed-without-arguments.sh
chmod +x ~/.practice/hooks/executed-without-arguments.sh
practice
# Expected output: "hook fired"
```

After confirming the smoke test hook fires, replace it with the real hook from Level 5.

**What you can do now:**
- Check whether your practice entity has a `hooks/` directory at all; if not, create it with `mkdir -p ~/.practice/hooks`
- Explain what "override" means in the context of entity vs framework hooks — why "additive" is the wrong mental model
- State the three diagnostic checks for a hook that appears not to be firing

**Exit criterion for this atom:** The operator can explain the override model (not additive), state what three things to check when a hook does not appear to fire, and run the smoke test to confirm their hook is wired up correctly.

---

## Atom 4.5: Reading Juno's Hook — What a Production Hook Looks Like

Before writing a hook from scratch, read a production one. Open `~/.juno/hooks/executed-without-arguments.sh`. You do not need to understand every line right now — you are reading for structure, not for mastery.

Read through the file top to bottom and identify these landmarks:

**Lines 1–2: Foundation**
```bash
#!/usr/bin/env bash
set -euo pipefail
```
Same as every `command.sh`. This is the universal opening.

**Lines 3–46: The signed policy block**
A large comment block containing a GPG-clearsigned assertion. This is `juno`'s statement of what this hook does — what harness it uses, whether it accepts remote triggers, what its authorization basis is. The signature proves Juno's author explicitly authorized this policy. You have not seen this before; you do not need to fully understand it yet. Level 7 explains it. For now, note its presence: a production entity hook carries a signed declaration of its behavior.

**Lines 49–55: Setup and prompt detection**
```bash
ENTITY_DIR="$HOME/.juno"
CALL_DIR="${CWD:-$PWD}"

PROMPT="${PROMPT:-}"
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi
```
Three things: where Juno lives, where the call came from, and the prompt detection block. This is the detection pattern you will write in Level 5.

**Lines 57–61: PRIMER.md injection**
If a PRIMER.md exists in the calling directory, its contents are prepended to the prompt. This is the pre-invocation context assembly pattern — entities that receive context about the calling project before receiving the task produce higher quality responses.

**Lines 63–68: Interactive path**
When `$PROMPT` is empty, Juno launches an interactive Claude Code session. One branch, `exec` to hand off process control.

**Lines 70–74: Non-interactive path — but with a twist**
Juno's non-interactive path **rejects** the prompt and exits with an error. Read it:
```bash
echo "juno: remote prompt rejected. File a GitHub issue to notify Juno." >&2
exit 1
```
Juno is not a worker entity. She cannot be remote-triggered via prompt. Her trust bond with koad says she acts under koad's direct authorization, not at the request of any entity that sends her a prompt. This is a deliberate policy, not a bug. The signed block at the top asserts this policy, and the implementation enforces it.

This is an important design lesson: the hook is where an entity's operating policy is implemented. A worker entity has a full non-interactive path. An orchestrator entity like Juno can reject non-interactive invocations entirely. The hook is the contract.

Compare Juno's hook to the framework default at `~/.koad-io/hooks/executed-without-arguments.sh`. The framework default has a complete non-interactive path — it is the general-purpose hook. Juno's entity-level override restricts this down to interactive-only. The entity layer is where policy lives.

**What you can do now:**
- Read Juno's hook and identify the five structural sections described above
- Explain in one sentence why Juno's non-interactive path rejects prompts
- Look at the framework hook (`~/.koad-io/hooks/executed-without-arguments.sh`) and identify the equivalent sections; note what is present there that Juno's hook removes

**Exit criterion for this atom:** The operator can identify the five structural sections in Juno's hook, explain the policy difference between Juno's hook and the framework default, and state what the signed policy block is for (without needing to understand GPG clearsigning yet).

---

## Exit Criterion

The operator can:
- Trace the invocation lifecycle from entity wrapper to hook execution, naming every step
- Explain what `executed-without-arguments.sh` does and when it fires
- State what happens when an entity has no entity-level hook (framework default fires)
- Identify the two invocation scenarios the hook must handle (interactive and non-interactive)
- Name the spec that catalogs other hook types (VESTA-SPEC-009)
- Identify the five structural sections in a production hook

**Verification question:** "What is the difference between `practice status` (invoking a command) and `practice` (invoking the entity bare)? Which one fires the hook?"

Expected answer: `practice status` resolves to `commands/status/command.sh` — it is a command invocation, found in command discovery. `practice` with no arguments finds no command to dispatch, falls through to the hook system, and fires `hooks/executed-without-arguments.sh`. The hook does not fire on command invocations.

---

## Assessment

**Question:** "You gestate a new entity called `nova` and immediately run `nova`. What happens and why?"

**Acceptable answers:**
- "The framework default fires — `nova` has no entity-level `executed-without-arguments.sh` hook. The dispatcher falls back to `~/.koad-io/hooks/executed-without-arguments.sh`, which launches the harness configured in `KOAD_IO_ENTITY_HARNESS`."
- "Nova inherits the framework default hook behavior because there is nothing in `~/.nova/hooks/` to override it. The dispatcher uses the framework layer as the fallback."

**Red flag answers (indicates level should be revisited):**
- "Nothing happens" — the framework default fires; something does happen
- "Nova runs its commands" — bare invocation triggers the hook (or default), not command discovery
- "Nova's hook runs" — Nova has no entity-level hook; the framework default runs

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

Atom 4.1 (the invocation lifecycle) should be walked through slowly the first time. The chain from wrapper to dispatcher to command discovery to hook fallback is not obvious to operators who have only ever typed commands. A quick demonstration — run `practice hello` while explaining "this fires command discovery," then run `practice` while explaining "this falls through to hooks" — is worth the two minutes.

Atom 4.2 introduces the two-path requirement that defines Level 5's complexity. Do not underinvest here. Operators who arrive at Level 5 without understanding why both paths are required will resist the complexity of the detection logic — it will feel like overengineering. The two-path requirement is not overengineering; it is the specification of the entity's public API. Make the operator name a concrete scenario for each path before moving on.

The future state caveat in Atom 4.2 (daemon worker system) is worth one sentence: "The hook architecture you are learning is in active production and is correct. A daemon-based replacement is coming. When it arrives, the concepts transfer." Do not spend more than thirty seconds on this. The operator should build with confidence in what exists, not hesitation about what is planned.

Atom 4.5 (reading Juno's hook) is the most important hands-on moment in this level. Walk through it with the operator, not just point to the file. The signed policy block is mysterious at first glance — acknowledge that it will be explained at Level 7 and move past it. The policy difference between Juno's hook (interactive-only, rejects non-interactive) and the framework default (handles both) is the moment when hooks as policy become concrete. Use Juno's design decision to ask the operator: "What kind of entity would have a hook that accepts non-interactive invocations? What kind would reject them?" This sets up the Level 7 synthesis.

---

### Bridge to Level 5

You understand when hooks fire and what the hook lifecycle looks like. You have read a production hook and identified its sections. Level 5 is where you write one: a working `executed-without-arguments.sh` for your practice entity that correctly handles both interactive and non-interactive invocation.
