---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 6
slug: anti-patterns-and-the-judgment-loop
title: "Anti-Patterns and the Judgment Loop"
status: scaffold
prerequisites:
  curriculum_complete:
    - commands-and-hooks
  level_complete:
    - multi-entity-orchestration/level-05
estimated_minutes: 30
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 6: Anti-Patterns and the Judgment Loop

## Learning Objective

After completing this level, the operator will be able to:
> Name all five orchestration anti-patterns from VESTA-SPEC-054 §9, state what is wrong with each, identify the correct alternative for each, and execute the complete launch-observe-decide loop for a three-entity orchestration sequence from scratch.

**Why this matters:** All five anti-patterns represent ways to have the mechanics right but the judgment wrong. An operator who can invoke the Agent tool, run parallel tasks, and verify via git log — but who pre-scripts chains, spawns observed sessions for routine delegation, or parses output for structured data — is technically competent and operationally fragile. This level closes the gap between mechanical skill and orchestration discipline.

---

## Knowledge Atoms

## Atom 6.1: The Five Anti-Patterns — Named and Explained

[STUB — Content to be authored]

Core content to cover:
- All five anti-patterns from VESTA-SPEC-054 §9, in full:

  **Anti-pattern 1: Loop Scripts**
  Writing shell scripts that loop over entity invocations. The `/loop` skill does not exist in this context. The daemon worker system is the right mechanism for recurring automated work. Loop scripts bypass the observe-and-decide step. The operator who writes a loop script has pre-decided that all iterations will succeed and that no intermediate result requires a change of plan.

  **Anti-pattern 2: Blocking Sequential Invocations Without a Decision Point**
  Launching entity A, waiting, launching B, waiting, launching C — when A's output does not inform what B should do. If A, B, and C are independent, they should run in parallel. Sequential execution of independent tasks is not safety; it is unnecessary coupling that adds latency without adding information.

  **Anti-pattern 3: Parsing Agent Output for Structured Data**
  Extracting filenames, counts, or structured results by parsing the conversational text of an agent's output. The entity should commit structured data to a file; the orchestrator reads that file with the Read tool after verifying via git log. Output parsing is fragile (output format varies), unnecessary (commits are authoritative), and a symptom of missing completion signals in the brief.

  **Anti-pattern 4: Spawning Observed Sessions for Routine Delegation**
  Using `juno spawn process` to launch entities for routine background work. Observed sessions add overhead (OBS, terminal window), do not return results to Juno, and are designed for koad to watch — not for Juno to orchestrate. Defaulting to observed mode for delegation is using the wrong tool.

  **Anti-pattern 5: Agent Tool for Simple File Reads**
  Launching an Agent session to read another entity's current state, PRIMER.md, or recent commits. This consumes a subagent context window for a task that the Read, Grep, or Bash tools can accomplish directly. The judgment test (Atom 6.3) exists specifically to prevent this.

---

## Atom 6.2: Each Anti-Pattern Reduces to a Judgment Failure

[STUB — Content to be authored]

Core content to cover:
- Each anti-pattern is not a random mistake — it reflects a specific failure in the judgment loop:
  - Loop scripts → replacing the decide step with pre-made decisions ("the next entity always runs regardless of outcome")
  - Blocking sequential without decision point → replacing the parallel opportunity with unnecessary sequencing (failure to ask "can these run simultaneously?")
  - Parsing agent output → replacing the git log check with a fragile proxy (failure to use the authoritative source)
  - Observed sessions for routine work → using the wrong invocation mechanism (failure to distinguish coordinated from observed work)
  - Agent tool for file reads → applying task-delegation overhead to an information-retrieval operation (failure to ask "does this require judgment?")
