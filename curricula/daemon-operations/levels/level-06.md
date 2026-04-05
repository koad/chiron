---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 6
slug: the-hybrid-coordination-model
title: "The Hybrid Coordination Model — GitHub Issues and DDP in Practice"
status: authored
prerequisites:
  curriculum_complete:
    - advanced-trust-bonds
  level_complete:
    - daemon-operations/5
estimated_minutes: 25
atom_count: 4
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 6: The Hybrid Coordination Model — GitHub Issues and DDP in Practice

## Learning Objective

After completing this level, the operator will be able to:
> Explain why GitHub Issues is the durable coordination layer and DDP is the real-time layer, give a concrete example of each that could not be handled by the other, describe the hybrid reconnection protocol an entity follows when coming back online, and state what breaks operationally if work is dispatched through DDP rather than GitHub Issues.

**Why this matters:** This is the most consequential level in the curriculum. An operator who misunderstands the hybrid model will dispatch real work through DDP methods — and lose it when the daemon restarts or the entity session ends. The distinction between durable coordination and real-time coordination is not an aesthetic design choice. It is the design principle that determines whether work persists. Getting this wrong has direct operational consequences.

---

## Knowledge Atoms

### Atom 6.1: Why GitHub Issues Is the Durable Layer

GitHub stores issues. This is not a subtle point — it is the entire reason GitHub Issues is the durable coordination layer. An issue filed on `koad/juno` exists on GitHub's servers, in the repository's history, accessible via the API and the web interface, regardless of what is happening on any local machine. The daemon can be stopped. The machine can be rebooted. The entity's Claude Code session can exit. The issue remains.

Consider the operational sequence: koad files an issue on `koad/juno` assigning Juno a task. The issue has a number, a title, a body, a label, and an assignee. Juno's session ends that afternoon. Twelve hours later, Juno starts a new session. The first thing Juno does — per the session start protocol — is `git pull` on `~/.juno`, then `gh issue list --state open`. The assigned task appears. Nothing was lost. No reconnection to any service was required. No daemon needed to be running during the twelve-hour gap.

The durability of GitHub Issues comes from the same property that makes git commits durable: the state is stored externally to the runtime. A git commit survives process crashes, network outages, and machine failures because it is persisted to disk (and replicated to the remote). A GitHub Issue survives the same events because it is persisted on GitHub's servers, accessible from any network-connected session.

This is the design constraint that makes the koad:io multi-entity coordination model reliable. With seven entities operating across three machines, with sessions starting and stopping throughout the day, the question "how does Juno know what to do when she wakes up?" must have an answer that does not depend on any daemon, any DDP connection, or any session continuity. That answer is: `gh issue list --state open`. Every entity, on every machine, after any length of downtime, recovers all pending work from the same authoritative source.

**What you can do now:**
- Name one specific property of GitHub Issues that makes it the durable layer (not a vague claim about reliability)
- Walk through the complete recovery sequence for an entity returning after 12 hours offline
- State what "durable" means in this context — what events it survives

**Exit criterion for this atom:** The operator can explain the durability guarantee of GitHub Issues with precision — what stores the data, what events it survives, and why the daemon's state (MongoDB, DDP) does not share that guarantee.

---

### Atom 6.2: Why DDP Is the Real-Time Layer

DDP enables things that GitHub Issues structurally cannot. The boundary between the two is not arbitrary — it follows from what each system is built to do.

GitHub Issues is asynchronous by design. Filing an issue, adding a comment, closing an issue — these are discrete actions with discrete timestamps. There is no mechanism in GitHub Issues for sub-second updates, for an entity to know the moment a URL is loaded in a browser, for a widget to update when an entity is selected. GitHub Issues is a message board with a very good API. It is not a pub/sub bus.

DDP is a reactive data protocol. When the Dark Passenger extension subscribes to `current`, it receives the currently selected entity's data within milliseconds of the DDP connection being established. When `passenger.check.in` changes the selection, every connected subscriber receives the update in real time — without polling, without a new HTTP request, without any client-initiated action. This is structurally impossible via GitHub Issues.

The capabilities that DDP enables today, and that GitHub Issues cannot replicate:

**Sub-second presence updates.** Switching which entity is selected via `passenger.check.in` updates the widget, the browser overlay, and any other subscriber immediately. There is no polling interval. There is no latency beyond the DDP round-trip.

**URL context delivery.** When the browser visits a URL, `passenger.ingest.url` delivers the URL to the daemon within the same browsing interaction. The operator does not copy and paste. The entity does not poll. The connection is live. (The routing to the entity session is not yet wired, but the delivery mechanism — DDP method call — is real-time in a way that a GitHub Issue comment is not.)

**Live presence in the admin PWA.** The Passengers list updates reactively when `passenger.reload` runs, when an entity is checked in, and when collection state changes. No page refresh required.

