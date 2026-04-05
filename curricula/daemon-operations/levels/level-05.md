---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 5
slug: debugging-daemon-issues
title: "Debugging Daemon Issues — Connection, Registration, Subscription"
status: authored
prerequisites:
  curriculum_complete:
    - advanced-trust-bonds
  level_complete:
    - daemon-operations/4
estimated_minutes: 30
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 5: Debugging Daemon Issues — Connection, Registration, Subscription

## Learning Objective

After completing this level, the operator will be able to:
> Diagnose the three most common daemon failure modes (daemon not running, entity not registered, DDP subscription not firing), apply a systematic check sequence to any connection problem, and know which log output to read at each step.

**Why this matters:** Daemon problems almost always look identical from the outside: the browser extension shows nothing, the widget is blank, an entity does not appear in the admin PWA. The cause could be any of three distinct failures. An operator without a diagnostic method spends time guessing. An operator with the three-step sequence resolves most issues in under three minutes — because stopping at the first failure prevents wasted effort on layers that are not broken.

---

## Knowledge Atoms

### Atom 5.1: The Three Failure Modes

Every connection problem with the daemon traces back to one of three failure modes. They are not interchangeable — each has a distinct cause and a distinct fix. The order in which they are listed is the order in which they should be checked.

**Mode 1: Daemon process not running.** The Meteor application has stopped or was never started. There is no process bound to port 9568. Every client — the browser extension, the widget, the admin PWA — fails at connection. The health check returns `Connection refused`. No amount of configuration changes will help until the process is running.

**Mode 2: Entity not registered.** The daemon is running and healthy, but a specific entity is missing from the Passengers collection. The admin PWA loads and shows other entities, but the expected entity is absent. Possible causes: no `passenger.json` in the entity directory, a malformed `passenger.json` (JSON parse error), a `passenger.json` present but the entity's `.env` does not contain any `KOAD_IO_` variable (the daemon's entity scanner skips directories that fail the `isKoadIOEntity` check), or `passenger.reload` has not been triggered since the file was added.

**Mode 3: DDP subscription not firing.** The daemon is running, the entity is registered (visible in the admin PWA), but a connected client — the browser overlay or the desktop widget — is not receiving reactive updates. The connection exists, but data is not flowing. Possible causes: the client's subscription call is failing silently, a network-layer interruption between client and daemon, or the client is subscribed to the wrong publication name.

These three modes are a hierarchy. Mode 1 subsumes Modes 2 and 3: you cannot have a registration problem if the daemon is not running, and you cannot have a subscription problem if the entity is not registered. Check from the bottom of the stack upward.

**What you can do now:**
- Name the three failure modes in the correct diagnostic order
- Describe one concrete symptom for each mode that distinguishes it from the others
- Explain why a Mode 3 problem cannot exist if Mode 1 is the actual cause

**Exit criterion for this atom:** The operator can describe all three failure modes and explain why the diagnostic order matters — specifically, why the process check comes before the registration check.

---

### Atom 5.2: The Diagnostic Sequence

The diagnostic sequence has three steps. Each step checks one layer. If a step reveals a problem, stop and fix it before proceeding — a failure at Layer 1 makes all Layer 2 and Layer 3 observations meaningless.

**Step 1: Is the daemon process running?**

```bash
curl -s localhost:9568/api/health
```

Three possible outcomes:

| Response | Meaning |
|----------|---------|
| JSON response with `status` field | Daemon is running. Proceed to Step 2. |
| `curl: (7) Failed to connect ... Connection refused` | Daemon is not running. Fix: start the daemon from `~/.koad-io/daemon/src/` with `meteor run`. |
| `curl: (7) Failed to connect ... No route to host` | Port 9568 is bound to a different interface or the machine is not reachable. Check daemon environment variables for `PORT` and `BIND_IP`. |

If the daemon is not running, start it. Do not proceed to Step 2 until the health check returns a JSON response.

**Step 2: Is the entity registered?**

Open the admin PWA at `http://localhost:9568`. Look for the entity in the Passengers list.

| What you see | Meaning |
|--------------|---------|
| Entity appears in the list | Entity is registered. Proceed to Step 3. |
| Entity is absent; other entities appear | Registration problem for this entity specifically. Check `passenger.json`, `.env`, and daemon log. |
| List is empty; no entities appear | Either MongoDB is disconnected (check daemon log for MongoDB errors) or no entity directories have both a valid `passenger.json` and a `KOAD_IO_`-containing `.env`. |

