---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 4
slug: output-verification
title: "Output Verification — Git Log as Ground Truth"
status: authored
prerequisites:
  curriculum_complete:
    - commands-and-hooks
  level_complete:
    - multi-entity-orchestration/level-03
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 4: Output Verification — Git Log as Ground Truth

## Learning Objective

After completing this level, the operator will be able to:
> Run the standard git log verification command against any entity directory, explain why git log is the canonical verification method (not agent output parsing), read entity output efficiently using `tail -20` or `--output-format=json .result`, and describe what to do when the expected commit is not present after notification.

**Why this matters:** Agent output is conversational. An entity may describe what it did, narrate its progress, and produce intermediate explanations — none of which constitute a verified result. The entity's commits are the ground truth. If the entity committed work, git log shows it. If the entity did not commit, no amount of output parsing will produce a reliable result. Verification is how the observe step in the judgment loop becomes actionable.

---

## Knowledge Atoms

## Atom 4.1: Why Git Log, Not Output Parsing

Agent output is conversational. When Sibyl finishes a research synthesis, she may say "I have completed the ICM synthesis and committed it to `research/icm.md`." In a different session, she may say "The research is saved — see `research/icm.md` for the full synthesis." Both sentences mean the same thing, and neither is reliably parseable. The structure varies. The phrasing varies. The file path may or may not appear in the output at all.

This variability is not a flaw in the entity — it is the nature of conversational output from a language model. VESTA-SPEC-054 §3.1 makes the principle explicit: "Agent output is conversational. An entity may explain what it did, describe what it found, or produce intermediate text that does not represent the actual committed result. Parsing this output for structured data is fragile and unnecessary."

The alternative is the entity's commits. A commit either exists in git history or it does not. The file is at the specified path or it is not. No interpretation is required. `git -C /home/koad/.sibyl/ log --oneline -5` returns a list of commit messages. The expected message prefix is either in that list or absent. This is certainty, not inference.

The practical rule that follows from this: every verification step in the judgment loop uses git log as the first check. Text output is supplementary — you read it only when the next decision depends on what the entity found, not to confirm that the entity found anything at all. Verification and decision-input are different operations. Git log handles verification. Output reading, when it happens, handles decision-input.

An entity that commits a file has created a permanent, verifiable record. An entity that describes what it did has created text. Treat them as what they are.

> **Verification step:** Pull the current state of any entity directory and run `git -C /home/koad/.<entity>/ log --oneline -5`. Note the format — one line per commit, hash prefix, message. This is what you will read after every background task notification.

---

## Atom 4.2: The Standard Verification Command

The standard verification command from VESTA-SPEC-054 §3.2:

```bash
git -C /home/koad/.<entity>/ log --oneline -5
```

Each part has a specific purpose. `-C /home/koad/.<entity>/` sets the working directory for the git command without requiring a `cd` — this means you can check multiple entity directories in rapid succession from a single shell context. `log --oneline` prints one line per commit: the short hash followed by the commit message. `-5` limits output to the five most recent commits.

What to look for: the expected commit message prefix from the completion signal in your invocation brief. If Sibyl was briefed to "commit your synthesis to `research/icm.md` with the message prefix `research:`", you are scanning for a line that begins with a hash and contains `research:`. That line's presence confirms the work was done.

Why five commits is sufficient: the work assigned in a single invocation brief should produce a small number of commits — typically one. If the expected commit is not in the most recent five, either the work was not done, or the entity committed many other things before completing the assigned task (which itself warrants investigation). Five is not arbitrary; it is a window sized for single-session assignments.

Checking three entities in parallel after background tasks complete:

```bash
git -C /home/koad/.sibyl/ log --oneline -5
git -C /home/koad/.faber/ log --oneline -5
git -C /home/koad/.mercury/ log --oneline -5
```

Three commands, three log snapshots, under a minute. The orchestrator now knows the committed state of all three entities and can make the next decision from confirmed ground truth.

