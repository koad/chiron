---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 1
slug: starting-the-daemon
title: "Starting the Daemon — Environment, Startup Sequence, Health Check"
status: authored
prerequisites:
  curriculum_complete:
    - advanced-trust-bonds
  level_complete:
    - daemon-operations/0
estimated_minutes: 30
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 1: Starting the Daemon — Environment, Startup Sequence, Health Check

## Learning Objective

After completing this level, the operator will be able to:
> Start the daemon from `~/.koad-io/daemon/src/`, set the required environment variables, follow the startup log to confirm each phase completes, and use the `/api/health` endpoint to verify the daemon is running and accepting connections.

**Why this matters:** A daemon that started but is not healthy is indistinguishable from a stopped daemon to an entity that tries to connect. Operators need to know the difference between "process is running" and "daemon is ready" — the health check is how.

---

## Knowledge Atoms

### Atom 1.1: The Startup Location — Why Directory Matters

The daemon must be started from `~/.koad-io/daemon/src/`. Not from `~/.koad-io/`, not from any entity directory, and not from `~`. The working directory matters because Meteor resolves paths relative to the application root, and the MongoDB data directory defaults to `./data` — which means the data directory path depends on where `meteor run` is invoked.

The correct startup command sequence:

```bash
cd ~/.koad-io/daemon/src/
meteor run
```

Or, using npm:

```bash
cd ~/.koad-io/daemon/src/
npm start
```

Both commands start the same Meteor application. `meteor run` is the development mode with source watching enabled. `npm start` uses the script defined in `package.json` which typically wraps `meteor run` with the appropriate environment for production-adjacent operation.

If you start the daemon from the wrong directory, Meteor will still attempt to run — but the MongoDB data path will resolve differently, and on a fresh start the daemon will create a `data/` directory in whatever the current working directory is. This is not catastrophic, but it means your data is scattered and your daemon's state does not persist reliably across restarts. Always `cd` to `src/` explicitly.

**What you can do now:**
- Navigate to the correct daemon startup directory from memory
- Start the daemon using either `meteor run` or `npm start`
- Explain why the working directory matters for MongoDB path resolution

**Exit criterion for this atom:** The operator can start the daemon from the correct directory without prompting and explain why the path matters.

---

### Atom 1.2: Environment Variables — What the Daemon Reads at Startup

The daemon reads several environment variables at startup. Some are required for the daemon to run in a non-default configuration; others have sensible defaults that most standard installs use. Knowing what each variable does means knowing what to set and what to leave alone.

**Port and bind address (almost always left at defaults):**

```bash
KOAD_IO_PORT=9568        # HTTP port for the daemon server (default: 9568)
KOAD_IO_BIND_IP=127.0.0.1  # IP address to bind to (default: 127.0.0.1 — localhost only)
```

The default `127.0.0.1` binding means the daemon is only accessible from the same machine. This is correct for a local workstation. If you want the daemon accessible from other machines on the network (for a multi-machine setup), set `KOAD_IO_BIND_IP=0.0.0.0`. Do not do this without understanding the security implications — the daemon has no authentication on its HTTP endpoints.

**MongoDB configuration:**

```bash
MONGO_URL=mongodb://127.0.0.1:3001/koad-io  # External MongoDB connection string
MONGO_OPLOG_URL=mongodb://127.0.0.1:3001/local  # Oplog connection for reactivity
KOAD_IO_AUTO_SPAWN_MONGO=true  # Spawn MongoDB automatically if MONGO_URL is not set
```

If `KOAD_IO_AUTO_SPAWN_MONGO` is `true` (the default) and no `MONGO_URL` is set, the daemon spawns its own MongoDB instance on port 3001 and stores data in `./data/` relative to the startup directory. This is the standard setup for development and single-machine installs.

If you have an existing MongoDB instance — for example, if other services on the machine already use MongoDB — set `MONGO_URL` and `MONGO_OPLOG_URL` explicitly and set `KOAD_IO_AUTO_SPAWN_MONGO=false`. The daemon will connect to the existing instance instead of spawning a new one. The database name in the URL (`koad-io` in the example above) can be any name; it does not need to be `koad-io`.

**Practical default for most installs:**

For a standard single-machine setup, no environment variables need to be set. The daemon defaults are:
- Port 9568 on localhost
- Auto-spawn MongoDB on port 3001
- Data in `~/.koad-io/daemon/src/data/`

Only set variables when you need non-default behavior.

**What you can do now:**
- State what `KOAD_IO_PORT` and `KOAD_IO_BIND_IP` control and what the defaults are
- Explain the difference between auto-spawned MongoDB and an external MongoDB instance
- Describe when you would set `MONGO_URL` explicitly

**Exit criterion for this atom:** The operator can explain what each environment variable does and state which ones a standard single-machine install needs to set (none — the defaults work).

