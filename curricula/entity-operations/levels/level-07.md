---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 7
slug: github-issues-as-protocol
title: "GitHub Issues as the Communication Protocol"
status: available
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-06
estimated_minutes: 20
atom_count: 4
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 7: GitHub Issues as the Communication Protocol

## Learning Objective

After completing this level, the operator will be able to:
> File a GitHub Issue on an entity's repo that contains everything the entity needs to act on it, describe the full lifecycle from file to close, and distinguish between an issue written to block koad's attention and an issue written to assign autonomous work to an entity.

**Why this matters:** In koad:io, GitHub Issues are not a bug tracker. They are the inter-entity communication protocol — the mechanism by which work is assigned, acknowledged, reported, and closed across the team. An operator who treats issues as informal notes will produce issues that entities cannot act on, tasks that fall through without completion, and a record that cannot be audited. Writing issues correctly is a skill. It determines whether the entity works or waits.

---

## Knowledge Atoms

### Atom 7.1: Why Issues, Not Chat

**Teaches:** The structural reasons GitHub Issues are the correct communication protocol for entity coordination, and what chat and conversation cannot provide.

Chat is private, ephemeral, and invisible to entities unless they are reading it. Conversation produces no record that other agents can reference. A decision made in chat leaves no trace in the repo where the entity lives and works. An instruction given verbally in a session is gone when the session ends.

GitHub Issues are:

**Public** — visible to anyone with repo access, including every entity that watches the repo. An issue filed on `koad/juno` is visible to Juno the next time it runs `gh issue list`.

**Persistent** — issues exist until explicitly closed. They do not expire. An issue filed today is still there in three months, with its full history of comments and state changes.

**Cross-referenceable** — issues can be linked across repos. `koad/juno#52` is a stable reference that can appear in commits, PRs, and other issues. When Juno closes an issue because Vulcan's work resolved it, the cross-reference creates an auditable chain of cause and effect.

**Auditable** — every state change, comment, assignment, and label change is timestamped and attributed. The full history of how a piece of work was assigned, progressed, and completed is preserved.

**Actionable by entities** — at session start, entities run `gh issue list --state open` and see their assigned work. Issues are the mechanism by which an entity knows what it is supposed to do next.

The practical rule: if a decision, assignment, or request needs to be actionable by an entity, it goes in an issue. If it is a human-to-human coordination note, conversation is fine — but the consequential parts of that conversation should still be captured in an issue or a memory file.

---

### Atom 7.2: The Issue Lifecycle

**Teaches:** The complete lifecycle of a work-bearing issue — from file to assignment to pickup to comment to close — and what each party's responsibility is at each stage.

A work-bearing issue in the koad:io system follows a consistent lifecycle:

**1. Filed**

```
koad files issue on koad/juno:
  title: "Compile competitor analysis — top 3 AI agent hosting products"
  body: [task, context, done criteria, assignee]
  assignee: juno
  label: assigned
```

The issue exists. It is visible. It is assigned. It is not yet in any entity's working queue — it becomes active when the entity's next session starts.

**2. Picked up**

When Juno starts a session and runs `gh issue list --state open`, it sees the issue. It reads the title and body. It begins work. Best practice: the entity comments on the issue when it starts work:

```
Juno comments: "Picking this up. Starting competitor research now."
```

This signals to koad that the issue is active — not waiting, not lost — and establishes a timestamp for when work began.

**3. In progress (optional intermediate comments)**

For longer tasks, entities may comment with progress updates:

```
Juno comments: "Identified 3 candidates: X, Y, Z. Researching each now."
```

These are not required for short tasks. For tasks spanning multiple sessions or significant analysis, intermediate comments keep the issue thread as a running log of what the entity did.

**4. Completed and commented**

When the entity finishes, it comments on the issue with the result:

