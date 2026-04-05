---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 3
slug: background-execution-and-parallel-delegation
title: "Background Execution and Parallel Delegation"
status: scaffold
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

[STUB — Content to be authored]

Core content to cover:
- From VESTA-SPEC-054 §2.1: "Entities do independent work. Waiting for entity A to finish before starting entity B is unnecessary coupling when A and B are working on unrelated problems."
- Background execution enables true parallel orchestration. When Sibyl researches and Faber drafts on unrelated topics, they can run simultaneously. The results come in as they complete; the orchestrator does not wait.
- The alternative (blocking sequential, `run_in_background: false`) is appropriate only when the next action cannot be determined until the entity's output is known. This is rare — more often, the orchestrator knows the full plan and can launch all entities simultaneously.
- Background-first is the default. Blocking is the exception. The question to ask before a blocking invocation: "Does the next action depend on what this entity produces?" If yes: block (and pace). If no: background.
- Practical implication: if you are invoking more than one entity, your default assumption should be "can these run in parallel?" Only fall back to sequential when the dependency exists.

---

## Atom 3.2: Running Multiple Entities in Parallel — One Message

[STUB — Content to be authored]

Core content to cover:
- Multiple Agent tool calls in a single message are independent and run in parallel.
- From VESTA-SPEC-054 §2.3, the pattern:
  ```
  Message:
    Agent(cwd=~/.sibyl/, prompt="...", run_in_background=true)
    Agent(cwd=~/.faber/, prompt="...", run_in_background=true)
    Agent(cwd=~/.mercury/, prompt="...", run_in_background=true)
  ```
- All three invocations start simultaneously. Each runs in its own context. The orchestrator receives three separate notifications as each completes.
- When to proceed: either wait for all three notifications before the next decision, or proceed on the first and handle subsequent results as they come in. The choice depends on whether the next action requires all three results or can be triggered by any one.
- No rate pacing needed for parallel invocations — they are simultaneous, not chained. Rate pacing only applies when one invocation follows another sequentially.
- Practical limit: launching too many entities simultaneously risks resource contention. In practice, the koad:io team is small enough (4–6 entities at a time) that this is rarely a concern.

---

## Atom 3.3: The Notification Pattern — How the Orchestrator Learns Work Is Done

[STUB — Content to be authored]

Core content to cover:
- The Bash tool with `run_in_background: true` notifies the orchestrating agent when the background task completes.
- The orchestrator does not poll. Does not use sleep loops while waiting. When the notification arrives, the orchestrator reads git log to verify work was done (covered in detail at Level 4).
- What the notification contains: the background task's output (the entity's conversational response). This output is supplementary — the canonical verification is git log, not parsed output.
- What to do with the notification:
  1. Check git log to verify the expected commit is present.
  2. If the next decision requires reading the entity's output (not just verifying completion), use `tail -20` or `--output-format=json .result` to read it efficiently.
  3. Decide what happens next.
- What not to do: wait for all notifications before checking any. Each notification is an opportunity to verify and decide. Check each as it arrives.

---

## Atom 3.4: Sequential Chains — When and How to Pace

[STUB — Content to be authored]

Core content to cover:
- Sequential chained calls are required when entity B's task depends on entity A's output. The operator launches A, waits for completion, then launches B.
- From VESTA-SPEC-054 §5: between sequential entity invocations in a chain, wait 60 seconds. This is the rate pacing rule.
- Why 60 seconds: chained API calls to the same backing model infrastructure can saturate rate limits. 60 seconds is the validated operational floor. Longer is acceptable; shorter is not.
- Implementation:
  ```bash
  # After entity A's output is received and verified:
  sleep 60
  # Then launch entity B
  ```
- What "chained" means: A completes, then B starts. Not parallel invocations launched in the same message.
- What rate pacing is not: it is not polling. It is not "wait 60 seconds and then check if A is done." The 60-second sleep happens after A's notification is received — after A is confirmed complete, before B is launched.
- The one legitimate use of sleep in entity orchestration. All other sleep usage in orchestration is a code smell (polling, artificial delay, chain scripting).

---

## Atom 3.5: Parallel vs. Sequential — Applying the Decision

[STUB — Content to be authored]

Core content to cover:
- The decision question: "Does entity B need to know what entity A found before starting?"
- Worked examples:
  - Sibyl researches topic X, Faber drafts content Y (unrelated topic) → parallel. Neither depends on the other.
  - Sibyl researches topic X, Faber drafts content based on Sibyl's research → sequential with pacing. Faber cannot start until Sibyl's research is available.
  - Faber drafts Day 7 content, Veritas reviews a different piece of Faber's previous work → parallel. Both work on Faber artifacts, but neither result depends on the other.
  - Sibyl researches ICM, then Juno decides whether to have Faber write a primer → sequential. Juno (the orchestrator) must observe Sibyl's output before making the decision. Then Faber is launched separately with appropriate pacing.
- Common mistake to name: treating a "for completeness" sequential chain as if it were a dependency. "I want to review Sibyl's research before starting Faber" is not a dependency — if Faber's task is independent, launch both in parallel and review Sibyl's output when it arrives. The review is for the orchestrator's knowledge, not for Faber's work.
- Summary rule: parallel unless there is a genuine data dependency. Rate pace all sequential chains.

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