After fixing a registration problem, click the Reload button in the admin PWA (or call `passenger.reload` via DDP). Do not restart the daemon — `passenger.reload` is faster and preserves other registered entities' state.

**Step 3: Is the DDP subscription firing?**

If the entity is registered but the browser overlay or widget is not showing it:

1. Check the browser extension's connection indicator. A disconnected state means the extension cannot reach the daemon over WebSockets — a network or permission issue, not a registration issue.
2. Open the admin PWA with browser developer tools open (Network tab, filter by WebSocket). Look for the DDP WebSocket connection. If it is not established, the client is not connected to the daemon at all.
3. Check the daemon log for DDP connection events. A successfully connecting client produces a connection log line. A client that connects and immediately disconnects produces both lines close together.
4. Verify the publication name. Clients subscribed to `"current"` receive only the selected entity. If the widget is showing nothing but an entity is registered and selected, confirm the widget is subscribed to `"current"` and that an entity has a `selected` timestamp in the collection.

**What you can do now:**
- Run the three-step sequence against a running daemon and narrate what each step's output means
- Explain when to stop the sequence and fix rather than continuing to the next step
- State what `passenger.reload` does and why it is preferred over a daemon restart

**Exit criterion for this atom:** The operator can apply the three-step diagnostic sequence to any described failure scenario, identify at which step the failure would appear, and state the correct fix.

---

### Atom 5.3: Reading the Daemon Log

The daemon writes to its process output — standard output and standard error — during startup, registration, and operation. This output is the primary diagnostic tool for problems that the health endpoint and admin PWA cannot surface.

**Where the log lives:** The daemon's log output goes wherever the process's stdout is directed. In standard Meteor development mode (`meteor run`), this is the terminal where you launched the process. If the daemon was started with a process manager or redirected to a file, the log is at the path configured for that redirect. There is no fixed log file location in the current implementation — the output follows the process.

**What to look for at startup:**

A healthy startup sequence produces log lines in this order:

```
[PASSENGERS] Meteor.startup() called
[PASSENGERS] Starting passenger registration...
[PASSENGERS] Found entities: ['.juno', '.vesta', '.vulcan', ...]
[PASSENGERS] Checking entity: .juno
[PASSENGERS] Found passenger.json for .juno
[PASSENGERS] Loaded config for .juno: juno
[PASSENGERS] ✓ Registered passenger: Juno
...
[PASSENGERS] Registration complete. Total passengers: N
```

**What registration failure looks like in the log:**

If an entity is skipped entirely — no log line for it at all — the `.env` check failed: the directory does not contain a `KOAD_IO_` variable. The entity directory was not considered.

If an entity appears in the `Found entities` list but produces `No passenger.json for .<entity>: ENOENT...`, the `passenger.json` file is missing.

If an entity appears in the `Found entities` list and the log shows a JSON parse error after `Found passenger.json for .<entity>`, the file exists but is malformed. The daemon logs the error but does not crash — it skips the entity and continues.

**What to look for during active operations:**

`[INGEST]` lines confirm `passenger.ingest.url` calls are reaching the daemon and which entity is selected.

`[IDENTITY]` and `[CHECK]` lines confirm the stub methods are being called (the extension is working) even though the methods return placeholder responses.

A `Received POST from passenger:` line confirms the HTTP endpoint received a request.

DDP connection events are logged by the Meteor framework itself — they appear without a `[PASSENGERS]` prefix and look like `I20260405-14:22:07.XXX (+0000) socket id ...`.

**What you can do now:**
- Read a startup log excerpt and identify whether all expected entities registered successfully
- Identify what a skipped entity, a missing `passenger.json`, and a malformed `passenger.json` each look like in the log
- State where the daemon's log output goes in the default (non-daemonized) configuration

**Exit criterion for this atom:** The operator can read a daemon startup log, identify how many entities registered, and spot the log signature for each of the three common registration failure patterns.

---

### Atom 5.4: Fixing Registration Problems

Registration failures follow a small number of patterns. Each has a specific fix. None of them require restarting the daemon — `passenger.reload` is always sufficient.

**Problem: Entity directory is skipped during scan (not in log at all)**

Cause: The entity's `.env` file does not contain any string matching `KOAD_IO_`. The daemon's `isKoadIOEntity()` function reads the `.env` and returns false. The entity directory is not added to the entity list and receives no further processing.

Fix: Add `KOAD_IO_VERSION=<version>` to the entity's `.env` file. Any `KOAD_IO_` variable is sufficient — `KOAD_IO_VERSION` is the standard choice. After editing, trigger `passenger.reload`.