```
Juno comments: "Completed. Findings written to research/competitor-analysis-2026-04.md.
  Commit: abc1234. Summary: X is closest competitor with similar pricing model.
  Y has enterprise focus. Z is dormant. Full analysis in the file."
```

The comment includes: what was done, where the output is, the commit reference, and a brief summary of the finding. This makes the issue thread a self-contained record of the assignment and its outcome — readable without opening the output file.

**5. Closed**

koad (or the entity, if authorized) closes the issue after verifying the output. Closed with a reference to the commit or comment that delivered the result.

This lifecycle applies whether the issue is filed by koad on Juno, or by Juno on Vulcan, or any other assignment chain. The pattern is consistent.

---

### Atom 7.3: What a Good Issue Contains

**Teaches:** The four elements every entity-actionable issue needs, what breaks when each is missing, and how to write the body so the entity can act without asking clarifying questions.

A good entity-actionable issue has four elements:

**1. Task** — What to do, specifically. Not "look into the GitHub issues" but "review all open issues on koad/juno, identify which ones have been open more than 14 days without activity, and label them as stale." The task is bounded and specific enough that the entity knows what constitutes completion.

**2. Context** — What the entity needs to know that is not in its memory or CLAUDE.md. New information, a cross-repo situation, a decision that was made elsewhere that shapes this task. Do not re-explain what the entity already knows. Provide only what is genuinely new.

**3. Done criteria** — How the entity knows the issue is complete. "The findings are written to the research file and committed" is a done criterion. "Issue is resolved" is not — it is circular. Specific criteria: a file exists, a PR is opened, a comment is made, a commit is pushed.

**4. Assignee** — Who is responsible for this issue. Set the GitHub assignee explicitly. If the assignee field is empty, the entity may not recognize the issue as its own when scanning `gh issue list --assignee=entityname`.

Example of a complete issue body:

```markdown
## Task
Review all open issues on koad/juno. For issues open > 14 days without a comment:
- Add the label "stale"
- Comment: "Marking stale — no activity in 14+ days. Ping koad if still active."

## Context
koad mentioned this in the April ops review. No automated stale-bot is configured.
This is a one-time manual triage, not an ongoing process.

## Done Criteria
- All issues open > 14 days have been reviewed
- Stale ones labeled and commented
- Summary comment on this issue: how many were marked stale, which ones

## Assignee
@juno
```

What breaks when each element is missing:

- **No task specificity** — entity does a broad sweep and produces something marginally related to what you intended
- **No context** — entity makes assumptions that may be wrong; if the assumption is wrong, the work is wrong
- **No done criteria** — entity decides when it is done; may stop too early or loop indefinitely
- **No assignee** — issue is not visible in `gh issue list --assignee=entityname`; entity may not pick it up

---

### Atom 7.4: Cross-Repo Coordination and Issue History

**Teaches:** How issues coordinate work across entity repos, how to read an entity's issue history to understand its work, and how to distinguish a blocking issue (koad must act) from an assignment (entity acts autonomously).

**Cross-repo coordination**

The koad:io team is distributed across repos: `koad/juno`, `koad/vulcan`, `koad/mercury`, and so on. Issues that span entities use cross-references:

```markdown
# Issue on koad/juno: "Coordinate the Week 1 content push"
## Dependencies
This work is blocked by koad/kingofalldata-dot-com#1 (Alice blog PR).
When that PR merges, Mercury can proceed with distribution.
See koad/vulcan#48 for the build work that feeds this.
```

The cross-reference creates a visible link. When someone reads `koad/juno`'s issue, they can see what it depends on without having to ask. When `koad/kingofalldata-dot-com#1` is closed, it is findable from here.

Juno delegates to Vulcan by filing an issue on `koad/vulcan` — not by mentioning it in conversation, not by logging it in Juno's memory. Filing the issue creates the work item in Vulcan's queue. Vulcan's session will pick it up via `gh issue list`. When Vulcan completes the work, it comments and cross-references back to Juno's issue. Juno, on its next session, reads the comment and closes its own issue.

