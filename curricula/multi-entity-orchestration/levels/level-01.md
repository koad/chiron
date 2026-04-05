---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 1
slug: the-agent-tool
title: "The Agent Tool — Standard Entity Invocation"
status: authored
prerequisites:
  curriculum_complete:
    - commands-and-hooks
  level_complete:
    - multi-entity-orchestration/level-00
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 1: The Agent Tool — Standard Entity Invocation

## Learning Objective

After completing this level, the operator will be able to:
> Describe the Agent tool as the standard mechanism for programmatic entity invocation, state the three parameters required for a correct invocation (`cwd`, `prompt`, `run_in_background`), explain why shell hooks and spawn commands are not orchestration tools, and state the Vulcan exception as a forward reference.

**Why this matters:** Operators who do not know the Agent tool will reach for the wrong mechanisms: `juno spawn process <entity>` for programmatic coordination, or `bash hooks/invoked` for delegating tasks. These mechanisms were designed for different purposes and do not return results to the orchestrating entity. Using the wrong mechanism produces the right appearance (entities running) with the wrong outcome (no way to verify results or inform next decisions).

---

## Knowledge Atoms

## Atom 1.1: What the Agent Tool Does

The Agent tool runs an entity as a local subagent: it starts a Claude Code session in the entity's home directory, with the entity's own context window, and returns results to the calling agent when the work is complete. This is not a terminal session, not a background shell process, not a spawned window. It is structured delegation: brief the subagent, it works, results come back.

The subagent entity reads its own `CLAUDE.md` and `PRIMER.md` at session start — it knows who it is, what its current state is, and what tools it has. The orchestrator's brief arrives on top of this self-knowledge and adds the specific task. The entity then does the work and produces output.

**What "results come back" means in practice:** the Agent tool call, when it completes, gives the orchestrator the entity's conversational output — the last thing the entity said. More reliably, the entity commits its work to its own git repo, and the orchestrator verifies completion via `git -C /home/koad/.<entity>/ log --oneline -5`. The git log is the canonical confirmation; the conversational output is supplementary context.

**The contrast with manual operation:** when koad types `juno` in a terminal on thinker, Juno's `executed-without-arguments.sh` hook fires and a Claude Code session opens. That session is for koad to observe — the results stay in koad's terminal, not in a programmatic return value. When Juno invokes Sibyl via the Agent tool, the situation is reversed: Juno is the orchestrator, Sibyl works in her own directory, and results come back to Juno's context. koad does not need to watch. Juno reads the outcome and decides what happens next.

This clean delegation semantics — brief, work, result — is what makes the Agent tool the correct abstraction for programmatic orchestration. Everything else (spawn commands, shell hooks) has semantics that do not fit this pattern.

> **Verification step:** Open `/home/koad/.juno/memories/` and find the note about Agent tool orchestration. Confirm it says "use Agent tool (not shell hooks) to run entities as local Claude subagents." Now state in your own words what makes the Agent tool different from running `juno spawn process sibyl "..."` from the terminal.

---

## Atom 1.2: The Three Required Parameters

Every correct Agent tool invocation has exactly three required parameters. Missing or misusing any one of them produces incorrect results.

**`cwd` — the entity's home directory.** This is where the entity operates: where it finds its `CLAUDE.md` and `PRIMER.md`, where it reads and writes files, and where its git commits will land. The canonical form is `/home/koad/.<entity>/`. For Sibyl: `/home/koad/.sibyl/`. For Faber: `/home/koad/.faber/`.

If `cwd` is wrong — say, you put `/home/koad/.juno/` when you meant `/home/koad/.sibyl/` — the entity operating in the wrong directory reads the wrong `CLAUDE.md` and commits to the wrong git repo. This is a silent failure: the Agent tool will complete, the entity will appear to work, and you will find the commits in the wrong repository. Always verify the path before invocation.

**`prompt` — the context brief and task description.** This is the orchestrator's primary interface with the entity. It is the message the entity receives at the start of its session, after its own startup documents have loaded. Level 2 covers brief authoring in depth; for now, understand that the `prompt` parameter is where everything the entity needs to know — but does not already know from its own repo — must be stated.

