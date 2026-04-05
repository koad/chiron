---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 0
slug: commands-vs-hooks
title: "Commands vs Hooks — The Conceptual Distinction"
status: authored
prerequisites:
  curriculum_complete:
    - entity-gestation
  level_complete: []
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 0: Commands vs Hooks — The Conceptual Distinction

## Learning Objective

After completing this level, the operator will be able to:
> State the fundamental difference between a command and a hook, explain which mechanism an operator uses to reach into an entity versus which mechanism the system uses to call an entity, and classify any given entity capability as "command" or "hook" by asking a single question.

**Why this matters:** Operators who conflate commands and hooks write entity capabilities in the wrong place — commands where hooks belong, and hooks where commands belong. The result is entities that break under automated invocation or fail to respond to manual use. The distinction is simple but must be explicit before any code is written.

---

## Knowledge Atoms

## Atom 0.1: The Pull/Push Distinction — Who Initiates?

Everything in the commands-and-hooks system follows from a single question: **who initiates this?**

If a human or another entity explicitly asks for something — types a command, calls a named capability by name — that is a **pull**. The operator reaches in. The entity responds to the call. Nothing happens until the caller pulls the trigger.

If the framework fires something automatically in response to an event — because the entity was invoked, because a condition was met, because a lifecycle moment occurred — that is a **push**. The system calls out. The entity receives the call and acts. The operator did not directly request it.

This is the commands-and-hooks distinction in one sentence: **commands are pull, hooks are push**.

A concrete pair to anchor the concept:

- `juno commit self` — a command. The operator types it. Nothing happens unless they do. The entity receives an explicit request and fulfills it.
- `executed-without-arguments.sh` — a hook. The framework fires it every time `juno` is invoked without a subcommand. The operator did not ask for it — they just said `juno` and the framework called the hook automatically.

The classification question is always the same: "Who initiates this?" If the answer is "the operator types it" or "another entity calls it by name," it is a command. If the answer is "it fires automatically when the framework detects an event," it is a hook.

**What you can do now:**
- Look at `~/.juno/commands/` and identify two commands there; state who initiates each one
- Look at `~/.juno/hooks/` and identify what is there; state what event causes it to fire
- Apply the question "who initiates this?" to the capability "log every time Juno is asked to do something" — classify it as command or hook

**Exit criterion for this atom:** The operator can state the pull/push distinction in one sentence and apply the classification question to at least three concrete examples without assistance.

---

## Atom 0.2: Commands as Shortcuts — The Operator's Interface

Commands are the operator-facing interface of an entity. They are explicit invocations: the operator types the entity name followed by a command name, and something happens. Nothing happens unless explicitly called. This is the defining property: **zero implicit behavior**.

Commands live in the `commands/` directory inside any entity directory. When you run `juno status`, the framework looks for `~/.juno/commands/status/command.sh` (and other layers — Level 1 covers this). The command runs. When you run `juno spawn process vulcan`, the framework finds `~/.juno/commands/spawn/process/command.sh` and runs it.

Commands take arguments. They return output. They can succeed or fail with an exit code. They can be chained. They are the primary mechanism for an operator to extend an entity's surface area without changing its automated behavior.

The zero-implicit-behavior property is what makes commands safe to add without side effects. You can add a hundred commands to an entity and none of them change how the entity behaves when invoked by an automated system. They only run when explicitly called. This is intentional: commands give you control, not automation.

Juno's command library illustrates the range. `juno status` pulls the latest state and shows open issues. `juno commit self` hands the commit task to an AI harness. `juno spawn process vulcan "build the auth module"` routes a task to another entity. Each is invoked explicitly; none fires automatically.

**What you can do now:**
- Run `ls ~/.juno/commands/` and observe the command tree
- Invoke one command — `juno status` or any other that is available — and observe the output
- Explain why adding a new command to `~/.juno/commands/` does not affect what happens when Juno is invoked without arguments

**Exit criterion for this atom:** The operator can state the zero-implicit-behavior property of commands and explain why it matters for safe capability extension.

---

## Atom 0.3: Hooks as Trained Responses — The System's Interface

