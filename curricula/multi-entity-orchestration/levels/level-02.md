---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 2
slug: the-invocation-brief
title: "The Invocation Brief — Contextualizing a Subagent"
status: scaffold
prerequisites:
  curriculum_complete:
    - commands-and-hooks
  level_complete:
    - multi-entity-orchestration/level-01
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 2: The Invocation Brief — Contextualizing a Subagent

## Learning Objective

After completing this level, the operator will be able to:
> Author a complete Agent tool brief containing all four required components, explain what the subagent entity already knows from its own PRIMER.md (and therefore does not need in the brief), identify briefs that are missing components, and write a completion signal that produces a verifiable output.

**Why this matters:** The brief is the primary interface between the orchestrating entity and the subagent. A brief with missing components produces partial work. A brief that duplicates what the entity already knows wastes context budget. A brief with a vague or missing completion signal produces work the orchestrator cannot verify. Brief quality is the single highest-leverage variable in orchestration outcomes — more than any tool mechanic.

---

## Knowledge Atoms

## Atom 2.1: The Four Required Components

[STUB — Content to be authored]

Core content to cover:
- From VESTA-SPEC-054 §1.2, the brief must include:
  1. **Identity line** — "You are [Entity], [role description] for the koad:io ecosystem." Example: "You are Sibyl, research entity for the koad:io ecosystem."
  2. **Task** — one to three sentences describing the specific work. What to produce, where to put it, what scope to cover.
  3. **Relevant cross-entity context** the entity cannot derive from its own repo (if any). For example: if Faber needs to know that Mercury's platform credentials are not yet configured, that information is not in Faber's repo. The brief supplies it.
  4. **Completion signal** — what to commit or output when done. Example: "When complete, commit your synthesis to `research/icm.md` with the message 'research: ICM pattern synthesis'."
- Why the identity line comes first: it orients the subagent before it reads its own context. The subagent's startup sequence reads CLAUDE.md and PRIMER.md — but it reads those after the prompt arrives. The identity line ensures the subagent knows its role from the very first line of the brief.
- Why the completion signal comes last: the subagent needs to hold the output format in mind while doing the work. A brief that describes a task but does not say what the deliverable looks like produces exploratory work rather than committed output.

---

## Atom 2.2: What the Entity Already Knows — The PRIMER.md Relationship

[STUB — Content to be authored]

Core content to cover:
- Every entity reads its own `CLAUDE.md` and `PRIMER.md` at session start. These documents contain the entity's identity, current state, capabilities, and relevant context.
- The brief supplements, not replaces, this context. The orchestrator does not need to explain who the entity is, what its tools are, or what its git workflow is — the entity's own startup documents cover this.
- What to include in the brief: context that is not in the entity's repo. If the entity's task requires knowledge of another entity's current state (e.g., "Vulcan just committed these three files — review them"), that context belongs in the brief.
- What to omit from the brief: the entity's own identity, tool access, standard workflow, and anything that is already in its PRIMER.md or CLAUDE.md.
- Practical test: before adding a sentence to a brief, ask "would the entity know this by reading its own startup documents?" If yes, omit it. If no, include it.
- Over-briefing (including content the entity already has) is not dangerous but it wastes context budget and can confuse the entity by contradicting its own self-knowledge.

---

## Atom 2.3: Writing the Task — One to Three Sentences

[STUB — Content to be authored]

Core content to cover:
- The task description should be one to three sentences. Longer is not better — a long task description suggests the operator is either over-specifying (telling the entity how to do its job) or combining multiple tasks into one brief (which should be two separate invocations).
- What a good task description contains: what to produce, where to put it, and what scope or constraints apply.
- What a good task description omits: how to produce it. The entity has judgment. If you tell it how, you are removing the benefit of delegation.
- Examples:
  - Good: "Research the pre-invocation context assembly pattern (ICM) from the Vesta spec registry. Write a synthesis covering the key insight, the invocation shape, and the relationship to PRIMER.md. Put your result in `research/icm-synthesis.md`."
  - Too vague: "Research ICM." (No deliverable, no scope, no location.)
  - Over-specified: "Research ICM. First, read VESTA-SPEC-054. Then read related specs. Then write a summary with five bullet points, organized as: definition, rationale, mechanism, example, limitations." (You are telling Sibyl how to be Sibyl.)
- When a task feels too long to summarize in three sentences, it is probably two tasks. Split the brief into two invocations.

---

## Atom 2.4: The Completion Signal — What to Commit

[STUB — Content to be authored]