---

### Atom 1.3: Reading the Startup Log

When the daemon starts, it writes log output to the terminal. This output is the only reliable signal of what is happening internally. Operators who do not read the startup log cannot tell whether the daemon has fully initialized or is stuck at an early phase.

The daemon startup progresses through distinct phases. Here is what to look for at each:

**Phase 1 — MongoDB starts (if auto-spawn is enabled):**
```
[MONGODB] Starting MongoDB on port 3001...
[MONGODB] MongoDB started, data at ./data
```
If MongoDB fails to start — because port 3001 is already in use, or the data directory has a lock file from a previous unclean shutdown — the daemon will either hang here or exit. If it hangs, check whether another MongoDB process is already running on port 3001: `lsof -i :3001`.

**Phase 2 — Meteor initializes:**
```
=> Started proxy.
=> Started MongoDB.
=> Started your app.
```
These three lines confirm Meteor's internal proxy, database connection, and application server are all running.

**Phase 3 — Passenger registration runs:**
```
[PASSENGERS] Meteor.startup() called
[PASSENGERS] Starting passenger registration...
[PASSENGERS] Found entities: ['.juno', '.vesta', '.vulcan', ...]
[PASSENGERS] Found passenger.json for .juno
[PASSENGERS] ✓ Registered passenger: Juno
[PASSENGERS] Registration complete. Total passengers: N
```
This phase runs `Meteor.startup()` and scans `$HOME/.*` for entity directories with `KOAD_IO_` in their `.env`. For each matching directory, it looks for `passenger.json`. Successful registrations log `✓ Registered passenger: <name>`. If an entity has no `passenger.json`, it logs "No passenger.json for <entity>" and continues — this is not an error.

**Phase 4 — Daemon is ready:**
```
=> App running at: http://localhost:9568/
```
This line confirms the HTTP server is accepting connections. The daemon is now fully initialized and the health endpoint is available.

If you see "App running at:" in the log, the daemon is ready. If you do not see it, the daemon is still initializing or has encountered an error earlier in the sequence.

**What you can do now:**
- Start the daemon and identify each startup phase in the log output
- Recognize the "App running at:" line as the ready signal
- Identify what a MongoDB startup failure looks like in the log and what to check

**Exit criterion for this atom:** The operator can read a startup log and state definitively whether the daemon reached the ready state, and — if not — which phase it stopped at.

---

### Atom 1.4: The Health Endpoint

The `/api/health` endpoint is the fastest way to verify a running daemon. It returns a JSON response describing the daemon's current state. Operators who rely only on the process being alive (checking `ps`, for example) may miss a daemon that started but failed to connect to MongoDB — the process is running but the daemon is degraded.

Check the health endpoint:

```bash
curl http://localhost:9568/api/health
```

A healthy daemon returns HTTP 200 with a JSON body. The exact fields depend on the daemon version, but a healthy response includes:

```json
{
  "status": "ok",
  "mongo": "connected",
  "passengers": 3,
  "uptime": 142
}
```

Key fields to verify:
- `"status": "ok"` — the daemon is in a healthy operational state
- `"mongo": "connected"` — MongoDB is reachable and the daemon can read/write state
- `"passengers": N` — N entities are registered; this should be greater than 0 if any entities have `passenger.json` files

A degraded response may show `"mongo": "disconnected"` or `"status": "degraded"`. In this state, DDP subscriptions will not deliver data, and the Passengers collection will be empty even if entities are registered. The daemon process is alive, but it cannot serve the real-time layer. Restarting the daemon is usually the correct response.

If `curl` returns `Connection refused`, the daemon is not running. If `curl` hangs without a response, the daemon is running but not yet ready — wait a few seconds and retry.

**What you can do now:**
- Use `curl` to check the health endpoint and read the response
- Explain what each field in a healthy response means
- Describe the difference between "process running" and "daemon healthy"

**Exit criterion for this atom:** The operator can curl the health endpoint, read the response, and state whether the daemon is healthy, degraded, or not running — and explain what the distinction means operationally.

---

### Atom 1.5: Stopping the Daemon Cleanly

Stopping the daemon correctly matters for two reasons: entity shutdown hooks need to fire, and MongoDB needs to flush its write journal cleanly. An unclean shutdown can leave a MongoDB lock file that prevents the next startup.

**Clean shutdown — Ctrl-C or SIGTERM:**

Press `Ctrl-C` in the terminal running the daemon, or send `SIGTERM` to the process:

```bash
kill -TERM <daemon-pid>
```

When the daemon receives SIGTERM or Ctrl-C, it runs its shutdown sequence:
1. Fires entity-shutdown hooks (any registered cleanup callbacks)
2. Stops the worker system gracefully (active workers finish current tasks)
3. Closes MongoDB connections
4. Exits the Meteor process

