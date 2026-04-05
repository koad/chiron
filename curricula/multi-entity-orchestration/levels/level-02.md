---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 2
slug: the-invocation-brief
title: "The Invocation Brief — Contextualizing a Subagent"
status: authored
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

A complete Agent tool brief has four required components, in this order. VESTA-SPEC-054 §1.2 names all four. Each has a specific job, and missing any one of them degrades the quality of what the entity produces.

**1. Identity line.** Opens with: "You are [Entity], [role] for the koad:io ecosystem." Example: "You are Sibyl, research entity for the koad:io ecosystem." The identity line comes first because the subagent's `CLAUDE.md` and `PRIMER.md` are loaded at session start — but they are loaded before the brief is processed in the agent's live context. The identity line ensures the subagent has role orientation from the very first line of the brief, before reading anything else.

**2. Task.** One to three sentences: what to produce, where to put it, what scope applies. Example: "Research the pre-invocation context assembly pattern from the Vesta spec registry and write a synthesis covering the key insight, invocation shape, and relationship to PRIMER.md. Put the result in `research/icm-synthesis.md`." The task tells the entity what success looks like. Atom 2.3 covers how to write it well.

**3. Cross-entity context** the entity cannot derive from its own repo. If Faber needs to know that Mercury's platform credentials are not yet configured (so Faber should not draft distribution steps), that information is not in Faber's `PRIMER.md`. It belongs in the brief. If there is no such context — all the relevant state is in the entity's own repo — this component can be omitted. It is only required when it is needed.

**4. Completion signal.** What to commit or output when done. Example: "When complete, commit your synthesis to `research/icm-synthesis.md` with the commit message 'research: ICM pattern synthesis'." The completion signal comes last because the entity needs to hold the expected output format in mind throughout the work. A brief without a completion signal produces exploratory output — the entity does excellent work and then has no specification for where to put it or how to mark it done.

> **Verification step:** Look at the invocation brief in Atom 2.5 (the "good brief" example). Point to each of the four components by name. Confirm all four are present and state what each one is doing in that specific brief.

---

## Atom 2.2: What the Entity Already Knows — The PRIMER.md Relationship

Every entity in the koad:io ecosystem reads its own `CLAUDE.md` and `PRIMER.md` at session start. These documents contain the entity's identity, specialization, current project state, git workflow, and awareness of the broader team. By the time the Agent tool's `prompt` parameter arrives, the entity already knows a great deal.

**The brief supplements this self-knowledge — it does not replace it.** The orchestrator does not need to explain who Sibyl is, what her research workflow is, what tools she has access to, or what her commit conventions are. Sibyl's `CLAUDE.md` covers all of this. Including it in the brief wastes context budget and risks contradicting the entity's own startup documentation.

