---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 6
slug: hook-internals
title: "Hook Internals — Ordering, Conflicts, the PID Lock Pattern"
status: scaffold
prerequisites:
  curriculum_complete:
    - entity-gestation
  level_complete:
    - commands-and-hooks/level-05
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 6: Hook Internals — Ordering, Conflicts, the PID Lock Pattern

## Learning Objective

After completing this level, the operator will be able to:
> Implement the full PID lock pattern (acquire, stale detection, write, trap-on-exit), apply the base64 encoding pattern for prompt transport, initialize PATH via NVM_INIT for non-interactive SSH, and explain why each of these mechanisms exists.

**Why this matters:** A hook without PID lock protection allows concurrent invocations that corrupt git state and agent memory. A hook without base64 encoding breaks on any prompt containing single quotes, apostrophes, or newlines. A hook without PATH initialization fails silently on any machine where NVM is not initialized in the non-interactive shell. These are the three failure modes that production hooks must prevent.

---

## Knowledge Atoms

## Atom 6.1: The PID Lock — Five Steps, One Trap

<!-- SCAFFOLD: Cover the full PID lock acquire/release sequence from VESTA-SPEC-020 §5. The five steps: (1) Check if lockfile exists at `/tmp/entity-<name>.lock`. (2) If it exists, read the PID from it. (3) Test the PID with `kill -0 "$LOCKED_PID" 2>/dev/null`. (4) If alive (exit 0) — another invocation is running, fail-fast with exit 1 and a message. (5) If dead (exit non-zero) — stale lock, overwrite and proceed. After passing the check: write own PID (`echo $$ > "$LOCKFILE"`), register `trap 'rm -f "$LOCKFILE"' EXIT` to clean up on any exit. Cover each step's rationale. Use `kill -0` semantics: signal 0 does not kill the process, it only checks existence. Cover why `/tmp` is the correct location (auto-cleared on reboot, always writable, consistent across Linux and macOS). Add the full PID lock to the practice entity hook. -->

---

## Atom 6.2: Stale Lock Detection — kill -0 Semantics

<!-- SCAFFOLD: Drill the `kill -0` semantics as a standalone atom because operators who misunderstand it write incorrect stale lock detection. `kill -0 PID`: if the process is alive and owned by this user, exit 0 (alive). If the process does not exist or is not owned, exit non-zero (dead). A stale lock is a lockfile with a PID that is no longer alive — typically left by a hook that crashed without running its trap, or a hook that ran on a machine that was later rebooted (`/tmp` is cleared on reboot). Cover the test pattern: `if [ -n "$LOCKED_PID" ] && kill -0 "$LOCKED_PID" 2>/dev/null; then` — the compound condition prevents false positives when the lockfile is empty or unreadable. Also: the PID lock applies only to the non-interactive path. Interactive sessions are not locked — a human running `practice` directly always gets a terminal. -->

---

## Atom 6.3: Base64 Encoding — Shell Quoting Across SSH

<!-- SCAFFOLD: Cover the problem and solution from VESTA-SPEC-020 §6. The problem: prompts contain single quotes, apostrophes, newlines, dollar signs — all characters that break shell quoting when passed across an SSH boundary. The solution: base64-encode the prompt before the SSH call, pass the encoded string (which is ASCII-safe, no shell metacharacters), decode on the remote side. Cover the encode/decode pattern: encode with `printf '%s' "$PROMPT" | base64 -w0 2>/dev/null || printf '%s' "$PROMPT" | base64`. Decode on the remote: `DECODED=$(echo '$ENCODED' | base64 -d)`. Cover the Linux vs macOS portability concern: GNU `base64` uses `-w0` to disable line wrapping; BSD `base64` (macOS) does not support `-w0`. The `2>/dev/null || fallback` pattern handles this. Explain why `printf '%s'` rather than `echo` (avoid trailing newline). Update the practice entity hook to use base64 encoding. -->

---

## Atom 6.4: PATH Initialization — NVM_INIT in Non-Interactive SSH

