---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 6
slug: hook-internals
title: "Hook Internals — Ordering, PID Lock, Base64, PATH Init"
status: authored
prerequisites:
  curriculum_complete:
    - entity-gestation
  level_complete:
    - commands-and-hooks/level-05
estimated_minutes: 30
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 6: Hook Internals — Ordering, PID Lock, Base64, PATH Init

## Learning Objective

After completing this level, the operator will be able to:
> Implement the full PID lock pattern (five distinct sub-steps: check, read, kill-0, write, trap), apply the base64 encoding pattern for prompt transport across shell boundaries, initialize PATH via `NVM_INIT` for non-interactive SSH invocations, and explain why each mechanism exists.

**Why this matters:** A hook without PID lock protection allows concurrent invocations that corrupt git state and agent memory. A hook without base64 encoding breaks on any prompt containing single quotes, apostrophes, or newlines. A hook without PATH initialization fails silently on any machine where NVM is not initialized in the non-interactive shell. These are the three failure modes that production hooks must prevent. Operators who skip this level ship hooks that work in testing and break in production — always under exactly the conditions that matter most.

---

## Knowledge Atoms

## Atom 6.1: The PID Lock — Five Steps, One Trap

The PID lock is the mechanism that prevents two concurrent non-interactive invocations from running simultaneously. Without it: two entities each invoke `practice` with different prompts, both pass mode detection, both call `claude -p`, both write to the same session history and git state at the same time. The result is corrupted output, corrupted git history, and an entity that requires manual cleanup to restore.

The PID lock is a fail-fast mechanism. When the entity is busy, callers are told immediately and given a clear message. They can decide to retry; the hook does not decide for them.

**The five steps. This is not a summary — commit this sequence:**

**Step 1: Check if the lockfile exists.**
```bash
LOCKFILE="/tmp/entity-practice.lock"

if [ -f "$LOCKFILE" ]; then
```
The lockfile is at `/tmp/entity-<name>.lock`. `/tmp` is always writable, always accessible, and automatically cleared on reboot. This location is correct for all Linux and macOS systems. Never put the lockfile inside the entity directory — it would be checked in to git, which is wrong.

**Step 2: Read the PID from the lockfile.**
```bash
  LOCKED_PID=$(cat "$LOCKFILE" 2>/dev/null || echo "")
```
The lockfile contains the PID of the process that acquired the lock. `2>/dev/null` suppresses errors if the file is unreadable (possible if it was created by a different user). The `|| echo ""` fallback ensures `LOCKED_PID` is empty rather than unset if reading fails.

**Step 3: Test the PID with `kill -0`.**
```bash
  if [ -n "$LOCKED_PID" ] && kill -0 "$LOCKED_PID" 2>/dev/null; then
```
`kill -0 <PID>` is the key mechanism. Signal 0 does not send a signal to the process. It only tests whether the process is alive and accessible. If the process exists and is owned by this user: exit 0 (alive). If the process does not exist or is not owned: exit non-zero (dead).

The compound condition `[ -n "$LOCKED_PID" ] && kill -0 ...` is deliberate. If `$LOCKED_PID` is empty (the lockfile was empty or unreadable), `kill -0 ""` would test PID 0 — which refers to the entire process group and always returns 0 on Linux. The empty check prevents this false positive.

**Step 4: If alive — fail fast.**
```bash
    echo "[lock] practice is busy (pid $LOCKED_PID). Try again shortly." >&2
    exit 1
  fi
```
The entity is running. The caller gets a clear, actionable error message. Exit 1, not exit 0. The PID in the message lets the caller verify the claim: `kill -0 <PID>` should confirm the process is running.

If the lockfile check condition is false — either the file does not exist, or the file exists but the PID is dead — execution falls through. In both cases, we proceed to acquire the lock.

**Step 5: Write own PID and register the trap.**
```bash
fi
echo $$ > "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT
```
`$$` is the current shell's PID. Write it to the lockfile. This claims the lock.

`trap 'rm -f "$LOCKFILE"' EXIT` registers a cleanup function that runs when the hook exits for any reason — normal completion, error exit, or signal. Without the trap, a hook that crashes between acquiring the lock and finishing its work leaves a stale lockfile. Every subsequent invocation would see the stale lock, find the PID is dead, overwrite it, and proceed — that is fine — but it adds a syscall to every invocation for a file that should not exist.

**The complete PID lock block:**

