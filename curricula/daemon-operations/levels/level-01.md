---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 1
slug: starting-the-daemon
title: "Starting the Daemon — Environment, Startup Sequence, Health Check"
status: stub
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
> Start the daemon from `~/.koad-io/daemon/`, set the required environment variables, follow the startup log to confirm each phase completes, and use the `/api/health` endpoint to verify the daemon is running and accepting connections.

**Why this matters:** A daemon that started but is not healthy is indistinguishable from a stopped daemon to an entity that tries to connect. Operators need to know the difference between "process is running" and "daemon is ready" — the health check is how.

---

## Knowledge Atoms

*(stub — authoring pending)*

### Atom 1.1: The Startup Location
**Teaches:** The daemon runs from `~/.koad-io/daemon/src/`. Not from any entity directory. `meteor run` or `npm start` from the src directory. Why the location matters (Meteor's working directory affects MongoDB path resolution).

### Atom 1.2: Required Environment Variables
**Teaches:** The environment table — `MONGO_URL`, `MONGO_OPLOG_URL`, `KOAD_IO_PORT` (default 9568), `KOAD_IO_BIND_IP` (default 127.0.0.1), `KOAD_IO_AUTO_SPAWN_MONGO`. What "auto-spawn MongoDB" means and when to set `MONGO_URL` explicitly.

### Atom 1.3: The Nine-Step Startup Sequence
**Teaches:** Walking through the startup log output — pre-flight, init, upstart hooks, startup, DDP connection, connected hooks, worker start, monitor, run state. What to look for at each phase to confirm it completed.

### Atom 1.4: The Health Endpoint
**Teaches:** `GET /api/health` at `localhost:9568/api/health`. What a healthy response looks like. What a degraded response looks like (MongoDB not connected, workers not started). How to use `curl` to check it from the command line.

### Atom 1.5: Stopping the Daemon Cleanly
**Teaches:** Ctrl-C or SIGTERM triggers entity-shutdown hooks and graceful worker termination. SIGKILL does not. Why clean shutdown matters (worker state marked gracefully vs. dirty).

---

## Exit Criterion

*(placeholder — to be written during authoring)*

The operator can start the daemon, read the startup log to confirm it reached run state, and curl the health endpoint to get a successful response.

---

## Bridge to Level 2

The daemon is running. Now it needs to know about the entities on this machine. Level 2 covers how entity registration works via `passenger.json`.
