# PRIMER: invoke/free

## What It Does

Free-form invocation of Claude Code without targeting a specific entity. Runs a prompt against a fresh Claude Code session in a specified directory (or the current directory), without the overhead of entity identity, memories, or team structure. The escape hatch: when you want Claude to do something but don't want to route it through an entity's full context.

## Intended Usage

```bash
juno invoke free "prompt"
juno invoke free --dir /some/path "prompt"
# e.g.
juno invoke free "summarize the git log for ~/.koad-io/ since last week"
juno invoke free --dir ~/.koad-io "what commands are available in this framework?"
```

## How It Works (Design)

```
juno invoke free "<prompt>" [--dir <path>]
    → DIR="${dir:-$PWD}"
    → claude -p <base64(prompt)> --dir "$DIR"
    → return output
```

No SSH routing, no entity validation. Runs locally (or on a specified machine). Minimal overhead.

## Current State

**Not yet implemented.** `command.sh` does not exist.

This is the simplest of the invoke commands — a direct `claude -p` wrapper with directory control. No entity routing, no PID lock needed.

## Gotchas

- **No entity context.** The session has no CLAUDE.md unless the target directory contains one. This is intentional — free-form means uncontrolled context.
- **Local execution.** Unlike `spawn process` and `invoke entity`, this runs on the local machine (thinker), not fourty4. Useful for querying local files that aren't on fourty4.
- **Prompt injection risk.** If the prompt is constructed from user input or file contents, sanitize before passing. Base64 encoding handles shell quoting but not prompt injection.

## What's Next

1. Write `command.sh` — `claude -p` wrapper with optional `--dir` flag
2. Consider `--model` flag to pick a cheaper model for simple tasks
3. Add `--machine` flag to route to fourty4 or flowbie when needed