```bash
LOCKFILE="/tmp/entity-practice.lock"

if [ -f "$LOCKFILE" ]; then
  LOCKED_PID=$(cat "$LOCKFILE" 2>/dev/null || echo "")
  if [ -n "$LOCKED_PID" ] && kill -0 "$LOCKED_PID" 2>/dev/null; then
    echo "[lock] practice is busy (pid $LOCKED_PID). Try again shortly." >&2
    exit 1
  fi
fi
echo $$ > "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT
```

**Where to insert this block:** The PID lock goes in the **non-interactive path only**, after the interactive branch has executed (or after mode detection if the interactive branch uses `exec` and therefore never reaches this code). Interactive sessions are not locked — a human always gets a terminal, and multiple interactive sessions are the operator's responsibility.

Because the interactive path uses `exec` (and therefore the hook process ends at that point), any code after the interactive branch only runs in the non-interactive case. Insert the PID lock immediately at the start of the non-interactive section:

```bash
# ── Interactive path (runs and exits via exec) ────────────────────────────────
if [ -z "$PROMPT" ]; then
  cd "$ENTITY_DIR"
  exec claude . --model sonnet --dangerously-skip-permissions --add-dir "$CALL_DIR"
fi

# ── Non-interactive path ──────────────────────────────────────────────────────
# PID lock — prevents concurrent non-interactive invocations
if [ -f "$LOCKFILE" ]; then
  LOCKED_PID=$(cat "$LOCKFILE" 2>/dev/null || echo "")
  if [ -n "$LOCKED_PID" ] && kill -0 "$LOCKED_PID" 2>/dev/null; then
    echo "[lock] practice is busy (pid $LOCKED_PID). Try again shortly." >&2
    exit 1
  fi
fi
echo $$ > "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT

# ... rest of non-interactive path
```

**Test the PID lock:**

```bash
# Terminal 1: start a slow non-interactive invocation
PROMPT="sleep 30 seconds and then respond" practice &

# Terminal 2: attempt a second invocation immediately
PROMPT="hello" practice
# Expected: "[lock] practice is busy (pid XXXXX). Try again shortly."

# Clean up
kill %1 2>/dev/null; wait 2>/dev/null
rm -f /tmp/entity-practice.lock
```

**What you can do now:**
- Write out the five steps from memory before adding them to your hook; check each step against this atom
- Add the PID lock to your practice hook in the correct location (non-interactive section)
- Run the concurrent invocation test and confirm the second invocation is rejected
- After the test, verify the lockfile is cleaned up (the trap should have run)

**Exit criterion for this atom:** The operator can recite all five PID lock steps from memory, explain the purpose of each, implement the block correctly in the hook, and verify it rejects concurrent invocations.

---

## Atom 6.2: Stale Lock Detection — kill -0 Semantics Drilled

`kill -0` is doing the most important work in the PID lock, and its semantics are not obvious to operators who have not used it before. This atom drills it as a standalone topic because getting it wrong produces exactly the failure mode the lock is supposed to prevent.

**Signal 0 is a test, not a kill.**

Every `kill` invocation consists of a signal and a target process ID. Signal 0 is special: it is not a real signal. When you send signal 0 to a process, the kernel checks whether the process exists and whether the sending process has permission to signal it — but it does not deliver any signal to the target.

The return value is what matters:
- **Exit 0** → the process exists and is accessible → the lock is **valid** → another invocation is running → fail fast
- **Exit non-zero** → the process does not exist, or is not owned by this user → the lock is **stale** → overwrite and proceed

```bash
kill -0 "$LOCKED_PID" 2>/dev/null
# $? == 0: alive
# $? != 0: dead
```

`2>/dev/null` suppresses the `kill: (PID) - No such process` message that would otherwise go to stderr when the process is dead.

**What is a stale lock?**

A stale lock is a lockfile that contains a PID for a process that no longer exists. Stale locks arise from:

1. **Hook crashes.** If the hook is killed mid-run (SIGKILL, machine restart, out-of-memory kill), the `trap` does not run and the lockfile is not deleted. On the next invocation, the lockfile exists but the PID it contains is gone. `kill -0` returns non-zero, confirming the process is dead, and the hook overwrites the lockfile with the new PID.

2. **Machine reboots.** `/tmp` is cleared on reboot. Even if a stale lockfile survived somehow, a reboot clears it. But in practice, reboots wipe `/tmp` before any entity invocations happen, so this case is self-healing.

