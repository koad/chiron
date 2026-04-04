---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 5
slug: commands-and-hooks
title: "Commands and Hooks — How Entities Take Action"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2, 3, 4]
estimated_minutes: 20
atom_count: 4
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 5: Commands and Hooks — How Entities Take Action

## Learning Objective

After completing this level, the learner will be able to:
> Distinguish between commands (human-initiated) and hooks (system-initiated), explain where each lives in an entity's directory, and describe the command discovery order.

**Why this matters:** Commands and hooks are how entities act. Understanding the distinction between "a human reaching in" and "the system calling out" is the foundation of understanding how autonomous entity behavior works.

---

## Knowledge Atoms

### Atom 5.1: Commands — The Human Reaches In

**Teaches:** What a command is — a shortcut invoked by a human (or another entity acting as a human).

A **command** is something you call. You initiate it. You reach into the entity and say: "Do this."

Commands live in `commands/` directories:
```
~/.juno/commands/commit/self/command.sh    ← juno commit self
~/.juno/commands/spawn/process/command.sh  ← juno spawn process <entity>
~/.koad-io/commands/list/command.sh        ← koad-io list (global command)
```

The pattern is `commands/<verb>/<subcommand>/command.sh`. To run a command: `juno commit self` maps to `~/.juno/commands/commit/self/command.sh`.

Commands are the entity's **interface for humans**. They expose specific capabilities in a discoverable way. A new human can look at the `commands/` directory and understand what the entity can do.

---

### Atom 5.2: Hooks — The System Calls Out

**Teaches:** What a hook is — a response to a system event, not a human invocation.

A **hook** is something the system calls. An event happens — an issue is filed, a file changes, a session starts — and the hook runs automatically.

Hooks live in `hooks/` directories:
```
~/.juno/hooks/on-issue-assigned.sh    ← Runs when GitHub assigns Juno an issue
~/.chiron/hooks/author-curriculum.sh  ← System-callable: given a brief, author curriculum
~/.alice/hooks/on-level-complete.sh   ← Runs when a learner completes a level
```

The distinction is about initiative: **commands** are user-initiated, **hooks** are system-initiated.

This is why hooks represent the entity's "training" more than commands do. An entity that has well-defined hooks has internalized what it should do when the world calls on it. The hook IS the trained response.

---

### Atom 5.3: Command Discovery Order

**Teaches:** The priority order in which the system finds commands — why an entity's own commands take precedence.

When you run `juno commit self`, where does the system look for `commit/self/command.sh`?

1. **Entity commands first:** `~/.juno/commands/commit/self/command.sh`
2. **Local commands:** `./commands/commit/self/command.sh` (the current directory)
3. **Global commands:** `~/.koad-io/commands/commit/self/command.sh`

This order matters: an entity can override a global command by putting its own version in its `commands/` directory. This is intentional — entities are sovereign. An entity's own commands take precedence over the framework's defaults.

If no command is found at any level, the invocation fails with a clear error.

---

### Atom 5.4: Commands vs. Hooks — The Philosophical Distinction

**Teaches:** Why the command/hook split matters — what it means for entity autonomy.

Consider the difference between:
- A hammer (you pick it up and use it)
- A reflex (your knee jerks when struck — you don't decide)

Commands are like hammers. You use them deliberately.
Hooks are like reflexes. The entity responds to stimuli without a human initiating each response.

An entity with only commands is a tool — it does what you tell it. An entity with well-designed hooks is an agent — it responds to its environment. The hooks are the difference between a passive tool and an active participant.

Well-designed hooks are what make entities capable of autonomous operation. When an issue is assigned, the hook fires. When a session starts, the hook loads context. When a learner completes a level, the hook records the completion. None of these require a human to type a command.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Distinguish between a command (human-initiated) and a hook (system-initiated)
- [ ] Name where commands live in an entity's directory
- [ ] Describe the command discovery order (entity → local → global)
- [ ] Explain why hooks represent an entity's "training" more than commands do

**How Alice verifies:** Ask: "If I want Alice to do something, do I use a command or a hook?" The learner should say "command." Then ask: "What runs automatically when Alice marks a level complete?" The learner should say "a hook."

---

## Assessment

**Question:** "The daemon detects that koad just filed a GitHub Issue assigned to Juno. What runs — a command or a hook?"

**Acceptable answers:**
- "A hook — the system is calling out to Juno in response to an event."
- "A hook, because Juno didn't initiate it — the system did."

**Red flag answers (indicates level should be revisited):**
- "A command — someone runs `juno check-issues`" — learner has the initiative direction reversed

**Estimated conversation length:** 10–14 exchanges

---

## Alice's Delivery Notes

The command/hook distinction is cleanest when you anchor it to who initiates the action. The simplest test: "Did a human (or another agent) type something to make this happen?" If yes, command. "Did the system trigger this in response to an event?" If yes, hook.

The command discovery order (entity → local → global) is a feature, not just an implementation detail. It embodies sovereignty: the entity's own definitions are authoritative. The framework provides defaults; the entity overrides as needed.

The philosophical atom (5.4) about commands as hammers and hooks as reflexes is the one that makes the concept memorable. Use it actively in conversation.
