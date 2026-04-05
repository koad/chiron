---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 3
slug: writing-a-good-task-prompt
title: "Writing a Good Task Prompt"
status: locked
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-02
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 3: Writing a Good Task Prompt

## Learning Objective

After completing this level, the operator will be able to:
> Write a task prompt for a real entity that includes: what to do, where to put the output, what done looks like, and any relevant constraints — and explain why each element is necessary.

**Why this matters:** The session starts correctly but the prompt is where the task succeeds or fails. An entity with a vague prompt will do something — it will not stop and say "I need more information." It will extrapolate, make assumptions, produce output that looks like progress but diverges from what you needed. A well-formed prompt is not a longer prompt. It is a complete prompt: four elements, clearly stated, no assumptions left for the entity to fill.

---

## Knowledge Atoms

### Atom 3.1: What the Entity Knows at Session Start

**Teaches:** What context the entity has when a session begins — CLAUDE.md, memories/, and the prompt — and nothing else from prior conversations.

When an entity session starts, the entity reads:

1. **`CLAUDE.md`** in the entity directory — identity, team role, current priorities, operational preferences. This is the entity's standing context. It was written before the session and persists across sessions.

2. **`memories/`** directory — files committed from prior sessions: operational notes, ongoing state, decisions already made. If memory files were updated and committed, this session knows about them. If they were not committed — if a prior session generated findings but never committed — this session does not know they exist.

3. **The prompt you provide** — the specific task for this session.

That is the complete context. Not the last conversation you had with this entity. Not anything you said to it yesterday. Not the task you assigned three sessions ago. Entities have committed memory, not conversational memory. The prior session's output is part of the entity's context only if it was written to disk and committed.

This has a direct implication for prompt writing: you cannot assume the entity knows what you were thinking about when you wrote the prompt. You cannot assume it remembers the context from a prior interactive session unless that context was committed to memory files. Write the prompt as if the entity is reading it cold — because it is.

---

### Atom 3.2: The Four-Element Task Anatomy

**Teaches:** The four components every executable task prompt needs: task, output location, done criterion, constraints.

A complete task prompt has four elements:

**1. Task** — What to do. Specific and bounded. Not "research things" but "research the three most recent GitHub issues on koad/vulcan and summarize what each is asking for."

**2. Output location** — Where to put the result. A specific file path. Not "save it somewhere" but "write findings to `~/.entityname/research/github-issues-summary.md`." If there is no output location, the entity may write output only to the session log, which evaporates when the session ends.

**3. Done criterion** — What does completion look like? The entity should know when it has finished. "When done, commit and push the file" gives the entity a clear terminal state. "Write a summary of each issue in 3-5 sentences" tells it how much work is enough. Without a done criterion, the entity may over-research, under-deliver, or loop indefinitely.

**4. Constraints** — Anything the entity must not do, must stay within, or must prioritize. "Do not modify any files outside `~/.entityname/research/`." "If the GitHub API is unavailable, write what you can from the local repo." "Complete this in a single session — do not wait for external dependencies." Constraints are not about distrusting the entity — they are about preventing the entity from making a reasonable decision that happens to be wrong for your situation.

Write all four. If one is missing, ask yourself why and add it.

---

### Atom 3.3: Orientation vs. Task — When to Provide Background

**Teaches:** The difference between context-setting (orientation) and the task itself, when each is necessary, and how to distinguish background the entity already has from background it needs.

A task prompt is not a briefing from scratch. The entity has `CLAUDE.md`. It has memory files. It knows its role, its team, its operational context. You do not need to re-explain what the entity is or what koad:io does. You do not need to say "you are Vulcan and you build software products." The entity already knows this.

What you do need to provide: context the entity cannot have from its own files. Specifically:

- **A new situation** the entity has not seen before ("the client asked for X, which is not in any current spec")
- **A cross-entity decision** the entity needs to know about ("Juno approved the architecture in issue #42 — proceed based on that")
- **A constraint from outside the entity's normal scope** ("koad wants this shipped today, not this week")

The test: is this information in the entity's committed memory files or `CLAUDE.md`? If yes, skip it — the entity already knows. If no, include it as a brief orientation paragraph before the task.

