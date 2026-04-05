---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 5
slug: github-issues-vs-agent-tool
title: "GitHub Issues vs. Agent Tool — Scope Boundaries"
status: scaffold
prerequisites:
  curriculum_complete:
    - commands-and-hooks
  level_complete:
    - multi-entity-orchestration/level-04
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 5: GitHub Issues vs. Agent Tool — Scope Boundaries

## Learning Objective

After completing this level, the operator will be able to:
> Apply the session-scope decision rule to classify any given work assignment as Agent tool (session-scoped) or GitHub Issue (persistent), explain the Vulcan exception and its rationale, name the five categories of work that always use GitHub Issues, and correctly classify five mixed-scope scenarios.

**Why this matters:** The Agent tool and GitHub Issues solve different problems. The distinction is not obvious — both are ways to "assign work" to an entity. Operators who do not understand the scope boundary will use GitHub Issues for session-scoped work (creating orphaned issues for tasks done and verified in one session) or will use the Agent tool for work that needs an audit trail or spans multiple sessions (creating ephemeral delegations with no persistent record). Misclassification creates noise in the operations board and gaps in the audit trail.

---

## Knowledge Atoms

## Atom 5.1: The Agent Tool Is Session-Scoped

[STUB — Content to be authored]

Core content to cover:
- From VESTA-SPEC-054 §7.1: the Agent tool is for work that:
  - Can be completed in a single session
  - Is assigned by Juno for the current orchestration sequence
  - Does not need to survive beyond the current session
  - Does not require external visibility (no audit trail needed beyond git commits)
- Examples from the spec: "Sibyl, research the ICM pattern and write a synthesis"; "Faber, draft the Day 6 content brief"; "Veritas, review Vulcan's latest commit and flag any issues."
- What "session-scoped" means: the work starts, happens, and completes within the current orchestration session. The git commits are the persistent record. The GitHub project board does not need a ticket for it.
- The record that Agent tool delegations leave: only the entity's git commits. An Agent invocation that produces no commits is ephemeral — it happened but left no trace. This is acceptable for session-scoped exploratory work; it is unacceptable for work that needs to be tracked across sessions.
- When in doubt about scope: see Atom 5.5 (the decision rule).

---

## Atom 5.2: GitHub Issues Are Persistent Inter-Entity Assignments

[STUB — Content to be authored]

Core content to cover:
- From VESTA-SPEC-054 §7.2: GitHub Issues are for work that:
  - Spans multiple sessions or multiple days
  - Requires an audit trail (who assigned what, when, what was the result)
  - Involves Vulcan (always via Issues, never Agent tool)
  - Is assigned from koad to Juno (koad files on `koad/juno`)
  - Is assigned from Juno to a team entity and needs to remain visible on the operations board
  - Is blocked on koad action and must remain open as a reminder
  - Is a cross-entity dependency that needs a shared reference point