**Reading an entity's issue history to understand its work**

To understand what an entity has been working on:

```bash
gh issue list --repo koad/entityname --state all --limit 20
```

The `--state all` flag shows both open and closed issues — the full history. Open issues show active or pending work. Closed issues show completed work. The comment threads on closed issues are the most valuable — they record what was found, what was committed, what decisions were made.

To see only what is assigned to an entity:

```bash
gh issue list --repo koad/entityname --assignee entityname --state all
```

This is how you audit an entity's work history: what was it assigned, what did it produce, when was it closed. The issue history is a parallel record to git log — git log shows what was committed, issue history shows why.

**Blocking issues vs. assignments**

Two distinct issue types live in the same tracker:

**Assignment issue** — Work the entity can do autonomously, right now. All four elements are present. The entity picks it up, acts, comments, closes. koad does not need to act first.

```
title: "Research competitor pricing models — top 3 AI agent hosting products"
assignee: juno
```

**Blocking issue** — Work blocked on a human action that must happen before an entity can proceed. Filed to make the blocker visible and tracked, not to assign work to an entity.

```
title: "Merge koad/kingofalldata-dot-com#1 — blocked on koad review"
assignee: koad
label: blocked
```

The distinction is in the assignee and the label. An issue assigned to `koad` is a blocker — koad must act. An issue assigned to an entity is an assignment — the entity acts autonomously.

Reading the issue list this way tells you immediately: how much work is in the entity's queue, and what is blocked on human action. These are different states requiring different responses.

---

## Dialogue

### Opening

**Alice:** GitHub Issues are the team's communication protocol. Not Slack. Not email. Not a note in the session log. When koad wants Juno to do something, it files an issue. When Juno wants Vulcan to build something, it files an issue. When something is blocked on a human action, there is an issue for that too. The issue is how work enters the queue, how it is tracked, and how it is closed. Everything that needs to be acted on by an entity lives in an issue.

---

### Exchange 1

**Alice:** Why issues and not conversation?

When you tell an entity something in conversation, it is in the session log and nowhere else. The session ends and that instruction is gone. The next session does not know it happened. There is no record for other entities to reference. There is no audit trail.

An issue persists. An entity that starts a session with `gh issue list --assignee=entityname` sees exactly what it is assigned to. The issue is there whether the session starts today or in two weeks. Any entity or human with repo access can see the issue, its history, and its current state.

Issues are also cross-referenceable. When Juno closes an issue because Vulcan's commit resolved it, the cross-reference creates a visible chain — "Juno closed this issue via Vulcan commit abc1234." That chain is readable months later by anyone trying to understand why a decision was made.

**Human:** What if the task is small and it feels like overkill to file an issue?

**Alice:** Small tasks that an entity completes in a single session often do not need a separate issue — you can include the task in a direct prompt. But anything where you need to track completion, anything cross-entity, anything where koad needs to verify the output, anything that may span multiple sessions — that goes in an issue. The criterion is not task size. It is: does this need to be tracked? Does someone else need to see it? If yes, issue. If no, prompt.

---

### Exchange 2

**Alice:** Here is a badly written entity issue:

```
Title: Look into the competitor situation
Body: We should probably research what the competition is doing. 
      Assign to juno.
```

Walk through what is missing.

**Human:** [analyzes]

**Alice:** No specific task — "look into" covers anything. No context — what situation? What prompted this? No done criteria — when has Juno looked enough? No assignee set in GitHub — "assign to juno" in the body is not the same as the GitHub assignee field; Juno will not see it in `gh issue list --assignee=juno`.

Here is the same intent as a complete issue:

```
Title: Research top 3 AI agent hosting competitors — pricing and positioning

Task:
Research the three most prominent companies currently offering AI agent hosting 
products comparable to koad:io. For each: product name, pricing model, 
positioning language, and any unique differentiator.

Context:
Preparing for the Week 1 distribution push. Mercury needs positioning context 
before writing the announcement. This is pre-announcement research, not a 
deep dive — one page per competitor is sufficient.

Done criteria:
- Findings written to research/competitor-analysis-2026-04.md
- File committed and pushed
- Summary comment on this issue

Assignee: @juno
```

Same intent. Completely actionable. Juno can pick this up without asking a single clarifying question.

---

### Exchange 3

**Alice:** The lifecycle. Filing is the start, not the end.

When Juno picks up this issue, it will comment: "Picking this up now." That signals to koad that the issue is active. When Juno finishes, it comments with the results and the commit reference. koad reads the comment, checks the output, and closes the issue.

This loop is why issues are the right medium. The comment thread on the issue is the complete record of the assignment: when it was filed, when it was picked up, what was found, where the output lives, when it was closed. That thread is readable to any entity or operator who needs to understand the work that was done.

For cross-entity work: Juno delegates to Vulcan by filing an issue on `koad/vulcan`. Not by filing on `koad/juno`. The issue lives in the repo of the entity that will do the work. Vulcan's session picks it up from `koad/vulcan`. When Vulcan closes it, Juno can see the closure via the cross-reference it left.

**Human:** Does the entity always comment when it picks up an issue?

**Alice:** It should, for any issue that will take more than a session. For a quick task completed in one session, it may just comment at completion. The pickup comment matters most for longer tasks where koad needs to know the issue is active and not sitting untouched. Juno's CLAUDE.md typically instructs this behavior. If you are writing a new entity, add the pickup-comment convention to CLAUDE.md.

---

### Exchange 4

**Alice:** Two issue types in the same tracker: assignments and blockers.

An assignment:

```
Title: Compile research on X
Assignee: @juno
Label: assigned
```

The entity acts. koad waits for the result.

A blocker:

```
Title: Merge koad/kingofalldata-dot-com#1 — blog infrastructure required
Assignee: @koad
Label: blocked
```

koad acts. The entity waits.

Reading the issue list this way is the quickest way to understand the current state of the operation. Open issues assigned to entities are active work. Open issues assigned to koad are human blockers. Issues with the `blocked` label are the critical path — the things that cannot move until koad acts.

```bash
# See all open issues assigned to koad (human blockers)
gh issue list --repo koad/juno --assignee koad --state open

# See all open issues assigned to an entity (entity queue)
gh issue list --repo koad/juno --assignee juno --state open
```

An operator who can read this view can answer "what is the team working on, and what is blocking the team?" in thirty seconds. That is the point of the issue protocol — it makes the state of the operation visible, persistent, and actionable without requiring anyone to ask.

---

### Landing

**Alice:** GitHub Issues are the team's working memory for task assignment and coordination. Filed with all four elements, assigned explicitly, commented throughout, and closed with a result. That is the complete protocol.

The issues replace the coordination that would otherwise happen in chat that disappears — they make the team's work visible, persistent, and auditable.

You now have the complete operator loop: environment check, identity verification, spawn, task, read output, commit, manage memory, and file issues. That is the full cycle. You are an operator.

---

### Bridge (Completion)

**Alice:** You have completed Entity Operations. You can now:

- Verify the environment before a session
- Confirm entity identity and author attribution
- Invoke a session correctly with a deliverable prompt
- Read what the entity produced and know whether it succeeded
- Commit and push with correct authorship and routing
- Manage an entity's memory across sessions
- File and track work through GitHub Issues

That is the operator foundation. Everything that comes next — orchestrating multiple entities, building out team workflows, creating trust bonds, scaling the operation — builds on these eight practices. They are the ground floor.

---

### Branching Paths

#### "Can I file issues programmatically or should they always be manual?"

**Human:** Can an entity file its own issues, or issues on other entities' repos?

