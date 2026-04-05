---
type: curriculum-level
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_slug: multi-entity-orchestration
level: 6
slug: anti-patterns-and-the-judgment-loop
title: "Anti-Patterns and the Judgment Loop"
status: authored
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

VESTA-SPEC-054 §9 documents five orchestration anti-patterns. Each one has been observed in production. None are hypothetical. The patterns are named so they can be recognized and called out by name.

---

**Anti-pattern 1: Loop Scripts**

Writing shell scripts that loop over entity invocations — iterating through a list of entities and invoking each one in sequence with a fixed prompt. The problem is not the loop syntax; it is what the loop assumes. A loop script embeds the decision that all iterations will proceed regardless of what any prior iteration produced. The operator who writes a loop script has pre-made all intermediate decisions. The observe-and-decide step is removed.

The correct mechanism for recurring automated work is the daemon worker system (under development). For current work requiring judgment at each step, the judgment loop handles it. There is no place in koad:io for a loop script over entity invocations.

---

**Anti-pattern 2: Blocking Sequential Invocations Without a Decision Point**

Launching entity A, waiting for it to complete, then launching B, then waiting for B, then launching C — when B's task does not depend on A's output, and C's task does not depend on B's output. Sequential execution of independent tasks is not safety. It is unnecessary coupling that adds latency without adding information.

If A, B, and C are independent, they run in parallel — multiple Agent calls in a single message with `run_in_background: true`. Sequential invocation is reserved for cases where one entity's output is another entity's input. Without that dependency, the decision to sequence is a failure to ask "can these run simultaneously?"

---

**Anti-pattern 3: Parsing Agent Output for Structured Data**

Extracting filenames, counts, paths, or structured results by parsing the conversational text of an agent's output. Level 4 covered why this fails: output format varies between sessions, phrasing varies, file paths may or may not appear in the text. Parsing is fragile and unnecessary.

The correct pattern: the brief includes a completion signal specifying where the entity commits its structured output. The orchestrator reads that file via the Read tool after verifying the commit via git log. The file is the structured data — committed, versioned, at a known path. The conversational output is context, not data.

---

**Anti-pattern 4: Spawning Observed Sessions for Routine Delegation**

Using `juno spawn process <entity>` to launch entities for routine background work tasks. The `spawn process` command opens a terminal window, triggers OBS streaming, and is designed for sessions that koad wants to watch. It does not return results to Juno. It is the mechanism for observed, human-attended entity operation — not for Juno-to-entity delegation.

Observed sessions are the right tool when koad explicitly wants to watch an entity work. They are the wrong tool when Juno is delegating work and needs the result returned for a subsequent decision. The Agent tool with `run_in_background: true` is the correct mechanism for coordinated delegation.

---

**Anti-pattern 5: Agent Tool for Simple File Reads**

Launching an Agent session to read another entity's current `PRIMER.md`, recent commits, or directory listing. An Agent invocation consumes a subagent context window, takes time, and involves the overhead of a full entity session — for a task that the Read, Grep, Glob, or Bash tools can accomplish directly in seconds.

The judgment test (Atom 6.3) exists specifically to prevent this. "Does this require the entity's judgment, or just its files?" Reading a file requires only the files.

> **Verification step:** Name all five anti-patterns from memory: loop scripts, blocking sequential without decision point, parsing output for structured data, observed sessions for routine delegation, Agent tool for file reads. State one concrete consequence of each error.

---

## Atom 6.2: Each Anti-Pattern Reduces to a Judgment Failure

The five anti-patterns are not a random assortment of mistakes. Each one corresponds to a specific judgment step in the loop that was bypassed or substituted with a worse mechanism.

| Anti-pattern | Judgment step bypassed | What was substituted |
|---|---|---|
| Loop scripts | The decide step after each iteration | Pre-made decision that all iterations proceed regardless of outcome |
| Blocking sequential without decision point | The question "can these run simultaneously?" | Unnecessary coupling that adds latency without adding information |
| Parsing agent output | The git log check (authoritative) | A fragile proxy that varies by session |
| Observed sessions for routine delegation | The distinction between coordinated and watched work | Wrong invocation mechanism that returns no results |
| Agent tool for file reads | The judgment test | Task-delegation overhead applied to information retrieval |

The unifying framing: every anti-pattern is a shortcut that removes a judgment from the loop. The operator who avoids the anti-patterns is not following rules — they are making better judgments at each step.

The correct alternative for each:

