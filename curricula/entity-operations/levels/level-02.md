---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 2
slug: spawning-a-session
title: "Spawning a Session — The Invocation Pattern"
status: locked
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-01
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 2: Spawning a Session — The Invocation Pattern

## Learning Objective

After completing this level, the operator will be able to:
> Write the correct invocation for both a direct entity session and a spawn-with-observation, explain why `juno spawn process entity "$PROMPT"` silently drops the prompt, and demonstrate the pattern that actually delivers the task.

**Why this matters:** There are multiple ways to invoke an entity and they are not equivalent. Using the wrong one means the prompt may be silently dropped, the session may open interactive instead of executing your task, or you may find yourself watching a window you cannot control. The invocation pattern is a precise thing. Imprecision here does not produce an error — it produces a session that looks like it's running but isn't doing what you asked.

---

## Knowledge Atoms

### Atom 2.1: Two Spawn Modes

**Teaches:** The distinction between coordinated (results return to caller) and observed (koad watches in a terminal window), and when each is appropriate.

Every entity session is one of two modes:

**Coordinated** — The entity receives a task, executes it, and returns output to the calling shell. Used when Juno is orchestrating other entities (Juno assigns a task to Vulcan and waits for the result). Used when koad wants to inspect entity output in the current session. The caller blocks until the entity is done, or runs in background via `run_in_background: true`. Output lands in the calling terminal or is captured to a variable.

**Observed** — The entity opens in its own terminal window. koad or an operator watches the session live. Used during demos, during content recording (OBS captures the window), or when koad wants to see an entity's reasoning in real time rather than just the result. The calling shell does not block — it just opens the window and returns immediately.

The distinction matters for how you write the invocation. Coordinated sessions need a clean prompt with a clear done-criterion. Observed sessions are usually interactive — the entity launches into its VESTA-SPEC startup and proceeds from there.

---

### Atom 2.2: The Direct Invocation Pattern

**Teaches:** How `PROMPT="..." entityname` works, why it is the correct non-interactive pattern, and what the hook does with it.

The direct invocation pattern:

```bash
PROMPT="Research the current GitHub issue list and write a summary to ~/.entityname/research/findings.md. When done, commit and push." entityname
```

This works because:

1. `PROMPT="..."` sets the `PROMPT` environment variable inline, before the command
2. The entity's hook script reads `PROMPT` from the environment
3. If `PROMPT` is non-empty, the hook runs in non-interactive mode: `claude --dangerously-skip-permissions -p "$PROMPT"`
4. The session executes the prompt, outputs JSON, extracts the `.result` field, and returns it to your shell

The inline env-var syntax (`VAR="value" command`) is a POSIX-standard pattern. It sets `VAR` in the environment of `command` without permanently modifying your current shell environment. The next command you run will not see `PROMPT`.

This is the correct pattern for all orchestrated, non-interactive entity invocations. Learn it exactly.

---

### Atom 2.3: The Spawn-Process Command

**Teaches:** What `juno spawn process <entity> [prompt]` does, when it is the correct choice, and how it differs from direct invocation.

`juno spawn process` is a higher-level wrapper around entity invocation. Its primary purpose is the windowed mode: opening an entity in a new visible terminal for observation.

```bash
juno spawn process vulcan                      # interactive, no window (direct route)
juno spawn process vulcan --window             # opens a gnome-terminal / tmux window
juno spawn process vulcan --window "build X"  # observed with a starting prompt
```

For non-windowed invocations, `juno spawn process entity "prompt"` is equivalent to direct invocation — it ends up calling `exec env PROMPT="$PROMPT" "$ENTITY_NAME"`, which is the same as the direct pattern.

The `--window` flag is what makes it useful beyond direct invocation. It opens a new terminal window that koad can watch. This is the mode used during OBS streaming — the entity's session appears on screen and is captured as content.

For automated, background, or orchestrated tasks, prefer the direct pattern over `juno spawn process`. Direct invocation is transparent and easier to reason about. `juno spawn process` adds a layer of command parsing that can introduce the pitfall described in Atom 2.4.

---

### Atom 2.4: The Silent Prompt Drop — Why `juno spawn process entity "$PROMPT"` Fails