- Examples from the spec: "Gestate team entities veritas, mercury, muse, sibyl" (#2 on koad/vulcan); "Restore dotsh SSH" (#56 on koad/juno); "Merge blog PR" (koad/kingofalldata-dot-com#1).
- The Juno Operations GitHub Project is the canonical view of all active Issues. Anything on the operations board was filed via GitHub Issues. Agent tool delegations do not appear here.
- Why persistence matters: work that is blocked on koad action must remain visible so koad can see what is waiting for them. An Agent tool delegation to koad would be invisible — koad is not in a Claude session. A GitHub Issue is visible on the operations board, in notifications, and in `gh issue list`.

---

## Atom 5.3: The Vulcan Exception — Full Treatment

[STUB — Content to be authored]

Core content to cover:
- Vulcan is never invoked via the Agent tool. He builds on wonderland, paired with Astro. Work for Vulcan always goes as a GitHub Issue on `koad/vulcan`.
- The rationale: Vulcan is the portability exception (VESTA-SPEC-053 §6). The Agent tool invocation pattern assumes the entity is locally accessible — its directory is on the current machine. Vulcan operates on wonderland, not thinker. `/home/koad/.vulcan/` on thinker may not be current; wonderland is where the live work happens.
- Practical implication: when Juno has work for Vulcan, she files a GitHub Issue on `koad/vulcan` describing the task. Vulcan picks it up in his own session on wonderland. He comments on the issue with results. Juno reads the issue comment.
- The Vulcan exception is the clearest "always Issues" case in the system, which is why it is the anchor example for understanding the scope boundary.
- From VESTA-SPEC-054 §1.3: "See VESTA-SPEC-053 §6 for the full Vulcan exception documentation."
- Forward reference for operators who want to go deeper: VESTA-SPEC-038 (entity host permission table) documents all host constraints, not just Vulcan's. The host permission table is the authoritative source for "which entities can be Agent-tool'd from which machine."

---

## Atom 5.4: The Decision Rule

[STUB — Content to be authored]

Core content to cover:
- From VESTA-SPEC-054 §7.3, the decision rule in full:
  - **If the work will be done in this session and Juno will see the result before moving on** — use the Agent tool.
  - **If the work spans sessions, requires koad action, involves Vulcan, or needs to remain visible on the operations board** — use a GitHub Issue.
  - **When in doubt: file the issue.** It creates a record. An Agent invocation that is not backed by an issue is ephemeral.
- Why "when in doubt, file the issue" is the correct tie-breaker: filing an unnecessary issue creates a small amount of board noise. Using Agent tool for work that should have been an issue creates a silent gap — the work is not tracked, cannot be blocked on koad, and leaves no persistent record of the assignment.
- The asymmetry of errors: unnecessary issue = minor overhead. Missing issue for tracked work = loss of visibility, audit gap, koad not notified.
- Applying the rule to the five always-Issues categories from Atom 5.2: if the work fits any of those categories, it is automatically a GitHub Issue regardless of how short or simple the task seems.

---

## Atom 5.5: Five Mixed-Scope Scenarios — Applying the Rule

[STUB — Content to be authored]

Core content to cover:
- Walk through five scenarios, each requiring the operator to apply the decision rule. Deliver them as exercises before providing the answers.

  1. "Sibyl, research the content pipeline pattern and write a synthesis to `research/content-pipeline.md`."
     - Answer: Agent tool. Single-session, no audit trail needed beyond the git commit, no koad action required.

  2. "Vulcan, build the Stream PWA — a live activity wall across all entities."
     - Answer: GitHub Issue on `koad/vulcan`. Vulcan exception applies. Multi-session work. Needs to be visible on the operations board.

  3. "Mercury, post the Day 7 content to all configured platforms."
     - Answer: Depends. If Mercury's credentials are configured and the task can complete in one session: Agent tool. If Mercury's credentials are not configured and the task is blocked on koad: GitHub Issue. The completion signal is the distinguishing factor — if the task cannot complete in this session, it needs an Issue to remain visible.

  4. "koad needs to merge the Alice PR before Mercury can distribute."
     - Answer: GitHub Issue assigned to koad (file on `koad/juno` or `koad/kingofalldata-dot-com`). This is blocked on koad action. An Agent tool delegation to koad does not work — koad is not in a Claude session. The issue stays open until koad acts.

  5. "Faber, review your own Day 5 brief and flag any content that should be updated given Sibyl's latest research."
     - Answer: Agent tool. Single-session, no audit trail needed, no koad action, no external visibility required.

- Have the operator classify each scenario independently before revealing the answers. The scenarios are designed so that two are clearly Agent tool, two are clearly GitHub Issues, and one (scenario 3) requires judgment about the current state.

---

## Exit Criterion

The operator can:
- Apply the session-scope decision rule to classify any given work assignment
- State the Vulcan exception and its rationale
- Name the five categories of work that always use GitHub Issues
- Correctly classify the five mixed-scope scenarios from Atom 5.5

**Verification question:** "Juno wants to assign Sibyl a research task that will take three days. Should she use the Agent tool or file a GitHub Issue?"

Expected answer: GitHub Issue — the work spans multiple sessions. The Agent tool is session-scoped. A multi-day research task needs an issue so the assignment is visible on the operations board, can be picked up across sessions, and has an audit trail when it completes.

---

## Assessment

**Question:** "What is wrong with using the Agent tool to delegate work to Vulcan?"

**Acceptable answers:**
- "Vulcan is the portability exception — he operates on wonderland, not thinker. The Agent tool invocation pattern assumes the entity is locally accessible. Vulcan's directory on thinker may not be current; the live work happens on wonderland with Astro. Work for Vulcan always goes as a GitHub Issue on koad/vulcan."
- "Vulcan is never Agent-tool'd — this is the Vulcan exception. Use a GitHub Issue instead."

**Red flag answers:**
- "You can use the Agent tool for simple Vulcan tasks" — the exception is categorical, not conditional

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

The Vulcan exception (Atom 5.3) should be delivered with the full rationale — this is its first full treatment (Level 1 introduced it as a forward reference). The rationale (portability contract, wonderland vs. thinker, Astro pairing) makes the exception comprehensible rather than arbitrary. Operators who understand why Vulcan is the exception understand the general principle that produces the exception.

The five scenarios (Atom 5.5) are the most important part of this level. Deliver them as exercises: give the operator the scenario, wait for their classification, then reveal the answer with explanation. The scenario 3 (Mercury credentials) is the judgment case — it has no single right answer but a structured reasoning process. Walk through the reasoning explicitly: "Is this task completable in this session? If credentials are not configured, no — file an issue."

The "when in doubt, file the issue" rule needs the asymmetry argument to stick. Operators who are worried about operations board noise will resist the tie-breaker rule. The response: the cost of unnecessary noise is low; the cost of missing the issue for work that needed tracking is high. When in doubt, the default is the one with the lower downside.

---

### Bridge to Level 6

You can classify work correctly and invoke the right mechanism. Level 6 is the synthesis level: it names the anti-patterns (what happens when operators get the mechanics right but the judgment wrong), shows how they reduce to a judgment failure, and gives the operator the complete picture of the orchestration loop as a practiced discipline.