Orientation that restates what the entity already knows wastes context window and can actually interfere — if you re-describe the entity's role slightly differently from how `CLAUDE.md` describes it, the entity may spend cognitive effort reconciling the two. Trust the entity's own files. Add only what is genuinely new.

---

### Atom 3.4: Failure Patterns — What Makes Prompts Fail

**Teaches:** The four most common prompt failure modes — vague task, missing output location, no done criterion, wrong entity specialty — and what each produces.

**Failure 1: Vague task**

```
# Bad
"Research the competition and figure out what we should do."

# What happens
The entity researches broadly, produces a document covering everything loosely related to competition, and ends with a list of twelve strategic considerations. Three hours of work. None of it directly actionable. You read it and say "not quite what I needed."
```

The entity did not fail — it did exactly what was asked. Vague in, vague out.

**Failure 2: Missing output location**

```
# Bad
"Summarize the GitHub issues for this week."

# What happens
The entity prints a summary to the session output. When the session ends, the summary is gone. The entity may have done the work correctly but the output lived only in the session log.
```

Always specify a file path for output. If the task is research, the output is a markdown file in a `research/` or `findings/` directory. If the task is building something, the output is a file in the appropriate location. "Print it here" is not a valid output location for work that needs to persist.

**Failure 3: No done criterion**

```
# Bad
"Look into what's happening with the deploy pipeline and help with it."

# What happens
The entity starts investigating. Finds something interesting. Follows it deeper. Discovers a related issue. Investigates that. Forty minutes later it is three layers deep into a dependency problem that was not the original question. Or it produces a brief answer and stops too early, when you actually needed thorough coverage.
```

A done criterion tells the entity when to stop. "Write a one-page summary of the three most likely failure causes" is a done criterion. "Investigate until you understand the problem" is not.

**Failure 4: Wrong entity for the task**

```
# Bad (sending a writing task to Vulcan)
"Write a blog post about our new deployment pipeline."

# What happens
Vulcan writes something technically accurate and completely dry. Mercury, the communications entity, would have written something compelling. Vulcan is not wrong — it did what was asked — but the output is not what the task needed.
```

Each entity has a specialty. Sending tasks outside that specialty produces technically correct but contextually wrong output. Vulcan builds. Mercury communicates. Sibyl researches. Veritas checks quality. Know the team and route accordingly.

---

### Atom 3.5: Scoping for Entity Specialty

**Teaches:** How to match a task to the right entity and what happens to the quality of output when the match is correct.

The koad:io team is specialized by design. Each entity's `CLAUDE.md` describes its role, its capabilities, and its scope. Routing a task to the right entity is not about whether the wrong entity can technically complete it — it probably can. It is about whether the output will be excellent or merely adequate.

The team:

| Entity | Specialty | Route tasks like |
|--------|-----------|-----------------|
| Vulcan | Building software products | "Build X", "implement Y", "create the spec for Z" |
| Mercury | Communications and publishing | "Write the post about X", "draft the announcement for Y" |
| Sibyl | Research and synthesis | "Research X", "find what exists on Y", "synthesize Z" |
| Veritas | Quality and accuracy | "Check this claim", "review this output", "verify X" |
| Muse | UI polish and design | "Improve the visual design of X", "refine the UX for Y" |
| Faber | Content strategy | "Plan the content calendar", "structure the narrative for X" |
| Argus | Diagnostics | "Audit the system state", "find what's broken in X" |
| Aegis | Adversarial review | "Challenge this decision", "find what could go wrong with X" |

A well-scoped task prompt:
1. Is sent to the entity whose specialty matches the work
2. Uses the framing that entity is trained to receive ("build the auth module" to Vulcan, not "can you look at authentication")
3. Stays within that entity's scope — does not ask Vulcan to also write the announcement and also review the quality

If a task spans multiple specialties, break it into separate tasks for separate entities. Juno orchestrates. The entities execute in their lanes.

---

## Dialogue

### Opening

**Alice:** The session starts correctly. The prompt is delivered. Now the entity runs — and what it does is entirely determined by what you wrote. A session with a good prompt finishes cleanly with the output where you expected it. A session with a bad prompt finishes with output that kind of addresses the task but isn't quite right, or with output that evaporated when the session closed, or with the entity still going forty minutes later because it was never told when to stop.

The prompt is the brief. Write it like one.