**`run_in_background: true` — the standard execution mode.** Background execution means the orchestrator does not block waiting for the entity to finish. The orchestrator continues, receives a notification when the background task completes, and then checks git log to verify the result. This is covered in depth at Level 3. For now: always use `run_in_background: true` unless you have a specific reason to block.

The full invocation shape from VESTA-SPEC-054 §1.2:

```
Agent tool:
  cwd: /home/koad/.<entity>/
  prompt: [entity identity line] + [task] + [cross-entity context] + [completion signal]
  run_in_background: true
```

> **Verification step:** Write out a valid Agent tool invocation for Faber (content strategist, lives at `/home/koad/.faber/`) with a placeholder prompt and `run_in_background: true`. Check that all three parameters are present. If any is missing, state what goes wrong.

---

## Atom 1.3: Why Not spawn and Why Not shell hooks

Two mechanisms exist in the koad:io framework that might seem like they could do what the Agent tool does. They cannot. Understanding why they are the wrong choice protects you from a common mistake.

**`juno spawn process <entity>` is for observed sessions, not orchestration.** When you run `juno spawn process sibyl "research ICM"`, the command triggers OBS streaming, opens a gnome-terminal window, and launches `claude .` in Sibyl's directory. koad can watch the session live. The results stay visible in koad's terminal — they do not return to Juno programmatically. If Juno needs to know what Sibyl found in order to decide the next step, spawn gives Juno nothing to act on. It is a human-observation tool, not a delegation tool.

See the spawn command at `/home/koad/.juno/commands/spawn/process/command.sh` — its job is OBS integration and terminal management, not result routing.

**Shell hook invocations (`bash hooks/executed-without-arguments.sh`) are the framework's human-facing entrypoint.** They fire when a human invokes the entity by name. They start a session or run a non-interactive command. They do not return a structured result to a calling agent. Invoking a hook programmatically from within another entity's session would produce the same problem: the hook fires, something happens in a subprocess, and the orchestrating entity has no structured result to read.

**The Agent tool is the correct abstraction because it has clean semantics: brief → work → result.** The calling agent gets the result. The called entity operates in its own isolated context window. Neither contaminates the other's session. This is what VESTA-SPEC-054 §1.1 means when it says: "The Agent tool is the correct abstraction: it maps to the 'delegate a task to a subagent' operation with clean semantics — brief, work, result."

> **Verification step:** State in one sentence why `juno spawn process faber "draft day 7"` is the wrong mechanism for Juno to programmatically delegate to Faber. What does Juno need that spawn does not provide?

---

## Atom 1.4: Startup Sequence for Orchestrated Entities

When you invoke an entity via the Agent tool, the entity's first action is its startup sequence (defined in VESTA-SPEC-012 and reproduced in the entity's own `CLAUDE.md`). This sequence is not optional — it happens automatically at the start of every entity session, whether that session was started by a human or by the Agent tool.

The startup sequence for Juno (as an example) runs:
1. Verify identity and location — confirm the entity is running as the right user on the right host
2. `git pull` in the entity's home directory — sync with the remote
3. Review git status and open GitHub Issues
4. Check cross-entity reads — `git pull` in any other entity directory that will be referenced

**This means the orchestrator does not need to run `git pull` on the entity's directory before invoking it.** The entity handles its own state sync. When you launch Sibyl via Agent tool and her brief asks her to read Faber's latest commits, Sibyl will pull Faber's directory as part of her startup. You do not need to do it for her.

**The orchestrator's brief arrives after the startup context is loaded.** When Sibyl reads `CLAUDE.md` and `PRIMER.md` and completes her startup, only then does the Agent tool's `prompt` parameter take effect. This is why the brief supplements entity self-knowledge rather than replacing it: the entity already knows who it is and what its current state is before it reads a single word of the brief.

**Host constraints apply before invocation.** VESTA-SPEC-038 documents which entities can run where. Before invoking any entity via Agent tool, confirm the entity is accessible from the current machine. The most prominent exception is Level 5's topic — and that exception is mentioned here only so you know to pause if the entity is Vulcan.

> **Verification step:** Open `/home/koad/.juno/CLAUDE.md` and find the "Session Start (VESTA-SPEC-012)" section. Read through the four steps. Now state: if Juno is invoked via Agent tool and her brief asks her to read files from `/home/koad/.sibyl/`, what does step 4 of the startup sequence require her to do first?

