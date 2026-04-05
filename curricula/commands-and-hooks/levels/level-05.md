---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 5
slug: writing-a-hook
title: "Writing a Hook — Inject Context, Guard, Log"
status: authored
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
> Write a working `executed-without-arguments.sh` for the practice entity that correctly detects the invocation mode (`$PROMPT` present vs. absent), branches to the interactive path (direct `claude` invocation) or non-interactive path (run `claude -p`), injects PRIMER.md context, and logs the invocation to a file.

**Why this matters:** The hook is the entity's contract with the outside world. A hook that misdetects the invocation mode either hangs waiting for input it will never receive (non-interactive path taken when interactive was intended) or exits immediately without producing a session (interactive path taken when a prompt was expected). Correct mode detection is the foundation on which all hook behavior depends.

---

## Knowledge Atoms

## Atom 5.1: The Minimal Hook Skeleton — Shebang, Variables, Prompt Detection

Every hook starts from the same skeleton. Write this now — before any branching logic, before any harness invocation, before any features. The skeleton is the hook's foundation. Add complexity on top of it; never start from complexity.

Create the hooks directory and the hook file:

```bash
mkdir -p ~/.practice/hooks
touch ~/.practice/hooks/executed-without-arguments.sh
chmod +x ~/.practice/hooks/executed-without-arguments.sh
```

Write the skeleton:

```bash
#!/usr/bin/env bash
set -euo pipefail

# ── Configuration ─────────────────────────────────────────────────────────────
ENTITY_DIR="${ENTITY_DIR:-$HOME/.practice}"
CALL_DIR="${CWD:-$PWD}"
LOCKFILE="/tmp/entity-practice.lock"

# ── Prompt detection ──────────────────────────────────────────────────────────
PROMPT="${PROMPT:-}"
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

echo "[hook] practice invoked. PROMPT length: ${#PROMPT}"
```

Invoke `practice` bare and confirm you see `[hook] practice invoked. PROMPT length: 0`. That is the skeleton working: the hook fires, reads the configuration, and reports correctly that no prompt was given.

Now test the non-interactive detection:

```bash
PROMPT="what entity are you?" practice
```

Expected output: `[hook] practice invoked. PROMPT length: 22` (or similar, depending on your prompt). The detection block works.

**Line by line:**

`ENTITY_DIR="${ENTITY_DIR:-$HOME/.practice}"` — reads from cascade, falls back to the conventional path. This is an exception to the conformance rule from Level 3: because the hook runs before the full cascade is loaded in some edge invocation paths, adding a fallback is defensive here. Once you are confident the cascade always provides `ENTITY_DIR`, you can remove the fallback.

`CALL_DIR="${CWD:-$PWD}"` — where the invocation happened. If the caller set `CWD` (as the framework dispatcher does), use it; otherwise fall back to `$PWD`. This is how the hook knows which project directory to look in for `PRIMER.md`.

`LOCKFILE="/tmp/entity-practice.lock"` — the location of the PID lockfile. Level 6 adds the full PID lock logic. For now, declare the path.

`PROMPT="${PROMPT:-}"` — read the prompt from the environment. The `:-` default makes it an empty string if unset (required for `set -u` compatibility).

`if [ -z "$PROMPT" ] && [ ! -t 0 ]; then PROMPT="$(cat)"; fi` — if `$PROMPT` is empty AND stdin is not a terminal (i.e., something is piped in), read from stdin. This handles the piped-prompt invocation pattern: `echo "do this task" | practice`.

After this block: `$PROMPT` is either empty (interactive) or non-empty (non-interactive). Every subsequent decision in the hook is based on this single variable.

**What you can do now:**
- Write the skeleton exactly as above; invoke `practice` and confirm the debug line fires
- Test `PROMPT="hello" practice` and confirm the prompt length changes
- Test `echo "piped prompt" | practice` and confirm the piped prompt is detected

**Exit criterion for this atom:** The operator has a working hook skeleton that correctly detects both the empty-prompt (interactive) and non-empty-prompt (non-interactive) scenarios.