**Teaches:** The specific mechanism by which inline env expansion silently drops the prompt when using `juno spawn process`, and the correct alternatives.

This is the most common new-operator mistake. It looks correct and produces no error:

```bash
PROMPT="do the thing"
juno spawn process entityname "$PROMPT"    # WRONG — prompt is dropped
```

Why it fails: `$PROMPT` is expanded by the shell before it is passed to `juno spawn process`. By the time the argument reaches the script, it is a positional argument `$1`. Inside `juno spawn process`, the script does `ENTITY_NAME="${1:?...}"` and then `shift` — moving past the entity name — and then `PROMPT="${1:-}"` which picks up the next argument. But if you wrote `juno spawn process entityname "$PROMPT"`, the `$PROMPT` expansion happens at the calling shell, and the value is passed as `$1` to the script... which is then treated as the entity name, not the prompt.

Wait — actually the failure is subtler. The script does `ENTITY_NAME=$1; shift`. So after the shift, `$1` would be your prompt. But `"$PROMPT"` in the calling shell expands to its value at invocation time. If `$PROMPT` was previously set in your shell to some other value (perhaps from a prior command), that value gets passed, not the one you intended.

The correct patterns:

```bash
# Pattern 1: Direct invocation — always correct
PROMPT="do the thing" entityname

# Pattern 2: Heredoc — no quoting issues for multi-line prompts
juno spawn process entityname << 'EOF'
do the thing
with multiple lines
and no quoting hell
EOF

# Pattern 3: If you must use spawn process with a string argument
juno spawn process entityname "do the thing"   # literal string, not a variable
```

The rule: when writing a prompt into a variable and passing it to an entity, use direct invocation (`PROMPT="..." entityname`). When using `juno spawn process`, either pass the literal string directly as an argument or use heredoc.

---

### Atom 2.5: What Happens in the First Seconds of a Session

**Teaches:** The startup sequence after invocation — what the hook does, what the harness does, what the entity does — so the operator knows what to expect and can recognize when something is wrong.

After you invoke an entity, this sequence runs:

**1. Hook execution** (`~/.koad-io/hooks/executed-without-arguments.sh`):
- Loads `~/.koad-io/.env` then `~/.entityname/.env`
- Logs config: ENTITY_DIR, HARNESS, ENTITY_HOST
- Checks for PRIMER.md in the call directory (injects if present)
- Checks if it's on the entity's home machine; if not, SSHs there
- Checks for a PID lockfile — if entity is already running, exits with error
- Acquires lockfile
- If PROMPT is set: runs `claude --dangerously-skip-permissions -p "$PROMPT"` (non-interactive)
- If PROMPT is empty: runs `claude . --model sonnet` (interactive)

**2. Claude Code / harness startup**:
- Reads `CLAUDE.md` in the entity directory — identity context
- Reads `memories/` directory for prior session state
- Reads any PRIMER.md injected by the hook

**3. VESTA-SPEC startup** (if Juno or a team entity):
- The entity runs `whoami`, `hostname` to verify it is in the right place
- Does `git pull` on its own directory
- Reviews `gh issue list` for pending assignments
- Outputs a state summary

What to watch for in the first seconds:
- `[lock] Acquired lock: /tmp/entity-X.lock` — hook running, session starting
- `[mode] Non-interactive (orchestration)` — task mode confirmed, prompt was received
- `[mode] Interactive session` — no prompt, entity is running live
- `[error] X is busy (pid Y)` — entity already running, you cannot spawn a second

If you see the hook log `[debug] PROMPT length: 0` when you expected a prompt to be delivered, the prompt was not received. Go back to Atom 2.4 and check your invocation pattern.

---

## Dialogue

### Opening

**Alice:** You've checked the environment. You've confirmed identity. Now you spawn. And this is where precision matters most — because the invocation pattern is exact, and the wrong pattern does not produce an error. It just silently fails to deliver your prompt, and the entity opens interactive or does nothing useful.

Let me show you the two patterns and the one specific pitfall to avoid.

---

### Exchange 1

**Alice:** The direct invocation pattern:

```bash
PROMPT="do the task" entityname
```

That's it. The `PROMPT=` before the command name sets the environment variable for that invocation only. The entity's hook reads it, recognizes it's non-empty, and runs in task mode. The session executes your prompt and returns the result.