**Problem: Missing passenger.json**

Cause: The entity directory passes the `.env` check but has no `passenger.json` file. The log shows `No passenger.json for .<entity>: ENOENT`.

Fix: Create the `passenger.json` file in the entity directory. See Level 2 for the required fields and format. After creating the file, trigger `passenger.reload`.

**Problem: Malformed passenger.json**

Cause: The file exists but contains invalid JSON — a trailing comma, a missing brace, unescaped characters. The daemon catches the `JSON.parse` error, logs it, and skips the entity. The daemon does not crash.

Fix: Validate the JSON with `jq . passenger.json` or a JSON validator. Fix the syntax error. Trigger `passenger.reload`.

**Problem: Entity registers but check.in calls fail**

Cause: The `name` field in `passenger.json` does not match the string the extension is passing to `passenger.check.in`. The method looks up by `{ name: passengerName }` — exact string match, case-sensitive. If `passenger.json` has `"name": "Juno"` and the extension calls `passenger.check.in("juno")`, the lookup returns null and the method returns a `not-found` error.

Fix: Confirm the display name in `passenger.json` matches exactly the name the extension is configured to use. The name is the lookup key for selection. After changing the `name` field, trigger `passenger.reload` — the old document (with the wrong name) is cleared and re-inserted with the corrected name.

**The reload procedure in all cases:**

After any `passenger.json` or `.env` change: click the Reload button in the admin PWA, or call `passenger.reload()` via a DDP client. The reload clears the entire Passengers collection and re-runs `registerPassengers()` from scratch. Every entity with a valid `passenger.json` and a `KOAD_IO_`-containing `.env` is re-registered. Confirm the fix by checking that the entity appears in the admin PWA's Passengers list after the reload completes.

**What you can do now:**
- Apply the correct fix for each of the four registration problem patterns
- Explain why `passenger.reload` is the right action after any registration fix rather than a full daemon restart
- Confirm a registration fix was successful using the admin PWA

**Exit criterion for this atom:** Given a description of a registration problem (skipped entity, missing file, malformed JSON, or failed check-in), the operator can identify the cause and apply the correct fix — including the reload step to confirm resolution.

---

### Atom 5.5: MongoDB Connection Problems

MongoDB is the daemon's state store. When MongoDB is unavailable or fails to start, the daemon runs — the Meteor process starts, the HTTP server binds to port 9568 — but the Passengers collection is inaccessible. The admin PWA loads but shows nothing. `passenger.reload` runs and returns without inserting any documents.

**How the daemon manages MongoDB:**

The daemon can either spawn its own MongoDB instance or connect to an external one, controlled by Meteor's `MONGO_URL` environment variable. If `MONGO_URL` is not set, Meteor spawns a local MongoDB and stores data in the `.meteor/local/db/` directory inside the daemon's source tree (relative to where `meteor run` is invoked — typically `~/.koad-io/daemon/src/.meteor/local/db/`). If `MONGO_URL` is set, Meteor connects to that URL.

**What MongoDB failure looks like:**

In the daemon log: Meteor's MongoDB driver logs connection errors with messages like `MongoError: connect ECONNREFUSED` or `failed to connect to server [...] on first connect`. These appear early in the startup log, before the `[PASSENGERS]` lines.