- **Loop scripts** → Daemon worker system for recurring automated work. Judgment loop for current work requiring intermediate decisions.
- **Blocking sequential without decision point** → Parallel invocations in a single message with `run_in_background: true`. Sequential only when one entity's output is another's input.
- **Parsing agent output** → Completion signals in briefs (Level 2) + Read tool after git log verification. The file at the specified path is the structured data.
- **Observed sessions for routine delegation** → Agent tool with `run_in_background: true`. Reserve `juno spawn process` for koad-attended observation.
- **Agent tool for file reads** → Read, Grep, Glob, and Bash tools directly, after `git pull` on the entity's directory.

These alternatives are not improvisations — each was taught in an earlier level. The anti-patterns exist to help operators recognize when they are sliding away from the correct pattern under time pressure or habit.

> **Verification step:** For each of the five anti-patterns, state the judgment question that the anti-pattern skips. If you cannot state the skipped question, re-read the anti-pattern description in Atom 6.1 before continuing.

---

## Atom 6.3: The Judgment Test — Before Every Agent Tool Invocation

VESTA-SPEC-054 §8.2 states the judgment test: "Before launching an Agent invocation, ask: does this require the entity's judgment, or just its files?"

The question is binary. If the answer is "just its files" — use dedicated tools. Pull the entity's directory with `git pull`, then read, grep, or glob directly. No Agent session needed.

If the answer is "this requires the entity to reason, decide, and commit work" — use the Agent tool.

The dedicated tools for file-access operations (VESTA-SPEC-054 §8.1):

| Operation | Correct tool |
|---|---|
| Read a file from another entity's directory | `Read` tool (after `git -C /home/koad/.<entity>/ pull`) |
| Search for a pattern across entity files | `Grep` tool |
| Find files by name pattern | `Glob` tool |
| Check another entity's recent commits | `Bash: git -C /home/koad/.<entity>/ log --oneline -5` |
| Read an entity's PRIMER.md | `Read` tool |
| Check GitHub Issue status | `Bash: gh issue view <number> --repo koad/<entity>` |
| List files in an entity's directory | `Bash: ls /home/koad/.<entity>/` |

These tools are available to Juno in every session. They cost no subagent context window. They complete in seconds. An Agent invocation for any of these operations is applying task-delegation overhead to information retrieval.

The judgment test also applies to anti-patterns 1 and 2. If the proposed "task" is "run the same prompt on each of these five entities in sequence" — apply the judgment test. Does each entity need to reason and commit? Or does the operator need the entities' existing files? If it is files, use dedicated tools. If it is judgment, ask whether the tasks are independent (parallel) or dependent (sequential with decision points between each).

The test is fast. It takes ten seconds to ask and answer. Skipping it is how anti-pattern 5 becomes habitual.

> **Verification step:** Before your next Agent tool invocation, state the judgment test answer aloud: "This requires [entity name]'s judgment because [reason] — specifically, the entity must [action] and [commit to path]." If you cannot complete that sentence, you may be looking at a file-read operation in disguise.

---

## Atom 6.4: The Complete Judgment Loop — A Worked Example

The following is a complete three-entity orchestration sequence for the Day 7 content pipeline. Each judgment moment is labeled. No step was pre-decided before the prior step's output was observed.

---

**Starting state:** Juno has identified that Day 7 content needs to be researched, drafted, and reviewed before Mercury can distribute.

**Judgment moment 1: Can Sibyl and Faber run in parallel?**
Faber's draft depends on Sibyl's research. They cannot run simultaneously. Sibyl goes first. This is not a pre-scripted decision — it is a dependency check at the start of the session.

**Launch (step 1):** Invoke Sibyl via Agent tool with `run_in_background: true`. Brief includes identity line, task (research the Day 7 topic, synthesize findings), cross-entity context (Faber will draft from this), and completion signal ("commit synthesis to `research/day-07.md` with message prefix `research:`").

**Observe (step 1):** Background task notification arrives.
```bash
git -C /home/koad/.sibyl/ log --oneline -5
```
Output includes: `a3f9c1e research: Day 7 topic synthesis — sovereignty proof of concept`

Commit confirmed. Read the summary: `tail -20` of Sibyl's output captures the key findings for Faber's brief.

**Judgment moment 2: Are the findings sufficient for a draft?**
Sibyl's synthesis is complete and substantive. No gaps that would require re-research. Decision: proceed to Faber.