---

## Atom 5.2: The Interactive Path — Local harness invocation

The interactive path fires when `$PROMPT` is empty after detection. The operator typed `practice` with no prompt in the environment and no piped input. They want a terminal session.

The correct behavior: launch the AI harness configured for this entity, in the entity directory, in a way that hands full terminal control to the harness.

For a local entity (running on the machine where the hook fires), the interactive path is:

```bash
if [ -z "$PROMPT" ]; then
  echo "[hook] Interactive path"
  cd "$ENTITY_DIR"
  exec claude . --model sonnet --dangerously-skip-permissions --add-dir "$CALL_DIR"
fi
```

**`exec` is essential here.** `exec` replaces the hook process with `claude`. Without it, the hook process waits for `claude` to finish — that is a zombie parent process sitting idle while the session runs. With `exec`, the hook process becomes `claude` directly. When the user ends their Claude Code session, the process exits cleanly with no orphan.

**`cd "$ENTITY_DIR"` places the session in the entity directory.** Claude Code reads `CLAUDE.md` from the current directory. If the entity has a `CLAUDE.md`, running `claude` from `$ENTITY_DIR` ensures the entity's context instructions are loaded automatically.

**`--add-dir "$CALL_DIR"` gives Claude Code access to the calling directory.** If the operator invoked `practice` from inside a project directory, they probably want Claude to be able to read files there. `--add-dir` grants read access without making it the working directory.

**What about SSH?** For entities that run on remote machines (like Juno, which lives on thinker and is accessed from other machines), the interactive path uses `exec ssh -t` to forward the terminal through SSH. The practice entity is local, so no SSH is needed. Level 6 covers the remote case in the context of PATH initialization — the practice entity hook uses the local form.

**Test the interactive path:**

```bash
practice
```

A Claude Code session should open in `~/.practice/`. Type `/exit` to end it. Confirm there are no orphaned processes after exiting:

```bash
ps aux | grep claude
```

You should not see a stale `practice` hook process. The `exec` replacement worked.

**Add the interactive branch to the skeleton** — insert it after the prompt detection block:

```bash
# ── Interactive path ──────────────────────────────────────────────────────────
if [ -z "$PROMPT" ]; then
  echo "[hook] Interactive path — launching claude"
  cd "$ENTITY_DIR"
  exec claude . --model sonnet --dangerously-skip-permissions --add-dir "$CALL_DIR"
fi
```

The rest of the hook (non-interactive path) goes after this `if` block. Because the interactive path uses `exec`, it never returns — the code after it only runs in the non-interactive case. This is the intended structure.

**What you can do now:**
- Add the interactive branch to your practice hook and test it with `practice` (bare)
- Confirm the session opens in `~/.practice/` (check the directory shown in the Claude Code session)
- Exit the session and verify no stale processes remain

**Exit criterion for this atom:** The operator can invoke `practice` bare, get an interactive Claude Code session, exit cleanly, and explain why `exec` rather than a plain call to `claude` is the correct pattern.

---

## Atom 5.3: The Non-Interactive Path — claude -p and --output-format=json

After the interactive branch exits (via `exec`), any code remaining in the hook only runs when `$PROMPT` is non-empty. This is the non-interactive path. Add a comment that makes this boundary explicit:

```bash
# ── Non-interactive path ──────────────────────────────────────────────────────
# If we reach this point, $PROMPT is set. Run a fresh -p session.
echo "[hook] Non-interactive path"
```

The core non-interactive invocation:

```bash
cd "$ENTITY_DIR"
claude --model sonnet --dangerously-skip-permissions --output-format=json \
  -p "$PROMPT" 2>/dev/null \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',''))"
```

**The four required Claude Code flags:**

| Flag | Required | Rationale |
|------|----------|-----------|
| `-p "$PROMPT"` | Yes | Batch/non-interactive mode — run the prompt and exit |
| `--output-format=json` | Yes | Structured output; the result is in the `.result` field |
| `--model sonnet` | Yes | Specifies which model to use; prevents fallback to a default that may differ |
| `--dangerously-skip-permissions` | Yes | Entities run autonomously; permission prompts would hang the non-interactive session |