3. **PID rollover (theoretical).** On very long-running systems, a PID from months ago might be reused by an unrelated process. The `kill -0` would return 0 (alive), but the process with that PID is not the hook — it is something else. The hook would incorrectly conclude it is busy. This is a known limitation; on a typical Linux system with a 32-bit PID space, the probability of collision is negligible for the hook's use case. Production systems with very high process churn could be affected.

**The compound condition is a safety measure.**

```bash
if [ -n "$LOCKED_PID" ] && kill -0 "$LOCKED_PID" 2>/dev/null; then
```

The `[ -n "$LOCKED_PID" ]` test is not redundant. On Linux, `kill -0 0` tests the calling process's process group — it always returns 0. If the lockfile is empty (possible if writing was interrupted), `$LOCKED_PID` is empty, and without the empty check, the lock would incorrectly conclude the entity is busy. Always check that the PID is non-empty before testing it.

**The lock applies only to non-interactive mode.**

This is worth stating explicitly: the PID lock is for non-interactive invocations only. When an operator types `practice` to open an interactive session, no lock is acquired. Multiple simultaneous interactive sessions are possible — they are the operator's responsibility. The lock exists to serialize automated task invocations, not to block humans.

If you find yourself adding the PID lock before the interactive branch: move it. The lock goes after the `exec` on the interactive path, in the non-interactive section only.

**Test stale lock detection:**

```bash
# Create a lockfile with a fake (non-existent) PID
echo "99999" > /tmp/entity-practice.lock

# Invoke the entity — should detect the stale lock and proceed
PROMPT="hello" practice
# Expected: the invocation succeeds, not rejected

# Verify the lockfile was overwritten with the new PID
cat /tmp/entity-practice.lock
# Should show a valid PID, not 99999
```

**What you can do now:**
- Run `kill -0 $$; echo $?` and confirm it returns 0 (your own shell is alive)
- Run `kill -0 99999 2>/dev/null; echo $?` and confirm it returns 1 (that PID does not exist)
- Perform the stale lock test above and confirm the invocation succeeds rather than rejecting

**Exit criterion for this atom:** The operator can explain `kill -0` semantics precisely, state what constitutes a stale lock and why it occurs, and demonstrate that their hook handles stale locks correctly by overwriting and proceeding.

---

## Atom 6.3: Base64 Encoding — Shell Quoting Across Boundaries

The Level 5 non-interactive path passes `$PROMPT` directly to `claude -p`. For local invocations where the hook and claude run in the same shell environment, this works. For prompts that are passed across SSH (when the entity runs on a remote machine) or that contain shell metacharacters, it breaks.

**The problem: shell metacharacters in prompts.**

A prompt like `Commit all changes to the 'entity's work' branch` contains a single quote in `entity's`. When this prompt is passed inside a single-quoted shell argument:

```bash
ssh host "claude -p 'Commit all changes to the 'entity's work' branch'"
#                   ^                          ^
#                  open                      close — the quote closes here,
#                                            not where intended
```

The shell sees the closing single quote after `entity`, not after `branch`. Everything from `s work' branch` becomes unquoted tokens that break the command. The error is cryptic; the prompt is silently mangled or the SSH command fails.

Additional metacharacters that cause problems:
- Apostrophes (same character as single quote)
- Newlines in multi-line prompts
- Dollar signs (interpreted by the remote shell)
- Backticks (executed by the remote shell)
- Double quotes (terminate double-quoted outer strings)

**The solution: base64 encoding.**

Base64 encodes arbitrary binary data to a string that contains only the characters `A-Z`, `a-z`, `0-9`, `+`, `/`, and `=`. None of these are shell metacharacters. A base64-encoded string is shell-safe — it can be passed anywhere without quoting concerns.

**Encode on the hook side (before sending):**

```bash
ENCODED=$(printf '%s' "$PROMPT" | base64 -w0 2>/dev/null || printf '%s' "$PROMPT" | base64)
```

**`printf '%s'` not `echo`.** `echo "$PROMPT"` appends a trailing newline. `printf '%s' "$PROMPT"` does not. For base64 encoding, a trailing newline changes the encoded output, producing a different string when decoded. Use `printf '%s'` for exact encoding.

**`-w0` for GNU coreutils (Linux).** On Linux, `base64` (from GNU coreutils) wraps output at 76 characters by default, inserting newlines. `-w0` disables wrapping, producing a single-line string. A wrapped string still decodes correctly, but single-line is safer for inline use in SSH commands.

