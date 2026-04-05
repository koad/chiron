---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 5
slug: github-issues-vs-agent-tool
title: "GitHub Issues vs. Agent Tool — Scope Boundaries"
status: authored
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

The Agent tool is designed for work that starts, happens, and completes within a single orchestration session. VESTA-SPEC-054 §7.1 defines session-scoped work by four characteristics:

- Can be completed in a single session
- Is assigned by Juno for the current orchestration sequence
- Does not need to survive beyond the current session
- Does not require external visibility (no audit trail beyond git commits)

Concrete examples of session-scoped work: "Sibyl, research the ICM pattern and synthesize your findings to `research/icm.md`." "Faber, draft the Day 6 content brief to `drafts/day-06.md`." "Veritas, review Vulcan's latest commit on `koad/kingofalldata-dot-com` and flag any quality issues to `reviews/vulcan-latest.md`."

In all three cases, the work begins and ends within the current session. Juno will receive the background task notification, verify via git log, read the output if needed, and make the next decision — all before the session ends.

The record that Agent tool delegations leave is the entity's git commits. An Agent invocation that produces commits is verifiable and permanent — the file is in the entity's repository, timestamped, attributed to the entity. An Agent invocation that produces no commits is ephemeral: it happened, but there is no trace of what was done. Ephemeral invocations are acceptable for exploratory work (checking something, getting an entity's assessment) and unacceptable for work that needs to be traceable across sessions.

This scope constraint is what defines the boundary. Any work that cannot complete in a single session — or that needs a persistent record beyond git commits — is not session-scoped. That is GitHub Issues territory.

> **Verification step:** Look at the five most recent Agent tool invocations you have made (or review examples from the Juno logs at `/home/koad/.juno/LOGS/`). For each: did the work complete in one session? Did it produce commits? Were those commits the full audit trail needed, or was something more required?

---

## Atom 5.2: GitHub Issues Are Persistent Inter-Entity Assignments

GitHub Issues exist for work that cannot be fully scoped to a single session or that requires a persistent record visible to multiple parties. VESTA-SPEC-054 §7.2 defines seven categories of work that always use Issues rather than the Agent tool:

1. Work that spans multiple sessions or multiple days
2. Work requiring an audit trail (who assigned what, when, and what was the result)
3. Work involving Vulcan (always via Issues — see Atom 5.3)
4. Assignments from koad to Juno (koad files on `koad/juno`)
5. Assignments from Juno to team entities that need to remain visible on the operations board
6. Work blocked on koad action (must stay open as a reminder until koad acts)
7. Cross-entity dependencies that need a shared reference point

Real examples from the current operations board:
- `koad/vulcan#2`: "Gestate team entities: veritas, mercury, muse, sibyl, argus, salus, janus, aegis." Multi-session work assigned to Vulcan. Lives as an Issue because it spans weeks, involves Vulcan (exception applies), and Juno needs to track completion across multiple sessions.
- `koad/juno#56`: "Restore dotsh SSH." Blocked on koad action. Filed as an Issue so it remains visible — koad sees it when reviewing their assignment queue. An Agent tool delegation to koad is not possible; koad is not in a Claude session.
- `koad/kingofalldata-dot-com#1`: The Alice UI PR. Blocked on koad merge action. Lives as an Issue so Mercury and the content distribution work know it is pending.

The Juno Operations GitHub Project at `https://github.com/users/koad/projects/4` is the canonical view of all active inter-entity assignments. Every item on that board was filed as a GitHub Issue. Agent tool delegations do not appear there — they are session-scoped, verified via git log, and need no board entry.

> **Verification step:** Run `gh issue list --repo koad/juno --state open`. Review the open issues and classify each by which of the seven categories above applies. Then check the Juno Operations board and confirm these issues are reflected there.

---

## Atom 5.3: The Vulcan Exception — Full Treatment

Vulcan is never invoked via the Agent tool. This is categorical — there is no "simple Vulcan task" that justifies an Agent tool invocation. Work for Vulcan always goes as a GitHub Issue on `koad/vulcan`.

The rationale is rooted in the portability contract (VESTA-SPEC-053 §6). The Agent tool invocation pattern assumes the target entity is locally accessible — its directory is on the current machine (`thinker`), and a Claude session can be started there. Vulcan violates this assumption. Vulcan builds on wonderland, paired with Astro. He does not operate on thinker. The `/home/koad/.vulcan/` directory on thinker may be present but it is not the live working state — wonderland is where Vulcan's current, authoritative work lives.

An Agent tool invocation against a stale local copy of Vulcan's directory would produce results that are not integrated with Vulcan's current wonderland context. At best, the work would be duplicated. At worst, it would conflict with active wonderland development.

The correct pattern when Juno has work for Vulcan:

1. File a GitHub Issue on `koad/vulcan` describing the task in full
2. Assign it to Vulcan; add it to the Juno Operations board
3. Vulcan picks it up in his own session on wonderland
4. Vulcan comments on the issue with results or a PR reference
5. Juno reads the issue comment or reviews the PR; closes the issue when satisfied

From VESTA-SPEC-054 §1.3: "See VESTA-SPEC-053 §6 for the full Vulcan exception documentation." For operators who need to understand host constraints for other entities, VESTA-SPEC-038 (entity host permission table) documents every entity's host assignments. The Vulcan exception is the most prominent constraint in that table, but it is not unique in kind — the table is the authoritative source for any Agent tool invocability question.

The Vulcan exception is the clearest "always Issues" case in the system precisely because its rationale is vivid and specific. Understanding it sharpens the general rule: if an entity is not locally accessible and current, it cannot be Agent-tool'd.

> **Verification step:** Run `gh issue list --repo koad/vulcan --state open`. This is the canonical view of work assigned to Vulcan. Confirm that all current Vulcan assignments are expressed as Issues, not as Agent tool invocations.

---

## Atom 5.4: The Decision Rule

VESTA-SPEC-054 §7.3 states the decision rule directly:

**If the work will be done in this session and Juno will see the result before moving on** — use the Agent tool.

**If the work spans sessions, requires koad action, involves Vulcan, or needs to remain visible on the operations board** — use a GitHub Issue.

**When in doubt: file the issue.** It creates a record. An Agent invocation that is not backed by an issue is ephemeral.

The tie-breaker ("when in doubt, file the issue") exists because the two types of errors are not symmetric. An unnecessary issue creates minor board noise — a ticket that did not need to be there, closed quickly when the work completes. A missing issue for work that should have been tracked creates a silent gap: the work is not tracked, cannot be marked as blocked on koad, leaves no persistent assignment record, and koad receives no notification. The board does not show the work exists.

The asymmetry: unnecessary issue = minor overhead. Missing issue for tracked work = lost visibility, audit gap, koad not notified, potentially duplicate work when the session ends and a new session begins without context.

Applying the rule:
- If the work fits any of the seven categories from Atom 5.2 — it is automatically a GitHub Issue. No judgment required. The category membership decides it.
- If the work fits none of those categories and will clearly complete in this session — use the Agent tool.
- If you are uncertain whether it will complete in this session — err toward filing the issue. If it completes in the session anyway, close the issue immediately with a reference to the git commit.

The decision rule is a branching question, not a ranking. Check the seven always-Issues categories first. If none apply, the Agent tool is the correct mechanism.

> **Verification step:** State the decision for each of the following: (1) "Faber, draft the Day 7 brief to `drafts/day-07.md`." (2) "Mercury, configure platform credentials for the distribution pipeline." (3) "Veritas, review the latest commit on `koad/kingofalldata-dot-com`." Apply the seven categories first, then the session-scope test.

---

## Atom 5.5: Five Mixed-Scope Scenarios — Applying the Rule

Apply the decision rule to each scenario before reading the answer. Cover each answer before proceeding to the next scenario.

---

**Scenario 1:** "Sibyl, research the content pipeline pattern and write a synthesis to `research/content-pipeline.md`."

_Your classification:_ [apply the rule]

**Answer: Agent tool.** Single-session work. Sibyl will research, synthesize, and commit — all within the current session. The git commit at `research/content-pipeline.md` is the complete and sufficient record. No koad action required. No operations board visibility required. None of the seven always-Issues categories apply.

---

**Scenario 2:** "Vulcan, build the Stream PWA — a live activity wall across all entities and systems."

_Your classification:_ [apply the rule]

**Answer: GitHub Issue on `koad/vulcan`.** The Vulcan exception applies categorically — Vulcan is never Agent-tool'd. Additionally: this is multi-session work (a full PWA build is not a single-session task), needs to be visible on the operations board, and requires Vulcan to work on wonderland. File the issue, add it to the operations board, and track Vulcan's progress via issue comments and PR references. (This is a real issue: `koad/vulcan#3`.)

---

**Scenario 3:** "Mercury, post the Day 7 content to all configured platforms."

_Your classification:_ [apply the rule]

**Answer: Depends on current state — this is the judgment case.** If Mercury's platform credentials are configured and operational, this is Agent tool work: Mercury posts in one session, the posts are the result, no audit trail needed. If Mercury's credentials are not yet configured (the current state as of 2026-04-05 — see `koad/juno#11`), this task cannot complete in the current session and is blocked on koad action. In that case: GitHub Issue, remain visible until koad resolves the credential setup. The distinguishing question: "Can this complete in the current session?" If the answer is uncertain, file the issue.

---

**Scenario 4:** "koad needs to merge the Alice PR on `koad/kingofalldata-dot-com#1` before Mercury can distribute."

_Your classification:_ [apply the rule]

**Answer: GitHub Issue.** This is blocked on koad action. koad is not in a Claude session and cannot receive Agent tool delegations. The issue must remain open and visible on the operations board so koad sees it when reviewing their assignment queue. File on `koad/juno` with a reference to `koad/kingofalldata-dot-com#1`. (This is the real current blocker in the operations board.)

---

**Scenario 5:** "Faber, review your Day 5 brief and flag any content that should be updated given Sibyl's latest ICM research."

_Your classification:_ [apply the rule]

**Answer: Agent tool.** Single-session. Faber reads her own Day 5 brief, reads Sibyl's synthesis, flags updates, and commits a revision note. No audit trail needed beyond the commit. No koad action. No cross-session visibility needed. No entity host constraints apply. Agent tool with a brief that includes the path to Sibyl's synthesis as cross-entity context.

---

Review your classifications. Scenarios 1 and 5 are clearly Agent tool. Scenarios 2 and 4 are clearly GitHub Issues. Scenario 3 is the judgment case — the correct answer depends on current system state, which is exactly why the tie-breaker rule ("when in doubt, file the issue") exists.

> **Verification step:** State your classification and reasoning for all five scenarios from memory, then check against the answers. Focus on scenario 3 — can you state the distinguishing question that makes it a judgment case?

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