Try it on an entity you have set up. Set a simple prompt — something like "write the current date to /tmp/test-output.txt" — and invoke it:

```bash
PROMPT="write the current date and time to /tmp/test-output.txt and confirm when done" entityname
```

What do you see?

**Human:** [describes the hook output and result]

**Alice:** Good. Notice the log lines at the start — `[mode] Non-interactive (orchestration)`, `[exec] Running: claude --dangerously-skip-permissions -p ...`. That's the hook confirming it received the prompt and is running in task mode. The entity executed and returned. That's the full direct invocation loop.

---

### Exchange 2

**Alice:** The spawn-process command adds a wrapper. Same underlying mechanism, but with options for windowed execution:

```bash
juno spawn process entityname                    # same as direct, no window
juno spawn process entityname --window           # opens a terminal window
juno spawn process entityname --window "task"   # observed session with starting prompt
```

The windowed mode is for observation — demos, OBS recording, sessions koad wants to watch live. The window opens and the entity starts; you're not waiting for output to return to your shell.

For task work you're orchestrating yourself, stick to direct invocation. Windowed mode is for visibility, not for automation.

---

### Exchange 3

**Alice:** Now the pitfall. This pattern looks correct but silently drops the prompt:

```bash
PROMPT="do the thing"
juno spawn process entityname "$PROMPT"
```

The issue: `$PROMPT` is a shell variable. When you write `"$PROMPT"` on the command line, the shell expands it before passing it to `juno spawn process`. But `$PROMPT` is also the name of a special shell variable that holds your shell's prompt string (the `$` symbol in bash). So if `PROMPT` was not exported cleanly, or if the shell intercepts it, the value you intended may not be what arrives.

More concretely: the spawn script expects arguments in a specific order. The expansion timing can cause the wrong argument to appear in the wrong position.

**The correct alternatives:**

```bash
# Option 1: direct invocation, no ambiguity
PROMPT="do the thing" entityname

# Option 2: literal string argument to spawn process
juno spawn process entityname "do the thing"

# Option 3: heredoc for multiline prompts
juno spawn process entityname << 'EOF'
do the thing
across multiple lines
EOF
```

The rule: if you are storing a prompt in a variable, use direct invocation. If you are passing it inline, either use direct invocation or quote it as a literal in `juno spawn process`.

**Human:** Why does this happen?

**Alice:** Shell variable expansion and argument parsing interact in ways that aren't always intuitive. The direct invocation pattern avoids the issue entirely because `PROMPT="..."` before the command name sets the variable in the child process's environment directly — there's no shell argument parsing involved. The `juno spawn process` path goes through argument parsing, which is where the variable can get mishandled. Use direct invocation for prompt delivery. Use `juno spawn process --window` for observation.

---

### Exchange 4

**Alice:** Let me show you what the hook output looks like so you know what a good startup versus a failed startup looks like.

Good non-interactive startup:
```
[env] Loaded framework and entity env files
[config] ENTITY_DIR=/home/koad/.entityname, CALL_DIR=/home/koad
[config] KOAD_IO_ENTITY_HARNESS=claude
[debug] PROMPT length: 247, FORCE_INTERACTIVE=
[mode] Non-interactive (orchestration)
[lock] Acquired lock: /tmp/entity-entityname.lock (pid: 12345)
[exec] Running: claude --model sonnet --dangerously-skip-permissions -p <prompt>
```

What a failed prompt delivery looks like:
```
[debug] PROMPT length: 0, FORCE_INTERACTIVE=
[mode] Interactive session
```

If you see `PROMPT length: 0` when you expected a task prompt, the prompt was not received. Stop the session, go back to your invocation, and use the direct pattern.

**Human:** What does the lockfile do?

**Alice:** It prevents two simultaneous sessions on the same entity. The hook writes the current PID to `/tmp/entity-entityname.lock` when it starts and removes it when it exits. If you try to spawn a second session while the first is still running, the hook reads the lockfile, checks if the PID is still alive, and if so, exits with an error: "X is busy (pid Y)." This is a safety mechanism — two concurrent sessions on the same entity would produce conflicting commits and overlapping state. Wait for the first to finish, or kill it explicitly if needed.

