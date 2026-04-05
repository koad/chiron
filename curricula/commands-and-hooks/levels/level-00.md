---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 0
slug: commands-vs-hooks
title: "Commands vs Hooks — The Conceptual Distinction"
status: scaffold
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

<!-- SCAFFOLD: Introduce the core mental model. Commands are pull: the operator or another entity explicitly invokes a named command. Hooks are push: the system calls the hook in response to an event. The question that classifies any capability: "Who initiates this?" If a human or another entity says "do this," it is a command. If the koad:io framework fires it in response to an event, it is a hook. Use concrete examples: `juno commit self` is a command (operator reaches in). `executed-without-arguments.sh` is a hook (framework calls out when the entity is invoked). -->

---

## Atom 0.2: Commands as Shortcuts — The Operator's Interface

<!-- SCAFFOLD: Commands are the operator-facing interface of an entity. They live in `commands/` and are invoked by name: `juno status`, `juno spawn process entity`. They take arguments. They return output. They can be chained. They are explicit: nothing happens until the operator (or another entity acting as operator) calls the command. Cover the key property: zero implicit behavior. A command does nothing unless explicitly called. This is what makes commands safe to add without side effects. -->

---

## Atom 0.3: Hooks as Trained Responses — The System's Interface

<!-- SCAFFOLD: Hooks are the system-facing interface of an entity. They live in `hooks/` and fire in response to framework events. The entity does not choose when hooks run — the framework does. The critical hook for most entities is `executed-without-arguments.sh`: it fires every time the entity is invoked by name. Cover the analogy: if commands are what the entity can do, hooks are what the entity does automatically. An entity with no hooks does nothing when invoked (falls through to the framework default). An entity with a hook has trained behavior. -->

---

## Atom 0.4: The Commands/Hooks Directory — Physical Reality of the Distinction

<!-- SCAFFOLD: Make the distinction concrete by grounding it in filesystem layout. `~/.entity/commands/` contains operator-invocable shortcuts. `~/.entity/hooks/` contains event-response handlers. A freshly gestated entity may have neither, one, or both. Walk through what the operator sees when they `ls ~/.juno/commands/` and `ls ~/.juno/hooks/`. Note that hooks are plural-possible (there can be multiple hook types) but most entities only have one hook: `executed-without-arguments.sh`. Avoid diving into the mechanics of either — that is Levels 1–6. -->

---

## Atom 0.5: Classifying Capabilities — One Question

<!-- SCAFFOLD: Give the operator a classification heuristic they can apply to any entity capability design decision: "Who initiates this?" If the answer is "the operator types a command" or "another entity calls it by name," it is a command. If the answer is "the framework fires it when the entity is invoked" or "it happens every time without being asked," it is a hook. Drill this with three or four examples from Juno's actual capabilities. Close with: both mechanisms are needed. Commands without hooks means the entity cannot be automated. Hooks without commands means the entity cannot be directly controlled. A complete entity skill (Level 7) uses both. -->

---

## Exit Criterion

The operator can:
- State the pull/push distinction in their own words
- Classify any described capability as "command" or "hook" by asking who initiates it
- Point to the correct directory (`commands/` or `hooks/`) for a given capability
- Explain why the same entity might need both a command and a hook for a single skill

**Verification question:** "Someone asks: 'I want to write something that runs every time Vulcan is invoked and logs the invocation to a file.' Is that a command or a hook, and where does it live?"

Expected answer: It is a hook — it fires automatically on every invocation without operator action. It lives in `~/.vulcan/hooks/`.

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

<!-- SCAFFOLD: Delivery guidance for Alice when presenting this level. This level is conceptual — no hands-on exercise. Operators arriving from entity-gestation have seen both `commands/` and `hooks/` in Juno's directory but have not been told what the distinction is. The level's job is to name a distinction they have implicitly felt but not formalized.

The pull/push framing is the core. "Who initiates?" is the question. Everything else in this level is reinforcing that single question with examples and grounding it in the filesystem layout they already know.

Do not spend time on mechanics here. The mechanics are Levels 1–6. Level 0 is purely about installing the right mental model before the operator writes a single line of code. -->

---

### Bridge to Level 1

You have the mental model. Level 1 opens the `commands/` directory and explains its structure: how command directories are named, what files they contain, and how the three-layer discovery algorithm finds the right command when you invoke `<entity> <command>`.
