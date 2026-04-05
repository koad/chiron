---
type: curriculum-bubble
id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
slug: multi-entity-orchestration
title: "Multi-Entity Orchestration — Running the Team"
description: "After completing all 7 levels, the operator can invoke a koad:io entity as a local subagent using the Agent tool, run multiple entities in parallel using run_in_background, verify entity work via git log, apply the launch-observe-decide judgment loop, distinguish Agent tool delegation from GitHub Issues, identify and avoid the Vulcan exception and other orchestration anti-patterns, and pace chained sequential invocations at the correct rate."
version: 0.1.0
status: scaffold — 7 levels stubbed, atoms are placeholders

authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
owned_by: kingofalldata.com
signature: (pending — signed by Chiron on first authoring commit)

prerequisites:
  - commands-and-hooks

audience: "Operators who have completed the full Builder Path (alice-onboarding → entity-operations → advanced-trust-bonds → entity-gestation → commands-and-hooks) and can gestate, configure, command, and hook a single entity. They understand the two-layer architecture, the hook invocation contract, trust bonds, and the cascade environment. They have operated Juno in isolation but have not coordinated multiple entities simultaneously. This curriculum teaches them to orchestrate a team of sovereign entities — delegating tasks, reading distributed output, and making judgment-driven decisions about what happens next."
estimated_hours: 3.0

level_count: 7
atom_count_total: 35
atom_count_confirmed: 0

is_shared: true
shared_with: ["*"]
license: cc-by

commissioned_by: (Chiron, self-directed — Orchestrator Path step 1/1, establishes the Orchestrator Path)
---

# Curriculum: Multi-Entity Orchestration — Running the Team

## Overview

A single entity is a capable agent. A team of entities is an autonomous organization. The difference between running one entity and running a team is not just scale — it is a different mental model. Single-entity operation is sequential: spawn, task, read, commit. Multi-entity orchestration is a judgment loop: launch, observe, decide.

This curriculum covers how to coordinate multiple koad:io entities in practice. It teaches the Agent tool as the standard invocation mechanism, background execution as the default mode, git log as the verification primitive, and GitHub Issues as the persistent inter-entity communication channel. It teaches when not to use the Agent tool, what the Vulcan exception is and why it exists, how to pace chained sequential invocations, and how to distinguish the two modes of entity operation — coordinated and observed.

The central claim of this curriculum is: **orchestration is a judgment loop, not a pipeline.** Entities are not stages in a data-processing chain. They are collaborators whose outputs inform decisions. Every anti-pattern in multi-entity orchestration comes from forgetting this: pre-scripted chains, blocking sequential calls where parallel would do, parsing agent output for structured data, spawning observed sessions for routine delegation. This curriculum teaches the correct patterns and names the anti-patterns explicitly.

Operators who complete this curriculum can coordinate any subset of the koad:io team, delegate tasks with proper context briefs, verify that work was done, and make the next decision based on what actually happened — not what they expected to happen.

## Entry Prerequisites

The learner has completed `commands-and-hooks` (the full Builder Path) and can:
- Gestate a new entity from scratch
- Author a command and hook in a live entity directory
- Explain the hook invocation contract and the PID lock pattern
- Navigate the cascade environment and read `.env` configuration
- Spawn a single entity session and observe its output
- Use GitHub Issues for inter-entity communication

The learner cannot yet:
- Invoke an entity as a local subagent via the Agent tool
- Run multiple entity invocations in parallel
- Verify entity work via git log rather than parsed output
- Apply the launch-observe-decide judgment loop
- Distinguish session-scoped Agent tool delegation from persistent GitHub Issue assignments
- State the Vulcan exception and its rationale

## Completion Statement

After completing all 7 levels, the operator will be able to:
- Explain the Agent tool as the standard mechanism for programmatic entity invocation
- Describe the standard invocation shape: identity brief, task, cross-entity context, completion signal
- Run multiple entity invocations in parallel in a single message with `run_in_background: true`
- Verify that entity work completed using `git -C /home/koad/.<entity>/ log --oneline -5`
- Read entity output efficiently using `tail -20` or `--output-format=json .result` rather than full output
- Apply the launch-observe-decide loop rather than pre-scripting invocation chains
- Pace sequential chained entity calls with a 60-second sleep between them
- State the Vulcan exception: Vulcan is never invoked via Agent tool; work goes as a GitHub Issue on koad/vulcan
- Distinguish Agent tool delegation (session-scoped) from GitHub Issues (persistent, multi-session)
- Apply the judgment test: "does this require the entity's judgment, or just its files?"
- Identify and name all five orchestration anti-patterns from VESTA-SPEC-054 §9

---

## Level Summary

| # | Title | Atoms (est.) | Minutes (est.) |
|---|-------|--------------|----------------|
| 0 | The Orchestration Mental Model — Launch, Observe, Decide | 5 | 25 |
| 1 | The Agent Tool — Standard Entity Invocation | 5 | 25 |
| 2 | The Invocation Brief — Contextualizing a Subagent | 5 | 25 |
| 3 | Background Execution and Parallel Delegation | 5 | 25 |
| 4 | Output Verification — Git Log as Ground Truth | 5 | 25 |
| 5 | GitHub Issues vs. Agent Tool — Scope Boundaries | 5 | 25 |
| 6 | Anti-Patterns and the Judgment Loop | 5 | 30 |

Full level content lives in `levels/`. See VESTA-SPEC-025 for the loading contract and progressive disclosure rules.

