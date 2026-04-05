---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 3
slug: background-execution-and-parallel-delegation
title: "Background Execution and Parallel Delegation"
status: authored
prerequisites:
  curriculum_complete:
    - commands-and-hooks
  level_complete:
    - multi-entity-orchestration/level-02
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 3: Background Execution and Parallel Delegation

## Learning Objective

After completing this level, the operator will be able to:
> Run multiple entity invocations in parallel in a single message using `run_in_background: true`, explain why background-first is the standard mode, state the notification pattern for background completion, apply the 60-second rate pacing rule for sequential chained invocations, and explain the distinction between parallel invocations (no pacing needed) and sequential chains (pacing required).

**Why this matters:** Background-first is not a performance optimization — it is the correct model for independent work. Entities doing unrelated tasks do not need to wait for each other. Blocking sequential invocations where parallel would do imposes unnecessary coupling and latency. Understanding when parallel is correct (independent tasks) and when sequential is required (dependent tasks needing pacing) is the difference between a responsive orchestration session and a slow, fragile one.

---

## Knowledge Atoms

## Atom 3.1: Why Background-First

`run_in_background: true` is not a performance optimization. It is the correct model for how entity work happens: independently, asynchronously, without the orchestrator blocking.

VESTA-SPEC-054 §2.1 states the principle directly: "Entities do independent work. Waiting for entity A to finish before starting entity B is unnecessary coupling when A and B are working on unrelated problems." When Sibyl researches ICM patterns and Faber updates the Day 6 content brief simultaneously, neither entity needs the other to finish first. Blocking on Sibyl would add minutes of unnecessary latency before Faber starts — and produce identical results.

**Background execution enables the observe loop to work correctly.** When entities run in the background, the orchestrator does not sit idle — it continues its own work, tracks incoming notifications, and acts on results as they arrive. This is the "observe" step of launch-observe-decide. A blocking invocation suspends the entire observe loop until the entity finishes; background execution keeps the loop alive.

**`run_in_background: false` (blocking mode) is the exception, not the rule.** Use it only when the next action literally cannot be determined until the entity's output is in hand — and even then, consider whether the dependency is real or assumed. If the orchestrator can describe what the next action is before the entity starts, the invocation should be background.

**The default question before every invocation:** "Does the next action depend on what this entity produces, and can I not know what that next action is until I see the output?" If the answer is yes to both: blocking (with rate pacing). If no: background.

In practice, the koad:io team is rarely so tightly coupled that a blocking invocation is required. The pattern you will use most often is: launch multiple entities in background mode, observe as notifications arrive, decide based on what actually came back.

> **Verification step:** State in one sentence when `run_in_background: false` is the correct choice. Then state in one sentence when it is incorrect. If you can state both, you have the background-first default installed.

---

## Atom 3.2: Running Multiple Entities in Parallel — One Message

Multiple Agent tool calls placed in a single message run in parallel. They start at the same time, operate in independent contexts, and each produces its own notification when complete.

From VESTA-SPEC-054 §2.3, the pattern looks like this in a single orchestrating message:

```
[Juno's message contains three Agent tool calls:]

Agent(
  cwd=/home/koad/.sibyl/,
  prompt="You are Sibyl, research entity... [brief] ...commit to research/icm-synthesis.md",
  run_in_background=true
)

Agent(
  cwd=/home/koad/.faber/,
  prompt="You are Faber, content strategist... [brief] ...commit to content/day-07-brief.md",
  run_in_background=true
)

Agent(
  cwd=/home/koad/.mercury/,
  prompt="You are Mercury, distribution entity... [brief] ...commit to distribution/checklist.md",
  run_in_background=true
)
```

All three start simultaneously. Each runs in its own context, reads its own startup documents, does its work, and commits. Three separate notifications will arrive as each completes — not all at once, but in whatever order they finish.