> **Verification step:** After running three entity invocations in parallel (from Level 3), use this exact pattern to check all three directories. Confirm that each shows the commit message prefix you specified in the corresponding brief's completion signal.

---

## Atom 4.3: Reading Output Efficiently — When Text Matters

Git log answers "was the work done?" Text output answers "what did the entity find?" These are different questions, and only the second one sometimes requires reading output at all.

The scenario where output reading matters: Sibyl researched the ICM pattern. Git log confirms the research synthesis was committed. But Juno's next decision — whether to send the synthesis to Faber for a content draft, or to Veritas for a quality review first — depends on the content of the synthesis. Now the output text is decision-relevant. Read it.

Read it efficiently. Two patterns from VESTA-SPEC-054 §3.3:

**Pattern 1: `tail -20`**
For most entity responses, the conclusion, summary, and key findings appear at the end of the output. The first two-thirds is scaffolding, reasoning, and intermediate steps. Reading the last 20 lines captures the conclusion without consuming the full transcript.

**Pattern 2: `--output-format=json .result`**
When invoking the Agent tool with `--output-format=json`, the final result is isolated in the `.result` field of the JSON output. This is the cleanest extraction method when the entity was briefed to produce a specific result rather than a conversational response.

Why not `cat` the full output: agent session output files can be large — hundreds of lines of tool calls, intermediate reasoning, and scaffolding. Passing the full output through the orchestrator's context window when only the conclusion matters wastes context capacity. The orchestrator handles multiple entities; context is finite.

The ordering is always: git log first, output reading second and only if the next decision requires content. An operator who reads output before checking git log may be processing text from an entity that did not finish the task.

> **Verification step:** After confirming a background task's commit via git log, identify whether the next launch depends on the entity's findings or only on whether the work was done. If it depends on findings, practice reading the last 20 lines of the output rather than the full session.

---

## Atom 4.4: What to Do When the Expected Commit Is Missing

You run `git -C /home/koad/.sibyl/ log --oneline -5` and the expected commit prefix is not there. This is not a failure mode that ends the session — it is a diagnostic moment. Three possible causes, each with a different response.

**Cause 1: The entity did not finish.** It hit a tool error, a context limit, or a logical dead end. The output will typically explain what happened — there will be an error message or a statement like "I was unable to access the required data." Check via `tail -20` of the output file.

