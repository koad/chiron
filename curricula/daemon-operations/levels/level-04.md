---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 4
slug: ddp-methods-and-publications
title: "DDP Methods and Publications — How the Browser Extension Connects"
status: authored
prerequisites:
  curriculum_complete:
    - advanced-trust-bonds
  level_complete:
    - daemon-operations/3
estimated_minutes: 30
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 4: DDP Methods and Publications — How the Browser Extension Connects

## Learning Objective

After completing this level, the operator will be able to:
> Name the DDP methods available on the daemon, explain what each one does and what calls it, describe how `passenger.ingest.url` delivers browser context to an entity, explain the difference between a DDP method and a DDP publication, and state honestly which methods are fully implemented and which are stubs.

**Why this matters:** DDP is how the daemon communicates with everything that connects to it — the browser extension, the desktop widget, the admin PWA, and future clients like the Stream PWA. An operator who understands the method set knows exactly what the daemon can and cannot do today. Knowing the honest status of each method prevents building workflows on top of stubs that log and return nothing.

---

## Knowledge Atoms

### Atom 4.1: DDP Concepts — Methods vs. Publications

DDP (Distributed Data Protocol) carries two kinds of interactions between the daemon and its clients. Confusing the two leads to misreading both the admin PWA and the browser extension source. The distinction is simple, but it matters.

A **DDP method** is a remote procedure call. The client calls it, the server executes it, and the server returns a result. One shot: call, execute, respond. Methods are used when the client wants the server to do something — change a value, trigger an action, ingest data. `passenger.check.in` is a method. The browser extension calls it, the daemon updates the Passengers collection, the daemon returns `{ _id: ... }`. The client does not continue receiving data after the call completes.

A **DDP publication** is a reactive data stream. The client subscribes to it, the server sends the current matching data set, and then sends incremental updates whenever the underlying data changes. The client stays subscribed until it unsubscribes or disconnects. Publications are used when the client wants to watch something — receive current state and stay current as it changes. `current` is a publication. When the Dark Passenger overlay subscribes to `current`, it receives the currently selected entity's document immediately. When `passenger.check.in` changes which entity is selected, every subscriber to `current` receives the update automatically, without making another call.

The practical consequence: if an operator says "I called `current` and got nothing," they have confused a publication for a method. Publications are subscribed to — not called. If a client says "I called `passenger.check.in` and nothing updated in the widget," the issue is not the method call — it is whether the widget is subscribed to the `current` publication and receiving the reactive update.

**What you can do now:**
- Describe the difference between a DDP method call and a DDP publication subscription in one sentence each
- Explain why a client does not need to make a second call to receive collection updates after subscribing
- State which kind of interaction `passenger.ingest.url` is and which kind `current` is

**Exit criterion for this atom:** The operator can explain, without reference material, why `current` is subscribed to rather than called, and what happens at the DDP level when `passenger.check.in` is called while a client is subscribed to `current`.

---

### Atom 4.2: The Passenger Methods

All five passenger methods are defined in `~/.koad-io/daemon/src/server/passenger-methods.js`. Each serves a distinct operational purpose, and each has a distinct implementation status. Knowing both — what the method does and whether it is fully wired — prevents confusion when a method returns less than expected.

**`passenger.check.in(passengerName)`** — Fully implemented. Accepts a display name string. Looks up the entity by `{ name: passengerName }` in the Passengers collection, removes `selected` from all documents, sets `selected: new Date()` on the target entity, and returns `{ _id: passenger._id }`. This is the primary selection method — it is what the browser overlay calls when the operator switches active entities.

**`passenger.ingest.url(data)`** — Partially implemented. Accepts `{ url, title, timestamp, domain, favicon? }`. Looks up the currently selected entity. Logs `[INGEST] <name> received URL: <url>` to the daemon log. Returns `{ success: true, passenger: name }` if an entity is selected, `{ success: false, reason: 'No passenger selected' }` if none is. The logging is real — the data arrives and is recorded. The routing is not yet wired — nothing downstream receives the URL context and delivers it to the entity's session.

**`passenger.resolve.identity(data)`** — Stub. Accepts `{ domain, url? }`. Logs `[IDENTITY] <name> resolving: <domain>`. Always returns `{ found: false, message: 'Identity resolution not implemented' }`. The method runs without error but produces no useful result. Future implementation: look up the entity's identity data for the given domain and return it.

**`passenger.check.url(data)`** — Stub. Accepts `{ domain, url? }`. Logs `[CHECK] <name> checking: <domain>`. Always returns `{ warning: false, safe: true, message: 'URL check not implemented' }`. The safe/warning flags are hardcoded — no actual check is performed. Future implementation: consult entity-specific URL policies and return a real safety assessment.