**Foundation for the Stream PWA.** Vulcan's `koad/vulcan#3` — the live activity wall across all entities and systems — is built on DDP subscriptions. The Stream PWA subscribes to `DaemonActivity` events and renders them as they arrive. A GitHub Issues feed could not produce this experience: it would require polling, would have API rate limits, and would have latency measured in seconds rather than milliseconds.

The principle: use DDP for anything that requires immediacy and can tolerate impermanence. Use GitHub Issues for anything that requires permanence and can tolerate asynchrony. Neither system is a substitute for the other.

**What you can do now:**
- Name two operational capabilities that DDP enables and GitHub Issues cannot
- Explain why the Stream PWA's live activity feed requires DDP rather than polling GitHub Issues
- State the principle for choosing between DDP and GitHub Issues in one sentence

**Exit criterion for this atom:** The operator can give a concrete example of a coordination need that belongs to DDP and one that belongs to GitHub Issues, and explain — in terms of the architectural properties of each — why they cannot swap.

---

### Atom 6.3: The Hybrid Reconnection Protocol

Every entity session follows the same reconnection sequence when coming back online. The sequence is designed to recover all durable state first, then reconnect to the real-time layer. Reversing the order does not lose work — but the correct order ensures the entity has its complete operational picture before making any decisions.

**The four steps:**

**Step 1: `git pull` on the entity directory.**
Reconcile all file-based state: configuration changes, updated `passenger.json`, new trust bonds, memory updates, any commits pushed by another session. Git is the source of truth for the entity's configuration and history. Pull before reading anything.

**Step 2: `gh issue list --state open`.**
Recover all assigned tasks. Every issue that was filed while the entity was offline, every issue that was updated, every issue that was assigned — all of it is here. This is the complete pending work queue. The entity's next actions are determined by this list. The daemon's state, whatever it is, does not affect what work is pending.

**Step 3: Connect to the daemon and re-establish DDP subscriptions.**
Once durable state is recovered, reconnect to the real-time layer. If the daemon is running, the entity registers its DDP client, subscribes to relevant publications, and becomes visible in the Passengers collection. If the daemon is not running, this step is skipped — the entity continues operating via the GitHub Issues layer, which was already recovered in Step 2.

**Step 4: Check for pending tasks in the daemon's worker queue.**
If the daemon is running and the `passenger.queue` publication is available, check for jobs with `status: "queued"` or `status: "in_progress"` that belong to this entity. This step acknowledges any work that was dispatched via the real-time layer and not yet acknowledged. Note: this step is only meaningful if the daemon has a persistent worker queue — currently the `PassengerJobs` collection is specified in VESTA-SPEC-045 but not yet implemented. Until it is, this step is a no-op.

The sequence's design principle: durable recovery first, real-time reconnection second. An entity that skips Step 2 and connects to the daemon first can receive DDP dispatches before knowing about its GitHub Issues assignments — potentially starting real-time work before processing the full pending queue. The correct sequence prevents this.

**What you can do now:**
- State the four steps of the reconnection protocol in the correct order
- Explain why the `git pull` and `gh issue list` steps come before the DDP connection step
- Describe what happens at Step 3 if the daemon is not running

**Exit criterion for this atom:** The operator can walk through the four-step reconnection protocol from memory and explain the ordering rationale — why each step precedes the next.

---

### Atom 6.4: What the Daemon Enables That GitHub Issues Does Not

This atom closes the curriculum by making concrete what the daemon's real-time layer adds to a system that already works without it. The framing is additive: the daemon is not required for operations to function, and its capabilities are a meaningful extension — not a replacement for anything.

**The capabilities that only exist when the daemon is running:**

**The Dark Passenger browser overlay.** The diamond widget in the browser corner, the URL ingest pipeline, the quick-launch buttons triggered from the browser — none of these function without a live DDP connection to the daemon. An entity operating without the daemon does not receive URL context from the browser and cannot be launched via the overlay. The entity is fully operational, but the browser integration is absent.

**Desktop widget.** The quick-launch diamond on the desktop surface — the one that shows the currently selected entity and exposes action buttons — subscribes to the `current` publication. Without the daemon, the widget has no DDP connection, shows nothing, and cannot trigger `open.*` methods. The daemon is the widget's entire backend.

**Admin PWA at localhost:9568.** The browser-accessible entity roster with reactive updates, the Reload button, the entity selector — all served by the daemon's HTTP server and populated via DDP. Without the daemon, `localhost:9568` returns `Connection refused`.

**Real-time entity presence.** Knowing which entities are registered and which is currently selected — visible in real time as selections change — exists only through the Passengers collection and DDP subscriptions. Without the daemon, there is no live roster.