- The unifying theme: all five anti-patterns bypass or substitute for a judgment step in the loop. The operator who avoids them is not following rules — they are making better judgments.
- Each anti-pattern has a correct alternative:
  - Loop scripts → daemon worker system for recurring work, judgment loop for current work
  - Blocking sequential without decision point → parallel invocations in a single message
  - Parsing agent output → completion signals in briefs, Read tool after git log verification
  - Observed sessions → Agent tool with `run_in_background: true`
  - Agent tool for file reads → Read, Grep, Bash tools directly after `git pull`

---

## Atom 6.3: The Judgment Test — Before Every Agent Tool Invocation

[STUB — Content to be authored]

Core content to cover:
- From VESTA-SPEC-054 §8.2: "Before launching an Agent invocation, ask: does this require the entity's judgment, or just its files?"
- If the answer is "just its files" — use dedicated tools. Pull the entity's repo, read the file, grep for the pattern.
- If the answer is "this requires the entity to reason, decide, and commit work" — use the Agent tool.
- The dedicated tools for file-access operations (from VESTA-SPEC-054 §8.1):
  | Operation | Correct tool |
  |-----------|-------------|
  | Read a file from another entity's directory | `Read` tool (after `git pull`) |
  | Search for a pattern across entity files | `Grep` tool |
  | Find files by name pattern | `Glob` tool |
  | Check another entity's recent commits | `Bash: git log` |
  | Read an entity's PRIMER.md | `Read` tool |
  | Check GitHub Issue status | `Bash: gh issue view` |
- The judgment test prevents anti-pattern 5 (Agent tool for file reads) and is also a useful forcing function for anti-patterns 1 and 2: if the "task" is "loop over these entities and do the same thing to each," the correct answer is that recurring automated work belongs in the daemon worker system, not an ad-hoc invocation chain.

---

## Atom 6.4: The Complete Judgment Loop — A Worked Example

[STUB — Content to be authored]

Core content to cover:
- Walk through a complete three-entity orchestration sequence demonstrating the judgment loop at each step:
  - **Starting state:** Juno has identified that Day 7 content needs to be researched, drafted, and reviewed before Mercury can distribute.
  - **Launch (step 1):** Juno checks: can Sibyl (research) and Faber (draft) run in parallel? No — Faber needs Sibyl's research. Launch Sibyl first.
  - **Observe (step 1):** Sibyl's notification arrives. `git -C /home/koad/.sibyl/ log --oneline -5` confirms the research commit. Read `tail -20` of Sibyl's output to get the research summary for Faber's brief.
  - **Decide (step 1):** Research looks solid. Proceed to Faber with the research as cross-entity context. Sleep 60 seconds (sequential chain).
  - **Launch (step 2):** Invoke Faber with a brief that includes Sibyl's research finding as cross-entity context and a completion signal specifying the draft path.
  - **Observe (step 2):** Faber's notification arrives. git log confirms the draft commit at the expected path.
  - **Decide (step 2):** Draft is ready. Can Veritas review it? Check if Veritas has context needed — she does not need any cross-entity context beyond the draft path. Launch Veritas. Also check: does Mercury need to wait for Veritas? Yes — distribute only after review. File a note.
  - **Launch (step 3):** Invoke Veritas with the draft path and a completion signal specifying where to commit review notes.
  - **Observe (step 3):** Veritas's notification arrives. git log confirms review notes committed. Read the notes via `tail -20`.
  - **Decide (step 3):** Review notes show no blocking issues. Mercury can now distribute. But Mercury credentials are not configured (known state from CLAUDE.md). File a GitHub Issue: "Mercury: distribute Day 7 when credentials are live."
- The sequence shows five judgment moments. No step was pre-decided before the prior step's output was observed.

---

## Atom 6.5: Operator Exercise — Run Your First Multi-Entity Orchestration

[STUB — Content to be authored]

