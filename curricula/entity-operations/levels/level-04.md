---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 4
slug: reading-entity-output
title: "Reading Entity Output"
status: available
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-03
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 4: Reading Entity Output

## Learning Objective

After completing this level, the operator will be able to:
> Check git log to confirm what an entity did, use `tail -20` and `--output-format=json .result` to read output without loading full files, and identify at least three signals that a session failed without producing an error message.

**Why this matters:** Entity output is not a reply. It is a record of actions taken. The session may have produced twenty screens of tool-call logs, intermediate reasoning, and diagnostic chatter — and the actual deliverable is a single committed file. If you do not know how to find what the entity did (versus what it said while doing it), you will either miss the output or read the wrong thing and conclude the session failed when it succeeded.

---

## Knowledge Atoms

### Atom 4.1: Git Log as the Definitive Record

**Teaches:** Why git log is the authoritative source of what an entity did, and why anything not committed did not happen in the operationally meaningful sense.

An entity session produces two kinds of output: things it said, and things it committed.

What it said — the reasoning, the tool call output, the status messages — lives in the session log and in the terminal. It evaporates when the session ends. It is useful for debugging a session in progress. It is not the record of what was accomplished.

What it committed is the record. A file written to disk but not committed is not part of the entity's history. If the session ends and the file was not committed, the next session starts without knowledge of it. The operator who checked the session log and saw "wrote findings to output.md" and assumed the work was done may be surprised when the next session produces the same findings from scratch — because the file was never committed.

```bash
git -C ~/.entityname log --oneline -10
```

This is the first thing to check after a session. Does the log show a commit with a message that matches what you assigned? If yes, the work was done and recorded. If no, either the session did not finish the task or it finished but failed to commit.

The commit message is also a quality signal. "research: competitor analysis for 2026-04" is a well-authored commit. "update" is not. An entity that commits with a vague message may have done less than a well-organized session would have done.

```bash
git -C ~/.entityname show --stat HEAD   # what files were changed in the last commit
git -C ~/.entityname diff HEAD~1 HEAD   # full diff of the last commit
```

These let you see exactly what changed without reading the full output file.

---

### Atom 4.2: Conversational Output vs. File Output

**Teaches:** The difference between what appears in session logs and what the entity actually produced as deliverable output, and where to look for each.

During a session, the AI produces a stream of text: reasoning, tool calls, confirmations, intermediate summaries. All of that is conversational output — the entity's working process made visible. It is valuable for understanding what happened, but it is not the deliverable.

The deliverable is in committed files.

When a session ends, check for deliverables in this order:

**1. git log** — what was committed?
**2. The files committed** — is the content what you expected?
**3. Session log (only if needed)** — why did something go wrong?

Operators who start with the session log get lost in the working process. They read pages of tool call output trying to understand whether the task succeeded. The correct starting point is the git log — if the commit is there, the work is done. The session log is for debugging, not for confirming completion.

If an entity directory has a `var/log/` or `logs/` directory, session logs may be written there. These are useful when:
- The session exited without committing and you want to know why
- The entity reported a problem mid-session
- You want to audit a completed session in detail

For routine output reading, git log and the committed files are sufficient.

---

### Atom 4.3: Reading Output Without Drowning — `tail`, `git log`, `--output-format=json`

**Teaches:** The specific commands for reading entity output efficiently, and why `cat` on a full output file is the wrong default.

A research session may produce a 500-line markdown file. A build session may produce a dozen changed source files. Loading everything into a terminal or editor by default is inefficient and often unnecessary.

Three tools cover most output-reading needs:

**`tail -20`** — read the last 20 lines of a file:
```bash
tail -20 ~/.entityname/research/findings.md
```
Most entity output files are structured with context at the top and conclusions at the bottom. The tail gives you the conclusion without loading the context you already know.

**`git log --oneline`** — confirm what was committed:
```bash
git -C ~/.entityname log --oneline -5
```
One line per commit, most recent first. Confirm the task completed. If the commit message is specific, you may need nothing else.

**`--output-format=json .result`** — read structured output from a non-interactive session:
```bash
PROMPT="do the task" entityname 2>/dev/null | jq -r '.result'
```
When an entity runs non-interactively (`claude -p`), it writes JSON to stdout with a `.result` field containing the final response. This is the clean output — not the tool call logs, not the session chatter, just the result. If you are orchestrating entities and need the output back in your shell, this is what you parse.

