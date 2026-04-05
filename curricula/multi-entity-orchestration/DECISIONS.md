---
type: curriculum-decisions
curriculum_slug: multi-entity-orchestration
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Pedagogical Decisions — multi-entity-orchestration

This document records the reasoning behind significant choices in how this curriculum is structured. It is an internal design document for Chiron and Alice — not learner-facing content.

---

## Decision 1: Lead with the mental model, not the mechanics

**Decision:** Level 0 teaches the launch-observe-decide loop as a mental model before any tool mechanics are introduced. The Agent tool is not mentioned until Level 1.

**Alternatives considered:**
- Start with the Agent tool (the primary mechanic) and derive the mental model from how it works
- Combine the mental model with the Agent tool introduction in a single Level 0

**Reasoning:**

Operators arriving at this curriculum have completed the Builder Path. They know how to spawn an entity. The temptation is to immediately teach them the Agent tool — the new mechanic they do not yet have. But the most common failure mode in multi-entity orchestration is not ignorance of the Agent tool; it is the wrong mental model. Operators who treat orchestration as a pipeline — pre-scripting chains of entity invocations before any work has happened — will make the same mistakes regardless of which tool they use.

Level 0's job is to install the judgment loop before any mechanics arrive. "Launch, observe, decide" is the organizing principle. Every subsequent level teaches a mechanic that serves this loop. Without the loop framing, operators learn tools in isolation and chain them incorrectly.

The risk of this approach: Level 0 may feel abstract to operators who want to "start doing something." The level mitigates this by using concrete examples from Juno's actual team workflow — real entities, real tasks, real decision points — rather than hypothetical scenarios.

---

## Decision 2: The invocation brief gets its own level (Level 2)

**Decision:** Level 2 is dedicated entirely to the anatomy and authoring of the context brief passed to a subagent entity.

**Alternatives considered:**
- Include brief authoring as a section within Level 1 (the Agent tool level)
- Defer brief authoring to Level 3 (parallel execution), where the operator writes actual invocations

**Reasoning:**

The invocation brief is the primary interface between the orchestrating entity and the subagent. An operator who understands the Agent tool mechanically but cannot write a good brief will get partial results, missed completion signals, and entities that duplicate context that was already in their PRIMER.md.