Core content to cover:
- The completion signal tells the entity what to do when its work is done: commit a specific file, write to a specific path, produce a specific output format.
- Why it is required: without a completion signal, the entity may do excellent work and then... not commit it. Or commit it to a surprising path. The git log check (Level 4) verifies against the completion signal — if the expected commit is not there, the work is not done.
- Standard form: "When complete, commit your result to `<path>` with the message `<commit message>`."
- More specific form: "Commit `<filename>` with the prefix 'research:' in the commit message so it is distinguishable in git log."
- What happens without a completion signal: the entity operates in its own judgment about what to commit. This is not always wrong — entities have their own commit hygiene. But the orchestrator cannot reliably verify completion via git log without knowing what to look for.
- The completion signal is also a quality gate. An entity that has committed its result has decided the work is done. A committed file is a signal from the entity that it stands behind the output.

---

## Atom 2.5: Reading a Brief — Two Examples (Good and Insufficient)

[STUB — Content to be authored]

Core content to cover:
- Walk through two complete brief examples side by side.
- **Good brief (Faber, content draft task):**
  ```
  You are Faber, content strategist for the koad:io ecosystem.
  
  Draft the Day 7 content brief for the "Reality Pillar" series. The theme is
  the $200 laptop experiment — seven days of operation on commodity hardware
  proving that sovereignty doesn't require expensive infrastructure. The audience
  is technical operators who have followed Day 1–6 posts. Target length: 600–800
  words. Tone: grounded, specific, not triumphalist.
  
  Note: Mercury's platform credentials are not yet configured — do not include
  distribution steps in this draft. Faber owns production; Mercury handles
  distribution when credentials are live.
  
  When complete, commit your draft to `content/day-07-brief.md` with the commit
  message 'content: Day 7 brief — $200 laptop experiment'.
  ```
  - Identity line: present
  - Task: clear scope, deliverable format, length, tone
  - Cross-entity context: Mercury credential status (not in Faber's repo)
  - Completion signal: specific path, specific commit message

- **Insufficient brief:**
  ```
  Write the Day 7 content brief.
  ```
  - No identity line. No scope. No length or tone. No cross-entity context. No completion signal.
  - The entity will do something. It may be good. But the orchestrator cannot predict the path, verify the commit, or know what the entity did with the Mercury constraint.

- Have the operator evaluate the insufficient brief component by component and state what is missing from each.

---

## Exit Criterion

The operator can:
- Name the four required brief components and state the purpose of each
- Identify a brief missing any component and name what is missing
- Explain what the entity already knows from its own PRIMER.md (and does not need in the brief)
- Write a completion signal for a given task that produces a verifiable git commit

**Verification question:** "You are writing a brief for Sibyl to research the content pipeline. You include: identity line, task description, and completion signal. What is potentially missing?"

Expected answer: Cross-entity context — if there is any context relevant to the task that Sibyl cannot derive from her own repo (e.g., what Mercury's current state is, what topics have already been researched), that belongs in the brief. If there is no such context needed, all four components are present.

---

## Assessment

**Question:** "Why is 'When done, let me know' an insufficient completion signal?"

**Acceptable answers:**
- "It does not specify what to commit or where. The orchestrator cannot verify work via git log without knowing what to look for — there is no specific file path or commit message prefix to check."
- "A completion signal must specify the deliverable: the file path and commit message. 'Let me know' produces output to the conversation, not a committed verifiable artifact."

**Red flag answers:**
- "It's fine — the entity will commit something" — the orchestrator needs to know what to verify, not just that something will happen

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

Brief authoring is a craft, not a formula. The four components are necessary but not sufficient — a brief with all four components can still be poorly written. The two-example exercise in Atom 2.5 is the most important part of this level: reading a good brief and an insufficient brief side by side makes the difference visceral.

Emphasize the PRIMER.md relationship. Operators who have just completed commands-and-hooks understand that entities have self-knowledge. The brief is not an orientation document — the entity already knows who it is. The brief is an assignment, not an introduction.

The "one to three sentences" rule for the task is a useful heuristic but should be explained as a smell detector, not a hard limit. If the operator cannot describe the task in three sentences, the task is probably too large for one invocation.

The completion signal is where most operators make mistakes in practice. A brief that says "research X and write up your findings" produces work. A brief that says "commit your synthesis to `research/x.md` with the prefix 'research:'" produces verifiable work. The difference matters at Level 4 when the operator tries to confirm via git log.

---

### Bridge to Level 3

You can write a complete brief. Level 3 teaches the execution mode: how to run multiple entities in parallel, why background execution is the standard, and how rate pacing works for the sequential case.