---

## Exit Criteria

The operator can:
1. Invoke any non-Vulcan entity as a subagent using the Agent tool with the correct invocation shape
2. Launch three entities in parallel in a single message and wait for their notifications
3. Verify each entity's work using `git -C` log before deciding what to do next
4. State the decision rule for Agent tool vs. GitHub Issue: if the work will be done in this session, use the Agent tool; if it spans sessions or involves Vulcan, use an Issue
5. Apply the judgment test to any proposed Agent tool invocation: "does this require judgment, or just files?"
6. Name all five anti-patterns from VESTA-SPEC-054 §9 and state why each is incorrect

---

## Design Rationale

### Why `commands-and-hooks` Is the Prerequisite (Full Builder Path Required)

The prerequisite graph in CURRICULUM-ROADMAP.md shows `multi-entity-orchestration` branching off `entity-operations` — at the same level as `entity-gestation`. However, this curriculum is designated as Orchestrator Path step 1, which follows the Builder Path. This is intentional:

An operator who orchestrates entities without understanding how those entities are built — their hooks, their invocation contracts, their cascade environment — cannot write effective invocation briefs. The brief must include a completion signal ("commit your result to `research/icm.md`"). An operator who does not know how commits work in entity directories cannot write that brief correctly. The commands-and-hooks prerequisite ensures operators understand what they are delegating before they delegate it.

The `multi-entity-orchestration` curriculum could, technically, be taken after `entity-operations` alone for operators who are only operating, not building. The Orchestrator Path designation reflects the intended audience: builders who want to also run the team.

### Why 7 Levels Instead of 6

The gap analysis estimated 6 levels and 30 atoms. This spec expands to 7 levels and 35 atoms. The addition is Level 2: The Invocation Brief. Context-brief authoring is the most common failure point in Agent tool delegation. An operator who understands the Agent tool mechanically but writes an insufficient brief will get an entity that does partial work, commits to the wrong path, or produces output that does not answer the question Juno was asking. A dedicated level on what goes into a brief — and what can be omitted because the entity already has it in its own PRIMER.md — prevents the most common orchestration failure mode.

### Why Orchestration Anti-Patterns Get Their Own Level

Level 6 is dedicated to anti-patterns and the judgment loop. This is unusual — most curricula put anti-patterns as a section within the relevant level. Here they get a dedicated level because:

1. The anti-patterns are specific, named, and have all been observed in production. They are not hypothetical failure modes — they are documented errors from real orchestration sessions.
2. The judgment loop (launch, observe, decide) is the positive framing of the same principle. Understanding why anti-patterns are wrong requires understanding what the correct loop looks like in practice.
3. Operators who reach Level 6 have all the mechanical skills. Level 6's job is to install the judgment layer that prevents mechanical competence from producing pre-scripted chain failures.

### Why GitHub Issues vs. Agent Tool Is a Full Level

The Agent tool and GitHub Issues solve different problems. The distinction is not obvious: both are ways to "assign work" to an entity. Operators who do not understand the scope boundary will use GitHub Issues for session-scoped work (creating orphaned issues for tasks that were done and verified in one session) or will use the Agent tool for work that needs an audit trail or spans multiple sessions (creating ephemeral delegations with no persistent record).

Level 5 teaches the scope boundary through the decision rule (§7.3 of VESTA-SPEC-054) and works through five concrete examples: two that are clearly Agent tool, two that are clearly GitHub Issues, and one that requires judgment. The Vulcan exception is covered here because it is the clearest case of "always GitHub Issues, never Agent tool" — understanding the exception sharpens the general rule.

---

## Specs Covered

| Spec | Coverage |
|------|---------|
| VESTA-SPEC-054 | Multi-entity orchestration protocol — Agent tool invocation, run_in_background, git log verification, judgment loop, GitHub Issues boundary, rate pacing, anti-patterns — fully covered across all 7 levels |
| VESTA-SPEC-053 | Entity portability contract — referenced at Level 1 (entities being orchestrated must be portable; the Agent tool invocation pattern assumes portability) |
| VESTA-SPEC-051 | PRIMER convention — referenced at Level 2 (the context brief supplements, not replaces, the entity's own PRIMER.md) |
| VESTA-SPEC-020 | Hook architecture — referenced at Level 1 (the Agent tool's prompt is the `-p` argument to the invocation contract) |
| VESTA-SPEC-012 | Entity startup sequence — referenced at Level 1 (orchestrated entities go through this sequence at the start of each Agent tool session) |
| VESTA-SPEC-038 | Entity host permission table — referenced at Level 1 and Level 5 (host constraints override Agent tool invocability; Vulcan/wonderland exception documented here) |

---

## Curriculum Changelog

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-04-05 | Initial scaffolding by Chiron. 7 levels, 35 atoms estimated. Orchestrator Path step 1. |

---

## References

- Prerequisite: commands-and-hooks v1.0.0+ (full Builder Path required)
- Canonical spec: VESTA-SPEC-054 (Multi-Entity Orchestration Protocol)
- Delivered by: Alice (kingofalldata.com)
- Progression system: Vulcan — see koad/vulcan for implementation
- Format authority: Vesta (VESTA-SPEC-025)
- Orchestrator Path position: Step 1 of 1 (establishes the Orchestrator Path)

---

**Signature:**
```
(Pending — Chiron to sign with ed25519 key on first delivery)
```
Signed by: chiron@kingofalldata.com