Core content to cover:
- This is the integration exercise. The operator runs an actual two-entity orchestration sequence from scratch.
- **Exercise:**
  1. Identify two entity directories available on the system (e.g., `~/.sibyl/` and `~/.faber/`, or whatever is available).
  2. Run `git pull` on both entities before invoking either.
  3. Write a brief for entity A with all four components. Include a completion signal specifying a verifiable file path and commit message prefix.
  4. Invoke entity A via the Agent tool with `run_in_background: true`.
  5. When the notification arrives, run git log verification. Confirm the expected commit.
  6. Apply the judgment test: is entity B's task independent of A's output, or dependent?
  7. If independent: launch B without waiting (parallel would have been the correct original choice — note this for next time).
  8. If dependent: read A's output efficiently, write B's brief with A's context, sleep 60 seconds, launch B.
  9. Verify B's work via git log.
- What success looks like: two entities completed their assigned work, both verified via git log, no anti-patterns applied, the judgment at step 6 was made consciously.
- What to commit after: Juno commits a state update to her own repo noting the orchestration sequence — which entities were invoked, what they produced, what the next step is. This closes the loop in the record.

---

## Exit Criterion

The operator can:
- Name all five anti-patterns and state the correct alternative for each
- Apply the judgment test to any proposed Agent tool invocation
- Walk through the complete launch-observe-decide loop for a three-entity sequence
- Execute a two-entity orchestration exercise demonstrating the judgment loop in practice

**Verification question:** "You want to check what is in Sibyl's current `research/` directory before deciding what to research next. Should you invoke Sibyl via the Agent tool?"

Expected answer: No — this is a file-read operation, not a judgment task. Use the Read tool (after `git pull` on `~/.sibyl/`) or `Bash: ls /home/koad/.sibyl/research/`. The Agent tool is for tasks requiring Sibyl's judgment; reading a directory listing requires only her files.

---

## Assessment

**Question:** "Describe loop scripts as an anti-pattern. What is wrong with them, and what is the correct alternative?"

**Acceptable answers:**
- "Loop scripts bypass the observe-and-decide step by pre-deciding that all iterations will succeed. They cannot respond when an entity surfaces a blocker or produces unexpected output. The correct alternative for recurring automated work is the daemon worker system. For current work requiring judgment at each step, the operator uses the judgment loop: launch one entity, observe its output, decide the next step."

**Red flag answers:**
- "Loop scripts are fine if all the entities always succeed" — the problem is not handling failure; it is removing judgment from intermediate decisions regardless of outcome

**Estimated engagement time:** 25–30 minutes

---

## Alice's Delivery Notes

This level is the synthesis. By now, operators have all the mechanics. Level 6's job is to connect those mechanics to the judgment principle and make the anti-patterns recognizable in the field.

The five anti-patterns should be delivered as a coherent set, not as a list. The unifying framing (each anti-pattern bypasses a judgment step) makes them memorable as a group rather than five isolated rules.

The judgment test (Atom 6.3) is the most practically useful thing in this level. Walk through the table from VESTA-SPEC-054 §8.1 and have the operator state which tool to use for each operation. The table is short — five minutes to internalize, prevents a common category of errors.

The worked example (Atom 6.4) should be read carefully. It demonstrates five judgment moments. If time allows, walk through the example interactively — pause at each "decide" step and ask the operator "what would you do here?" before revealing the answer.

The integration exercise (Atom 6.5) is the capstone. If the operator's environment does not have Sibyl and Faber available, adapt with whatever entity directories are accessible. The mechanics are the same regardless of which entities are used.

---

### Curriculum Completion

You have completed the Orchestrator Path's first curriculum. You can:
- Invoke entities as local subagents using the Agent tool
- Author complete context briefs with all four required components
- Run parallel and sequential entity invocations with correct pacing
- Verify entity work using git log as the ground truth
- Classify work correctly as Agent tool or GitHub Issues
- Apply the judgment test before every invocation
- Name and avoid all five orchestration anti-patterns
- Execute the launch-observe-decide loop from start to finish

The Orchestrator Path continues as the team grows: content-pipeline-operations (when Veritas, Muse, Mercury, and Sibyl are all gestated and operational) will walk the full production-to-distribution loop that this curriculum has taught you to orchestrate.