**No `exec` here.** The non-interactive path does not use `exec` because the hook needs to continue after `claude` exits — specifically, to parse the JSON output. `exec` would replace the hook process and give the caller raw JSON rather than the extracted result.

**`--output-format=json` produces a structured response:**

```json
{
  "type": "result",
  "result": "I am the practice entity, running on thinker.",
  "cost_usd": 0.0021,
  "session_id": "abc123..."
}
```

The `python3` one-liner extracts `.result`. This works on any system with Python 3 installed, which is universal on both Linux and macOS without additional installation.

**`2>/dev/null` suppresses claude's progress output.** Claude Code prints status lines to stderr during a `-p` run. Callers who capture stdout to get the result do not want these mixed in. Suppressing stderr means the result is clean.

**Test the non-interactive path:**

```bash
PROMPT="What entity are you? State your name and directory." practice
```

Expected output: the entity's response as plain text, extracted from the JSON. It should mention `practice` and the directory.

```bash
# Verify the JSON output format directly (without extraction)
PROMPT="Say hello." claude --model sonnet --dangerously-skip-permissions --output-format=json -p "Say hello." 2>/dev/null
```

You should see the raw JSON structure. The python3 extraction gives you just the `.result` field.

**Simplified path for Level 5:** This level's hook does not yet have the PID lock or base64 encoding. Level 6 adds both. The hook written here is correct for the nominal case but is not production-safe for concurrent invocations or prompts with special characters. That is intentional — learn the structure first, then add the safety protocols.

**What you can do now:**
- Add the non-interactive branch to your practice hook
- Test with `PROMPT="describe what you are" practice` and confirm you receive a response
- Explain why `--output-format=json` is used and what the `python3` extraction does

**Exit criterion for this atom:** The operator can invoke the practice entity with a prompt, receive a clean text response, and explain what each of the four Claude flags does.

---

## Atom 5.4: Injecting Context — PRIMER.md and Pre-Invocation Context

An entity invoked bare has access to its own `CLAUDE.md` — that is Claude Code's standard context loading. But when another entity invokes it from within a project directory, the entity being invoked has no context about that project. It has to ask, or infer from the prompt, or miss relevant information entirely.

PRIMER.md injection solves this. The pattern: before passing the prompt to claude, check if a `PRIMER.md` exists in the calling directory (`$CALL_DIR`) and prepend it to the prompt with a separator.

```bash
# ── PRIMER.md injection ───────────────────────────────────────────────────────
if [ -n "$PROMPT" ] && [ -f "${CALL_DIR}/PRIMER.md" ]; then
  PROJECT_PRIMER="$(cat "$CALL_DIR/PRIMER.md")"
  PROMPT="$(printf 'Project context (from %s/PRIMER.md):\n%s\n\n---\n\n%s' \
    "$CALL_DIR" "$PROJECT_PRIMER" "$PROMPT")"
  echo "[hook] Injected PRIMER.md from $CALL_DIR"
fi
```

Insert this block **after prompt detection and before the interactive/non-interactive branch**.

**Why `if [ -n "$PROMPT" ]` guards the injection:** PRIMER.md injection is only useful when there is a prompt — the interactive path will load `CLAUDE.md` normally via Claude Code's own mechanism. Injecting context into an interactive session would waste tokens and add noise. The guard ensures injection only happens on the non-interactive path.

**The format of the injected prompt:**

```
Project context (from /home/koad/myproject/PRIMER.md):
<contents of PRIMER.md>

---

<original prompt>
```

The separator `---` is a Markdown horizontal rule that clearly demarcates where the context ends and the task begins. Claude understands this as a structural boundary without needing explicit instruction.

**What to put in a PRIMER.md:** A PRIMER.md is a brief orientation document for agents arriving in a project directory. It should cover: what this project is, its current state, what an agent finding this file should do first. It is not a full specification — it is an entry-point. A useful PRIMER.md for a project directory might be 100–300 words.