**When to proceed after launching:** it depends on what the next decision requires. If the next action needs all three results (e.g., Juno reviews all three outputs before deciding the Week 2 plan), wait for all three notifications before acting. If the next action can be triggered by the first result that arrives (e.g., Juno can begin reviewing Sibyl's research while Faber and Mercury are still working), proceed on the first notification.

**Rate pacing does not apply to parallel invocations.** Pacing applies to sequential chains where one invocation follows another over time. Multiple calls in the same message are launched simultaneously — there is no "between" to pace.

**Practical ceiling:** launching more than six or seven entities simultaneously on the same machine can create resource contention. The koad:io team is small enough (Sibyl, Faber, Mercury, Veritas, Muse, Janus — six maximum concurrent) that this limit is rarely reached in practice.

> **Verification step:** Write a single orchestrating message that launches Sibyl (research task) and Faber (draft task) in parallel. Both should have `run_in_background: true`. Confirm neither brief depends on the other's output. Count: how many notifications will arrive?

---

## Atom 3.3: The Notification Pattern — How the Orchestrator Learns Work Is Done

When a background Agent tool invocation completes, the orchestrating agent receives a notification. This is the signal that transitions the loop from "waiting" to "observe."

**The orchestrator does not poll.** There is no sleep loop, no periodic `git log` check, no "wait 30 seconds and see if the entity is done." The notification arrives automatically when the entity's session completes. When it arrives, the orchestrator acts.

**What the notification contains:** the entity's final conversational output — whatever the entity said at the end of its session. This output is useful context but it is not the canonical verification. The entity may summarize its work accurately or may describe what it intended to do rather than what it actually committed. The canonical verification is always the git log (covered in depth at Level 4).

**The three-step response to a notification:**

1. Check git log to verify the expected commit is present:
   ```bash
   git -C /home/koad/.<entity>/ log --oneline -5
   ```
   Look for the commit message specified in the brief's completion signal.

2. If the next decision requires reading the entity's content output (not just confirming it was committed), read efficiently. Use `tail -20` on the committed file or `--output-format=json .result` to read the agent's output without scanning the full conversation.

3. Decide what happens next: launch the next entity, file an issue, update Juno's own state, or report to koad.

**Do not wait for all notifications before acting on any.** Each notification is an independent opportunity to verify and decide. If Sibyl finishes and her research does not depend on Faber's draft, act on Sibyl's notification immediately — even if Faber and Mercury are still running. This keeps the judgment loop responsive rather than batch-processing all results at the end.

> **Verification step:** Describe in order the three actions you take when a background entity notification arrives. Do not reference Level 4's content — just name the three steps from memory and state what the canonical verification is.

---

## Atom 3.4: Sequential Chains — When and How to Pace

Sequential chained invocations are required when entity B's task genuinely depends on entity A's output. You launch A, wait for the notification, verify the result, and then launch B — with one required step between the verification and the launch.

**The rate pacing rule (VESTA-SPEC-054 §5):** between sequential entity invocations in a chain, wait 60 seconds.

```bash
# Entity A's notification arrives. You verify git log. Then:
sleep 60
# Now launch entity B
```

**Why 60 seconds:** chained API calls to the same model infrastructure in quick succession can saturate rate limits, causing the second invocation to fail or produce degraded output. 60 seconds is the validated operational floor — tested against the koad:io team's actual usage patterns. Longer is acceptable. Shorter is not.

**What "between" means precisely:** the 60-second sleep happens after A's notification is received and verified, and before B is launched. It is not a polling interval ("sleep 60, then check if A is done"). A is confirmed done first. Then you sleep. Then you launch B.

```bash
# Timeline:
# T=0:    Launch entity A (background)
# T=varies: A's notification arrives
# T=verify: Check git log — A's commit is present
# T=verify+sleep 60: Sleep completes
# T=verify+60s: Launch entity B
```

**The only legitimate use of `sleep` in entity orchestration.** Every other sleep usage in an orchestration session is a code smell:
- `sleep` before checking if an entity is done → polling (wrong; wait for notification)
- `sleep` as artificial delay between parallel launches → unnecessary (parallel launches need no pacing)
- `sleep` inside a loop script → loop scripts are an anti-pattern entirely

The 60-second sleep exists only in the sequential chain pattern. If you find yourself writing `sleep` for any other reason, stop and reconsider the design.

> **Verification step:** Draw or describe the timeline for this scenario: you launch Sibyl to research ICM (background), receive her notification, verify her commit, then launch Faber to write a primer based on Sibyl's research. Where in that timeline does the 60-second sleep go?

---

## Atom 3.5: Parallel vs. Sequential — Applying the Decision

The decision question is always the same: **"Does entity B need to know what entity A found before starting?"**

If yes: sequential with pacing. If no: parallel.

Work through five concrete scenarios from the koad:io team workflow:

| Scenario | Decision | Rationale |
|----------|----------|-----------|
| Sibyl researches topic X; Faber drafts a Day 7 brief (unrelated topic) | **Parallel** | Neither output depends on the other. Both can start simultaneously. |
| Sibyl researches ICM; Faber writes a primer using Sibyl's synthesis as source | **Sequential + pacing** | Faber cannot start without `research/icm-synthesis.md`. Launch Sibyl, verify commit, sleep 60s, launch Faber with Sibyl's synthesis referenced in the brief. |
| Faber drafts Day 7 content; Veritas reviews Faber's Day 6 draft (a different artifact) | **Parallel** | Both work on Faber's outputs, but neither depends on the other's result. Independent tasks run simultaneously. |
| Sibyl researches whether ICM is already documented; Juno decides whether Faber should write a primer | **Sequential** | Juno (the orchestrator) must observe Sibyl's result before making the decision. This is not about Faber's dependency — it is about the orchestrator's judgment step. |
| Faber drafts Day 7; Mercury prepares a distribution checklist for the same day | **Parallel** | Distribution planning does not require the draft to be complete. They are independent preparations for the same delivery date. |

**The common mistake to name explicitly:** treating the orchestrator's desire to review as a dependency. "I want to review Sibyl's research before starting Faber" is not a data dependency — it is a preference. If Faber's task is genuinely independent of Sibyl's output, launch both in parallel. Review Sibyl's research when her notification arrives. Your review is for your own knowledge; it does not block Faber.

The moment you conflate "I want to see this first" with "Faber needs this to start," you have introduced false sequencing. The rule catches it: "Does Faber need to know what Sibyl found before starting?" Not "does the orchestrator want to read it first."

**Summary:** parallel unless there is a genuine data dependency. Rate pace every sequential chain. Never use sleep for any other purpose.

> **Verification step:** Classify each of these three scenarios as parallel or sequential (with rationale): (1) Sibyl researches koad:io philosophy, Faber updates the BUSINESS_MODEL.md draft. (2) Faber commits a new draft, Veritas reviews that specific draft. (3) Mercury prepares distribution assets, Muse creates UI mockups for the same release.

---

## Exit Criterion

The operator can:
- Write a message containing two or more parallel Agent tool invocations with `run_in_background: true`
- State the notification pattern and what to do when a notification arrives
- State the 60-second rate pacing rule and explain when it applies vs. when it does not
- Correctly classify five given orchestration scenarios as "parallel" or "sequential with pacing"

**Verification question:** "You want Sibyl to research topic A and Faber to research topic B simultaneously. You also want Veritas to review Faber's previous work. Can all three run in parallel?"

Expected answer: Yes — all three are independent tasks. None depends on another's output. Launch all three in the same message with `run_in_background: true`. No rate pacing needed.

---

## Assessment

**Question:** "You launch entity A and wait for its notification. You then want to launch entity B, whose task does not depend on A's output. Should you sleep 60 seconds before launching B?"

**Acceptable answers:**
- "No — rate pacing applies to sequential chains where one entity's output is another's input. If B is independent of A, they should have been launched in parallel. Sleeping 60 seconds before launching B is unnecessary if B does not depend on A. However, if you are launching them sequentially for other reasons, the 60-second pacing still applies to avoid rate limit saturation."
- The nuanced answer: rate pacing applies whenever you are chaining API calls sequentially, regardless of dependency. The 60-second rule is a platform constraint, not a logical requirement. If B is independent, launch both in parallel and avoid the issue entirely.

**Red flag answers:**
- "Always sleep 60 seconds between entity invocations" — pacing applies to sequential chains, not to parallel invocations in the same message

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

The parallel-first mindset is the key installation for this level. Operators who have worked sequentially in single-entity operation will default to sequential multi-entity operation. The level's job is to break that habit: "what can run simultaneously?" should be the first question, not "what should I do first?"

The notification pattern atom (3.3) requires some care. Operators may be used to either blocking calls (you wait) or fire-and-forget (you never check). The background notification pattern is different: you do not wait, but you do check when notified. The check is via git log, not via output parsing — which is the Level 4 content. Frame the notification check here as "when you get the notification, go to the git log check procedure — which Level 4 will teach you."

The rate pacing atom (3.4) should be brief and concrete. 60 seconds. Sequential chains only. After completion notification, not before. One sleep command, not a polling loop. These four facts are the whole rule.

---

### Bridge to Level 4

You can launch entities and receive their notifications. Level 4 teaches the verification step: when a notification arrives, how do you confirm the work actually happened? The answer is git log — but it takes a full level to understand why git log is the ground truth and how to read it efficiently.
