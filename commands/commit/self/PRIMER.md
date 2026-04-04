# PRIMER: commit/self

## What It Does

AI-powered self-commit for Juno's own repository (`~/.juno/`). Invokes `opencode` with a structured prompt that tells it to review staged git changes and produce a commit message — then execute the commit. Juno commits like she's maintaining a real business project: subject line in imperative mood, body explaining the *why* and business impact.

## How It Works

```
juno commit self
    → cd ~/.juno/
    → opencode --model ${OPENCODE_MODEL:-opencode/big-pickle} run "$PROMPT"
        → opencode reviews: git diff --staged
        → generates commit message (72-char subject, business-impact body)
        → executes: git commit -m "..."
```

The prompt enforces Juno's commit style: business-impact framing, no commentary outside the message, never auto-push.

## Current State

**Working.** Used regularly to commit docs, memories, PROJECTS/, LOGS/.

Model is configurable via `OPENCODE_MODEL` env var. Default is `opencode/big-pickle` (opencode's alias for a large model — check `~/.juno/opencode/opencode.jsonc` for the current model routing).

## Gotchas

- **Must stage files first.** The command reads `git diff --staged`. If nothing is staged, opencode will output "No files staged for commit." and exit cleanly.
- **Never pushes.** By design. Run `git push` manually after reviewing the commit.
- **opencode must be authenticated.** If opencode hasn't been set up with API keys, it will fail silently or error. Check `opencode status` if unsure.
- **Runs in `~/.juno/` always.** The `cd ~/.juno/` at the top is unconditional. This command only commits Juno's own repo — not other entities, not `~/.koad-io/`.

## What's Next

- Add a `--push` flag for cases where immediate push is desired
- Consider a pre-commit review step (show the proposed message, confirm before committing)
- Hook into the session close protocol so Juno auto-commits at end of each session