**What to include in the brief:** context that exists outside the entity's own repo. If Faber needs to know that Vulcan just merged a specific commit (`7d95c39`) to the main site, and that information is not in Faber's `PRIMER.md`, the brief must supply it. If Sibyl needs to know that a particular line of research was already completed by a previous session (and that information lives in another entity's logs), the brief must supply it.

**What to omit from the brief:** the entity's own identity, its standard tools, its git workflow, its awareness of the team structure, and any context that is already in its own repo. Run `ls /home/koad/.<entity>/` and `cat /home/koad/.<entity>/PRIMER.md` before writing a brief — this tells you what the entity already has.

**Practical test:** before adding any sentence to a brief, ask "would this entity know this by reading its own startup documents?" If yes, omit it. If no, include it.

Over-briefing — including content the entity already has — is not catastrophic, but it wastes context window budget and can introduce confusion if the brief's version of a fact differs from the entity's own `PRIMER.md`. When in doubt, leave it out: the entity's self-knowledge is reliable.

> **Verification step:** Run `cat /home/koad/.faber/PRIMER.md` (or open it with Read). List three facts about Faber that are already there. These are facts you do not need to include in any brief you write for Faber.

---

## Atom 2.3: Writing the Task — One to Three Sentences

The task component of the brief is the orchestrator's most important writing job. It tells the entity what to produce, where to put it, and what constraints apply. It does not tell the entity how to do the work.

**Target length: one to three sentences.** This is not an arbitrary style preference — it is a smell detector. A task description longer than three sentences usually means one of two things: the orchestrator is over-specifying (directing the entity's process, not its outcome), or the orchestrator is combining multiple tasks into one brief (which should be two separate invocations with two separate notifications).

**What a good task description includes:**
- What to produce: a synthesis, a draft, a review comment, a list of blockers
- Where to put it: a specific file path in the entity's repo
- Scope or constraints: topic limits, audience, length, tone, what to exclude

**What a good task description omits:** how to produce it. The entity has judgment. Sibyl knows how to do research; you do not need to tell her which files to read first. Faber knows how to draft content; you do not need to specify the outline structure. If you tell the entity how to do its job, you have removed the benefit of delegation — you might as well do it yourself.

Three examples at different quality levels:

| Quality | Example |
|---------|---------|
| Good | "Research the pre-invocation context assembly pattern (ICM) from the Vesta spec registry. Write a synthesis covering the key insight, invocation shape, and relationship to PRIMER.md. Put the result in `research/icm-synthesis.md`." |
| Too vague | "Research ICM." — No deliverable, no scope, no output location. |
| Over-specified | "Research ICM. First read VESTA-SPEC-054. Then read related specs. Then write five bullet points covering definition, rationale, mechanism, example, and limitations." — You are directing Sibyl's process, not her outcome. |

**When a task is too large for three sentences:** it is probably two tasks. Split into two invocations with two completion signals. Each invocation returns a notification. The orchestrator observes the first result before launching the second — which is the correct sequential pattern.

> **Verification step:** Write a task description (one to three sentences) for this goal: have Veritas review Faber's latest committed draft and identify any factual claims that need citation. Check your task description contains: what to produce, where to put the review, and what scope applies. Confirm it does not specify how Veritas should do the review.

---

## Atom 2.4: The Completion Signal — What to Commit

The completion signal is the last component of the brief and the one most often missing from insufficient briefs. It tells the entity what to do when its work is done: commit a specific file to a specific path with a specific commit message prefix.

**Why it is required:** without a completion signal, the entity may produce excellent work and then not commit it — or commit it to a path the orchestrator did not expect. The git log verification check (Level 4) verifies against what the completion signal specified. If the orchestrator does not know what to look for in git log, they cannot confirm the work is done.

**Standard form:**
```
When complete, commit your result to `research/icm-synthesis.md` with the commit message 'research: ICM pattern synthesis'.
```

**More specific form with a prefix constraint:**
```
Commit `content/day-07-brief.md` with a commit message starting with 'content:' so it is distinguishable in git log.
```

The prefix constraint lets the orchestrator use a quick `git log --oneline | grep "^content:"` to find the commit without scanning the full log.

**What happens without a completion signal:** the entity exercises its own judgment about what to commit and where. Entities have their own commit hygiene — Sibyl knows to commit research files, Faber knows to commit content drafts. But the orchestrator cannot predict the exact path or message. If the orchestrator checks `git log` for `research/icm.md` and Sibyl committed `research/icm-synthesis.md` instead, the check fails — not because the work was not done, but because the orchestrator did not specify the expected path.

**The completion signal as a quality gate:** an entity that has committed its result has decided the work is complete and it stands behind the output. A commit is not a draft — it is a declaration. The completion signal makes this gate explicit.

> **Verification step:** Write a completion signal for this task: have Faber produce a Day 8 content brief. Include a specific file path, a commit message, and a prefix that will make it easy to find in git log. The signal should be one to two sentences.

---

## Atom 2.5: Reading a Brief — Two Examples (Good and Insufficient)

The fastest way to internalize brief quality is to read two examples side by side and diagnose the difference. Both are for the same task: Faber drafts the Day 7 content brief.

**Good brief:**

```
You are Faber, content strategist for the koad:io ecosystem.

Draft the Day 7 content brief for the "Reality Pillar" series. The theme is
the $200 laptop experiment — seven days of operation on commodity hardware
proving that sovereignty does not require expensive infrastructure. The audience
is technical operators who have followed Day 1–6 posts. Target length: 600–800
words. Tone: grounded, specific, not triumphalist.

Note: Mercury's platform credentials are not yet configured — do not include
distribution steps in this draft. Faber owns production; Mercury handles
distribution when credentials are live.

When complete, commit your draft to `content/day-07-brief.md` with the commit
message 'content: Day 7 brief — $200 laptop experiment'.
```

Component audit:
- **Identity line:** "You are Faber, content strategist for the koad:io ecosystem." — present
- **Task:** series name, theme, audience, length, tone — specific and constrained to Faber's judgment on how to write it
- **Cross-entity context:** Mercury's credential status — not in Faber's repo; must come from the orchestrator
- **Completion signal:** specific path (`content/day-07-brief.md`), specific commit message with a greppable prefix — present

**Insufficient brief:**

```
Write the Day 7 content brief.
```

Component audit:
- **Identity line:** absent — Faber will use her startup self-knowledge, but the brief does not orient her
- **Task:** no series name, no theme, no audience, no length, no tone — Faber will make choices the orchestrator cannot predict
- **Cross-entity context:** absent — Faber does not know Mercury's credential status; she may draft distribution steps that cannot be executed
- **Completion signal:** absent — Faber will commit to whatever path she judges appropriate; the orchestrator has no way to verify via git log

The entity will do *something* when given the insufficient brief. It may even be good. But the orchestrator cannot predict the path, cannot verify the commit, and does not know whether Faber accounted for the Mercury constraint. The brief is the orchestrator's control surface — an insufficient brief cedes that control.

> **Verification step:** Take the insufficient brief above and rewrite it into a complete four-component brief. Check your version against the component audit: identity line, task with scope and constraints, cross-entity context (is any needed?), completion signal with path and commit message.

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
