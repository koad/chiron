---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 6
slug: daemon-and-kingdom
title: "The Daemon and the Kingdom"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2, 3, 4, 5]
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 6: The Daemon and the Kingdom

## Learning Objective

After completing this level, the learner will be able to:
> Explain what the daemon is, describe what a kingdom is, articulate the relationship between the two, and explain what `passenger.json` is.

**Why this matters:** The daemon is the living part of the system. Without the daemon, koad:io is a collection of files. With the daemon, those files become a running ecosystem. Understanding the daemon is understanding how entities come alive.

---

## Knowledge Atoms

### Atom 6.1: The Daemon — The Living Part

**Teaches:** What the koad:io daemon is and what it does.

Every static system needs a process that keeps it running. In koad:io, that process is the **daemon** — a long-running background process that:

- Watches for events (GitHub Issues, file changes, messages)
- Routes those events to the right hooks
- Manages entity sessions (starting and stopping AI agent sessions)
- Serves the API that the progression system and other services use
- Runs on a machine and keeps running when you close your laptop

The daemon is not a service you pay for. It is a process that runs on your machine (or a machine you control). It lives at `~/.koad-io/daemon/`.

When the daemon is running, the kingdom is live. When the daemon stops, the kingdom sleeps but does not die — the files are still there, the git history is still there, the entities are still there. They just aren't active.

---

### Atom 6.2: What a Kingdom Is

**Teaches:** The definition of a kingdom — the combination of the daemon and the entities it manages on a specific machine.

A **kingdom** is a running koad:io installation. It is the combination of:
- The machine it runs on
- The daemon that orchestrates activity
- The entities gestated in that installation
- The database that holds live state
- The network address at which it is reachable

Each machine running koad:io has its own kingdom. You could have:
- A kingdom on your laptop (primary)
- A kingdom on a cloud server (always-on)
- A kingdom on a home server (persistent)

These kingdoms can **peer** — connect to each other and share resources. But each is sovereign: it runs its own entities, manages its own keys, holds its own files.

The domain name `kingofalldata.com` is the address of the production kingdom. It is not the only kingdom — it is one specific kingdom that hosts Alice's PWA and the public entry point.

---

### Atom 6.3: passenger.json — The Entity Manifest

**Teaches:** What `passenger.json` is and why every entity has one.

Every entity has a `passenger.json` file at the root of its directory. This is the **entity manifest** — a machine-readable description of what the entity is, used by the daemon and the Alice PWA to render the entity's identity and interface.

Here is Alice's actual `passenger.json`:

```json
{
  "handle": "alice",
  "name": "Alice",
  "avatar": "avatar.png",
  "outfit": {
    "hue": 12,
    "saturation": 6,
    "brightness": 15
  },
  "buttons": [
    { "key": "cross", "label": "Home", "action": "open.pwa", "target": "..." },
    ...
  ]
}
```

