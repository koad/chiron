---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 0
slug: the-orchestration-mental-model
title: "The Orchestration Mental Model — Launch, Observe, Decide"
status: authored
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

When you operated a single entity, the mental model was straightforward: spawn it, give it a task, read what it committed, move on. You were the director; the entity was the worker. The sequence was yours to control because there was only one thread of work.

Multiple entities break that model — not mechanically, but conceptually. The moment you have two entities working at the same time, a new class of problem emerges: **whose output do you read first? And what does entity A's result mean for what entity B should do?**

Consider the koad:io team workflow in practice. Juno spots a content opportunity and delegates: Sibyl researches the topic while Faber sketches a draft calendar. Sibyl comes back with a finding — the topic has already been covered extensively by a competitor, and the angle needs to shift. Now Faber's calendar sketch, drafted in parallel, is based on the original angle. The orchestrator must decide: does Faber restart? Pivot mid-draft? Or does Mercury's distribution channel change the calculus entirely?

A single-entity operator would never face this. A multi-entity orchestrator faces it constantly.

The change is not that you have more entities to launch. The change is that **you are now managing decisions, not scripts**. Information arrives asynchronously, outputs are interdependent in ways that cannot be fully predicted in advance, and the plan you had at T=0 may be obsolete by the time the first entity commits its results.

This is the conceptual shift the rest of Level 0 builds on: what the loop looks like, why it cannot be pre-scripted, and what the orchestrator's actual job is.

> **Verification step:** Describe the koad:io team workflow in one sentence (Juno → Sibyl → Faber → Mercury). Now identify one point in that chain where an intermediate output could change what the next entity should do. If you can name that point, you understand why orchestration requires judgment rather than scripting.

---

## Atom 0.2: The Three Moments — Launch, Observe, Decide

Every act of orchestration — regardless of how many entities are involved or how long the work takes — passes through the same three moments. Getting fluent with these moments is the core skill of this curriculum.

**Launch.** You identify what work needs doing right now and which entities are equipped to do it. You invoke them — in parallel if the tasks are independent, sequentially if one depends on another's output. The launch is not the whole plan; it is the current step. You do not pre-declare what comes after until you see what comes back.

**Observe.** When entities complete, you check that the work actually happened. The canonical check is `git -C /home/koad/.<entity>/ log --oneline -5` — you look for the expected commit in the entity's log. If the next decision depends on the content of what the entity produced, you read the output; otherwise, the commit's presence is sufficient. Observation is not passive — it is active verification.

**Decide.** Based on what is now done and what the output contains, you choose the next action. This might be launching the next entity in a sequence, filing a GitHub Issue for a task that spans sessions, committing a state update to Juno's own repo, or sending koad a Keybase notification that a blocker has been resolved. The decision is made with real information — not predictions.

**Why it is called a loop:** the decide step produces the next launch. The loop terminates when the orchestration goal is reached or a blocker surfaces that requires koad's action before proceeding. You do not exit the loop on a pre-declared schedule; you exit it when the state of the world says you are done.

**Contrast with a pipeline:** in a pipeline, the "decide" step is made in advance — "A always feeds B." In the loop, decide is live. After observing A's output, you choose B, or C, or neither. The pipeline removes your judgment from the process. The loop keeps it in.

> **Verification step:** Pick any two-step task you have done with a single entity (e.g., Sibyl researches → you review). Map it to launch, observe, decide. Now ask: if you had Faber also running during Sibyl's research, where in the loop would you make a decision about whether Faber's work changes based on Sibyl's finding?

---

## Atom 0.3: Why Not Pre-Scripted Chains

The instinct to pre-script feels efficient: you can see the whole workflow in advance — research, then draft, then distribute — so why not encode it as a sequence and let it run? The answer is that pre-scripted chains treat entities as functions with predictable inputs and outputs. They are not.

VESTA-SPEC-054 §4.4 identifies three ways pre-scripted chains fail in practice:

**1. An entity surfaces a blocker that changes what the next step should be.** Sibyl researches topic X and finds the key source was just updated with contradictory information. The correct response is for the orchestrator to decide whether Faber should address the contradiction, wait for a resolution, or pivot the topic. A pre-scripted chain that launches Faber immediately after Sibyl regardless of output cannot make this decision.

**2. An entity produces a result that makes a downstream step unnecessary.** Veritas reviews Faber's draft and finds it is already complete and publication-ready. A pre-scripted chain that launches a revision round anyway wastes entity time and potentially introduces regressions.

**3. An entity fails or produces partial output requiring human judgment.** No script can substitute for the orchestrator reading what happened and deciding whether to retry, escalate to koad, or take a different path.

