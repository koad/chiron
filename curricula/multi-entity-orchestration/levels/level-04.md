---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 4
slug: output-verification
title: "Output Verification — Git Log as Ground Truth"
status: scaffold
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

[STUB — Content to be authored]

Core content to cover:
- From VESTA-SPEC-054 §3.1: "Agent output is conversational. An entity may explain what it did, describe what it found, or produce intermediate text that does not represent the actual committed result. Parsing this output for structured data is fragile and unnecessary."
- The entity's commits are the ground truth. The commit exists or it does not. The file is at the specified path or it is not. git log tells the orchestrator which of these is true with certainty.
- Why output parsing is fragile: agent output varies in structure between sessions. The entity may say "I committed the research" in one session and "The synthesis is at research/icm.md" in another. Both mean the same thing; neither is reliably parseable. git log never varies — it shows commits.
- The practical implication: every verification step in the judgment loop uses git log first. Text output is read only if the decision about what to do next depends on what the entity found — not to verify that it found anything at all.
- From VESTA-SPEC-054 §3.1: "The entity's commits are the ground truth. If the entity committed work, git log shows it. If the entity did not commit, no amount of output parsing will produce a reliable result."

---

## Atom 4.2: The Standard Verification Command

[STUB — Content to be authored]

Core content to cover:
- Standard form from VESTA-SPEC-054 §3.2:
  ```bash
  git -C /home/koad/.<entity>/ log --oneline -5
  ```
- What each part does: `-C` sets the working directory without `cd`; `log --oneline` shows one line per commit (hash + message); `-5` limits to five most recent commits.
- What to look for: the expected commit message prefix from the completion signal. If the entity was briefed to commit with "research: ICM pattern synthesis", that string should appear in the five most recent commits.
- Why `-5` is sufficient: if the expected work is not in the five most recent commits, it either was not done or was committed more than five commits ago (which means something went wrong — the entity did a lot of other work before completing the assigned task).
- Checking multiple entities:
  ```bash
  git -C /home/koad/.sibyl/ log --oneline -5
  git -C /home/koad/.faber/ log --oneline -5
  git -C /home/koad/.mercury/ log --oneline -5
  ```
- This pattern is repeatable and fast. Three commands, three log snapshots, thirty seconds. The orchestrator knows the state of all three entities.

---

## Atom 4.3: Reading Output Efficiently — When Text Matters

[STUB — Content to be authored]

Core content to cover:
- Sometimes the next decision depends not just on whether the work was done (git log confirms this) but on what the entity found. In these cases, read the output — but read it efficiently.
- Two patterns from VESTA-SPEC-054 §3.3:
  1. `tail -20 <output-file>` — reads the last 20 lines of the output file. For most entity responses, the conclusion and summary are at the end.
  2. `--output-format=json` and reading `.result` from the JSON — produces structured output that can be read programmatically.
- Why not `cat` the full output: output files can be large. `cat` on a full agent session output file can consume significant context. The orchestrator needs the conclusion, not the full transcript.
- When to read output vs. when git log is enough:
  - Work verification: git log is enough. If the commit is present, the work is done.
  - Decision input: read the output if the next launch depends on the content of the entity's findings (e.g., Sibyl researched — now Juno needs to decide whether the findings warrant a Faber draft or a Veritas review).
- Git log check is always first. Output reading is supplementary and conditional on the next decision.

---

## Atom 4.4: What to Do When the Expected Commit Is Missing

[STUB — Content to be authored]

Core content to cover:
- The expected commit is not in `git log --oneline -5`. Three possible reasons:
  1. **The entity did not finish.** It hit a tool error, a context limit, or a logical dead end. Check the entity's output for error messages or explanation.
  2. **The completion signal was absent or unclear.** The entity completed its work but did not know what to commit or where. (This is a brief authoring failure — Level 2's lesson.)
  3. **The entity committed with a different message.** The git log is there but does not match the expected prefix. Expand the log: `git -C /home/koad/.<entity>/ log --oneline -10` to see more recent commits.
- Diagnostic sequence:
  1. Expand log to -10 to check if the commit exists with an unexpected message
  2. Read entity output (`tail -20`) to check for errors or explanations
  3. If the entity explains a blocker — file a GitHub Issue
  4. If the entity completed work to a wrong path — read the output, locate the file, evaluate whether to re-invoke or accept the result
  5. If the entity clearly did not finish — consider re-invoking with a clearer brief
- The orchestrator's decision (step 4.4's decide moment): what does the missing commit tell me about what should happen next?

---

## Atom 4.5: Verification as the Observe Step — Connecting to the Loop

[STUB — Content to be authored]

Core content to cover:
- Verification is the observe step of the launch-observe-decide loop. The orchestrator launches (Level 1–3), observes (Level 4), then decides (Level 5–6).
- A complete observe step:
  1. Receive the background task notification
  2. Run `git -C /home/koad/.<entity>/ log --oneline -5`
  3. Confirm the expected commit is present (or diagnose the absence)
  4. If the decision requires content: read output efficiently via `tail -20`
  5. Ready to decide
- The observe step takes approximately 30–60 seconds per entity. For three parallel entities, the orchestrator runs three git log checks in sequence — each takes seconds. This is the minimum viable verification pass.
- Why verification matters for the decide step: the orchestrator who skips verification and proceeds directly to the decide step is making decisions based on assumed outcomes. The orchestrator who verifies is making decisions based on confirmed state. The difference compounds over a multi-step orchestration session.
- Closing the loop: the decide step produces the next launch. The observe step feeds the decide step. The launch step starts the work. One iteration of the loop: launch → work happens → notification → git log → decide → launch (next step).

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
