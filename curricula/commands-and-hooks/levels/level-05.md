---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 5
slug: writing-a-hook
title: "Writing a Hook — Inject Context, Guard, Log"
status: scaffold
prerequisites:
  curriculum_complete:
    - entity-gestation
  level_complete:
    - commands-and-hooks/level-04
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 5: Writing a Hook — Inject Context, Guard, Log

## Learning Objective

After completing this level, the operator will be able to:
> Write a working `executed-without-arguments.sh` for the practice entity that correctly detects the invocation mode ($PROMPT present vs. absent), branches to the interactive path (exec ssh -t) or non-interactive path (run claude -p), and logs the invocation to a file.

**Why this matters:** The hook is the entity's contract with the outside world. A hook that misdetects the invocation mode either hangs waiting for input it will never receive (non-interactive path taken when interactive was intended) or opens a terminal that closes immediately (interactive path taken when a prompt was expected). Correct mode detection is the foundation on which all hook behavior depends.

---

## Knowledge Atoms

## Atom 5.1: The Minimal Hook Skeleton — Shebang, Paths, Prompt Detection

<!-- SCAFFOLD: Introduce the minimal hook skeleton from VESTA-SPEC-020 §2.3. Cover each element: shebang (`#!/usr/bin/env bash`), `set -euo pipefail`, entity-specific variables (`ENTITY_HOST`, `ENTITY_DIR`, `CLAUDE_BIN`, `NVM_INIT`, `LOCKFILE`), and the prompt detection block. Walk through the detection logic: `PROMPT="${PROMPT:-}"` reads the env var; `if [ -z "$PROMPT" ] && [ ! -t 0 ]; then PROMPT="$(cat)"; fi` reads from stdin if PROMPT is empty and stdin is a pipe. After this block, `$PROMPT` is either empty (interactive) or populated (non-interactive). The operator writes this skeleton for the practice entity — no branches yet, just detection. Verify that detecting an empty PROMPT and a piped PROMPT both work as expected. -->

---

## Atom 5.2: The Interactive Path — exec ssh -t

<!-- SCAFFOLD: The interactive path fires when `$PROMPT` is empty (no prompt in env, no pipe on stdin). Cover the interactive SSH command from VESTA-SPEC-020 §4: `exec ssh -t "$ENTITY_HOST" "$NVM_INIT && cd $ENTITY_DIR && $CLAUDE_BIN --model sonnet --dangerously-skip-permissions -c"`. Explain each component: `ssh -t` forces TTY allocation (required for interactive terminal programs), `$NVM_INIT` initializes PATH on the remote (covered in depth at Level 6), `cd $ENTITY_DIR` places the session in the entity's home, `-c` resumes the last Claude Code session. Explain `exec`: it replaces the hook process with SSH, leaving no orphaned shell. Add the interactive path to the practice entity hook. Test by invoking `practice` bare — the interactive path should fire. -->

---

## Atom 5.3: The Non-Interactive Path — claude -p and --output-format=json

<!-- SCAFFOLD: The non-interactive path fires when `$PROMPT` is set. Cover the core sequence from VESTA-SPEC-020 §3: SSH to entity host, initialize PATH, decode prompt (covered at Level 6), run `claude -p "$DECODED" --output-format=json --model sonnet --dangerously-skip-permissions`, extract `.result` from the JSON output. For this level, use a simplified version: no base64 (defer to Level 6), no PID lock (defer to Level 6), just the SSH command with the prompt passed directly. Explain the four required Claude flags from §3.3 and what each does. Add the non-interactive path to the practice entity hook. Test by setting `PROMPT="what entity are you?"` and invoking `practice`. -->

---

## Atom 5.4: Injecting Context — PRIMER.md and Pre-Invocation Context

<!-- SCAFFOLD: Cover the context injection pattern from Juno's hook: before passing the prompt to claude, check if a `PRIMER.md` exists in the calling directory and prepend it to the prompt. This is the pre-invocation context assembly pattern — entities that receive context about the calling project before they receive the task perform better. Show the pattern: read `$CALL_DIR/PRIMER.md` if it exists, prepend it to `$PROMPT` with a separator. This is an optional enhancement — the hook works without it — but it is the pattern that makes entities context-aware when invoked from a project directory. Add it to the practice entity hook as a feature. -->

---

## Atom 5.5: Logging the Invocation — Append to a Log File

<!-- SCAFFOLD: A hook that logs its invocations is dramatically easier to debug than one that does not. Cover the minimal logging pattern: at the start of the hook (after mode detection), append a timestamped line to a log file in `$ENTITY_DIR/var/hooks/`. The log captures: timestamp, invocation mode (interactive vs non-interactive), the prompt if non-interactive (truncated to avoid giant log files). Cover why `var/` is the correct location: it is gitignored by default, appropriate for ephemeral runtime data. Show how to read the log after invocations to verify the hook is running correctly. Add the logging to the practice entity hook. This atom is also the first time the operator must ensure `var/hooks/` exists — show `mkdir -p` as the pattern. -->

---

## Exit Criterion

The operator can:
- Write a `executed-without-arguments.sh` skeleton with correct prompt detection
- Implement the interactive path with `exec ssh -t` and the correct claude flags
- Implement the non-interactive path with `claude -p` and `--output-format=json`
- Add PRIMER.md context injection
- Add invocation logging to `var/hooks/`
- Test both paths and verify correct behavior from the log

**Verification question:** "Your practice entity's hook fires but always takes the interactive path, even when you set `PROMPT='test'` before invoking. What do you check first?"

Expected answer: Check that `$PROMPT` is actually set in the environment when the hook runs. The wrapper must inherit the environment variable. Alternatively, check the prompt detection block — the `&&` between the empty check and the stdin test may not be correct.

---

## Assessment

**Question:** "Why does the interactive path use `exec ssh` while the non-interactive path does not use `exec`?"

**Acceptable answers:**
- "The interactive path hands control to SSH completely — there is no output to post-process, so `exec` replaces the hook process with SSH and avoids leaving an orphaned shell. The non-interactive path needs to parse the JSON output from claude after SSH returns, so it cannot use `exec` — it must continue executing after the SSH command completes."

**Red flag answers (indicates level should be revisited):**
- "Both paths should use `exec`" — the non-interactive path cannot use `exec` if it needs to process output
- "`exec` makes it faster" — not the reason; it is about process lifecycle and avoiding orphan processes

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

<!-- SCAFFOLD: This level is the most hands-on of the curriculum. The operator should be writing code from Atom 5.1 through Atom 5.5. Alice's role is to narrate what is being written and why, catch mistakes before they are committed, and ensure the test at each atom actually produces the expected output.

The simplified non-interactive path (no base64, no PID lock) is intentional — those are Level 6's content. An operator who is simultaneously managing base64 encoding and PID lock while learning the basic hook structure will lose the thread. Level 5's goal is a hook that works correctly in the nominal case. Level 6 adds the safety protocols.

Atom 5.4 (PRIMER.md injection) is worth time because it is the mechanism that makes entities genuinely useful in project contexts. An operator who understands this pattern will use it everywhere — they will add PRIMER.md to their project directories and see their entities respond with context they did not have to re-explain every invocation. This is a high-value moment in the curriculum if Alice frames it correctly. -->

---

### Bridge to Level 6

Your hook works. It detects the invocation mode, handles both paths, and logs. But it is not yet production-safe: it has no PID lock (two concurrent invocations could corrupt state), no base64 encoding (prompts with special characters will break), and no PATH initialization (the remote SSH command may not find claude). Level 6 adds all three.