**`passenger.reload()`** — Fully implemented. Takes no arguments. Calls `Passengers.remove({})` to clear the entire collection, then calls `registerPassengers()` to re-scan entity directories and repopulate. Returns `{ success: true }`. This is the primary operational control for after-configuration changes — add or modify a `passenger.json`, then call `passenger.reload` (via the admin PWA's Reload button) rather than restarting the daemon.

**What you can do now:**
- Name all five passenger methods from memory and state what each does
- State which methods are fully implemented and which are stubs
- Explain why `passenger.reload` is preferred over restarting the daemon after a registration change

**Exit criterion for this atom:** The operator can describe each of the five passenger methods — what it accepts, what it does, what it returns, and whether it is fully wired — without reference to documentation.

---

### Atom 4.3: The open.* Methods — Desktop Integration

The seven `open.*` methods are defined in `~/.koad-io/daemon/src/server/clicker.js`. They are the daemon's mechanism for reaching into the desktop environment — launching browsers, opening applications, loading URLs. All seven use Node.js's `child_process.exec` to run shell commands.

The seven methods:

| Method | Command executed |
|--------|-----------------|
| `open.pwa(appId)` | Chrome with `--app-id=<appId>` (Chrome profile, Default) |
| `open.chrome()` | Chrome with Default profile |
| `open.brave()` | Brave with Default profile |
| `open.with.default.app(url)` | `open <url>` — system default handler |
| `open.with.chrome(url)` | Chrome with Default profile and target URL |
| `open.with.brave(url)` | Brave with Default profile and target URL |
| `open.pwa.with.brave(appId)` | Brave with `--app-id=<appId>` (Brave profile, Default) |

All seven are fire-and-forget: the method executes the shell command and returns without waiting for the browser to open. The `exec` callback logs errors only — no return value carries process status to the caller.

These methods run as the daemon user — koad on thinker. Browser paths are hardcoded: `/usr/bin/google-chrome` for Chrome methods, `/usr/bin/brave-browser` for Brave methods. If those binaries are not at those paths, the method logs an error and does nothing visibly. An operator on a machine with a different browser installation will need to update these paths.

The practical use: the desktop widget's quick-launch buttons map to these methods. When a button in `passenger.json` has `"action": "open.brave"`, clicking it in the overlay calls `open.brave()` on the daemon. The daemon runs the shell command, and Brave opens (or an error appears in the daemon log if the binary is missing).

**What you can do now:**
- Name the seven `open.*` methods and describe what each one launches
- Explain the fire-and-forget behavior: why a failed `exec` does not surface an error to the caller
- State where the browser binary paths are hardcoded and what an operator needs to change if the paths differ

**Exit criterion for this atom:** The operator can explain how a quick-launch button press in the browser overlay translates into a daemon shell command — what calls what, through what mechanism, and where errors go.

---

### Atom 4.4: How passenger.ingest.url Works Today

`passenger.ingest.url` is the most operationally significant method in the current codebase, and also the one with the largest gap between what its name implies and what it currently does. Understanding this gap prevents false confidence in URL context delivery.

When the Dark Passenger browser extension visits a URL, it calls `passenger.ingest.url` with a payload containing:
- `url` — the full URL of the current page
- `title` — the page title
- `timestamp` — an ISO 8601 string
- `domain` — the domain extracted from the URL
- `favicon` — optional; the favicon as a data URI if available

The daemon receives this payload. The method validates it with Meteor's `check()` — if any required field is missing or the wrong type, the call returns a validation error. If the payload is valid, the daemon does two things: it looks up the currently selected entity from the Passengers collection, and it logs the URL to the daemon process output as `[INGEST] <entity name> received URL: <url>`.

That is all it currently does. The method returns `{ success: true, passenger: entity.name }` — which accurately describes what happened: the daemon received the URL and knows which entity is selected. What it does not do: forward the URL context to the entity's Claude Code session, write it to any queue, publish it via DDP to any subscriber, or trigger any follow-on action. The spec comment says "processing TBD."

The log entry is real and useful for debugging: it confirms the extension is calling the method, the daemon is receiving the payload, and the correct entity is selected. An operator who sees `[INGEST]` lines in the daemon log knows the browser pipe is working. The absence of those lines — while the daemon is running and an entity is selected — indicates an extension configuration problem.

**What you can do now:**
- Describe the `passenger.ingest.url` payload fields and which ones are required vs. optional
- Explain exactly what the daemon does today when it receives a valid URL ingest call
- State what to look for in the daemon log to confirm the browser pipe is working

**Exit criterion for this atom:** The operator can describe the full current behavior of `passenger.ingest.url` — what it validates, what it logs, what it returns, and what it does not yet do — without confusing it with its intended future behavior.

---

### Atom 4.5: The HTTP REST Endpoint

DDP is the primary protocol for clients that can speak WebSockets. For clients that cannot — HTTP-only systems, webhooks, shell scripts, external services — the daemon exposes an HTTP endpoint that receives the same class of inbound data.

The endpoint is defined in `~/.koad-io/daemon/src/server/passenger-api.js`:

```
POST /passenger/post
Host: localhost:9568
Content-Type: application/json
```

The endpoint accepts any JSON body via a POST request. The handler logs the received body to the daemon process output as `Received POST from passenger: <body>`. It then responds with HTTP 200 and `{ status: "success", message: "Action processed successfully" }`.

The CORS headers on the response — `Access-Control-Allow-Origin: *` — are intentionally permissive. Because the daemon binds to localhost only by default, this is safe: no external origin can reach the endpoint without local network access.

The implementation status matches `passenger.ingest.url`: the pipe exists, the data arrives, the logging confirms receipt. No routing is wired. The comment block in the source explicitly marks processing as commented out. An HTTP client posting JSON to this endpoint will receive a success response and the data will appear in the daemon log — nothing more.

This endpoint exists for the same reason as the DDP method: browser context delivery is the intended use case, but the delivery mechanism needs to be flexible. Systems that cannot maintain a WebSocket connection (webhooks, CI pipelines, single-shot scripts) can use POST rather than DDP. When processing is wired, both the DDP method and the HTTP endpoint will deliver to the same pipeline.

**What you can do now:**
- Describe the HTTP endpoint's URL, method, and expected body format
- Explain what the daemon does with an incoming POST request today
- State why the CORS `Allow-Origin: *` header is safe given the daemon's default bind configuration

**Exit criterion for this atom:** The operator can make a test POST to `localhost:9568/passenger/post` with a JSON body, observe the log output, and explain what the response indicates about current implementation status.

---

## Exit Criterion

The operator can name all five passenger DDP methods and the seven `open.*` methods, state which are fully implemented and which are stubs, explain the difference between calling `passenger.ingest.url` and subscribing to the `current` publication, and describe what the HTTP REST endpoint at `/passenger/post` currently does.

**Verification question:** "The browser extension visits a URL. passenger.ingest.url is called. The daemon log shows `[INGEST] Juno received URL: https://example.com`. Does Juno's Claude Code session see the URL?"

Expected answer: No — not yet. The log confirms the URL reached the daemon and the correct entity is selected. But `passenger.ingest.url` only logs the payload; it does not forward the URL context to Juno's session or any subscriber. The routing is not implemented. The log line is evidence the browser pipe is working, not evidence that URL context is being delivered to the entity.

---

## Assessment

**Question:** "What is the difference between `passenger.check.in` and the `current` publication? A developer says they are both 'ways to get the current entity.' Are they?"

**Acceptable answers:**
- "`passenger.check.in` is a DDP method — you call it to *change* which entity is selected. `current` is a DDP publication — you *subscribe* to it to receive (and stay updated on) whichever entity is selected. One is a write action, the other is a read stream. They serve different purposes."
- "No, they are not the same kind of thing. `check.in` is an RPC call that modifies collection state. `current` is a reactive subscription that reflects collection state. One causes changes; the other observes them."

**Red flag answers:**
- "They are both ways to call the daemon" — conflates methods and publications
- "`current` returns the current entity when you call it" — misidentifies a publication as a callable method

**Estimated engagement time:** 25–30 minutes

---

## Alice's Delivery Notes

Operators arriving at this level have read the Passengers collection (Level 3) and know what the `current` publication returns. The challenge of this level is the methods-vs-publications distinction — operators who have used REST APIs may map DDP methods to HTTP GET requests and DDP publications to... nothing in their existing mental model. Frame publications as "a standing query with push updates" to give them a concrete analog.

The stub status of `passenger.resolve.identity` and `passenger.check.url` must be stated plainly. Operators who are paying attention will ask "so the browser overlay's safety check feature does nothing?" The correct answer is yes, currently. Being honest about stubs is part of what makes this curriculum trustworthy.

Atom 4.4 (`passenger.ingest.url`) deserves careful delivery. The operator may arrive expecting URL context delivery to be a working feature — they have seen it mentioned as a core capability. The log evidence is real; the routing gap is real. Both facts matter. The framing: "the browser pipe is live; the delivery pipeline is not yet wired."

Atom 4.5 (HTTP endpoint) is lower priority — it will not come up in normal operations. Cover it for completeness and to ensure operators know the daemon has a non-DDP inbound surface.

---

### Bridge to Level 5

The operator now knows what the daemon can do. Level 5 covers what to do when it does not do it — diagnosing and resolving the three most common failure modes: daemon not running, entity not registered, and DDP subscription not firing.