**`2>/dev/null || fallback` for portability.** On macOS, `base64` is BSD base64 and does not support `-w0`. The flag causes an error. The `2>/dev/null` suppresses that error message, and the `||` fallback runs `base64` without the flag. On macOS, no wrapping occurs by default — the fallback produces the correct single-line output.

```bash
# GNU coreutils (Linux): -w0 works
printf '%s' "hello world" | base64 -w0
# → aGVsbG8gd29ybGQ=

# BSD base64 (macOS): -w0 fails, fallback used
printf '%s' "hello world" | base64 -w0 2>/dev/null || printf '%s' "hello world" | base64
# → aGVsbG8gd29ybGQ=
```

Both produce the same output.

**Decode on the remote side:**

```bash
DECODED=$(echo '$ENCODED' | base64 -d)
```

Note the **single quotes around `'$ENCODED'`** in the remote command string. When the hook constructs the SSH command, `$ENCODED` has already been expanded on the local side. The single quotes prevent the remote shell from further expanding the literal base64 string. The remote shell sees a literal encoded string, decodes it, and assigns the result to `$DECODED`.

**Update the non-interactive path with base64:**

```bash
# ── Non-interactive path ──────────────────────────────────────────────────────
# (PID lock has already run — not shown)

# Base64-encode the prompt for safe transport
ENCODED=$(printf '%s' "$PROMPT" | base64 -w0 2>/dev/null || printf '%s' "$PROMPT" | base64)

# Local invocation (no SSH) — decode and pass to claude
DECODED=$(echo "$ENCODED" | base64 -d)
cd "$ENTITY_DIR"
claude --model sonnet --dangerously-skip-permissions --output-format=json \
  -p "$DECODED" 2>/dev/null \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',''))"
```

For a local entity, encoding then immediately decoding is logically a no-op — the round-trip produces the same string. But it installs the habit and confirms the encode/decode works before the entity ever runs on a remote host. When the entity is eventually deployed remotely, the encoding side is already correct.

**Test with a prompt containing shell metacharacters:**

```bash
PROMPT="Commit changes to the 'entity's work' branch with message: it's done!" practice
```

Without base64: this would break on any remote invocation. With base64: the prompt is encoded to a clean ASCII string, decoded on the other side, and passed to claude correctly.

**What you can do now:**
- Add base64 encoding to your practice hook non-interactive path
- Test with a prompt containing a single quote and confirm the invocation succeeds
- Run the portability test: `printf '%s' "test" | base64 -w0 2>/dev/null || printf '%s' "test" | base64` — confirm it produces a single-line output
- Explain in one sentence why the single quotes around `'$ENCODED'` in the SSH command matter

**Exit criterion for this atom:** The operator can explain why raw prompt passing breaks, apply the encode/decode pattern correctly with the portability fallback, and test it with a metacharacter-containing prompt.

---

## Atom 6.4: PATH Initialization — NVM_INIT in Non-Interactive SSH

Base64 encoding solves the quoting problem. There is a second problem for entities that run on remote hosts via SSH: the remote shell may not have `claude` on its `PATH`.

**The non-interactive shell problem:**

When SSH runs a command without `-t` (non-interactive, headless), the remote shell is a non-interactive, non-login shell. On bash and zsh, this means:

- `.zshrc` is **not** sourced (zsh only sources it for interactive shells)
- `.bash_profile` / `.bashrc` may not be sourced (depends on system configuration)
- `nvm` is not initialized — `nvm` requires initialization code that lives in `.zshrc`
- `$PATH` contains only the system default: `/usr/bin:/bin:/usr/sbin:/sbin`
- `claude` is installed via nvm's node binary path — which is nowhere on the system PATH

Result: `claude: command not found`. The SSH command fails silently. `2>/dev/null` suppresses the error. The hook produces no output, the caller sees nothing, and the invocation appears to succeed — but it produced nothing.

This is one of the most insidious failures in hook authoring. The entity works perfectly in interactive mode (interactive SSH sources `.zshrc`). It silently produces no output in non-interactive mode. The only hint is the empty result.

**The solution: hardcode the PATH.**

```bash
NVM_INIT="export PATH=/opt/homebrew/bin:$HOME/.nvm/versions/node/v24.14.0/bin:$PATH"
```