Hooks are the system-facing interface of an entity. Where commands respond to operator requests, hooks respond to framework events. The entity does not choose when hooks run — the framework does. **Hooks are what an entity does automatically.**

Hooks live in the `hooks/` directory inside an entity directory. The most important hook — and the one most entities have — is `executed-without-arguments.sh`. This hook fires every time the entity is invoked by name without a subcommand. When the koad:io framework sees `juno` with nothing after it (and no command matches), it looks for `~/.juno/hooks/executed-without-arguments.sh` and runs it.

This is the mechanism that makes entities agents. Without a hook, invoking `juno` by itself does nothing useful — the framework has no default behavior. With a hook, invoking `juno` launches the entity's AI harness, loads its context, and starts a session. The hook is the entity's trained response to "wake up."

The hook analogy is useful: if commands are what the entity can do when asked, hooks are what the entity has been trained to do when events occur. An entity with no hooks is dormant — it can respond to commands but it cannot act on its own. An entity with a well-authored hook is autonomous — it wakes when called, handles both interactive and non-interactive invocation, acquires locks to prevent concurrent conflicts, and routes tasks to the right harness.

Run `ls ~/.juno/hooks/` and you see one file: `executed-without-arguments.sh`. That is Juno's entire automatic behavior: a single, carefully authored response to invocation. Levels 4, 5, and 6 dissect how it works. Level 0's job is simply to name what it is.

**What you can do now:**
- Read the first five lines of `~/.juno/hooks/executed-without-arguments.sh` and confirm it is a shell script with a shebang
- State in one sentence what event causes `executed-without-arguments.sh` to fire
- Contrast: what happens when you run `juno status` vs. what happens when you run `juno` with nothing after it

**Exit criterion for this atom:** The operator can name the most important hook type, state what event fires it, and contrast hook invocation with command invocation.

---

## Atom 0.4: The commands/ and hooks/ Directories — Physical Reality of the Distinction

The conceptual distinction maps directly to two directories in every entity's filesystem:

```
~/.entity/
├── commands/     ← operator-reachable shortcuts
│   ├── status/
│   │   └── command.sh
│   ├── commit/
│   │   └── self/
│   │       └── command.sh
│   └── spawn/
│       └── process/
│           └── command.sh
└── hooks/        ← event-response handlers
    └── executed-without-arguments.sh
```

The `commands/` directory is a nested namespace. Each subdirectory is a command name, and command names can be nested arbitrarily deep (more on this in Level 1). The `hooks/` directory is flat: hook files are named after the events that fire them. `executed-without-arguments.sh` is named after its trigger condition — executed without arguments.