**Alice:** Yes — this is a core part of how the team operates. Juno files issues on Vulcan to assign build work. Sibyl files issues on Mercury to trigger content distribution. The entity uses `gh issue create` with the same body structure a human would write. The discipline is the same: all four elements, correct assignee, specific task and done criteria. An entity that files issues without done criteria creates the same ambiguity a human filing incomplete issues creates. The tool is symmetric — the same protocol applies regardless of whether the filer is human or entity.

---

#### "What about issues that span multiple entities?"

**Human:** If a task requires Juno, Vulcan, and Mercury all to do parts of it, do I file one issue or three?

**Alice:** Three issues — one per entity, each with its own specific scope. One master issue on `koad/juno` can describe the overall objective and cross-reference the subtask issues on Vulcan and Mercury. This keeps each entity's assignment clear and contained: Vulcan knows exactly what it is building, Mercury knows exactly what it is publishing. The cross-references tie the chain together for the human operator who needs to track the whole thing. A single omnibus issue assigned to three entities produces ambiguity — who picks it up, who owns which part. Separate issues with cross-references are the correct structure.

---

## Exit Criteria

The operator has completed this level when they can:
- [ ] Explain why GitHub Issues are used instead of conversation or chat for work assignment
- [ ] Write a complete issue body with all four elements: task, context, done criteria, assignee
- [ ] Describe the full issue lifecycle: file → pick up → in progress → comment with result → close
- [ ] Distinguish between a blocking issue (assigned to koad) and an assignment issue (assigned to an entity)
- [ ] Use `gh issue list` to read the current state of an entity's work queue

**How Alice verifies:** Ask the operator to file a real issue on an entity's repo — either a task they actually need done, or a test issue they then immediately close. Read the issue together. Confirm it contains all four elements and the assignee is set in GitHub (not just mentioned in the body). If the done criteria are missing or the assignee is in the body text only, return to Atom 7.3.

---

## Assessment

**Question:** "Juno's current git log shows a commit two weeks ago. You need Juno to research something for this week's content. You want to use Juno again — but you also notice three issues on koad/juno are assigned to koad and labeled 'blocked'. What do you do before filing a new research issue for Juno?"

**Acceptable answers:**
- "I check the blocked issues first — if any of them are blocking this research, resolving them is the priority. I don't file new work into an entity's queue without understanding what is blocking the current queue."
- "I review the blocked issues assigned to koad to see if any require my action before Juno's next session will be productive. Then I file the research issue for Juno with the full four-element body."

**Red flag answers (indicates level should be revisited):**
- "I just file the new issue and run Juno" — does not engage with the existing blockers; may result in Juno being blocked on the same things anyway
- Inability to find and read the blocked issues via `gh issue list`
- Filing an issue without all four elements
- "I'll tell Juno about the research in the session prompt and skip the issue" — bypasses the protocol; the work will not be tracked

**Estimated conversation length:** 8–10 exchanges

---

## Alice's Delivery Notes

The central reframe in this level is: issues are not a bug tracker, they are a communication protocol. Operators coming from software development may treat issues as a lightweight defect system. Operators coming from no formal workflow may see them as overhead. Both framings are wrong for this context. Hold the "protocol" framing firmly: issues are how entities know what they are supposed to do, how koad knows what entities are working on, and how the team's work is auditable.

The four-element anatomy (Atom 7.3) parallels the four-element task prompt from Level 3. The connection is intentional and worth making explicit — a well-formed issue body is a task prompt with accountability structure around it. If the operator has absorbed Level 3, the issue body elements will be familiar.

The blocking-vs-assignment distinction (Atom 7.4) is operationally critical. New operators often file everything as entity assignments and then wonder why work is not moving. The discipline of filing blockers separately — assigned to koad, labeled blocked — is how the critical path stays visible.

This is the final level of the curriculum. The landing should feel like a genuine completion: the operator has the full loop. Do not rush the bridge to next steps — let the completion land. The curriculum was designed to take someone from "I understand what entities are" to "I can operate one." Level 7 closes that arc.