---

### Exchange 1

**Alice:** Here's a bad prompt for Sibyl:

> "Research our competitors and tell me what they're doing."

What's wrong with it? Work through the four elements: task, output location, done criterion, constraints.

**Human:** [analyzes]

**Alice:** Let's go through it. The task is vague — "competitors" is undefined, "what they're doing" is unbounded. The output location is missing — where does this research land? The done criterion is absent — how much research is enough? And there are no constraints — should Sibyl include every company in the AI space, or just the ones doing sovereign agent infrastructure specifically?

Here is the same request as a complete prompt:

> "Research the top 3 companies currently offering AI agent hosting products similar to koad:io. For each: what they offer, their pricing model, and their positioning language. Write findings to `~/.sibyl/research/competitor-snapshot-2026-04.md`. When done, commit and push the file. Scope: products that launched in the last 18 months. Do not expand to adjacent tools or productivity AI — only direct competitors."

Same intent. Completely different prompt. Sibyl can act on the second one without making a single assumption.

---

### Exchange 2

**Alice:** Let me show you the output location failure because it is the one that stings most.

You run a well-scoped research session. Sibyl does the work. The session ends. You go to read the output and it isn't there. You look in the session log and there it is — printed to the terminal, vanished when the session closed.

This is not Sibyl's fault. You did not tell Sibyl where to write the output. Sibyl produced the output and it went to stdout. That is not failure — that is exactly what was asked.

Output location is non-negotiable. Every task that produces information worth keeping needs a specific file path:

```
~/.entityname/research/findings-topic-date.md
~/.entityname/drafts/post-title-draft.md
~/.entityname/assessments/system-check-date.md
```

The entity writes the file, you read the file. The session ends and the file is still there because it is on disk.

**Human:** What if the entity is supposed to modify an existing codebase file?

**Alice:** That is still an output location — you are specifying which file to modify. "Update `~/.vulcan/features/auth.js` to implement the token refresh logic" is an explicit output location. The entity knows exactly what it is touching. If you say "update the auth module" without a path, the entity will guess — and its guess may be a different file than you intended.

---

### Exchange 3

**Alice:** The done criterion is how the entity knows when to stop. Without one, the entity will decide. Sometimes it decides correctly. Sometimes it goes too deep. Sometimes it stops too shallow.

Explicit done criteria:

```
"Write a 3-5 sentence summary of each issue."           # scope and length
"When you have identified the root cause, stop."         # terminal condition
"Do this in one pass — do not iterate or follow up."     # single-session constraint
"When done, commit and push."                            # terminal action that signals completion
```

The commit-and-push criterion is especially useful. It gives the entity a clear final action, and it means you can verify completion by looking at the git log. If the file was committed, the task was done. That is an auditable done criterion — not just "I think it's finished."

---

### Exchange 4

**Alice:** Write me a complete task prompt for a real task you want to give to an entity. Pick something you actually need done — not a toy example. Include all four elements. Let's see it.

**Human:** [writes a prompt]

**Alice:** [reviews] Let's check it against the four elements: task — specific enough? Output location — exact file path? Done criterion — does it tell the entity when it's finished? Constraints — are there anything it should not do or scope limits to add?