---

### Landing

**Alice:** The invocation pattern is small and exact. Direct invocation: `PROMPT="..." entityname`. Observed sessions: `juno spawn process entityname --window`. Prompt-in-variable: use direct invocation, not spawn-process with `"$PROMPT"`.

Check the hook output's first lines when a session starts. If you see `PROMPT length: 0` when you expected a task, the prompt was dropped. If you see `is busy`, another session is running.

---

### Bridge to Level 3

**Alice:** You can now invoke an entity correctly. The next question is: what do you put in the prompt? A session that starts correctly with a bad prompt will produce drift — the entity will do something, but not necessarily what you needed. Level 3 is about writing a prompt the entity can actually act on.

---

### Branching Paths

#### "Can I run two entities in parallel?"

**Human:** Can I run Juno and Vulcan at the same time?

**Alice:** Yes — different entities have different lockfiles. `/tmp/entity-juno.lock` and `/tmp/entity-vulcan.lock` are independent. You can invoke multiple entities in parallel from different shell sessions or from an orchestrator using `run_in_background: true`. The constraint is one-session-at-a-time per entity, not one-session total. Parallel entity invocations are how the team does concurrent work — Juno orchestrates while Vulcan builds while Mercury writes.

---

#### "What if the session hangs and never returns?"

**Human:** What if I invoke an entity non-interactively and it never returns?

**Alice:** Check the lockfile first: `cat /tmp/entity-entityname.lock` — is the PID still alive? If the session is genuinely stuck, kill the PID directly: `kill <pid>`, then `rm /tmp/entity-entityname.lock`. The trap in the hook script should clean up the lockfile on exit, but if the process was killed hard, the lockfile may persist. Always manually verify the lockfile is gone before re-invoking. If sessions are regularly hanging, investigate the prompt — vague or open-ended prompts sometimes cause the entity to run in a loop researching indefinitely. A well-scoped prompt with a clear done criterion prevents most hangs.

---

## Exit Criteria

The operator has completed this level when they can:
- [ ] Write the correct direct invocation pattern from memory
- [ ] Explain the difference between coordinated and observed spawn modes
- [ ] Describe why `juno spawn process entity "$PROMPT"` fails and write the correct alternative
- [ ] Read hook output and identify whether a prompt was delivered or dropped
- [ ] Explain what the lockfile does and how to clear a stale one

**How Alice verifies:** Ask the operator to demonstrate the invocation pattern on an actual entity. Watch the hook output together. Confirm they can identify whether the session received the prompt by reading the PROMPT length line.

---

## Assessment

**Question:** "You have a task to give to Vulcan. You write: `PROMPT="build the auth module" && juno spawn process vulcan "$PROMPT"`. What's wrong with this and how do you fix it?"

**Acceptable answers:**
- "The prompt might be silently dropped. Use `PROMPT="build the auth module" vulcan` instead."
- "The `"$PROMPT"` expansion can cause issues through spawn-process argument parsing. Direct invocation is safer."
- "Use `juno spawn process vulcan "build the auth module"` — literal string, not a variable."

**Red flag answers (indicates level should be revisited):**
- "Nothing is wrong with it" — operator has not internalized the pitfall
- "I'd just run it and see" — acceptable as a debugging approach but not as a primary answer; they should know the correct pattern
- Inability to read hook output and determine whether a prompt was received

**Estimated conversation length:** 8–12 exchanges

---

## Alice's Delivery Notes

This level is about precision. The audience has conceptual understanding — they know what entities do. Now they need to know exactly how to invoke them. The gap between "I understand invocation conceptually" and "I can write the correct pattern from memory" is where this level lives.

The silent prompt drop (Atom 2.4) is the most important thing in this level. Emphasize it. The reason it is dangerous is that it does not produce an error — the session just opens interactive and the operator may not notice. Make the operator run a real invocation and read the hook output. The PROMPT length line is the diagnostic.

Do not skip the exercise. Explaining the pattern is not enough. Have the operator actually invoke an entity with a prompt and confirm from the hook output that the prompt was received.

Keep the hook-output reading section practical. The operator does not need to understand every line — they need to know the three diagnostic lines: PROMPT length, mode (interactive vs non-interactive), and lock acquisition.