Prepend `NVM_INIT` to every SSH command string. The remote shell executes `export PATH=...` before anything else, placing the nvm node binary directory at the front of `$PATH`. `claude` is found.

```bash
ENTITY_HOST="fourty4"  # the remote host where this entity lives
NVM_INIT="export PATH=/opt/homebrew/bin:$HOME/.nvm/versions/node/v24.14.0/bin:$PATH"
CLAUDE_BIN="$HOME/.nvm/versions/node/v24.14.0/bin/claude"

ssh "$ENTITY_HOST" "$NVM_INIT && cd $ENTITY_DIR && \
  DECODED=\$(echo '$ENCODED' | base64 -d) && \
  $CLAUDE_BIN --model sonnet --dangerously-skip-permissions \
    --output-format=json -p \"\$DECODED\" 2>/dev/null"
```

Note the escaped `\$` before `(echo` and `DECODED` — these are intended for the **remote** shell to expand, not the local shell. The local shell constructs the command string and passes it to SSH; the remote shell runs it.

**Why hardcode the node version?**

The tempting alternative: `$(nvm which node)` to find the current nvm-managed node at runtime. But this requires nvm to be initialized — which is exactly the problem `NVM_INIT` is solving. A circular dependency. Hardcoding the version breaks that cycle.

When the node version is upgraded (e.g., nvm installs node v26.0.0), update `NVM_INIT` and `CLAUDE_BIN` in the hook. This is a deliberate maintenance step: hook authors are responsible for knowing when their node version changes.

**`/opt/homebrew/bin` is included for macOS.** Homebrew installs tools to `/opt/homebrew/bin` on Apple Silicon Macs. Including it ensures tools like `git` and `python3` installed via Homebrew are available in the remote shell. On Linux, this path does not exist but adding it to `$PATH` is harmless — the kernel silently skips non-existent path entries.

**For the practice entity (local-only):** The practice entity runs on the same machine as the hook, so no SSH is involved. `NVM_INIT` is not strictly needed for local invocations — `claude` is already on the local shell's `PATH`. But declare `NVM_INIT` anyway to complete the pattern. When you copy this hook as a template for a remote entity, the pattern is already in place.

```bash
# At the top of the hook (configuration section)
NVM_INIT="export PATH=/opt/homebrew/bin:$HOME/.nvm/versions/node/v24.14.0/bin:$PATH"
CLAUDE_BIN="$HOME/.nvm/versions/node/v24.14.0/bin/claude"
```

**Test that `$CLAUDE_BIN` is correct:**

```bash
source <(echo "export PATH=/opt/homebrew/bin:$HOME/.nvm/versions/node/v24.14.0/bin:$PATH")
which claude
# Should show: /home/koad/.nvm/versions/node/v24.14.0/bin/claude (or similar)
```

If `claude` is not found at this path, adjust the node version number to match what is installed:

```bash
ls $HOME/.nvm/versions/node/
# Shows installed node versions — use the one that has claude
```

**What you can do now:**
- Add `NVM_INIT` and `CLAUDE_BIN` to the configuration section of your practice hook
- Verify `$CLAUDE_BIN` points to an executable: `ls -la "$HOME/.nvm/versions/node/v24.14.0/bin/claude"` (adjust version as needed)
- Explain the non-interactive shell problem in one sentence and why hardcoding the path solves it

**Exit criterion for this atom:** The operator can explain why the non-interactive shell does not have `claude` on its PATH, apply the `NVM_INIT` solution, verify the correct node version is hardcoded, and understand when to update the hook after a node version upgrade.

---

## Atom 6.5: Hook Ordering and Conflicts — The Filename Is the Contract

In the commands system, multiple layers can provide the same command — entity layer wins over framework layer, deepest path wins over parent path. Hook resolution is simpler: there is one hook per event. There is no "hook ordering" for a single event.

**Each event fires exactly one hook file.** The dispatcher looks for `executed-without-arguments.sh`. If it finds the entity-level file, it runs it and stops. If it does not find an entity-level file, it uses the framework-level file. There is no accumulation, no chain, no "run both." The entity hook replaces the framework hook entirely for that event.

**The filename is the event identifier — it is a contract, not a convention.**

You cannot name your hook something other than `executed-without-arguments.sh` and expect it to fire. The dispatcher looks for exact filenames. A file named `startup.sh` or `main-hook.sh` or `run.sh` in `hooks/` will never be called by the dispatcher — it will only run if you explicitly `source` or call it from another hook.