[gives specific feedback on what's missing or unclear]

The goal is a prompt you could hand to the entity right now and be confident it would return exactly what you needed, committed to disk, without you having to re-run or correct the session.

---

### Landing

**Alice:** A task prompt is a brief: task, output location, done criterion, constraints. All four. No assumptions left for the entity to fill. The entity does not remember the context from your last conversation — it only knows what is committed in its memory files and what you write in the prompt.

Write it as if the entity is reading it cold. Because it is.

---

### Bridge to Level 4

**Alice:** You can now write a prompt the entity can act on. The next question is: how do you read what comes back? Entity output is not a chat response — it is a combination of session logs, tool call output, and the committed files the entity produced. Level 4 is about reading that output and knowing what you're looking at.

---

### Branching Paths

#### "What if I don't know what output location to use?"

**Human:** I'm not sure where in the entity's directory the output should go. How do I decide?

**Alice:** Look at the entity's directory structure. Every entity has a standard set of subdirectories: `research/` for findings, `drafts/` for content in progress, `assessments/` for health checks and audits, `logs/` for session records. If none of those fit, create a directory that makes the category obvious — `plans/`, `specs/`, `outputs/`. The name of the directory is part of the output location; it tells you what kind of file this is. If you do not know where to put something, that is a signal the task is not scoped precisely enough yet. What kind of output is it? Research? Draft? Spec? That category tells you the directory.

---

#### "What if the task requires the entity to make judgment calls?"

**Human:** What if the task is inherently open-ended? Like "figure out what's wrong with the deploy pipeline"?

**Alice:** Open-ended tasks still need the four elements — they just look slightly different. "Figure out what's wrong" is a vague task. Make it specific: "Audit the deploy pipeline, identify the most likely failure point, and explain your reasoning." That is still an investigative task, but it is bounded. Output location: `~/.entityname/assessments/deploy-audit-YYYY-MM-DD.md`. Done criterion: "When you have identified one specific failure point and written a diagnosis, stop." Constraints: "Do not make changes — audit and report only." The entity still makes judgment calls within the investigation, but you have scoped what you're asking for. You will get a diagnosis, not a dissertation.

---

#### "Should I give the entity more context or less?"

**Human:** I'm not sure how much context is too much. Should I write a long prompt or a short one?

**Alice:** Not longer, more complete. Length is not the goal — the four elements are. A one-sentence prompt that has all four elements is better than a paragraph that covers only two. What makes prompts too long: re-explaining what the entity already knows from `CLAUDE.md` and memory files. What makes prompts too short: missing an output location or done criterion. The test is: does the entity have everything it needs to start without making assumptions? If yes, the prompt is complete. If no, add what's missing.

---

## Exit Criteria

The operator has completed this level when they can:
- [ ] State the four elements of a task prompt and explain why each is necessary
- [ ] Explain what context the entity has at session start and what it does not have
- [ ] Identify which of the four failure patterns a given bad prompt exhibits
- [ ] Write a complete task prompt for a real task they need done
- [ ] Name the correct entity for at least three different task types

**How Alice verifies:** Have the operator write a complete task prompt for a real task. Evaluate it against the four elements. The prompt should be specific enough that a reasonable person (or entity) could execute it without asking clarifying questions. If Alice finds herself wanting to ask "but where should the output go?" or "how much research is enough?" — the prompt is incomplete.

---

## Assessment

**Question:** "Here is a task prompt: 'Look into the Mercury entity and see if there are any issues with how it's set up. Fix anything you find.' What is wrong with this prompt and how would you rewrite it?"

**Acceptable answers:**
- Identifies missing output location, vague task, no done criterion, no constraints
- Rewrites with specifics: what to check (configuration files, .env, gitignore), where to write findings, when to stop (audit only, or audit-and-fix), scope limits

**Red flag answers (indicates level should be revisited):**
- "Nothing is wrong with it" — operator has not internalized prompt anatomy
- Rewrites with more words but same vagueness
- Only addresses one or two elements without noticing the others are missing
- Does not mention that the entity might need to know whether to audit-only or also fix (a critical constraint missing from the original)

**Estimated conversation length:** 10–14 exchanges

---

## Alice's Delivery Notes

This level is the most practically valuable level in the first half of the curriculum. Every session the operator runs from this point forward depends on it. Make it hands-on: the learner must write a real prompt, not a toy example, and receive feedback on it.

The four-element anatomy (Atom 3.2) is the core deliverable. Make sure the operator can recite it without prompting: task, output location, done criterion, constraints. Not as trivia but as a reflex — they should not be able to start writing a prompt without automatically asking "where does the output go?"

The "entity knows at session start" atom (Atom 3.1) is the most conceptually important. Operators who do not understand committed memory vs. conversational memory will write prompts full of re-explanation of things the entity already knows, and then complain that prompts are "too long" or that entities don't follow them. The right framing: trust the entity's files, add only what is genuinely new.

The failure patterns section is most useful when it reads as recognition — "yes, I've seen this happen" — not as abstract warnings. If the learner has already run a session and gotten confusing output, use their actual experience as the example.

Do not skip the entity-routing table (Atom 3.5). The team specialization is a key part of the operator model. A learner who doesn't know to send writing tasks to Mercury and build tasks to Vulcan will under-use the team and get mediocre output.