**Stream PWA (Vulcan#3 — pending).** The live activity wall across all entities and systems is built on DDP subscriptions to `DaemonActivity`. When implemented, it will require the daemon to be running. Without the daemon, the Stream PWA has no data source.

**The important framing:**

These capabilities are additive. Their absence means those features are unavailable — not that operations are broken. An entity can receive assignments, do work, commit results, file issues, and close tickets entirely through the GitHub Issues layer while the daemon is stopped. The operator will not have a browser overlay or a real-time widget. The work will continue.

This is the same principle introduced in Level 0 (the operational diff) now stated at the end of the curriculum, after the operator has worked with the daemon in detail. The point lands differently after six levels of concrete operations: the operator now knows exactly what the daemon does, has debugged it, and understands its method set. "The daemon is additive" is not a dismissal — it is a precise architectural claim about which system carries which responsibility.

**What you can do now:**
- List three capabilities that require the daemon to be running
- State what an entity can still do while the daemon is stopped
- Explain why "daemon is additive" is a precise architectural claim, not a statement that the daemon is unimportant

**Exit criterion for this atom:** The operator can produce a concrete list of what the daemon enables — grouped as browser integration, desktop presence, and real-time infrastructure — and explain clearly that operations through GitHub Issues are unaffected when the daemon is offline.

---

## Exit Criterion

The operator can describe a scenario where GitHub Issues is the correct coordination tool and a scenario where DDP is the correct tool, explain what would go wrong in each scenario if the wrong tool were used, walk through the hybrid reconnection protocol in order, and state what the daemon adds to a system that already works without it.

**Verification question:** "koad wants to assign Vulcan an urgent build task right now. Should he file a GitHub Issue or dispatch it via a DDP method call?"

Expected answer: File a GitHub Issue. The DDP dispatch would be lost if the daemon restarts before Vulcan acknowledges it. There is no persistence guarantee on DDP method calls. GitHub Issues persist on GitHub's servers regardless of daemon state. If urgency is needed, koad can also notify Vulcan directly (via Keybase or by spawning a session) — but the assignment itself must go through a durable channel. If the `PassengerJobs` worker queue were implemented with proper persistence, there could be a case for DDP dispatch with a persistence guarantee — but that is not the current state of the system.

---

## Assessment

**Question:** "An operator decides to use DDP method calls exclusively for task dispatch because 'it's faster and more direct.' What operational risk does this create?"

**Acceptable answers:**
- "Any task dispatched only via DDP is lost when the daemon restarts, the entity session ends, or the MongoDB collection is cleared. DDP state is in-memory and in MongoDB — neither is durable in the way GitHub Issues are. If the entity does not process and acknowledge the task before the daemon restarts, the task is gone. There is no recovery path."
- "DDP is real-time, not durable. A method call result does not persist. Work assigned only via DDP has no audit trail, no assignee record, no way for the entity to recover it on reconnect via `gh issue list`. The operator has created a coordination model that cannot survive daemon downtime."

**Red flag answers:**
- "DDP calls return a result so the operator knows the task was received" — confuses delivery acknowledgment with task persistence
- "The entity will see the task in the Passengers collection" — the Passengers collection is an entity roster, not a task queue

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

Operators arriving at this level have operated the daemon, registered entities, read live state, called DDP methods, and debugged failure modes. They have seen the daemon up close. This level asks them to step back and understand the architectural boundary — when is each system the right tool?

The most important thing to convey in this level is the failure mode that incorrect hybrid model usage creates. It is not a theoretical concern: if koad dispatches a task to Vulcan via `passenger.reload` or some future worker method and the daemon restarts before Vulcan acknowledges it, the task is gone. There is no `gh issue list` recovery path for DDP state. This is the operational consequence that motivates the whole level.

Atom 6.1 and 6.2 should be taught as a pair — durability vs. immediacy. Frame them as "what each system was built to be good at" rather than "what each system lacks." GitHub Issues is not slow and awkward; it is persistently durable. DDP is not fragile; it is appropriately real-time. The framing affects how operators approach tool selection.

Atom 6.3 (reconnection protocol) is operational procedure. Deliver it as a checklist. The ordering rationale — durable recovery before real-time reconnection — is the key insight. An operator who understands the rationale will reconstruct the correct order even if they forget the specific steps.

Atom 6.4 closes the curriculum's conceptual arc: Level 0 introduced the "daemon is additive" principle; Level 6 confirms it with full operational knowledge. The operator has now seen everything the daemon does. The final message — operations continue without the daemon — lands as a grounded conclusion, not an abstract claim.

---

## Curriculum Complete

After completing this level, the operator has finished daemon-operations. They can:

- Explain what the daemon is, where it lives, and what it adds to the ecosystem
- Start the daemon and verify it is healthy
- Write a valid `passenger.json` and register any entity
- Read the Passengers collection, interpret every field, and understand the liveness gap
- Name and explain every DDP method and publication, including honest status on stubs
- Diagnose the three failure modes using the three-step diagnostic sequence
- Apply the hybrid reconnection protocol and explain the ordering rationale
- State the design principle: GitHub Issues for durability, DDP for immediacy

The prerequisite graph's next step is determined by the operator's focus area. See the Curriculum Registry at kingofalldata.com for available next curricula.