This is different from some CI systems (like GitHub Actions) where multiple workflow files can respond to the same event. In koad:io, each event has exactly one canonical hook filename. If you need multiple behaviors on a single event, compose them inside the one hook file.

**Entity vs framework hook — replacement semantics:**

The entity-level hook does not extend or augment the framework hook. It replaces it completely. This has a practical consequence: if the framework hook does something useful that you want to preserve, you must include that logic in your entity hook.

Example: the framework hook handles both interactive and non-interactive paths, with PRIMER.md injection and cascade loading. Juno's entity hook removes the non-interactive path entirely. She must still handle interactive invocation correctly — she cannot delegate that back to the framework hook.

Read Juno's hook again with this in mind:

```bash
# Juno does NOT have: PID lock
# Juno does NOT have: non-interactive path
# Juno DOES have: PRIMER.md injection (explicitly included)
# Juno DOES have: interactive path (fully implemented)
```

Juno's hook includes what it needs and omits what its policy prohibits. The framework hook is irrelevant once the entity hook file exists.

**Adding a second executed-without-arguments.sh:**

This is not possible. The file is a unique name in the `hooks/` directory. If you write a new `hooks/executed-without-arguments.sh`, it overwrites the existing one. There is no mechanism to have two files with the same name in the same directory. This is by design — one event, one handler, no ambiguity.

**The complete production-safe hook — incorporating all of Level 6:**

```bash
#!/usr/bin/env bash
set -euo pipefail

# ── Configuration ─────────────────────────────────────────────────────────────
ENTITY_DIR="${ENTITY_DIR:-$HOME/.practice}"
CALL_DIR="${CWD:-$PWD}"
LOCKFILE="/tmp/entity-practice.lock"
NVM_INIT="export PATH=/opt/homebrew/bin:$HOME/.nvm/versions/node/v24.14.0/bin:$PATH"
CLAUDE_BIN="$HOME/.nvm/versions/node/v24.14.0/bin/claude"

# ── Prompt detection ──────────────────────────────────────────────────────────
PROMPT="${PROMPT:-}"
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

# ── PRIMER.md injection (non-interactive only) ────────────────────────────────
if [ -n "$PROMPT" ] && [ -f "${CALL_DIR}/PRIMER.md" ]; then
  PROJECT_PRIMER="$(cat "$CALL_DIR/PRIMER.md")"
  PROMPT="$(printf 'Project context (from %s/PRIMER.md):\n%s\n\n---\n\n%s' \
    "$CALL_DIR" "$PROJECT_PRIMER" "$PROMPT")"
fi

# ── Logging ───────────────────────────────────────────────────────────────────
LOG_DIR="$ENTITY_DIR/var/hooks"
mkdir -p "$LOG_DIR"
INVOCATION_MODE="interactive"
[ -n "$PROMPT" ] && INVOCATION_MODE="non-interactive"
printf '%s [%d] mode=%s prompt_len=%d prompt_excerpt="%s"\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$$" \
  "$INVOCATION_MODE" "${#PROMPT}" "${PROMPT:0:80}" \
  >> "$LOG_DIR/invocations.log"

# ── Interactive path ──────────────────────────────────────────────────────────
if [ -z "$PROMPT" ]; then
  cd "$ENTITY_DIR"
  exec claude . --model sonnet --dangerously-skip-permissions --add-dir "$CALL_DIR"
fi

# ── Non-interactive path ──────────────────────────────────────────────────────

# PID lock — prevents concurrent non-interactive invocations
if [ -f "$LOCKFILE" ]; then
  LOCKED_PID=$(cat "$LOCKFILE" 2>/dev/null || echo "")
  if [ -n "$LOCKED_PID" ] && kill -0 "$LOCKED_PID" 2>/dev/null; then
    echo "[lock] practice is busy (pid $LOCKED_PID). Try again shortly." >&2
    exit 1
  fi
fi
echo $$ > "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT

# Base64-encode prompt for safe transport
ENCODED=$(printf '%s' "$PROMPT" | base64 -w0 2>/dev/null || printf '%s' "$PROMPT" | base64)
DECODED=$(echo "$ENCODED" | base64 -d)

# Run claude
cd "$ENTITY_DIR"
claude --model sonnet --dangerously-skip-permissions --output-format=json \
  -p "$DECODED" 2>/dev/null \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',''))"
```

