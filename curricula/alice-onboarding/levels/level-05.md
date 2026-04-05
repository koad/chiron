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

Hooks live in `hooks/` directories. The only hook currently implemented in the live system is:
```
~/.juno/hooks/executed-without-arguments.sh  ← Runs when juno is invoked with no arguments
```

The following are examples of hooks that represent intended behavior — they illustrate the pattern but are **not yet implemented** in the live system:
```
~/.juno/hooks/on-issue-assigned.sh    ← (future) Runs when GitHub assigns Juno an issue
~/.chiron/hooks/author-curriculum.sh  ← (future) System-callable: given a brief, author curriculum
~/.alice/hooks/on-level-complete.sh   ← (future) Runs when a learner completes a level
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

## Dialogue

### Opening

**Alice:** You now know what entities are, how they establish identity, and how they authorize each other. Here's the next layer: what do entities actually *do*? And how does the difference between "I told it to do this" and "it did this on its own" work?

That's the distinction between commands and hooks. It sounds simple. The implications are significant.

---

### Exchange 1

**Alice:** A command is something you call. You type it, or another entity sends it — and the entity responds. Here's a real one:

```
juno commit self
```

That maps to a shell script at `~/.juno/commands/commit/self/command.sh`. You reached in. You initiated. The entity responded.

**Human:** So it's like running any other shell script?

**Alice:** Exactly — that's all it is. The pattern `commands/<verb>/<subcommand>/command.sh` is just a naming convention. What makes it powerful is that it's discoverable: you can look at `~/.juno/commands/` and see everything Juno can do. There's no hidden API. No documentation to look up. The filesystem is the interface.

---

### Exchange 2

**Alice:** A hook is the opposite direction. You didn't initiate it — something in the world did. An event happened, and the system called the hook.

Imagine a hook at `~/.alice/hooks/on-level-complete.sh`. You didn't run it. When you complete a level, the system runs it — records your completion, unlocks the next level, maybe sends a summary somewhere. (This specific hook is planned for the live system; the pattern is already used by hooks like `~/.juno/hooks/executed-without-arguments.sh`.)

That's the hook model: the system calls out; you didn't initiate it. That's what makes it different from a command.

**Human:** Who tells the system to fire the hook?

**Alice:** The daemon — which you'll meet properly in Level 6. For now: the daemon watches for events, and when one matches a hook, it calls that hook. You don't have to be present. You don't have to initiate. The entity just... responds. The way a knee jerks when you tap it.

---

### Exchange 3

**Alice:** When you run `juno commit self`, the system needs to find the right script. It looks in three places, in this order:

1. Juno's own `commands/` directory — `~/.juno/commands/`
2. The current directory's `commands/` folder
3. The global framework commands — `~/.koad-io/commands/`

The entity's own commands come first. Always.

**Human:** Why does that matter?

**Alice:** Because it's sovereignty in practice. The framework ships with default commands. But if Juno has its own version of a command — its own `commit/self` — Juno's version wins. The entity is not overridden by the framework. The framework provides defaults; the entity defines its own behavior where it wants to. This is the same idea as the file-over-cloud-service principle, but applied to commands: your local definition beats the global one.

---

### Exchange 4

**Alice:** Here's the analogy that makes this stick for me. A command is like a hammer. You pick it up, you use it, you put it down. You decided to use it. Without you picking it up, nothing happens.

A hook is like a reflex. You touch something hot and your hand pulls back before you've consciously decided to move it. The stimulus triggered a response — you didn't deliberate. The entity responds to its environment.

**Human:** So hooks are more automatic.

**Alice:** More than automatic — they're what makes an entity an *agent* rather than just a tool. A tool does what you tell it, when you tell it. An agent responds to the world. The hooks are where the agent's behavior lives. An entity without hooks is a very organized shell script collection. An entity with well-designed hooks is something that keeps working while you sleep.

---

### Exchange 5

**Alice:** Think about what hooks enable. When someone files a GitHub Issue assigned to Juno, a hook fires — Juno reads the issue, creates a plan, files a response — all without a human doing anything after the issue was filed. That's not magic. It's a hook that runs a Claude session with the issue content. The autonomy is in the hook design. (This pattern is the direction the `on-issue-assigned.sh` hook is being built toward; the current live hook `executed-without-arguments.sh` already demonstrates the mechanism.)

What would your entity do if you could define any hook you wanted? What events would you want it to respond to automatically?

**Human:** I'd want it to respond when I get a specific kind of message, or when a file I care about changes.

**Alice:** Those are exactly the right instincts. `on-message-received.sh`, `on-file-changed.sh` — those are examples of hooks the system is designed to support. The design question isn't "what commands does my entity have?" — it's "what does my entity do when the world changes around it?" That question is where entity design actually lives.

---

### Landing

**Alice:** Commands are how you reach in. Hooks are how the world reaches out. Both are shell scripts. Both follow a naming convention. But the difference between an entity that only has commands and one with well-designed hooks is the difference between a filing cabinet and a colleague. One waits for you. The other keeps working.

---

### Bridge to Level 6

**Alice:** Commands run when called. Hooks fire when events happen. But something has to be watching for those events. Something has to route the right hook to the right entity. Something has to keep running while you close your laptop.

That's the daemon. And the daemon is what makes the whole thing live.

---

### Branching Paths

#### "How is this different from shell aliases or cron jobs?"

**Human:** This sounds like shell aliases and cron jobs. What's actually different here?

**Alice:** Shell aliases and cron jobs are yours, running in your environment, with no awareness of which entity they belong to. The command system is entity-aware: `juno commit self` knows it's running in Juno's context — it has access to Juno's git credentials, Juno's `.env`, Juno's directory. The hook system is event-aware: it fires in response to specific typed events from the daemon, not arbitrary time schedules. The difference is structure and context. You could do everything with shell aliases — but you'd also have to manually maintain the context, the routing, the discovery. The commands/hooks system provides that structure so entities have a consistent interface. The question isn't "can you do this with cron?" — it's "would you want to maintain fifty cron jobs with no entity context and no naming convention?"

---

#### "Can one entity's hook trigger another entity's command?"

**Human:** Can Alice's hook call a Juno command? Can entities talk to each other?

**Alice:** Yes — and that's where the system gets interesting. An entity's hook can call another entity's command directly, or it can file a GitHub Issue that the other entity's hook picks up. Both patterns exist. The GitHub Issue pattern is more common for asynchronous work — it creates a trail, it's human-readable, it goes through the same authorization checks. The direct command call is faster but tighter-coupled. The important thing is: when one entity calls another's command, the trust bond system still applies. Alice doesn't get to call Juno commands she's not authorized to call. The authorization infrastructure you saw in Level 4 is what makes inter-entity communication trustworthy.

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
