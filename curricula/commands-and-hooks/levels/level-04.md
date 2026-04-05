---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 4
slug: the-hooks-directory
title: "The hooks/ Directory — When Hooks Fire, Hook Types"
status: scaffold
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

<!-- SCAFFOLD: Trace the full lifecycle of an entity invocation. When an operator types `practice`, the wrapper script (`~/.koad-io/bin/practice`) sets `ENTITY=practice` and calls `koad-io`. With no arguments and no subcommand match, the framework looks for `executed-without-arguments.sh` in `~/.practice/hooks/`. If found, it executes that script. If not found, it falls through to the framework default behavior. Make this sequence explicit: entity wrapper → koad-io dispatcher → command lookup → no command match → hook lookup → hook execution. This is the lifecycle that every invocation of a bare entity name follows. Cover what "bare entity name" means: `practice` with no arguments versus `practice status` (the latter is a command invocation, not a hook trigger). -->

---

## Atom 4.2: executed-without-arguments.sh — The Front Door

<!-- SCAFFOLD: `executed-without-arguments.sh` is the hook that fires when an entity is invoked without arguments. It is the entity's front door. Every interaction that begins with another entity or system invoking the entity by name passes through this hook. Cover the two invocation scenarios: (1) an operator types `practice` at the terminal — interactive, human-driven, (2) another entity sets `PROMPT="do this task"` and invokes `practice` — non-interactive, automated. The hook must handle both. This is why it is the most complex and most important hook in the system: it is the interface between the entity and everything outside it. Note the future state caveat: VESTA-SPEC-020 §8 acknowledges this architecture is transitional and will be superseded by the daemon worker system. -->

---

## Atom 4.3: Other Hook Types — The Hooks Catalog (VESTA-SPEC-009)

<!-- SCAFFOLD: `executed-without-arguments.sh` is the canonical hook but not the only one. VESTA-SPEC-009 catalogs other hook types. Cover the concept: hooks fire on events, and different events have different hook file names. Give examples of hook types that exist or are planned in the catalog: pre-commit hooks, post-spawn hooks, entity-start hooks, message-received hooks. This curriculum does not teach all hook types — it teaches the pattern using `executed-without-arguments.sh`. Operators who need other hook types read VESTA-SPEC-009 and apply the same authoring pattern. The point of this atom: hooks are an extensible system, not a single fixed script. -->

---

## Atom 4.4: Framework Default vs Entity Override — What Happens Without a Hook

<!-- SCAFFOLD: When an entity has no `executed-without-arguments.sh`, the framework falls back to its default behavior. Cover what the default is: typically opens an interactive Claude Code session in the entity directory. This is the behavior an operator sees if they gestate a fresh entity and invoke it immediately — no hook, framework default fires. An entity with a hook replaces this default entirely. The hook is not an addition to the default — it is a replacement. Cover the practical consequence: if you are testing a hook and seeing the framework default, your hook is either missing, not executable, or in the wrong location. This is the most common debugging scenario for Level 5. -->

---

## Atom 4.5: Reading Juno's Hook — What a Production Hook Looks Like

<!-- SCAFFOLD: Open `~/.juno/hooks/executed-without-arguments.sh` and read it without needing to understand every detail. Point out the main sections: the GPG-signed policy block (a signed assertion about what this hook does — covered at Level 7), the prompt detection logic, the PRIMER.md injection section, the non-interactive branch, the interactive branch. The goal is not full comprehension — the goal is to see that a production hook is recognizable as an extension of the pattern being learned, not a fundamentally different thing. An operator who has read Juno's hook before writing their own arrives at Level 5 with confidence rather than apprehension. -->

---

## Exit Criterion

The operator can:
- Describe the invocation lifecycle from entity wrapper to hook execution
- Explain what `executed-without-arguments.sh` does and when it fires
- State what happens when an entity has no hook (framework default)
- Identify the two invocation scenarios the hook must handle (interactive and non-interactive)
- Name the spec that catalogs other hook types (VESTA-SPEC-009)

**Verification question:** "What is the difference between `practice status` (invoking a command) and `practice` (invoking the entity bare)? Which one fires the hook?"

Expected answer: `practice status` resolves to `commands/status/command.sh` — it is a command invocation. `practice` with no arguments triggers `executed-without-arguments.sh` — it fires the hook. The hook does not fire on command invocations.

---

## Assessment

**Question:** "You gestate a new entity called `nova` and immediately run `nova`. What happens and why?"

**Acceptable answers:**
- "The framework default fires — `nova` has no `executed-without-arguments.sh` hook. The default behavior opens an interactive Claude Code session in `~/.nova/`."
- "Nova falls through to the framework default because there is no hook in `~/.nova/hooks/`."

**Red flag answers (indicates level should be revisited):**
- "Nothing happens" — the framework default fires; something does happen
- "Nova runs its commands" — bare invocation triggers the hook (or default), not command discovery

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

<!-- SCAFFOLD: Atom 4.2 introduces the two-path requirement (interactive vs non-interactive) that defines the complexity of Level 5's authoring exercise. Make sure the operator understands both paths before Level 5 begins — the Level 5 hook has distinct code branches for each, and an operator who does not understand why will write a single-path hook that breaks under automated invocation.

The future state caveat in Atom 4.2 (daemon worker system) is worth mentioning briefly. Operators who are building entities intended to run for months need to know the current hook architecture will eventually be superseded. Alice should frame this as: "The hook architecture you are learning is correct and in production. A daemon-based replacement is coming. When it arrives, the skills you build here will transfer — the pattern changes, not the underlying concepts."

Atom 4.5 (reading Juno's hook) is the most important hands-on moment in this level. Alice should walk through it with the operator, not just point to the file. The signed policy block in Juno's hook is mysterious at first glance — acknowledge that it will be explained at Level 7 so operators do not get derailed trying to understand it now. -->

---

### Bridge to Level 5

You understand when hooks fire and what the hook lifecycle looks like. Level 5 is where you write one: a working `executed-without-arguments.sh` for your practice entity that correctly handles both interactive and non-interactive invocation.