Pre-scripted chains bypass the observe-and-decide step — the exact step that makes orchestration useful. The entities do not know they are in a chain. They operate normally. If the script does not pause to check, it will keep launching the next entity regardless of what the previous one found.

**The correct model:** one step, observe, decide. If you expect a three-step sequence, let it emerge from three decisions. You will end up with the same steps most of the time — and the ability to deviate when reality demands it.

This is also why loop scripts (`for entity in sibyl faber mercury; do invoke "$entity"; done`) are explicitly an anti-pattern. If you need recurring automated work, the daemon worker system is the right mechanism. Ad hoc shell loops remove judgment from the process entirely.

> **Verification step:** Describe a three-step orchestration goal you might want to accomplish. Identify the specific thing you would need to observe at the end of step 1 before safely committing to step 2. If you can name that observation, you understand why the step cannot be pre-scripted.

---

## Atom 0.4: Sequential vs. Parallel — When to Use Each

Not every orchestration decision is about what to launch next. Many are about whether to launch things at the same time or one after another. Getting this right prevents unnecessary latency and prevents incorrect results.

**Parallel invocation** is appropriate when entities A, B, and C are working on tasks whose outputs do not depend on each other. Launch all three in a single message with `run_in_background: true`. Each runs in its own context. Results arrive asynchronously. You proceed as notifications come in.

Example: Juno wants Sibyl to research content pipeline patterns, Faber to update the Day 6 brief format, and Mercury to draft a distribution checklist. None of these outputs depends on another. Launch all three simultaneously. Do not wait.

**Sequential invocation** is required when entity B's task uses entity A's output as its input. A must complete first. B's brief must reference what A produced. Launch A, observe (confirm the commit), then launch B with A's output as context in the brief.

Example: Sibyl researches the ICM pattern, then Faber writes a primer using Sibyl's synthesis as source material. Faber cannot start until `research/icm-synthesis.md` exists and has been read. This is a genuine sequential dependency.

**The decision question:** "Does entity B need to know what entity A found before starting?" Yes → sequential (with rate pacing, covered in Level 3). No → parallel.

**Common mistake 1 — false sequencing:** Launching entities one after another when they are actually independent. This imposes coupling that does not exist and adds needless latency. If you are waiting for Sibyl to finish before starting Faber and Faber's task has nothing to do with Sibyl's research, you are serializing for no reason.

**Common mistake 2 — false parallelism:** Launching B before A finishes when B genuinely depends on A's output. B will operate on missing or stale context and produce results that may be wrong or incomplete.

> **Verification step:** Name two entity tasks from the koad:io workflow that could run in parallel right now. Then name two that must run sequentially. For the sequential pair, state exactly what A must produce before B can start.

---

## Atom 0.5: The Orchestrator's Role — Decisions, Not Scripts

The orchestrator — Juno, or any entity coordinating the team — is not executing a plan. They are making a series of decisions, each informed by the latest state of the work.

At every iteration of the loop, the orchestrator answers three questions:

1. **What is done?** Check `git -C /home/koad/.<entity>/ log --oneline -5` for each entity that was just notified. Confirm the expected commit is present. This is not optional — it is the primary verification mechanism.

2. **What does what is done tell me?** Read the entity's output if the next decision requires it. Often the commit alone is sufficient: if Sibyl committed `research/icm-synthesis.md` as instructed, the research is done. Sometimes the content matters — if Sibyl's synthesis surfaced a blocker, the content tells you what the next step should be.

3. **What should happen next?** Launch the next entity, file a GitHub Issue for work that spans sessions, send koad a Keybase notification, or close the loop because the goal is reached.

The orchestrator's job is to maintain this cycle, not to manage the entities. **The entities manage themselves.** Each one reads its own `CLAUDE.md` and `PRIMER.md`, handles its own git workflow, and delivers committed results. The orchestrator manages the sequence of decisions — which entities are active, in what order, with what context.

This is why orchestration fails when automation replaces judgment: an automated chain can execute faster than any human or AI orchestrator, but it cannot decide. When Sibyl finds something unexpected, the chain does not know what to do with it — it launches Faber anyway. The judgment loop exists precisely to handle the unexpected. An orchestrator who pre-scripts every step has optimized for the expected case and made the unexpected case catastrophic.

The curriculum is not about making you faster at orchestration. It is about making you better-informed and more responsive — so that when the work deviates from the plan (and it always does, eventually), you can adapt rather than cascade through a broken chain.

> **Verification step:** Write down the three questions the orchestrator answers at each loop iteration from memory. Now apply them to the last thing you did with a single entity: what was done, what did it tell you, and what happened next? If you can map it to the loop, you have the mental model.

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