The log output during a clean shutdown ends with:
```
[DAEMON] Shutdown signal received
[DAEMON] Workers stopped gracefully
=> Exited
```

**Unclean shutdown — SIGKILL:**

```bash
kill -KILL <daemon-pid>
```

`SIGKILL` bypasses the shutdown sequence. The daemon process is terminated immediately. Worker tasks in progress are abandoned without cleanup. MongoDB may not have flushed its journal — if MongoDB was auto-spawned and was mid-write, a lock file may remain at `~/.koad-io/daemon/src/data/.lock`.

If the daemon fails to start after an unclean shutdown with a MongoDB error like "ERROR: dbpath (/path/to/data) is already in use", remove the lock file:

```bash
rm ~/.koad-io/daemon/src/data/.lock
```

Then restart the daemon normally.

**When SIGKILL is appropriate:**

If the daemon is hanging — not responding to Ctrl-C, not shutting down after several seconds — SIGKILL is the correct fallback. Accept that you may need to clean up the MongoDB lock file on the next start. It is not a data corruption risk; it is a stale marker that MongoDB uses to detect unclean shutdowns.

**What you can do now:**
- Stop the daemon cleanly using Ctrl-C
- Explain what happens during a clean shutdown that does not happen with SIGKILL
- Clear a MongoDB lock file if the daemon fails to start after an unclean shutdown

**Exit criterion for this atom:** The operator can stop the daemon cleanly, confirm the shutdown log shows graceful termination, and recover from a post-crash lock file without help.

---

## Exit Criterion

The operator can start the daemon from `~/.koad-io/daemon/src/`, read the startup log to confirm it reached the ready state, curl the health endpoint to verify healthy status, and stop the daemon cleanly. They can explain the difference between a running daemon and a healthy daemon.

**Verification sequence:**
1. Operator starts the daemon and identifies the "App running at:" line in the log
2. Operator curls `/api/health` and reads the response without assistance
3. Operator stops the daemon with Ctrl-C and identifies the graceful shutdown confirmation in the log
4. Operator is asked: "curl returns 'Connection refused'. What does that mean?" — expected answer: "The daemon is not running. Either it was never started or it stopped. Distinct from a degraded response, which means the process is alive but MongoDB is disconnected."

---

## Assessment

**Question:** "You start the daemon and see these log lines:
```
[PASSENGERS] Meteor.startup() called
[PASSENGERS] Starting passenger registration...
[PASSENGERS] Found entities: ['.juno']
[PASSENGERS] No passenger.json for .juno
[PASSENGERS] Registration complete. Total passengers: 0
=> App running at: http://localhost:9568/
```
Is the daemon healthy? What does the '0 passengers' entry mean?"

**Acceptable answers:**
- "The daemon is healthy — it reached 'App running at:' which is the ready signal. The 0 passengers means Juno's entity directory doesn't have a passenger.json file. That's not an error; it means Juno hasn't been registered with the daemon yet. The daemon is fully operational."
- "Healthy, just no entities registered. passenger.json is missing from .juno/. I'd add it and call passenger.reload."

**Red flag answers:**
- "The daemon failed to start because passengers is 0" — conflates passenger registration with daemon health
- "This is an error and the daemon needs to be restarted" — misreads a normal registration-miss as a failure state

**Estimated engagement time:** 25–30 minutes

---

## Alice's Delivery Notes

Operators at this level are ready to touch the terminal. They know what the daemon is (Level 0) and are now doing the first hands-on operation. Keep the level concrete — every concept should have a command or a log line the operator can see.

The most important conceptual gap at this level is "process running vs. daemon healthy." Operators who have worked with other system processes often think "process is alive" means "service is ready." The health endpoint is the corrective — introduce it early in your delivery, not as an afterthought.

The MongoDB lock file recovery procedure is in this level because it will happen in practice. Unclean shutdowns are common in development. An operator who has never seen the lock file error will be confused the first time it appears; an operator who has read this level will know exactly what it is and how to clear it in under 10 seconds.

Atom 1.3 (reading the startup log) should be experienced, not just described. If Alice is delivering this level interactively, have the operator start the daemon and narrate what they see. Stopping at each phase and confirming recognition is more valuable than a faster passthrough.

Do not spend time on Meteor internals. The operator needs to recognize phases in the log, not understand how Meteor's package system works. "Meteor initializes" is sufficient framing for the `=> Started proxy.` / `=> Started MongoDB.` / `=> Started your app.` sequence.

---

### Bridge to Level 2

The daemon is running. It scanned for entity directories and found either no `passenger.json` files or existing ones. Level 2 covers how to write a valid `passenger.json` from scratch — the registration card that makes an entity visible to the daemon, the browser extension, and the desktop widget.
