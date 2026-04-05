---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 4
slug: ddp-methods-and-publications
title: "DDP Methods and Publications — How the Browser Extension Connects"
status: stub
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
> Name the DDP methods available on the daemon, explain what each one does and what calls it, describe how `passenger.ingest.url` delivers browser context to an entity, and explain the difference between a DDP method (RPC call) and a DDP publication (reactive data stream).

**Why this matters:** DDP is how the daemon communicates with everything that connects to it — the browser extension, the desktop widget, and future clients like the Stream PWA. An operator who understands the method set knows exactly what the daemon can and cannot do today vs. what is planned but not yet wired.

---

## Knowledge Atoms

*(stub — authoring pending)*

### Atom 4.1: DDP Concepts — Methods vs. Publications
**Teaches:** DDP method = RPC call (call it, get a result, one-shot). DDP publication = reactive data stream (subscribe, get current data, get updates automatically). The difference matters: `passenger.check.in` is a method, `current` is a publication. Understanding this prevents confusion about why some calls return data and others trigger side effects.

### Atom 4.2: The Passenger Methods
**Teaches:** `passenger.check.in`, `passenger.ingest.url`, `passenger.resolve.identity`, `passenger.check.url`, `passenger.reload`. What each does, what arguments it takes, which are fully implemented vs. stub-only. The honest status: `resolve.identity` and `check.url` are stubs that log and return nothing.

### Atom 4.3: The open.* Methods — Desktop Integration
**Teaches:** `open.pwa`, `open.chrome`, `open.brave`, `open.with.default.app`, `open.with.chrome`, `open.with.brave`, `open.pwa.with.brave`. These execute shell commands via Node.js `child_process.exec`. They are the daemon's mechanism for reaching into the desktop environment. Why this matters: they run as the daemon user, with the daemon user's PATH and environment.

### Atom 4.4: How passenger.ingest.url Works Today
**Teaches:** The extension calls `passenger.ingest.url({ url, title, timestamp, domain, favicon? })`. The daemon logs the payload. Full processing — delivering the URL context to the active entity session — is not yet wired. The spec says "processing TBD." The operator should understand this is a live data pipe that logs but does not yet route.

### Atom 4.5: The HTTP REST Endpoint
**Teaches:** `POST /passenger/post` at localhost:9568. Accepts JSON. Currently logs and returns `{ status: "success" }`. Full processing not wired. This endpoint exists for systems that cannot speak DDP (HTTP-only clients, webhooks). Same gap as `passenger.ingest.url` — the pipe exists, routing is future work.

---

## Exit Criterion

*(placeholder — to be written during authoring)*

The operator can list the passenger DDP methods from memory, state which are fully implemented and which are stubs, and explain the difference between calling `passenger.ingest.url` and subscribing to the `current` publication.

---

## Bridge to Level 5

The operator knows what the daemon can do. Level 5 covers what to do when it does not do it — diagnosing and resolving the three most common failure modes.