Never `cat` a full output file by default. The reflex is: tail first, expand to full if the tail is insufficient. For session logs, the same rule applies — they can be very long. Start with the last 20 lines; they usually contain either the final outcome or the error that stopped the session.

---

### Atom 4.4: Recognizing Session Failure

**Teaches:** The specific signals that indicate a session failed without producing a clear error, and what each signal means.

Entity sessions fail in ways that do not always announce themselves. The session may exit cleanly but produce no deliverable. It may time out. It may encounter a permission error and continue on a different path. Knowing the failure signals prevents you from treating a failed session as successful.

**Signal 1: No commit after the session**

```bash
git -C ~/.entityname log --oneline -1
# Shows a commit from two days ago, not from the session you just ran
```

If the session should have committed something and did not, it either did not complete the task or completed it and failed at the commit step. Check the task prompt: did you include "commit and push when done"? An entity that was not told to commit may write output to disk without committing it.

**Signal 2: Lockfile left behind**

```bash
ls /tmp/entity-entityname.lock
# File exists after the session exited
```

The hook's cleanup trap should remove the lockfile on exit. If it is still present and the session is not running (the PID is dead), the session exited abnormally — killed, crashed, or interrupted. The lockfile must be removed manually before the next session can start.

**Signal 3: No files changed**

```bash
git -C ~/.entityname status
# "nothing to commit, working tree clean"
# And git log shows no new commits from this session
```

Combined with a session that appeared to run, this means the entity ran but produced no output. Either the task was already done and the entity correctly determined there was nothing to do, or the entity encountered a blocking problem and exited without writing anything. Read the session tail output to determine which.

**Signal 4: Error in the last output lines**

```bash
tail -20 ~/.entityname/var/log/session-latest.log   # if session logs are enabled
```

Common failure patterns in tail output:
- `Permission denied` — entity tried to write to a path it cannot access
- `API error` / `rate limit exceeded` — API call failed mid-session
- `No such file or directory` — the entity tried to read a file that does not exist (usually a memory reference or path in the prompt that was wrong)
- `already exists` / conflict messages — entity tried to create a file that was already there

**Signal 5: Lockfile absent but nothing committed**

If the session exited immediately — the lockfile was created and removed within seconds — with no commits and no output, the entity's hook may have exited before the harness started. This can happen if the entity's `.credentials` is missing an API key the harness requires. Check the session log's first lines for hook-level errors.

---

### Atom 4.5: Output You Cannot Parse — Diagnosis and Recovery

**Teaches:** What to do when the entity produced output that does not match what you expected, including how to re-read the task, check the diff, and decide whether to accept or re-run.

Sometimes the entity runs, commits something, and the output is not what you needed. Not a failure — the session completed. But not a success either. This is the "unexpected output" case and it requires diagnosis, not panic.

**Step 1: Check the diff first**

```bash
git -C ~/.entityname diff HEAD~1 HEAD
```

Read what actually changed. Often the output is correct but your mental model of the file was different from the entity's. The diff shows you the delta. Read it before deciding anything is wrong.

**Step 2: Compare the output to the task prompt**

Did the entity deliver what the prompt asked for? If the prompt said "3-5 sentences per issue" and the entity wrote three paragraphs per issue, it misread the scope. If the output location is correct and the format is close but not exact, this is usually a fixable prompt issue — add more specificity to the constraint.

**Step 3: Check CLAUDE.md and the entity's memory**

```bash
cat ~/.entityname/CLAUDE.md | head -40
tail -20 ~/.entityname/memories/MEMORY.md
```

If the entity produced something that looks like it is responding to prior context — a previous decision, a prior constraint — it may be that a memory file contains guidance that shaped the output in an unexpected way. Reading the entity's current context helps you understand why it did what it did.

**Step 4: Decide: accept, amend, or re-run**

- **Accept** if the output is usable, even if not exactly what you envisioned. Do not re-run sessions just because the format differs from what you imagined — use the output you have.
- **Amend** if the entity's commit introduced a small error you can fix manually. Commit the fix directly.
- **Re-run** only if the output does not address the task at all. When you re-run: fix the prompt, add the missing constraint, and specify the output location more precisely.

Do not re-run sessions habitually. Each re-run is context window usage and API cost. Get the prompt right, accept reasonable output, and reserve re-runs for genuine failures.

---

## Dialogue

### Opening

**Alice:** The session ran. Now what do you look at?

Most new operators either read everything — all the session output, every tool call log, every intermediate message — or nothing, assuming that if the session ran without error the work is done. Both approaches miss the actual answer.

