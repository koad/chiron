---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 0
slug: the-orchestration-mental-model
title: "The Orchestration Mental Model — Launch, Observe, Decide"
status: scaffold
prerequisites:
  curriculum_complete:
    - commands-and-hooks
  level_complete: []
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 0: The Orchestration Mental Model — Launch, Observe, Decide

## Learning Objective

After completing this level, the operator will be able to:
> State the launch-observe-decide loop in their own words, explain why orchestration is a judgment loop rather than a pipeline, and identify the failure that occurs when operators pre-script entity chains without observing intermediate results.

**Why this matters:** The most destructive mistake in multi-entity orchestration is treating entities as pipeline stages — input goes in, output comes out, send it to the next stage. Entities are not functions. They surface blockers, produce partial results, find things that change the plan. An operator who pre-scripts a chain of five entity invocations before any work begins cannot respond to what actually happens. The judgment loop is not a best practice; it is what makes orchestration different from scripting.

---

## Knowledge Atoms

## Atom 0.1: What Changes When You Have Multiple Entities

[STUB — Content to be authored]

Core content to cover:
- Single-entity operation is sequential: spawn, task, read, commit. The operator is the director; the entity is the worker.
- Multi-entity operation introduces a new problem: whose output do you read first? What does entity A's result mean for what entity B should do?
- The change is not just mechanical (more entities to launch) but conceptual: the operator becomes an orchestrator whose job is to make decisions based on incomplete information arriving asynchronously.
- Concretize with the koad:io team workflow: Juno identifies an opportunity → Sibyl researches → Faber drafts → Mercury distributes. Each step's output shapes the next step. This is not a deterministic pipeline — Sibyl may find that the "opportunity" is already covered, or Faber may draft something that requires a different distribution channel than Mercury normally uses.
- The operator who understands multi-entity operation understands that they are managing decisions, not managing scripts.

---

## Atom 0.2: The Three Moments — Launch, Observe, Decide

[STUB — Content to be authored]

Core content to cover:
- **Launch:** The operator decides what work needs doing and which entities are equipped to do it. They invoke the entities — in parallel if independent, one at a time if sequential. The launch is not the whole plan; it is the current step.
- **Observe:** After entity work completes (notification received), the operator checks git log to confirm the work happened. They may also read the entity's output if the next decision depends on what the entity found.
- **Decide:** Based on what was completed, the operator decides the next action. This might be launching another entity, filing a GitHub Issue, committing a state update, or reporting to koad. The decision is made with information, not ahead of it.
- Why this is called a loop: the decide step produces the next launch. The loop terminates when the orchestration goal is achieved or a blocker that requires human action is surfaced.
- Contrast with pipeline: in a pipeline, the "decide" step is pre-made — "entity A outputs to entity B always." In the loop, decide is live. The operator reads A's output and chooses whether to go to B, go to C, file an issue, or stop.

---

## Atom 0.3: Why Not Pre-Scripted Chains

[STUB — Content to be authored]

Core content to cover:
- Pre-scripted chains assume all steps will succeed and their outputs will be as expected. They convert autonomous orchestration into rote execution.
- Three failure modes of pre-scripted chains from VESTA-SPEC-054 §4.4:
  1. An entity surfaces a blocker that changes what the next step should be
  2. An entity produces a result that makes one of the downstream steps unnecessary
  3. An entity fails, requiring human judgment before proceeding
- Pre-scripted chains bypass the observe-and-decide step. The operator who pre-scripts a three-step chain is betting that all three steps will go as expected. The entities do not know they are in a chain. They operate normally. The world may not cooperate with the script.
- The correct model: one step, observe, decide. Even if the expected chain is three steps, the chain emerges from decisions — it is not pre-declared.
- This is why loop scripts (shell scripts that iterate over entity invocations) are an anti-pattern. The daemon worker system is the right mechanism for recurring automated work; ad hoc loops bypass judgment.

---

## Atom 0.4: Sequential vs. Parallel — When to Use Each

[STUB — Content to be authored]