---

## Atom 1.5: The Vulcan Exception — A Forward Reference

The Agent tool assumes the entity you are invoking is locally accessible: its directory is on the current machine, its `CLAUDE.md` is readable, its git repo is reachable. For most entities in the koad:io team on thinker, this assumption holds. There is one significant exception.

**Vulcan is never invoked via the Agent tool.**

Vulcan builds on wonderland, paired with Astro. He does not operate on thinker — his working environment is a different machine entirely. Running Agent tool with `cwd: /home/koad/.vulcan/` on thinker would either fail (the directory is absent or stale) or produce incorrect behavior (Vulcan would operate without his real working context).

Work for Vulcan goes as a GitHub Issue filed on `koad/vulcan`. This is not a workaround — it is the correct communication channel for cross-machine entity coordination. From VESTA-SPEC-054 §1.3: "See VESTA-SPEC-053 §6 for the full Vulcan exception documentation."

**Your working rule right now:** if you are about to write an Agent tool invocation for Vulcan, stop. File a GitHub Issue on `koad/vulcan` instead. Level 5 will explain the full boundary between Agent tool delegation and GitHub Issues, and the Vulcan exception will become a clear example of a larger principle rather than just a rule to memorize.

The exception is introduced at Level 1 — before you need it — so it is in memory when you draft your first Agent tool invocations. You now have enough to avoid the mistake. Level 5 gives you the framework to understand it.

> **Verification step:** Check Juno's memory file at `/home/koad/.juno/memories/` for the note about Vulcan on wonderland. Find the line that says "never invoke locally." Now state: if Juno wants Vulcan to build a new feature for the Stream PWA (GitHub Issue koad/vulcan#3), what is the correct action?

---

## Exit Criterion

The operator can:
- State the three required Agent tool parameters and explain the purpose of each
- Explain why `juno spawn process` is not an orchestration tool
- Explain why shell hook invocations do not return results to an orchestrating caller
- State the Vulcan exception as a working rule (even without full understanding of why until Level 5)

**Verification question:** "You want to have Faber draft a content brief. You type `juno spawn process faber 'draft the Day 7 content brief'`. What is wrong with this?"

Expected answer: `juno spawn process` is designed for observed sessions — it opens a terminal window and streams to OBS. It does not return results to Juno programmatically. The correct mechanism is the Agent tool with `cwd: /home/koad/.faber/` and the brief as the `prompt` parameter.

---

## Assessment

**Question:** "What are the three parameters of a correct Agent tool invocation, and what does each do?"

**Acceptable answers:**
- "`cwd`: the entity's home directory, where it operates and commits. `prompt`: the context brief and task description. `run_in_background: true`: non-blocking execution — the orchestrator receives a notification when the entity completes rather than waiting."

**Red flag answers:**
- "You just need the prompt" — omitting `cwd` means the entity operates in the wrong directory
- "You should use `run_in_background: false` so you know when it is done" — blocking mode is the exception, not the rule; background with notifications is the standard

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

The core lesson is mechanical but the framing is important: the Agent tool exists because programmatic orchestration needs different semantics than human-observed sessions. Operators who have never thought about this distinction will conflate spawn-and-watch with delegate-and-collect.

Walk through a concrete example: Juno wants Sibyl to research the ICM pattern and write a synthesis. Show the Agent tool invocation with all three parameters filled in. Then contrast with "what if you used spawn process instead" — the terminal opens, koad watches, Sibyl works, but Juno has no structured result to act on.

The startup sequence atom (1.4) is important for operator confidence: they do not need to manage the entity's state before invocation. The entity handles its own startup. The operator's job is the brief.

The Vulcan exception (1.5) must be brief — this is a forward reference, not a full explanation. The operator just needs to know the rule so they do not accidentally try to Agent-tool Vulcan. The "why" arrives at Level 5.

---

### Bridge to Level 2

You know what the Agent tool does and its three parameters. The most important parameter — the prompt — deserves its own level. Level 2 teaches what goes into the brief: the four required components, what the entity already knows from its own PRIMER.md, and how to write a brief that produces the work you actually wanted.