The correct question after any entity session is simple: did the work land on disk, and is it what you needed? Two questions. The first is answered by git log. The second is answered by reading the committed output — efficiently. Let's go through how to do both.

---

### Exchange 1

**Alice:** After any entity session, first command:

```bash
git -C ~/.entityname log --oneline -5
```

This tells you what was committed. If you assigned a task and the session should have committed output, this is where you verify that it did. The commit message is the summary.

What are you looking for? A commit with a message that matches the task. "research: competitor analysis" for a research task. "add: auth module implementation" for a build task. If the commit is there, the work exists in the repo's history and cannot be silently lost.

If there is no new commit since you spawned the session: the session either completed without committing (you forgot to tell it to commit) or the session failed before completing. Those are different problems with different responses.

**Human:** What if the entity committed but the message is vague, like "update files"?

**Alice:** Read the diff. `git -C ~/.entityname show --stat HEAD` shows which files changed. `git -C ~/.entityname diff HEAD~1 HEAD` shows what changed in them. A vague commit message does not mean bad work — it means you need one more step to confirm the work is correct. It is also a signal to add "write a descriptive commit message" to your standard task prompt.

---

### Exchange 2

**Alice:** You confirmed a commit exists. Now read the output without drowning.

If the deliverable is a file:

```bash
tail -20 ~/.entityname/research/findings.md
```

The tail. Not `cat`. Entity-produced markdown files are often structured with introduction and context at the top, conclusions and findings toward the bottom. The tail gives you the conclusion — usually what you actually need to read first. If the tail looks correct, you may be done. If you need more, read the full file.

If you ran a non-interactive session and want the result back in your shell:

```bash
PROMPT="summarize the open issues" entityname 2>/dev/null | jq -r '.result'
```

The `.result` field in the JSON output is the entity's final response — the clean answer, stripped of all the tool call output and reasoning chatter. This is what you parse when you are orchestrating entities from a script or another session.

**Human:** When would I need the JSON format?

**Alice:** When Juno is orchestrating Sibyl, for example — Juno runs Sibyl with a prompt, captures the result, and uses it in the next step of an orchestration sequence. Rather than writing the output to disk and then reading the file, you pipe the result directly through `jq`. It keeps the orchestration clean without an extra file-create-and-read cycle.

---

### Exchange 3

**Alice:** Now the failure signals. The session ran. It looked like it completed. But something is off.

The five things to check:

One — no new commit in `git log`. If the task called for committed output and none appeared, the session did not finish or did not commit.

Two — lockfile still present at `/tmp/entity-entityname.lock`. The session exited abnormally. Remove the file before re-invoking: `rm /tmp/entity-entityname.lock`.

Three — `git status` shows nothing changed. Combined with no new commit, the entity ran but produced nothing. Either the task was already done and the entity correctly stopped, or it encountered a blocker silently.

Four — tail of the session log shows an error: permission denied, API error, missing file. These are explicit failures. The entity encountered a problem and stopped.

Five — session exited in seconds with nothing committed. The hook exited before the harness started. Usually a missing API key.

**Human:** What do I do when I see signal two — the lockfile is there but the session isn't running?

**Alice:** Remove it manually: `rm /tmp/entity-entityname.lock`. Verify the PID inside it is actually dead first: `cat /tmp/entity-entityname.lock` gives you the PID, then `ps aux | grep <pid>` confirms whether that process exists. If the process is dead and the lockfile is there, the cleanup trap in the hook did not run — hard kill, power interruption, or out-of-memory. Remove the lockfile. You are safe to re-invoke.

---

### Exchange 4

**Alice:** The last case: the session committed something, but it is not quite what you needed. Do not immediately re-run.

First: read the diff.

```bash
git -C ~/.entityname diff HEAD~1 HEAD
```

Read what actually changed. Often the output is correct and your expectation was imprecise. The entity delivered what the prompt asked for — your prompt was underspecified.

Second: check your prompt. Did it include an output location? A done criterion? A scope constraint? If any element was missing, the entity made a reasonable assumption. Understanding which assumption it made tells you what to add to the prompt if you run it again.

Third: decide. Accept the output if it is usable. Amend the commit if there is a small fixable error. Re-run only if the output does not address the task at all. Re-runs cost time and API budget. Use the output you have if it is close.

**Human:** How do I know when to accept vs. re-run?

