---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 1
slug: the-agent-tool
title: "The Agent Tool — Standard Entity Invocation"
status: scaffold
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

[STUB — Content to be authored]

Core content to cover:
- The Agent tool runs an entity as a local subagent in its own directory, with its own context window, and returns results to the calling agent.
- The invocation is programmatic — not a terminal session, not a background shell process. It is a structured delegation: brief the subagent, it works, results come back.
- The subagent reads its own `CLAUDE.md` and `PRIMER.md` at session start. It knows who it is. The brief supplements that self-knowledge with the specific task.
- What "returns results" means: the Agent tool call receives the entity's output when the work completes. The orchestrator can read that output or, more reliably, verify via git log that the work was committed.
- Contrast with running the entity manually: when koad types `juno` in a terminal, Juno's hook fires and a Claude Code session opens. That session is for koad to observe. When Juno invokes Sibyl via the Agent tool, it is Juno who is orchestrating — Sibyl works and the results come back to Juno, not to koad's terminal.

---

## Atom 1.2: The Three Required Parameters

[STUB — Content to be authored]

Core content to cover:
- `cwd` — the entity's home directory (e.g., `/home/koad/.sibyl/`). This is where the entity operates: where its `CLAUDE.md` lives, where its git commits will land, where it reads and writes files.
- `prompt` — the context brief and task description. This is the orchestrator's message to the entity. Level 2 covers brief authoring in depth; this level establishes that the prompt parameter is the primary interface.
- `run_in_background: true` — the standard mode. Background execution means the orchestrator does not block waiting for the entity to complete. The orchestrator receives a notification when the background task finishes. This is covered in depth at Level 3.
- Optional but important: why `cwd` matters. If `cwd` is wrong, the entity operates in the wrong directory, reads the wrong CLAUDE.md, and commits to the wrong git repo. Always verify the path: `/home/koad/.<entity>/` is the canonical form.
- The invocation shape from VESTA-SPEC-054 §1.2 in full:
  ```
  Agent tool:
    cwd: /home/koad/.<entity>/
    prompt: [entity context brief] + [specific task]
    run_in_background: true
  ```

---

## Atom 1.3: Why Not spawn and Why Not shell hooks

[STUB — Content to be authored]

Core content to cover:
- `juno spawn process <entity>` is designed for observed sessions. It triggers OBS streaming, opens a gnome-terminal window, runs `claude .` in the entity's directory. koad can watch. Results are visible to koad directly — they do not return to Juno programmatically. Using spawn for routine delegation adds overhead, consumes terminal space, and does not return results.
- Shell invocations (`bash hooks/invoked`, `bash hooks/executed-without-arguments.sh`) are the framework's entrypoint for human-facing operation (launching a session). They are not designed for Juno to programmatically delegate and collect a result. The hook fires, a session opens or a non-interactive command runs — neither returns a structured result to an orchestrating caller.
- The Agent tool is the correct abstraction because it has clean semantics: brief → work → result. The calling agent gets the result. The called entity operates in its own context. Neither contaminates the other's session.
- From VESTA-SPEC-054 §1.1: "The Agent tool is the correct abstraction: it maps to the 'delegate a task to a subagent' operation with clean semantics — brief, work, result."

---

## Atom 1.4: Startup Sequence for Orchestrated Entities

[STUB — Content to be authored]

Core content to cover:
- When an entity is invoked via Agent tool, it goes through its startup sequence (VESTA-SPEC-012): verify identity and location, pull latest state, review status, check cross-entity reads.
- This means every Agent tool invocation starts with a `git pull` in the entity's directory. The entity's state is always fresh.
- Practical implication: the orchestrator does not need to run `git pull` on the entity's directory before invoking it via Agent tool. The entity handles its own state sync.
- The entity reads its own `CLAUDE.md` and `PRIMER.md`. The orchestrator's brief arrives after this context is loaded — which is why the brief supplements rather than replaces entity self-knowledge.
- Host constraints apply: before invoking an entity via Agent tool, check VESTA-SPEC-038 (entity host permission table). Some entities have host-specific constraints. Vulcan is the most prominent example — more in Level 5.

---

## Atom 1.5: The Vulcan Exception — A Forward Reference

[STUB — Content to be authored]

Core content to cover:
- Vulcan is never invoked via the Agent tool. He builds on wonderland, paired with Astro. Work for Vulcan goes as a GitHub Issue on `koad/vulcan`.
- Why: Vulcan is the portability exception. The Agent tool invocation pattern (VESTA-SPEC-054 §1.2) assumes the entity is locally accessible — its directory is on the current machine, its git repo is reachable. Vulcan operates on wonderland, not thinker. The Agent tool cannot reach him.
- From VESTA-SPEC-054 §1.3: "See VESTA-SPEC-053 §6 for the full Vulcan exception documentation."
- This is introduced here as a forward reference, not a full treatment. The full treatment is at Level 5 (GitHub Issues vs. Agent tool), where the operator understands both sides of the boundary and can appreciate why the exception exists.
- The operator's working rule right now: if the entity is Vulcan, stop and file a GitHub Issue instead. Level 5 will explain why.

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