A freshly gestated entity may have neither directory, one, or both — depending on what the mother entity contributed. An entity with no `commands/` directory accepts no custom commands (it falls through to the framework's own command set). An entity with no `hooks/` directory does nothing when invoked by itself (the framework default applies, which is typically a usage message).

Juno has both. Run `ls ~/.juno/commands/` to see the commands tree. Run `ls ~/.juno/hooks/` to see the one hook. This is typical for a mature entity: a handful of purpose-built commands and one well-crafted hook.

The directories are not interchangeable. Putting a script in `hooks/` with the intention of invoking it as a command will not work — the hook naming convention is event-driven, not operator-driven. Putting a script in `commands/` with the intention of having it fire automatically will also not work — it will only run when explicitly called. The distinction is enforced by where you put the file, not by the file contents.

**What you can do now:**
- Run `ls ~/.juno/commands/` and `ls ~/.juno/hooks/` and note the structural difference
- Explain why a script at `~/.juno/hooks/greet.sh` would never run unless there is a framework event called `greet`
- State the rule: commands go in `commands/`, event handlers go in `hooks/`

**Exit criterion for this atom:** The operator can describe the two directories, state what each contains, and explain why the directories are not interchangeable.

---

## Atom 0.5: Classifying Capabilities — One Question

The pull/push distinction is a classification tool. Before writing a single line of code for any new entity capability, apply this question: **"Who initiates this?"**

Work through the answers:

- **"The operator types it by name"** → command. Put it in `commands/<name>/command.sh`.
- **"Another entity calls it by name"** → command. Same location; the caller is different but the mechanism is the same.
- **"It fires every time the entity is invoked"** → hook. Put it in `hooks/executed-without-arguments.sh`.
- **"It fires in response to a framework lifecycle event"** → hook. The event name determines the hook filename.
- **"It happens without anyone asking"** → hook. The framework asked, even if no human did.

Drill this with Juno's actual capabilities:

| Capability | Who initiates? | Type |
|-----------|----------------|------|
| `juno status` — pull latest git state, show open issues | Operator types it | Command |
| `juno commit self` — AI-powered self-commit | Operator types it | Command |
| `juno spawn process vulcan "build auth"` — route task to Vulcan | Operator types it | Command |
| Entity launches Claude Code when `juno` is typed alone | Framework detects invocation without arguments | Hook |
| Entity injects `PRIMER.md` context before every prompt | Framework calls hook on invocation, hook adds context | Hook |
| Entity acquires PID lock to prevent concurrent sessions | Part of hook execution, fires automatically | Hook behavior |

Notice the last row: the PID lock is not a separate command — it is behavior embedded in the hook. Hooks can be complex. Commands can be simple. The classification question is about where the trigger comes from, not about the complexity of the response.

**The synthesis:** both mechanisms are needed for a complete entity skill. A command alone cannot automate — it waits to be called. A hook alone cannot be directly controlled — it fires when the framework decides. Level 7 shows them working together: a command that enqueues a task, a hook that processes it. Neither is superior; they are complementary.

**What you can do now:**
- Apply the classification question to three new capabilities you would want to add to an entity of your own design
- State what would be missing from an entity that had hooks but no commands
- State what would be missing from an entity that had commands but no hooks

**Exit criterion for this atom:** The operator can apply the classification question to any described capability without prompting and produce the correct command-or-hook answer with a rationale.

---

## Exit Criterion

The operator can:
- State the pull/push distinction in their own words
- Classify any described capability as "command" or "hook" by asking who initiates it
- Point to the correct directory (`commands/` or `hooks/`) for a given capability
- Explain why the same entity might need both a command and a hook for a single skill

**Verification question:** "Someone asks: 'I want to write something that runs every time Vulcan is invoked and logs the invocation to a file.' Is that a command or a hook, and where does it live?"

Expected answer: It is a hook — it fires automatically on every invocation without operator action. It lives in `~/.vulcan/hooks/executed-without-arguments.sh` (or as a behavior within that hook).

---

## Assessment

**Question:** "What is the difference between `juno status` (a command) and `executed-without-arguments.sh` (a hook)?"

**Acceptable answers:**
- "`juno status` runs when an operator explicitly invokes it. `executed-without-arguments.sh` runs every time Juno is invoked — whether by a human or by another entity sending a prompt. One is pull, the other is push."
- "A command is initiated by the caller. A hook is initiated by the framework in response to an event."

**Red flag answers (indicates level should be revisited):**
- "They're both shell scripts in the entity directory" — technically true but misses the distinction
- "Hooks are more powerful than commands" — false; they serve different purposes and neither is superior

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

This level is conceptual — no hands-on exercise beyond reading existing files. Operators arriving from entity-gestation have seen both `commands/` and `hooks/` in Juno's directory but have not been told what the distinction is. The level's job is to name a distinction they have implicitly felt but not formalized.

The pull/push framing is the core. "Who initiates?" is the question. Everything else in this level is reinforcing that single question with examples and grounding it in the filesystem layout they already know.

The classification table in Atom 0.5 is the most useful pedagogical tool in this level. Walk through it with the operator before asking them to apply it on their own. The contrast between "juno status" (explicit) and "entity launches Claude Code when juno is typed alone" (implicit) is where the light turns on for most operators.

Do not spend time on mechanics here. The mechanics are Levels 1–6. Level 0 is purely about installing the right mental model before the operator writes a single line of code.

---

### Bridge to Level 1

You have the mental model. Level 1 opens the `commands/` directory and explains its structure: how command directories are named, what files they contain, and how the three-layer discovery algorithm finds the right command when you invoke `<entity> <command>`.