**Alice:** Ask: can I use this output to make progress? If yes — even if it's 80% of what you wanted — accept it and work with it. Get it to 100% by following up or adjusting in the next session. If the output is fundamentally wrong — different topic, wrong entity, output format that makes it unusable — then re-run with a corrected prompt. The standard is "is this usable" not "is this exactly what I imagined."

---

### Landing

**Alice:** Three habits. One: check git log first — if the commit is there, the work is recorded. Two: use tail, not cat — read the end of files where conclusions live. Three: understand the five failure signals so you can diagnose without guessing.

The session output is not a conversation. It is a record of actions. Read it as a record.

---

### Bridge to Level 5

**Alice:** You can now read what the entity produced. The next question is: what if the commit was not made by the entity — should you commit on its behalf? And whose name goes on a commit in an entity directory when a human makes it? Level 5 covers the commit protocol and why authorship in entity repos is a deliberate practice.

---

### Branching Paths

#### "Can I always trust the commit message to summarize what was done?"

**Human:** Can I just read the commit message and assume I know what happened?

**Alice:** For well-authored sessions, yes — the commit message is a reliable summary. For sessions that committed with a message like "update" or "wip", no — the message is incomplete and you need to check the diff. Good commit messages come from good prompts: if your task prompt says "when done, commit with a descriptive message that summarizes what you did," you get better messages. If you do not include that, the entity may commit with whatever default occurred to it. Train the output you want by specifying it in the prompt.

---

#### "What if the entity produced a lot of files across multiple commits?"

**Human:** What if the session committed five times, not once?

**Alice:** Read the log range:

```bash
git -C ~/.entityname log --oneline --since="2 hours ago"
```

Or if you know the commit before the session started:

```bash
git -C ~/.entityname log --oneline <start-sha>..HEAD
```

This shows all commits the session made. Each should have a message describing what it did in that step. Multi-commit sessions are common for complex tasks — the entity commits incrementally as it completes subtasks. Read the sequence top to bottom to understand the narrative of what was done. If the sequence makes sense and the final state is what you needed, the session succeeded.

---

## Exit Criteria

The operator has completed this level when they can:
- [ ] Use `git log --oneline` to confirm whether an entity session committed output
- [ ] Use `tail -20` on an output file rather than `cat`
- [ ] Explain what the `.result` field is in non-interactive session JSON output and how to extract it
- [ ] Name at least three failure signals and describe what each indicates
- [ ] Describe the decision process for accepting vs. re-running unexpected output

**How Alice verifies:** Ask the operator: "A session just ran. Walk me through how you verify it succeeded." The answer should start with git log, not with reading session output. They should be able to name at least three failure signals without prompting.

---

## Assessment

**Question:** "You spawned Sibyl with a research prompt. The session ran for ten minutes and exited without error. You check and there is no new commit in git log and `/tmp/entity-sibyl.lock` is still present. What happened and what do you do?"

**Acceptable answers:**
- "The session exited abnormally — the lockfile wasn't cleaned up. I check whether the PID in the lockfile is still alive. If not, I remove the lockfile. I then check whether any files were written but not committed with `git status`."
- "No commit means either the task wasn't done or wasn't committed. Combined with a stale lockfile, the session crashed or was interrupted. I remove the lockfile, check git status for uncommitted work, and decide whether to re-run."

**Red flag answers (indicates level should be revisited):**
- "I read through all the session output to understand what happened" — correct approach for deep debugging, but should not be the first step
- "The session finished fine — no errors means success" — incorrect; no commit is a failure signal regardless of clean exit
- Not knowing that a stale lockfile prevents re-invocation
- "I just re-run it" — without first checking whether partial output exists or the lockfile is stale

**Estimated conversation length:** 8–12 exchanges

---

## Alice's Delivery Notes

The key conceptual shift in this level is from "session output" to "git log as definitive record." Operators coming from interactive AI tools expect the session to produce a response they read directly. In koad:io, the response is committed files — the session output is working process. This reframe is the most important thing to establish.

Do not let the operator skip the hands-on exercise of checking git log on an actual entity directory. The commands should become reflexes. Explaining them is not enough — they need to run them.

The failure signals section is especially valuable. New operators assume "no error message = success." The five signals enumerate the ways a session can fail silently. Make sure the operator can recognize a stale lockfile specifically — it is the most operationally disruptive failure because it blocks all future sessions until resolved.

The unexpected output section should push back gently on the impulse to re-run. Most new operators re-run too readily. The habit to build is: diagnose first, accept if usable, re-run only when genuinely necessary.