<!-- SCAFFOLD: Cover the PATH initialization problem from VESTA-SPEC-020 §7. Non-interactive SSH does not source `.zshrc` or `.bashrc` — the remote shell has only the system default PATH. `claude` is installed via NVM's node, which is not on the system PATH. Result: `claude: command not found` in the remote SSH command, silently (stderr is suppressed). The solution: hardcode `NVM_INIT="export PATH=/opt/homebrew/bin:$HOME/.nvm/versions/node/v24.14.0/bin:$PATH"` and prepend it to every SSH command. Explain why hardcoding the node version is correct: `$(nvm which node)` requires nvm to be initialized, which is the problem we are solving. Cover the consequence of node version upgrades: when the node version changes, the hook must be updated. Add `NVM_INIT` to the practice entity hook. Test the non-interactive path and confirm claude is found. -->

---

## Atom 6.5: Ordering and Conflicts — What Happens When Multiple Hooks Exist

<!-- SCAFFOLD: Cover hook ordering semantics when multiple hooks exist in the `hooks/` directory (other than `executed-without-arguments.sh`). The general principle: hook files are named by event, and events do not collide (each event fires exactly one hook). If the same event hook exists in both the entity directory and the framework directory (analogous to the commands layer system), the entity's hook takes precedence. Cover the concept of hook conflicts: an operator who adds a second copy of `executed-without-arguments.sh` under a different name will not trigger it — the framework is looking for the specific filename. Hook filenames are a contract, not a convention. Close with: there is no "hook ordering" for the same event because each event has exactly one hook — the framework does not run multiple hooks for the same event. This is different from some CI systems where multiple hooks can fire for the same event. -->

---

## Exit Criterion

The operator can:
- Implement the five-step PID lock acquire/release sequence from memory
- Explain `kill -0` semantics and what constitutes a stale lock
- Apply the base64 encode/decode pattern with correct Linux/macOS portability handling
- Explain the PATH initialization problem and apply the `NVM_INIT` solution
- State why hook filenames are a contract (event-to-file mapping) and what that means for hook ordering

**Verification question:** "Your hook's PID lockfile exists and contains PID 12345. You run `kill -0 12345` and get exit code 1. What does that mean and what does your hook do next?"

Expected answer: Exit code 1 means the process with PID 12345 is dead — the lock is stale. The hook overwrites the lockfile with its own PID and proceeds.

---

## Assessment

**Question:** "Your hook receives the prompt: `Commit all changes to the 'entity's work' branch.` (note the apostrophe). Why does this break without base64 encoding, and how does base64 encoding fix it?"

**Acceptable answers:**
- "The apostrophe in 'entity's' terminates the outer single-quoted SSH argument, breaking the shell command. Base64 encodes the prompt to a string containing only alphanumeric characters and `+`, `/`, `=` — no shell metacharacters. The encoded string passes through SSH cleanly and is decoded on the remote side."

**Red flag answers (indicates level should be revisited):**
- "Use double quotes instead of single quotes" — the problem occurs with single quotes inside single-quoted strings, not from the outer quoting; double quotes have their own escaping issues with dollar signs and backticks
- "Escape the apostrophe" — correct in theory but impractical; base64 eliminates the entire class of problems

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

<!-- SCAFFOLD: This level has the highest density of technical detail in the curriculum. Pace carefully. The PID lock alone (Atoms 6.1 and 6.2) has five distinct steps and two edge cases (stale lock, interactive-path exemption). Do not rush through these to get to base64.

The base64 portability issue (GNU vs BSD `base64`) is worth a concrete demonstration if the operator is on macOS: run `echo "test" | base64 -w0` and watch it fail. Then show the fallback pattern working. Operators who only ever run on Linux will skip this — but they will eventually deploy to a macOS machine and be mystified when the hook breaks.

By the end of this level, the practice entity hook should be feature-complete: prompt detection, interactive path, non-interactive path with PID lock and base64 and NVM_INIT, context injection, and logging. Before moving to Level 7, ask the operator to run the full test sequence: (1) invoke interactively, (2) invoke with a simple prompt, (3) invoke with a prompt containing an apostrophe, (4) check the log. If all four work, the hook is solid. -->

---

### Bridge to Level 7

Your hook is production-safe. Your commands are entity-aware. Level 7 brings them together: you will design a complete entity skill — a command that does something observable, a hook that handles it under automation — and deliver a working end-to-end test that proves the skill works.