**Cause 2: The completion signal was absent or unclear in the brief.** The entity completed its work but did not know what to commit or where to commit it. It may have written findings to the session only. This is a brief authoring failure — the completion signal was missing or underspecified (Level 2's lesson). The work may exist in the session but not in git.

**Cause 3: The entity committed with a different message than expected.** The work is done and committed, but the commit message does not match the expected prefix. Expand the log window:

```bash
git -C /home/koad/.<entity>/ log --oneline -10
```

Scan the expanded window for the content of the work, not the expected prefix.

**Diagnostic sequence:**

1. Expand log to `-10` — check if the commit exists with an unexpected message
2. Read entity output with `tail -20` — check for errors or explanation
3. If the entity explains a blocker → file a GitHub Issue so the blocker is tracked
4. If the entity completed work to an unexpected path → read the output to locate the file; decide whether to accept it or re-invoke with a corrected brief
5. If the entity clearly did not finish → re-invoke with a clearer brief and an explicit completion signal

The missing commit is the decide moment. What does its absence tell you about what should happen next? That question drives the diagnostic sequence.

> **Verification step:** Simulate a missing commit by checking an entity directory that has not been recently invoked. Run the standard `-5` check, then expand to `-20`. Practice reading the commit history to determine whether recent work matches an expected pattern.

---

## Atom 4.5: Verification as the Observe Step — Connecting to the Loop

Verification is the observe step of the launch-observe-decide loop. The orchestrator launches (Levels 1–3), observes (Level 4), then decides (Levels 5–6). Until this level, the loop was described abstractly. This level makes the observe step concrete: it is git log, in sequence, for each entity that was launched.

The complete observe step, written as a procedure:

1. Background task notification arrives
2. Run `git -C /home/koad/.<entity>/ log --oneline -5`
3. Confirm the expected commit is present — or begin the diagnostic sequence from Atom 4.4
4. If the next decision requires knowing what the entity found, read output via `tail -20`
5. State of each invoked entity is now confirmed — ready to decide

For three entities launched in parallel (Level 3), the observe pass runs three git log checks in sequence. Each check takes seconds. Total observe pass for three entities: under two minutes.

The stakes of skipping verification are asymmetric. An orchestrator who skips the observe step and moves directly to the decide step is making decisions based on assumed outcomes. If Sibyl appears to have finished but did not actually commit — if she completed the work in session but the completion signal was missing — the orchestrator who skips verification sends Faber a brief with a non-existent research file path. Faber's invocation fails or produces an incomplete draft. One skipped git log check cascades into a failed downstream task.

The orchestrator who verifies is making decisions based on confirmed state. The 30 seconds spent on git log is not overhead — it is the foundation for every decision that follows.

One complete iteration of the loop, with verification:

```
launch Sibyl
    ↓  (work happens)
notification arrives
    ↓
git -C /home/koad/.sibyl/ log --oneline -5  ← observe step
    ↓  (commit confirmed)
decide: launch Faber with Sibyl's synthesis as context
    ↓
sleep 60
    ↓
launch Faber  ← next loop iteration begins
```

> **Verification step:** After any entity background task completes, make git log verification the first action before any subsequent invocation. Build the reflex: notification → git log → decide. Do not invert the order.

---

## Exit Criterion

The operator can:
- Run the standard git log verification command against any entity directory
- Explain why git log is the canonical verification method rather than output parsing
- Read entity output efficiently using `tail -20` rather than `cat`
- Diagnose a missing expected commit using the three-possibility framework
- Describe the complete observe step of the judgment loop

**Verification question:** "Sibyl's background task notification has arrived. How do you verify that the research synthesis was committed?"

Expected answer: `git -C /home/koad/.sibyl/ log --oneline -5` — look for the expected commit message from the completion signal in the five most recent commits. If it is present, the work is done. If not, check the output for errors or run with `-10` to see more history.

---

## Assessment

**Question:** "Sibyl's output says 'I have completed the ICM synthesis and saved it to research/icm.md.' Is the work verified?"

**Acceptable answers:**
- "Not yet. The entity's output is conversational and does not confirm a commit. Run `git -C /home/koad/.sibyl/ log --oneline -5` to confirm the commit is in git history. If the commit is there, the work is verified. If not, the entity may have written the file without committing it."
- "Output is supplementary, not verification. Check git log."

**Red flag answers:**
- "Yes, the entity said it saved the file" — agent output does not confirm a commit; only git log does

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

This level is the most directly practical in the curriculum. The verification command (`git -C ... log --oneline -5`) is short and memorable. Have the operator run it against three entity directories — any three that exist on the system — and observe what they see. Even if the entities have not been actively working, seeing real git history from real entity directories makes the command concrete.

The "why not output parsing" argument (Atom 4.1) needs to be delivered with conviction. Operators who have done text parsing in other contexts will resist this — it feels like the orchestrator is leaving information on the table. The reframe is: commits are the source of truth; output is context. You are not losing information by using git log; you are reading from the authoritative record instead of the conversational transcript.

The missing-commit diagnostic (Atom 4.4) should be delivered as a practical troubleshooting sequence, not a theory. "Here is what you check, in order." Operators who have this sequence memorized will recover from verification failures gracefully; operators who do not will spend five minutes reading full output files trying to figure out what happened.

---

### Bridge to Level 5

You can launch entities, run them in parallel or in paced sequences, and verify that their work was committed. Level 5 covers the other half of the "observe then decide" structure: when should the work be an Agent tool invocation versus a GitHub Issue, and how do you make that decision correctly?
