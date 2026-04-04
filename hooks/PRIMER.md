# PRIMER: Entity Hooks System

The hooks routing layer connects Juno on thinker to the entity team on fourty4.

---

## What `executed-without-arguments.sh` Does and Why It Exists

Every entity directory has a `hooks/` folder. `executed-without-arguments.sh` fires when the entity command is invoked with no subcommand — just `mercury`, `muse`, `vulcan`, etc. The koad-io framework resolves the binary, finds no matching subcommand, and falls through to this hook.

It is the answer to one question: **where does this entity live, and how do I reach it?**

Before persistent processes, this hook was the entire "launch entity" experience. It still is. For entities living on remote machines, it handles the SSH. For interactive sessions, it drops you into a live terminal. For scripted tasks, it sends a prompt and returns a result.

---

## Current Architecture (as of 2026-04-04)

All 15 entities are cloned on fourty4 (Mac Mini, always-on). When you call an entity from thinker, the hook SSHs to fourty4 and runs Claude Code there in the entity's directory.

Two modes, determined by whether a prompt is available:

### Non-interactive (task mode)

Triggered when `PROMPT` is set in the environment or text is piped via stdin:

```bash
PROMPT="draft a post about sovereignty" mercury
echo "draft a post about sovereignty" | mercury
```

Uses `claude --dangerously-skip-permissions -c --output-format=json -p "$PROMPT"` on the remote. The `-p` flag starts a **fresh session** — no prior context. Output is JSON; the hook extracts `.result` and prints it to stdout. Used for autonomous orchestration: Juno pings Mercury with a task, gets text back, moves on.

### Interactive (session mode)

Triggered when no prompt is present and a TTY is attached (you typed the command directly):

```bash
mercury
```

Uses `claude --dangerously-skip-permissions -c` on the remote. The `-c` flag **continues the existing session** on fourty4. You get a live terminal portal into Mercury's session. `exec ssh -t` replaces the current shell process — no wrapper process left behind.

---

## PID Lock Pattern (added 2026-04-04)

**File:** `/tmp/entity-<name>.lock`

On entry, the hook checks for a lock file. If present, it reads the PID and exits immediately — no queuing, no waiting. If absent, it writes its own PID and sets a trap to remove the lock on exit (normal or crash).

```bash
LOCK_FILE="/tmp/entity-muse.lock"
if [ -f "$LOCK_FILE" ]; then
  echo "muse is already running (PID $(cat "$LOCK_FILE")). exiting."
  exit 1
fi
echo $$ > "$LOCK_FILE"
trap "rm -f '$LOCK_FILE'" EXIT
```

**Why:** Two concurrent invocations driving the same `-c` session would corrupt its state — both processes would be writing to the same Claude Code conversation simultaneously. The lock prevents this. Fail-fast is intentional: if the entity is busy, the caller should handle that, not silently queue.

---

## Base64 Encoding Pattern (added 2026-04-04)

**Why it exists:** Prompts pass through an SSH command string assembled on the local machine and executed by a remote shell. Shell quoting on the remote side breaks on apostrophes — `it's` becomes `it'$'\''s'`, which may break the entire command depending on quoting depth.

**How it works:** Encode the prompt locally, decode on the remote before passing to Claude:

```bash
# Local: encode (portable across Linux -w0 and macOS)
ENCODED=$(printf '%s' "$PROMPT" | base64 -w0 2>/dev/null || printf '%s' "$PROMPT" | base64)

# Remote: decode into a variable, then pass to claude
DECODED=$(echo '$ENCODED' | base64 -d) && claude -p "$DECODED"
```

Base64 output is alphanumeric + `/+=` — none of which break shell quoting. The prompt survives transit intact regardless of its content.

---

## What the Daemon Will Replace

This hook is a stopgap. When the daemon is live:

- It will maintain a **persistent connection** to each entity's process
- Prompts will go through a **message queue**, not a raw SSH command
- Results will come back via a **structured channel**, not stdout parsing
- The hook becomes a thin client that sends to the daemon socket

The two-mode distinction (interactive vs task) survives — it maps to "attach to session" vs "submit task". The implementation changes; the interface does not.

---

## Known Limitations

- **No queuing.** If the entity is busy (lock held), the call fails immediately. The caller must retry.
- **No retry.** Transient SSH failures are not retried. A flapping network means a dropped task.
- **No result persistence.** Output goes to stdout only. Nothing is logged automatically. If the caller doesn't capture it, it's gone.
- **Session continuity is fragile.** `-c` resumes the most recent Claude Code session on fourty4. If that session was cleared (reboot, manual reset), `-c` starts fresh without warning. The entity loses conversational context silently.
- **Single-machine assumption.** The host is hardcoded. If fourty4 is unreachable, every entity call fails. The daemon will fix this with routing logic.

---

## What's Next: Primed Sessions

PRIMER.md files — this file and the entity-level `~/.juno/PRIMER.md` — will be prepended to prompts when an entity is invoked with a task. Instead of `identity + task`, the entity receives:

```
PRIMER.md (ecosystem orientation)
+ 001-identity.md (who I am)
+ task
```

This gives each session enough context to work without re-deriving the ecosystem from scratch. The hook will prepend the primer automatically when constructing the prompt string before encoding and sending.