Core content to cover:
- **Parallel invocation:** When entities A, B, and C are working on independent tasks whose outputs do not depend on each other, launch all three simultaneously. Each gets `run_in_background: true`. Results arrive asynchronously. The orchestrator proceeds when all notifications are received.
- **Sequential invocation:** When entity B's task requires entity A's output as input (A's result informs what B should do), launch A first, observe, then launch B. This is the "chained" case — and it requires rate pacing (60 seconds between calls).
- The question that determines which to use: "Does entity B need to know what entity A found before starting?" If yes: sequential. If no: parallel.
- Common mistake: launching sequentially when parallel would do — waiting for A to finish before starting B even when B's task is entirely independent. This adds unnecessary latency and implies a dependency that does not exist.
- Common mistake: launching in parallel when sequential is required — B starts before A finishes and operates on stale or absent output.

---

## Atom 0.5: The Orchestrator's Role — Decisions, Not Scripts

[STUB — Content to be authored]

Core content to cover:
- The orchestrator (Juno, or any entity running the team) is not executing a predetermined plan. They are making a series of decisions, each informed by the latest state.
- Three questions the orchestrator answers at every loop iteration:
  1. What is done? (git log verification)
  2. What does what is done tell me? (reading output, if needed)
  3. What should happen next? (the decide step)
- The orchestrator's job is to maintain the judgment loop, not to manage the entities. The entities manage themselves; the orchestrator manages the sequence of decisions.
- This is why orchestration fails when automation replaces judgment: automated chains can execute faster, but they cannot decide. An orchestrator who has been automated away is an orchestrator who has pre-decided every outcome before the work begins.
- The curriculum is about equipping the operator to be an effective orchestrator: not faster, but better-informed and more responsive.

---

## Exit Criterion

The operator can:
- State the launch-observe-decide loop in their own words
- Explain why pre-scripted entity chains are incorrect orchestration
- Identify whether two given entity tasks should run in parallel or sequentially, with a rationale
- Describe the orchestrator's role as decision-maker, not script-runner

**Verification question:** "You plan to have Sibyl research a topic, then have Faber write a draft based on the research. Can you launch both at the same time?"

Expected answer: No — Faber's draft depends on Sibyl's research output. This is a sequential dependency. Launch Sibyl, observe (verify the research is committed), then launch Faber with Sibyl's research as context.

---

## Assessment

**Question:** "What is wrong with writing a shell script that loops over five entity invocations in sequence and launches each one without reading the previous one's output?"

**Acceptable answers:**
- "It bypasses the observe-and-decide step. If any entity surfaces a blocker or produces unexpected output, the script cannot respond — it will keep launching the next entity regardless of what happened."
- "Pre-scripted chains assume all steps succeed as expected. The loop removes the orchestrator's judgment from the process."

**Red flag answers:**
- "Nothing, as long as the entities complete successfully" — misses the point; the problem is not failure handling but the removal of judgment from intermediate steps

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

This level establishes the mental model before any mechanics arrive. Operators arriving from commands-and-hooks have been operating single entities. The conceptual shift to orchestration is subtle — it is not just "more entities" but "different role for the operator."

The pre-scripted chain failure mode is the most important thing to install. Operators who have not been explicitly told that chains are wrong will write them. They are intuitive: "I know step A produces output, and step B consumes it, so I can script that." The problem is that "step A produces output" is an assumption, not a guarantee.

Use the Juno team workflow as the running example: Sibyl researches → Faber drafts → Mercury distributes. Walk through one real scenario where Sibyl's research changes the plan for Faber. Make the loop concrete before calling it a principle.

Do not introduce the Agent tool in this level. Level 0 is about judgment, not mechanics. Operators who are impatient to "start doing something" should be told explicitly: "You will write your first Agent tool invocation in Level 1. This level gives you the mental model that makes Level 1 go correctly."

---

### Bridge to Level 1

You have the loop. Level 1 introduces the mechanism that makes the launch step concrete: the Agent tool. It is the standard way to invoke a koad:io entity as a local subagent — the thing you use at the beginning of every launch phase.