The brief has four required components (identity line, task, cross-entity context, completion signal) and the PRIMER.md/brief relationship (the brief supplements, not replaces, the entity's own context). These components and their relationship warrant a dedicated level because:

1. The "supplements, not replaces" principle requires knowing what the entity already has — which requires understanding PRIMER.md and CLAUDE.md. Operators need explicit instruction on this before they write their first brief.
2. The four components have non-obvious ordering. The identity line comes first not because it is most important, but because it orients the subagent before it reads its own context. The completion signal comes last because it specifies the output format, which the subagent needs to hold in mind while doing the work.
3. Brief quality is the single highest-leverage variable in orchestration outcomes. A mechanical understanding of the Agent tool is useless with a bad brief.

---

## Decision 3: Parallel execution before sequential

**Decision:** Level 3 teaches parallel execution (`run_in_background: true`, multiple Agent calls in one message) before teaching rate pacing for sequential chains (also covered in Level 3, §2).

**Alternatives considered:**
- Teach sequential first as the "simpler" case, then generalize to parallel
- Treat parallel and sequential as separate topics in separate levels

**Reasoning:**

VESTA-SPEC-054 §2.1 states that background-first is the default mode. Sequential blocking invocations are the exception, not the rule. Teaching sequential first would install the wrong default: operators would default to "launch one, wait, launch next" and think of parallel as the advanced case.

By teaching parallel first, the curriculum installs the correct default: entities doing independent work run simultaneously. Sequential is then introduced as the special case — "when one entity's output is another's input, you must sequence them, and here is how to pace that."

Rate pacing (the 60-second sleep between sequential calls) is covered in Level 3 rather than in its own level because it is a single rule with a single rationale. It does not need the space a full level provides. Pairing it with parallel execution allows the contrast: parallel invocations launched in the same message do not need pacing; sequential chains that depend on prior output do.

---

## Decision 4: Git log as verification is taught before GitHub Issues

**Decision:** Level 4 (git log verification) precedes Level 5 (GitHub Issues vs. Agent tool).

**Alternatives considered:**
- Teach GitHub Issues before verification (since Issues are the "communication" mechanism — more visible to operators)
- Combine git log verification with Level 3 (parallel execution)

**Reasoning:**

Git log verification is the completion check for every Agent tool invocation. The Level 5 content — deciding when to use the Agent tool vs. GitHub Issues — depends on understanding what "completion" looks like for an Agent tool invocation. If the operator has not yet learned that git log is the verification primitive, the Level 5 discussion of "when Agent tool is done" is abstract.

By placing git log at Level 4 and GitHub Issues at Level 5, the curriculum builds the decision rule on a concrete foundation: the operator knows that Agent tool completion = new git commits, so they can correctly evaluate "will this task produce commits in this session?" as the distinguishing question.

Git log is also simpler to teach than the GitHub Issues decision framework. Following the pedagogy established in commands-and-hooks (simpler mechanics before complex judgment), Level 4 delivers the verifiable fact (commits happened or did not) before Level 5 delivers the judgment framework (use Agent tool or Issues?).

---

## Decision 5: Anti-patterns level (Level 6) is the synthesis, not an appendix

**Decision:** The anti-patterns and judgment loop content occupies the final level (Level 6) and serves as the curriculum's synthesis level, equivalent to Level 7 in commands-and-hooks.

**Alternatives considered:**
- Distribute anti-pattern callouts throughout earlier levels (e.g., "don't do X" notes in each mechanic level)
- Make Level 6 a hands-on exercise level (have the operator orchestrate all three entities simultaneously) with anti-patterns embedded

**Reasoning:**

Anti-patterns are most useful after the operator has the complete mechanical picture. An operator who has not yet learned git log verification cannot appreciate "parsing agent output for structured data" as an anti-pattern — they do not yet know the correct alternative. An operator who has not learned GitHub Issues cannot appreciate "spawning observed sessions for routine delegation" as a mistake — they do not know what the correct mechanism is.

Level 6 can only succeed as a synthesis because it assumes all prior levels. The five anti-patterns from VESTA-SPEC-054 §9 each have a correct alternative that was taught in Levels 1–5. Level 6 names the anti-pattern, points to the correct alternative, and explains the judgment that leads an operator to the right choice.

The hands-on exercise embedded in Level 6 — the "full team orchestration" exercise where the operator coordinates three entities simultaneously — is the integration moment. It is not an assessment of mechanical skill (that was covered in Levels 3 and 4) but of judgment: can the operator decide, in real time, which entity to launch next based on what has already completed?

---

## Decision 6: The Vulcan exception is taught at Level 5, not Level 1

**Decision:** The Vulcan exception (Vulcan is never invoked via the Agent tool; work goes as a GitHub Issue on koad/vulcan) is covered at Level 5 (GitHub Issues vs. Agent tool), not at Level 1 (the Agent tool introduction).

**Alternatives considered:**
- Cover the Vulcan exception at Level 1 as an immediate caveat to the Agent tool introduction
- Cover the Vulcan exception at Level 6 as part of anti-patterns

**Reasoning:**

Mentioning the Vulcan exception at Level 1 creates an asymmetry before the operator understands either side of it: "here is the Agent tool, but by the way, never use it for Vulcan." The operator does not yet know what GitHub Issues delegation looks like, so the exception is incomprehensible — they cannot understand why the exception exists or what the alternative is.

At Level 5, the operator knows both sides: Agent tool delegation and GitHub Issues. The Vulcan exception is then the clearest possible example of the "always Issues, never Agent tool" end of the decision spectrum. It sharpens the general rule because its rationale is specific and vivid: Vulcan builds on wonderland, paired with Astro; he does not operate on thinker; the Agent tool invocation pattern assumes portability (VESTA-SPEC-053), and Vulcan is the portability exception.

Level 1 introduces the Agent tool as the standard mechanism and notes that "exceptions exist — Level 5 covers them." This deferred forward reference keeps Level 1 clean without hiding the existence of exceptions.

---

## What This Curriculum Defers

**Entity team workflow end-to-end:** The full Juno → Vulcan → Veritas → Muse → Mercury → Sibyl → Juno loop involves entities not yet gestated (Veritas, Muse, Mercury, Sibyl). This curriculum teaches the orchestration pattern using whichever entities are available. A future `content-pipeline-operations` curriculum will walk the full content generation and distribution loop when the team is fully operational.

**Daemon worker system as orchestration replacement:** VESTA-SPEC-020 Section 8 documents that the daemon worker system will eventually replace ad-hoc Agent tool orchestration for recurring work. This curriculum teaches the Agent tool pattern, which is canonical for current practice. A curriculum update will be needed when the daemon migration occurs.

**Cross-machine entity invocation:** Some entities run on specific machines (Vulcan/wonderland, entities on fourty4). The Agent tool invocation pattern in this curriculum assumes the entity is local. Remote invocation patterns — SSH-based delegation, GitClaw event watching — are not covered here and belong in a future `infrastructure-operations` curriculum.

**Keybase notification as orchestration output:** Reporting results to koad via Keybase (`ssh juno@dotsh 'keybase chat send koad "..."'`) is a post-orchestration step referenced in VESTA-SPEC-054 §4.3. It is mentioned at Level 6 as a "decide" outcome but not taught as a dedicated level. Operators who need the Keybase notification pattern can reference `reference_notify_koad.md` in Juno's memory.
