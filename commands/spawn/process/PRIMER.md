# PRIMER: spawn/process

## What It Does

Spawns a team entity as a sovereign Claude Code session, SSH-routed to fourty4 (the Mac Mini headquarters). Each entity gets its own full Claude Code instance in its own `~/.<entity>/` directory — not a tool call inside Juno's session, but a complete independent agent with its own CLAUDE.md, memories, keys, and git identity.

Optionally triggers OBS streaming on the entity's scene (when `OBS_ENABLED=true`).

## How It Works

```
juno spawn process <entity> ["prompt"]
    → validate: ~/.<entity>/ exists and looks gestated
    → OBS: switch to entity scene, start stream (if enabled)
    → if prompt provided:
        SSH to fourty4 → claude -p <base64(prompt)>   # non-interactive, fresh session
    → if no prompt:
        SSH to fourty4 → claude -c                    # interactive, resume last session
    → monitor: wait for process exit
    → OBS: stop stream
```

**SSH routing (added 2026-04-04):** All entities are routed to fourty4 rather than spawned locally. fourty4 is the permanent home machine — entities clone there and persist between invocations.

**PID lock (added 2026-04-04):** A lock file prevents concurrent invocations of the same entity. If a process is already running for `<entity>`, spawn will refuse and report the existing PID. Prevents double-spawning during slow startups.

**Base64 encoding (added 2026-04-04):** Prompts passed over SSH are base64-encoded before transmission to avoid shell quoting issues with special characters, newlines, and quotes in the prompt string.

**Session modes:**
- `claude -p <prompt>` — non-interactive: runs the prompt, produces output, exits. Used when you want the entity to do a specific task and return.
- `claude -c` — interactive: resumes the most recent Claude Code session. Used when you want to continue a conversation or pick up where you left off.

## Current State

**Working for local terminal (older path).** The SSH-to-fourty4 routing and PID lock are the current operational model as of 2026-04-04.

OBS integration is present but gated behind `OBS_ENABLED=true` + `OBS_HOST`. Not in active use — the streaming infrastructure is still being wired up.

The task-posting mechanism (creating a GitHub Issue for the entity to discover) is in the command but bypassed when a direct prompt is passed via SSH.

## Gotchas

- **Entity must exist on fourty4, not just locally.** The `~/.<entity>/` check validates local disk, but the actual spawn happens on fourty4. If the entity hasn't been gestated there, the SSH command will fail. Ensure fourty4 has a matching `~/.<entity>/` with `CLAUDE.md` and `.env`.
- **PID lock is on fourty4.** The lock file lives at `/tmp/spawn-<entity>.pid` on fourty4. If a previous session crashed without cleaning up, delete the stale lock manually: `ssh fourty4 rm /tmp/spawn-<entity>.pid`.
- **OBS WebSocket client required.** OBS integration needs either `obs-cli` or `websocat` on the machine. Neither is installed by default — OBS will log a warning and continue without streaming.
- **Prompt quoting.** Even with base64 encoding, verify that `$PROMPT` doesn't contain null bytes or binary content that could corrupt the base64 output.
- **Terminal detection fallback.** Without tmux/gnome-terminal/xterm, the command falls back to headless bash mode and logs to `~/.entity/var/spawn-<timestamp>.log`. Check there if spawn appears to succeed but nothing happens.

## What's Next

- Wire the GitHub Issue posting mechanism back in as a fallback when SSH is unavailable
- Add `--interactive` / `--non-interactive` flags to force session mode
- Add health check after spawn: verify the Claude Code process is actually running before declaring success
- OBS: implement scene auto-creation for entities that don't have a scene yet
- Stale lock detection: auto-remove lock if the PID it references is no longer alive
