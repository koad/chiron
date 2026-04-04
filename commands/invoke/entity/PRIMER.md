# PRIMER: invoke/entity

## What It Does

Invokes a named team entity non-interactively with a specific prompt, waits for the response, and returns. Unlike `spawn process` (which opens a persistent session), `invoke entity` is a call-and-response: send task, get output, done. Used for single-shot delegation — Juno invoking Vulcan to answer a question, Juno asking Veritas to review a doc.

## Intended Usage

```bash
juno invoke entity <entity> "prompt"
# e.g.
juno invoke entity vulcan "what's the status of issue #7?"
juno invoke entity veritas "review this doc and flag any inaccuracies: $(cat docs/api.md)"
```

## How It Works (Design)

```
juno invoke entity <entity> "<prompt>"
    → validate entity exists on fourty4
    → SSH fourty4 → cd ~/.<entity>/ && claude -p <base64(prompt)>
    → capture stdout
    → return output to Juno's session
```

This is `spawn process` in non-interactive mode, with output piped back rather than displayed in a terminal. The entity runs in its own directory with its own CLAUDE.md and memories — the response reflects the entity's actual identity and context.

## Current State

**Not yet implemented.** `command.sh` does not exist.

The mechanism is clear: `claude -p` (print mode) over SSH to fourty4 is already working in `spawn process`. This command is a thin wrapper that adds output capture and piping back to the caller.

## Gotchas

- **Output size.** Claude Code's `-p` mode returns the full conversation output. For long entity responses this can be large. Consider truncating or redirecting to a temp file.
- **Entity context.** The entity responds based on its own CLAUDE.md and memories on fourty4. If fourty4's copy is out of date, the response may not reflect recent changes.
- **No session persistence.** Each invocation is a fresh `-p` session. Entity does not remember the previous invocation (unless memories are written during the session).
- **Error handling.** If the entity session fails (API error, SSH drop), the caller gets no output and no clear error. Build in exit code checking.

## What's Next

1. Write `command.sh` — thin wrapper around `claude -p` via SSH
2. Add `--timeout` flag for long-running entity tasks
3. Add `--quiet` flag to suppress entity preamble and return only final output
4. Consider a response format convention (entities prefix structured output with `RESULT:`)