In the admin PWA: the page loads (the HTTP server is running), the Passengers list is empty (no MongoDB reads succeed), and clicking Reload produces no change (the insert operations fail silently from the PWA's perspective — the log shows the registration attempt followed by no `✓ Registered passenger:` lines).

**Diagnosing auto-spawned MongoDB failure:**

If the daemon is configured to auto-spawn MongoDB (no `MONGO_URL` set) and MongoDB does not start:

1. Check whether the `.meteor/local/db/` data directory exists and is writable: `ls -la ~/.koad-io/daemon/src/.meteor/local/db/`
2. Check for a stale `mongod.lock` file in that directory — a lock file left by a previous crashed MongoDB process can prevent restart. If present, remove it.
3. Check available disk space: `df -h ~` — MongoDB will not start if disk space is exhausted.
4. Check the daemon log for `mongod` error output — Meteor echoes mongod's stderr to the daemon log.

**What the health endpoint shows during MongoDB failure:**

`GET /api/health` still returns a 200 response (the HTTP server is running), but the `mongodb.status` field in the response will reflect the disconnected state. If the health endpoint is returning `Connection refused`, the daemon process itself is down — MongoDB state is irrelevant until the process is running.

**What you can do now:**
- Distinguish MongoDB failure from daemon-not-running by comparing what `GET /api/health` returns in each case
- Locate the auto-spawned MongoDB data directory and explain when a stale lock file would prevent MongoDB from starting
- Describe what the admin PWA shows when the daemon is running but MongoDB is unavailable

**Exit criterion for this atom:** The operator can describe the symptoms of a MongoDB connection failure (compared to a daemon process failure), locate the auto-spawned data directory, and identify the two most common causes of auto-spawned MongoDB startup failure.

---

## Exit Criterion

The operator can apply the three-step diagnostic sequence — health check, admin PWA, DDP subscription — to any described daemon connection problem, identify the failure mode, state the fix, and confirm resolution. Given a daemon startup log excerpt, the operator can identify registration successes and failures and name the cause of each failure.

**Verification question:** "The browser extension is showing the widget as blank. The operator opens localhost:9568 and sees three entities in the Passengers list, but Juno is not there. Juno's entity directory has a passenger.json. What is the most likely cause, and what are the steps to resolve it?"

Expected answer: The most likely cause is that Juno's `.env` does not contain a `KOAD_IO_` variable — the daemon's entity scanner skipped the directory. Steps: (1) Check Juno's `.env` for a `KOAD_IO_VERSION` or other `KOAD_IO_` variable. (2) If missing, add `KOAD_IO_VERSION=<version>`. (3) Trigger `passenger.reload` via the admin PWA Reload button. (4) Confirm Juno appears in the Passengers list. If the `.env` check passes but the issue persists, examine the daemon log for the registration attempt — look for a JSON parse error against Juno's `passenger.json`.

---

## Assessment

**Question 1:** "You run `curl localhost:9568/api/health` and get `{ status: 'healthy' }`. You open the admin PWA and see an empty Passengers list. Reload does nothing. What layer is failing and what do you check next?"

**Acceptable answers:**
- "The daemon is running (health check passed), so Mode 1 is not the issue. The empty list after reload suggests a registration problem affecting all entities — either MongoDB is unavailable or no entity directory passes the entity scanner's checks. Check the daemon log for MongoDB connection errors or for `Found entities: []` at startup."
- "Layer 2 — registration. The daemon process is healthy. Check for MongoDB errors in the daemon log, and verify that at least one entity directory has both a valid `passenger.json` and a `KOAD_IO_` variable in its `.env`."

**Red flag answers:**
- "Restart the daemon" — the daemon is running; restart discards state without diagnosing the cause
- "The daemon is broken" — the health endpoint passed; the daemon is not broken

**Question 2:** "What is the difference between calling `passenger.reload` and restarting the daemon?"

**Acceptable answers:**
- "`passenger.reload` clears and repopulates the Passengers collection without stopping the process. Existing DDP clients stay connected. Restarting the daemon closes all connections, stops MongoDB (if auto-spawned), and requires all clients to reconnect. For registration fixes, `passenger.reload` is always sufficient and less disruptive."

**Estimated engagement time:** 25–30 minutes

---

## Alice's Delivery Notes

Operators arriving at this level are debugging for the first time in this curriculum. The three-failure-mode model is the most important thing to convey — without it, operators will try fixes in random order and occasionally succeed by luck, which builds fragile intuition.

The diagnostic sequence in Atom 5.2 should be treated as a procedure, not a list of suggestions. The stop-and-fix behavior is essential: operators who continue to Step 3 while a Step 1 problem is present will confuse themselves.

Atom 5.3 (reading the log) is the atom operators will return to most often in practice. The startup log pattern — `Found entities`, `Checking entity`, `Found passenger.json`, `Registered passenger` — is the fingerprint of a healthy registration. An operator who can read this pattern can diagnose most registration problems without any other tool.

Atom 5.5 (MongoDB) is the failure mode operators are least likely to encounter and least likely to diagnose correctly without prior knowledge. The key insight is the distinction between `curl localhost:9568/api/health` returning `Connection refused` (daemon not running) vs. returning a JSON response with MongoDB status (daemon running, MongoDB state visible from the response). Cover this distinction explicitly.

---

### Bridge to Level 6

The operator can now start the daemon, register entities, read live state, debug method calls, and resolve connection failures. Level 6 steps back to the strategic question: when is the daemon the right coordination tool, and when is GitHub Issues the right tool? The hybrid model is what makes the system coherent — and what prevents operational errors that lose work.