**Run the full production test sequence before declaring Level 6 complete:**

1. `practice` — interactive session opens, closes cleanly, no lock artifacts
2. `PROMPT="what entity are you?" practice` — response extracted and printed
3. `PROMPT="describe the 'entity's purpose' in this system" practice` — single-quote prompt succeeds
4. Two concurrent invocations (from the test in Atom 6.1) — second is rejected
5. `cat ~/.practice/var/hooks/invocations.log` — four entries, correct modes

All five must pass. If any fails, diagnose before Level 7.

**What you can do now:**
- Write the complete production-safe hook from the template above into your practice entity
- Run the five-scenario test sequence
- Explain in one sentence the difference between hook replacement (entity level) and hook ordering (does not exist)

**Exit criterion for this atom:** The operator can explain the replacement model for entity vs framework hooks, state that hook filenames are contracts not conventions, and deliver a hook that passes all five production test scenarios.

---

## Exit Criterion

The operator can:
- Recite the five PID lock steps from memory: check, read, kill-0 test, fail-fast or write PID, trap
- Explain `kill -0` semantics and what constitutes a stale lock
- Apply the base64 encode/decode pattern with the correct Linux/macOS portability handling
- Explain the non-interactive shell PATH problem and apply the `NVM_INIT` solution
- State why hook filenames are a contract and what the entity-level override semantics are

**Verification question:** "Your hook's PID lockfile exists and contains PID 12345. You run `kill -0 12345` and get exit code 1. What does that mean and what does your hook do next?"

Expected answer: Exit code 1 means the process with PID 12345 does not exist — the lock is stale. The hook overwrites the lockfile with its own PID (`echo $$ > "$LOCKFILE"`) and proceeds to run the non-interactive path.

---

## Assessment

**Question:** "Your hook receives the prompt: `Commit all changes to the 'entity's work' branch.` Why does this break without base64 encoding when passed over SSH, and how does base64 encoding fix it?"

**Acceptable answers:**
- "The apostrophe in `entity's` terminates the outer single-quoted SSH argument at the wrong position — the shell sees the string close early and the rest of the prompt becomes unquoted tokens. Base64 encodes the prompt to a string containing only `A-Z`, `a-z`, `0-9`, `+`, `/`, `=` — no shell metacharacters. The encoded string passes through SSH cleanly and is decoded on the remote side before being passed to claude."

**Red flag answers (indicates level should be revisited):**
- "Use double quotes instead of single quotes" — the problem occurs with single quotes inside single-quoted strings; double quotes have their own issues with dollar signs and backticks
- "Escape the apostrophe" — correct in theory but brittle; base64 eliminates the entire class of quoting problems with one mechanism

**Estimated engagement time:** 25–30 minutes

---

## Alice's Delivery Notes

This level has the highest density of technical content in the curriculum. The PID lock alone spans Atoms 6.1 and 6.2 with five distinct steps and two edge cases (stale lock, interactive-path exemption). Do not rush through this to reach base64. An operator who misunderstands the PID lock and writes it incorrectly will not discover the error until their entity experiences a race condition under load — by which time the cause is opaque.

The five PID lock steps (Atom 6.1) should be recited out loud by the operator before they write them in code. "Check, read, test with kill-0, fail-fast if alive, write own PID and register trap." Then they write from memory and check against the reference. This install-then-verify sequence is more durable than copy-paste.

The base64 portability issue (Atom 6.3) is worth a concrete demonstration if the operator is on macOS: run `echo "test" | base64 -w0` and observe the error. Then show the fallback pattern working. Operators who only ever run on Linux will experience this as abstract. Operators who deploy to macOS later will be mystified when the hook breaks without this pattern.

The Atom 6.5 "complete production-safe hook" is the deliver moment. The operator now has a complete, production-safe hook in their practice entity that handles everything: mode detection, PRIMER.md injection, logging, PID lock, base64, PATH initialization. Run the five-scenario test sequence together as a ritual before declaring Level 6 complete. Operators who run all five scenarios before Level 7 arrive at the synthesis level with confidence rather than residual uncertainty.

---

### Bridge to Level 7

Your hook is production-safe. Your commands are entity-aware. Level 7 brings them together: you will design and deliver a complete entity skill — a command that makes a capability available to operators, a hook that exposes the same capability to automation, and shared library logic that keeps both implementations synchronized. You will test all three invocation scenarios and see the whole system work as a unit.