**Why this produces better results:** An entity invoked to "review the latest commit" in a project it has never seen needs context to give a useful review. A PRIMER.md that explains "this is the alice front-end; we use TypeScript; main is always deployable; PRs go through vulcan" gives the entity ten seconds of context that would otherwise take minutes to establish.

**Test injection:**

```bash
mkdir -p /tmp/testproject
cat > /tmp/testproject/PRIMER.md << 'EOF'
This is the test project. It has no files. When asked about it, say "test project found" first.
EOF

cd /tmp/testproject
PROMPT="What do you know about this project?" practice
```

The response should mention "test project found" — the entity read the PRIMER.md and incorporated it. Remove the test directory afterward.

**What you can do now:**
- Add PRIMER.md injection to your practice hook in the correct location (after detection, before branching)
- Test it by creating a PRIMER.md in a temp directory and invoking practice from there with a prompt
- Explain why the injection guard (`if [ -n "$PROMPT" ]`) is necessary

**Exit criterion for this atom:** The operator can add PRIMER.md injection to a hook, verify it works, and explain the mechanism and why it only fires on the non-interactive path.

---

## Atom 5.5: Logging the Invocation — Append to var/hooks/

A hook that logs its invocations is dramatically easier to debug than one that does not. When something goes wrong — the wrong path fires, a prompt is mangled, context injection fails — the log file shows exactly what the hook received and what it decided.

The minimal logging pattern:

```bash
# ── Logging ───────────────────────────────────────────────────────────────────
LOG_DIR="$ENTITY_DIR/var/hooks"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/invocations.log"

INVOCATION_MODE="interactive"
if [ -n "$PROMPT" ]; then
  INVOCATION_MODE="non-interactive"
fi

PROMPT_EXCERPT="${PROMPT:0:80}"
printf '%s [%s] mode=%s prompt_len=%d prompt_excerpt="%s"\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  "$$" \
  "$INVOCATION_MODE" \
  "${#PROMPT}" \
  "$PROMPT_EXCERPT" \
  >> "$LOG_FILE"
```

Insert this block **after PRIMER.md injection (which may have lengthened the prompt) and before the interactive/non-interactive branch**.

**Why `var/hooks/` is the correct location:**

- `var/` is the conventional location for ephemeral runtime data in Unix systems. It is analogous to `/var/` at the system level.
- Runtime data — logs, PID files, transient state — belongs in `var/`, not in the entity root.
- `var/` should be gitignored by default. Check your practice entity's `.gitignore` to confirm `var/` is excluded. If it is not, add it:

```bash
echo "var/" >> ~/.practice/.gitignore
```

Logs should not be committed to git. They are ephemeral debug data, not part of the entity's identity.

**`mkdir -p "$LOG_DIR"`** creates the directory if it does not exist. This is the `mkdir -p` pattern: always use it when creating directories that might already exist. Without `-p`, creating an already-existing directory is an error.

**The log line format:**

```
2026-04-05T12:34:56Z [12345] mode=non-interactive prompt_len=22 prompt_excerpt="what entity are you?"
2026-04-05T12:35:10Z [12348] mode=interactive prompt_len=0 prompt_excerpt=""
```

Each line has: ISO 8601 timestamp, PID, invocation mode, full prompt length, and first 80 characters of the prompt. The 80-character truncation prevents gigantic log lines if a long prompt with PRIMER.md prepended is passed.

**Reading the log after testing:**

```bash
cat ~/.practice/var/hooks/invocations.log
```

Run both invocation modes and confirm two distinct log entries appear, with different mode values.

**Complete hook at the end of Level 5:**

```bash
#!/usr/bin/env bash
set -euo pipefail

# ── Configuration ─────────────────────────────────────────────────────────────
ENTITY_DIR="${ENTITY_DIR:-$HOME/.practice}"
CALL_DIR="${CWD:-$PWD}"
LOCKFILE="/tmp/entity-practice.lock"

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
cd "$ENTITY_DIR"
claude --model sonnet --dangerously-skip-permissions --output-format=json \
  -p "$PROMPT" 2>/dev/null \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',''))"
```