**Launch (step 2):** Sleep 60 seconds (sequential chain). Invoke Faber with a brief including Sibyl's synthesis path (`research/day-07.md` on `~/.sibyl/`) as cross-entity context, task ("draft the Day 7 post"), completion signal ("commit draft to `drafts/day-07.md` with message prefix `content:`").

**Observe (step 2):** Notification arrives.
```bash
git -C /home/koad/.faber/ log --oneline -5
```
Output: `7b2d8f4 content: Day 7 draft — sovereignty proof of concept`

Confirmed.

**Judgment moment 3: Does the draft need Veritas before Mercury can distribute?**
Yes — distribution from Veritas-reviewed content only. Launch Veritas with the draft path.

**Launch (step 3):** Invoke Veritas with the draft path and completion signal ("commit review notes to `reviews/day-07.md`, flag any blocking issues").

**Observe (step 3):** Notification arrives.
```bash
git -C /home/koad/.veritas/ log --oneline -5
```
Confirmed. Read `tail -20` of review notes.

**Judgment moment 4: Can Mercury distribute now?**
Veritas flagged no blocking issues. But Mercury's platform credentials are not yet configured — this is a known state (see `koad/juno#11`). The task cannot complete in this session.

**Decide (step 3):** File a GitHub Issue: "Mercury: distribute Day 7 when platform credentials are configured. Draft at `~/.faber/drafts/day-07.md`, reviewed clean by Veritas." Assign to Mercury. Add to operations board.

---

Five judgment moments. No pre-scripted chain. Each launch followed an observation and a deliberate decision. The final outcome was a GitHub Issue rather than a Mercury invocation because the system state — at the moment of decision — made that the correct choice.

> **Verification step:** Walk through the five judgment moments and state, for each: what question was being asked, and what would have changed the answer. This is the loop as a practiced discipline.

---

## Atom 6.5: Operator Exercise — Run Your First Multi-Entity Orchestration

This is the integration exercise. Apply all skills from Levels 1–6 in a single sequence from scratch.

---

**Setup:**

1. Identify two entity directories available on thinker (e.g., `~/.sibyl/` and `~/.faber/`, or any two entities that are accessible and current).
2. Run `git pull` on both before invoking either — entities are live, local copies go stale:
   ```bash
   git -C /home/koad/.<entity-a>/ pull
   git -C /home/koad/.<entity-b>/ pull
   ```

---

**The exercise:**

3. Apply the judgment test to both tasks before writing any brief. State: "Entity A's task requires judgment because [reason]. Entity B's task requires judgment because [reason]."

4. Determine whether the tasks are independent or dependent. If dependent: sequence them with a decision point between. If independent: launch both in parallel in a single message.

5. Write the brief for entity A with all four components (identity line, task, cross-entity context if any, completion signal specifying file path and commit message prefix).

6. Invoke entity A via the Agent tool with `run_in_background: true`.

7. When the notification arrives: run git log verification. Confirm the expected commit message prefix appears in the five most recent commits:
   ```bash
   git -C /home/koad/.<entity-a>/ log --oneline -5
   ```

8. Apply the judgment test for step 2: is entity B's task independent of A's output, or dependent on it?
   - If **independent**: this was a parallel opportunity — note it for next time. Launch B now.
   - If **dependent**: read A's output efficiently via `tail -20`. Write B's brief with A's cross-entity context included. Sleep 60 seconds. Launch B.

9. When entity B's notification arrives, verify via git log:
   ```bash
   git -C /home/koad/.<entity-b>/ log --oneline -5
   ```

---

**What success looks like:**

Both entities completed their assigned work. Both are verified via git log. No anti-patterns were applied. The judgment at step 8 was made consciously — you can state why you chose parallel or sequential. If Mercury-style distribution or Vulcan-style building was involved at any point, it was routed to a GitHub Issue, not an Agent invocation.

---

**Closing the loop:**

Commit a state update to Juno's own repo (`~/.juno/`) documenting the orchestration sequence: which entities were invoked, what they produced, what the next step is. This is the record that closes the session.

```bash
git -C /home/koad/.juno/ add LOGS/
git -C /home/koad/.juno/ commit -m "log: orchestration sequence — [entity-a] + [entity-b]"
git -C /home/koad/.juno/ push
```

The session's orchestration work now has a permanent record: entity commits in each entity's repository, and a log entry in Juno's repository. This is what a complete judgment loop looks like, in full.

> **Verification step:** After completing the exercise, state: how many judgment moments did you encounter? What was the most important piece of output from entity A that informed the entity B decision? Was there any moment where you were tempted to apply an anti-pattern instead of the correct mechanism?

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