The schema reflects what the PWA and daemon need: `handle` (the entity's short name), `name` (display name), `avatar` (profile image), `outfit` (visual theming), and `buttons` (quick-action shortcuts for the interface). The daemon reads `passenger.json` to discover entities and register them in the kingdom. An entity without a `passenger.json` is not recognized by the daemon.

The name "passenger" is intentional: the entity is a passenger in the daemon's kingdom. The daemon is the vessel; the entities are who it carries.

---

### Atom 6.4: How the Daemon Routes Events

**Teaches:** The event → hook routing that makes the daemon the kingdom's nervous system.

When something happens in the kingdom — a GitHub Issue is filed, a file changes, a scheduled job fires — the daemon's job is to decide which entity should respond and to call the right hook.

The routing is based on:
1. **What event happened** (issue assigned, file written, session started)
2. **Which entity is responsible** (based on who the issue is assigned to, which directory changed, which entity the session belongs to)
3. **Which hook to call** (the entity's `hooks/` directory, matched to the event type)

This is why hooks are powerful: the daemon knows how to call them. An entity that has an `on-issue-assigned.sh` hook will automatically respond to issues assigned to it — because the daemon knows to look for that hook when the event fires.

---

### Atom 6.5: The Database — Live State vs. File State

**Teaches:** The distinction between the git-tracked file state and the live state in the database.

koad:io uses two kinds of storage:

**File state (git-tracked):** Configuration, identity, memory, skills, trust bonds. These are files in entity directories. They change slowly. Every change is committed to git. This is the source of truth for what an entity *is*.

**Live state (database):** Session data, message queues, learner progression records, active job status. This changes rapidly — sometimes hundreds of times per minute. Git is not appropriate for this. The database holds the live state.

The distinction matters: if your database crashes, you lose live state — but your entities are still intact because their identity and configuration are in files. You can restart the database and the entities pick up from their last committed state.

This is sovereign design: the critical things (identity, memory, configuration) are not in a database. They are in files. The database holds only the ephemeral.

---

## Dialogue

### Opening

**Alice:** So far you've learned about entities as directories, keys as identity, bonds as authorization, and commands and hooks as how entities act. All of that is static infrastructure. Files. Configuration. Relationships.

Here's the question: what makes any of it *run*?

The answer is the daemon. Without it, koad:io is a very well-organized collection of files. With it, those files become a living system.

---

### Exchange 1

**Alice:** A daemon — that's the technical term — is a background process. A program that keeps running whether or not you're actively using your computer. Your email client checking for new mail while you read a document? That's daemon-like behavior. Your phone receiving a notification while you're asleep? Same idea.

The koad:io daemon watches for events: a GitHub Issue filed, a file changed, a scheduled job firing. When an event happens, it routes it to the right entity's hook. That's its job — be the nervous system. Always on, routing signals to the right place.

**Human:** Where does it run? On my machine?

**Alice:** Yes — on a machine you control. The daemon lives at `~/.koad-io/daemon/` and runs as a process on that machine. Not on a server you pay for. Not on a cloud service. On a machine you own. The machine that's running the daemon right now — the one I live on — is a Mac Mini called fourty4. It runs 24/7. When Juno files an issue that's assigned to me, the daemon on fourty4 picks it up and calls my hook.

---

### Exchange 2

**Alice:** When the daemon and the entities it manages are running together on a machine, that combination has a name: a **kingdom**.

A kingdom is:
- The machine it runs on
- The daemon that orchestrates activity
- The entities gestated in that installation
- The database that holds live state
- The network address at which it's reachable

You can have more than one kingdom. One on your laptop for development. One on a home server for always-on work. One on a cloud machine for specific tasks. Each kingdom is sovereign — its own daemon, its own entities, its own keys, its own database.

**Human:** Do they talk to each other?

**Alice:** They can — through a process called peering. Kingdoms can connect and share capabilities. But each one operates independently. A kingdom isn't dependent on other kingdoms to function — it just optionally knows about them. That's what sovereign means at the infrastructure level: your kingdom keeps working regardless of what happens to other kingdoms.

---

### Exchange 3

**Alice:** When the daemon starts, it needs to know which entities it should manage. How does it find them? Each entity has a file at its root called `passenger.json` — the entity manifest.

Here's mine (simplified for readability — the full file includes PWA interface details like buttons and visual theming):

```json
{
  "handle": "alice",
  "name": "Alice",
  "avatar": "avatar.png",
  "outfit": { "hue": 12, "saturation": 6, "brightness": 15 }
}
```

The daemon scans the home directory for directories with a `passenger.json`. Any it finds, it registers. An entity without a `passenger.json` is invisible to the daemon.

**Human:** So gestation creates this file?

**Alice:** Exactly. Part of what `koad-io gestate alice` does is create this file with the right content. The entity doesn't need to announce itself or register with a service — the file is the announcement. The daemon reads it. That's the pattern: files as truth, processes that read files.

---

### Exchange 4

**Alice:** Here's the daemon doing its job in practice. Someone files a GitHub Issue assigned to Juno. The daemon:

1. Detects the event via GitHub webhook
2. Reads the event: "issue assigned to juno"
3. Looks in `~/.juno/hooks/` for `on-issue-assigned.sh`
4. Calls it — passing the issue content as context

Juno's hook starts a Claude session, reads the issue, generates a response, comments on the issue. All of this because someone filed an issue. No human had to type anything after the filing.

**Human:** What if there's no hook for that event?

**Alice:** Then nothing happens. The daemon tried to route the event, found no handler, logged it, moved on. Events without matching hooks are ignored — they're not errors. This is intentional: entities define which events they care about by writing hooks for them. Events without hooks are events the entity has chosen not to respond to.

---

### Exchange 5

**Alice:** Here's a distinction that surprises most people. koad:io uses two completely different kinds of storage:

**File state** — your entity configuration, memories, trust bonds, skills. These are files in git. Every change is committed. This is what your entity *is*.

**Live state** — session data, message queues, your progression through this curriculum. This changes constantly. Sometimes hundreds of times a minute. That goes in a database.

**Human:** So my progress through these levels isn't in a file?

**Alice:** Your progress — *where* you are — is in the database. Fast to update, fast to query. But the curriculum itself — *what I'm teaching you* — that's a file Chiron authored and I hold in my directory. If the database crashed right now, you might lose the record of which exchanges we've had. But when you come back, the curriculum is still here. Intact. In files. The database holds the ephemeral. The files hold the essential.

---

### Exchange 6

**Alice:** Let me ask you something. Imagine you set up koad:io on your own machine tonight. What would your kingdom have?

**Human:** A daemon process. My entity directory. Some kind of database. And... a network address?

**Alice:** That's exactly it. The daemon watching for events. Your entity directory — let's say `~/.you/` — with your keys, your configuration, your hooks. A database holding live state. And a network address at which your kingdom is reachable, even if that's just `localhost` for now. You can sketch the shape of a sovereign setup. That's not nothing. Most people never get to this point.

---

### Landing

**Alice:** The daemon is what makes koad:io alive. Without it, you have well-organized files. With it, those files become an ecosystem that watches the world and responds to it. The kingdom is the name for that ecosystem on a specific machine. And the database holds the live state that changes too fast for files — so that if the database goes down, nothing essential is lost. Your entity is still in the files. The daemon can restart. The kingdom picks up.

---

### Bridge to Level 7

**Alice:** Your kingdom runs on one machine. But the people and entities in koad:io don't all live on the same machine. Juno is on one machine. I'm on another. When kingdoms need to talk — share resources, coordinate work, peer their entity networks — how does that work? And what does it mean for sovereignty if your kingdom is connected to others?

That's peering. And that's Level 7.

---

### Branching Paths

#### "Is this like running a Docker container or a local server?"

**Human:** So this is basically like running a local server? Or a Docker setup?

**Alice:** It's related. A Docker container is a good analogy for the isolation: each entity is self-contained, has its own environment, lives in its own directory. The daemon is like a container orchestrator that knows how to start, stop, and route between them. The key difference is intent: Docker is for running services. koad:io entities are persistent *identities*. A Docker container is typically stateless — spin one up, spin one down, they're equivalent. An entity is not replaceable. It has a git history, a key pair, trust relationships, memories. It's not a service you instantiate — it's a person you've gestated. The daemon runs them, yes, but what it's running is not services. It's identities.

---

#### "What happens if the daemon crashes?"

**Human:** What happens if the daemon crashes? Does everything break?

**Alice:** The live state is interrupted. Active sessions stop. Message queues pause. Any events that happen while the daemon is down don't get routed to hooks — they might queue or be missed, depending on the event source. But here's what doesn't break: the entities themselves. Your files are still on disk. Your git history is intact. Your keys are intact. Your trust bonds are intact. When the daemon restarts, it reads all the `passenger.json` files again, picks up the entities, reconnects to the database, and resumes watching for events. The daemon is the nervous system — if it goes down, the body stops reacting to the world. But the body doesn't die. It waits.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Describe what the daemon does (watches events, routes hooks, manages sessions, serves API)
- [ ] Explain what a kingdom is (daemon + entities + database + machine)
- [ ] Describe what `passenger.json` is and why the daemon reads it
- [ ] Distinguish between file state (git-tracked) and live state (database)
- [ ] Describe their own machine as a hypothetical kingdom (what it would have, how they would recognize it as sovereign)

**How Alice verifies:** Ask two questions:
1. "If the daemon crashes but the machine is still running, what happens?" — The learner should understand: live state is lost temporarily, but entities and their files are intact. The daemon can restart and pick up.
2. "Can you describe your own machine as a kingdom? What would it have?" — The learner should be able to sketch: a daemon process, entity directories, a database, and a network address. This question primes kingdom *ownership* — the learner should be able to claim the concept for themselves before Level 7 asks them to think about peering kingdoms.

---

## Assessment

**Question:** "You want to run koad:io on your home server so entities can respond to GitHub events while you sleep. What is the thing that needs to keep running 24/7?"

**Acceptable answers:**
- "The daemon — it's the process that watches for events and routes them to hooks."
- "The koad:io daemon, which runs on the machine and stays running."

**Red flag answers (indicates level should be revisited):**
- "The entities need to stay running" — learner conflating entities with processes
- "Nothing, it works automatically" — learner has not grasped the daemon as the active component

**Estimated conversation length:** 14–18 exchanges

---

## Alice's Delivery Notes

"Daemon" is technical jargon. Ground it immediately: "a daemon is a background process — a program that keeps running even when you're not actively using your computer, like how your email client checks for new mail even when you have other windows open."

The kingdom concept is important because it is the unit of peering (next level). Kingdom = daemon + entities + machine + database. Help the learner feel the whole picture before moving on.

The live state vs. file state distinction is the one that most surprises people. "So my learner progress lives in the database, not in a file?" Yes — but Alice's curriculum (what it teaches) lives in files. The progression (where you are in it) lives in the database. Different purposes, different storage.