This is the Level 5 hook: functional, loggable, context-injecting. It does not yet have the PID lock or base64 encoding — those are Level 6. But it correctly handles both invocation modes and produces verifiable output.

**What you can do now:**
- Add logging to the hook
- Invoke the hook interactively and non-interactively
- Read the log and confirm two distinct entries appear with correct mode labels
- Verify the log is in `var/hooks/` and that `var/` is gitignored

**Exit criterion for this atom:** The operator's hook logs every invocation with mode, prompt length, and excerpt; they can read the log after each test; and they can verify the log is gitignored and not committed.

---

## Exit Criterion

The operator can:
- Write a `executed-without-arguments.sh` skeleton with correct prompt detection
- Implement the interactive path with `exec claude` and explain why `exec` is required
- Implement the non-interactive path with `claude -p` and `--output-format=json`
- Add PRIMER.md context injection with the correct guard condition
- Add invocation logging to `var/hooks/` with `mkdir -p`
- Test both paths and verify correct behavior from the log

**Verification question:** "Your practice entity's hook fires but always takes the interactive path, even when you set `PROMPT='test'` before invoking. What do you check first?"

Expected answer: Confirm `$PROMPT` is exported so it is inherited by the hook process. Use `export PROMPT="test"` or inline it as `PROMPT="test" practice`. If that does not fix it, inspect the detection block — the `&&` in `[ -z "$PROMPT" ] && [ ! -t 0 ]` must be correct.

---

## Assessment

**Question:** "Why does the interactive path use `exec claude` while the non-interactive path uses a plain `claude` call?"

**Acceptable answers:**
- "The interactive path hands full terminal control to `claude` — there is no output to post-process after claude exits, so `exec` replaces the hook process with claude cleanly. The non-interactive path needs to receive the JSON output from claude, extract `.result`, and print it — it cannot use `exec` because it must continue executing after the claude call completes."
- "exec is a process replacement. The interactive path does not need the hook shell after claude starts. The non-interactive path does — it pipes output through python3."

**Red flag answers (indicates level should be revisited):**
- "Both paths should use `exec`" — the non-interactive path cannot use `exec` if it needs to process output
- "exec makes it faster" — not the reason; it is about clean process handoff and avoiding orphan shell processes

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

This level is hands-on from Atom 5.1. The operator should be at a terminal for the entire level, writing each section of the hook and testing it before moving to the next. Alice guides but does not type — the operator writes the hook themselves with Alice narrating.

The ordering of additions matters pedagogically. Introduce them in this sequence: (1) skeleton + detection, (2) interactive path, (3) non-interactive path, (4) PRIMER.md injection, (5) logging. Each addition is testable before the next is added. Operators who jump ahead and write the full hook at once cannot isolate failures when something goes wrong.

The simplified non-interactive path (no base64, no PID lock) is intentional. An operator who is simultaneously managing base64 encoding and PID lock while learning the basic hook structure will lose the thread. Level 5's goal is a hook that works correctly in the nominal case. Level 6 adds the safety protocols that make it production-ready.

Atom 5.4 (PRIMER.md injection) is worth time because it illustrates how entities compose with project context. Operators who understand this pattern will add PRIMER.md to their project directories and immediately see better responses from invoked entities — they will not have to re-explain their project every time. This is a high-value practical demonstration.

By the end of this level, the practice entity has a working hook at `~/.practice/hooks/executed-without-arguments.sh` and an invocation log at `~/.practice/var/hooks/invocations.log`. Both files are observable artifacts that prove the hook is functioning. Test both paths before declaring Level 5 complete.

---

### Bridge to Level 6

Your hook works. It detects the invocation mode, handles both paths, injects context, and logs. But it is not yet production-safe: it has no PID lock (two concurrent invocations could corrupt state), no base64 encoding (prompts with single quotes, apostrophes, or newlines will break under SSH), and no PATH initialization (entities on remote hosts cannot find `claude` in a non-interactive shell). Level 6 adds all three.
