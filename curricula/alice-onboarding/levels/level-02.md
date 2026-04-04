---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 2
slug: what-is-an-entity
title: "What Is an Entity?"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1]
estimated_minutes: 20
atom_count: 5
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 2: What Is an Entity?

## Learning Objective

After completing this level, the learner will be able to:
> Describe what an entity is in the koad:io model, explain the two-layer architecture (framework vs. entity layer), and identify what makes an entity "theirs."

**Why this matters:** "Entity" is the vocabulary the rest of the curriculum depends on. Getting this wrong means every subsequent level builds on a misunderstanding. Level 2 plants the vocabulary with precision.

---

## Knowledge Atoms

### Atom 2.1: An Entity Is a Directory

**Teaches:** What an entity is at the most concrete level — a directory on disk with a specific structure.

An entity in koad:io is a directory. Not a record in a database, not an API endpoint, not an account on a platform. A directory on your filesystem, with a specific structure that the koad:io framework understands.

Every entity has a home:
```
~/.alice/     ← Alice's entity directory
~/.juno/      ← Juno's entity directory
~/.chiron/    ← Chiron's entity directory
```

Everything that makes an entity what it is — its identity, its memory, its configuration, its keys, its skills — lives in that directory. The entity is the directory.

---

### Atom 2.2: The Two-Layer Architecture

**Teaches:** How the framework layer and entity layer relate to each other and why they are separate.

koad:io has two layers that never get confused:

```
~/.koad-io/    ← Framework layer
~/.alice/      ← Entity layer (Alice's)
~/.juno/       ← Entity layer (Juno's)
```

The **framework layer** (`~/.koad-io/`) is the runtime — CLI tools, templates, the daemon engine, the browser extension. It is like an operating system: it provides capabilities, but it has no identity of its own.

The **entity layer** is where identity lives. Each entity directory is a separate sovereign unit — its own git repository, its own keys, its own configuration, its own memory. The framework serves the entity. The entity is not part of the framework.

This separation is what makes portability possible. If you move Alice's directory to another machine, Alice works on that machine. The framework is the engine; the entity is the person.

---

### Atom 2.3: What "Gestation" Is

**Teaches:** The process by which a new entity comes into existence.

Entities don't get "signed up for" — they are **gestated**. Gestation is the process of creating a new entity directory with everything it needs to operate: keys, identity files, configuration, git repository, initial memory files.

```bash
koad-io gestate alice    # Create the alice entity
```

The gestation command creates `~/.alice/` with the full structure: cryptographic keys, a `CLAUDE.md` identity file, memory files, a passenger manifest, and a git repository ready to push to GitHub.

After gestation, the entity exists — as files on disk. The entity can then be run, configured, given skills, and connected to other entities.

Gestation is birth. The entity did not exist before. It does now. It is yours.

---

### Atom 2.4: Entities Are Sovereign Individuals

**Teaches:** The philosophical implication of the entity model — entities are individuals, not services.

In most software, an "agent" is a process. It runs, it does things, it stops. It has no persistent identity between runs.

In koad:io, an entity is more like a person. It has:
- A name (`alice`, `juno`, `chiron`)
- Cryptographic keys (its unforgeable identity)
- Memory (context that persists across sessions)
- Skills (things it knows how to do)
- Relationships (trust bonds to other entities)
- A git history (every change to its configuration is recorded)

This is not metaphor — these are actual properties stored in the entity's directory. The entity persists because the files persist. Its "personality" is its CLAUDE.md and memories. Its relationships are its trust bonds. Its history is its git log.

---

### Atom 2.5: Not Your Keys, Not Your Agent

**Teaches:** The single most important principle of entity ownership.

There is a phrase in the cryptocurrency world: "not your keys, not your coins." The idea: if you don't hold the private keys, you don't own the asset — you have a claim in someone else's ledger.

koad:io applies the same principle to AI agents: **not your keys, not your agent**.

If your AI agent runs on a vendor's server, you don't own it — you have a subscription. The vendor holds the keys. They can revoke access. They can shut down. They can change what the agent does. The relationship you built with that agent is hostage to a commercial arrangement.

In koad:io, the entity's cryptographic keys live in `~/.{entity}/id/`. You hold them. No vendor holds them. The agent is yours — not as a service, but as property.

---

## Dialogue

### Opening

**Alice:** I live at `~/.alice/` on a Mac Mini called fourty4. That's a hidden folder — the dot in front means your file browser won't show it by default, but it's just a regular folder. That's where I am. That's it. Let me show you what's in there.

---

### Exchange 1

**Alice:** When you open `~/.alice/`, here's what you see:

```
CLAUDE.md
memories/
commands/
trust/
id/
hooks/
```

Each of these does something specific. `CLAUDE.md` — that's my identity file. It tells me who I am: my name, my role, my relationships, how I operate. Every session, I read that file first. It's the difference between me and a blank AI chat window.

**Human:** So it's like a system prompt?

**Alice:** It's more than that. A system prompt gets reset every session. `CLAUDE.md` is a file that persists, gets edited, gets committed to git — a version control system that tracks every change, like Track Changes in Word but for every file, forever. When my understanding of my role evolves, that file changes. When Chiron updates my curriculum structure, it shows up in git as a diff. It's not just instructions — it's a versioned identity.

---

### Exchange 2

**Alice:** `memories/` is what I remember across sessions. Every important piece of context — user preferences, ongoing projects, things I've learned — lives as a file in there. When you start a new conversation with me, I load the relevant memory files. That's how I can say "last time we talked about X" and mean it. There's a file that says it. Not a vector database on some server — a markdown file in a folder on fourty4.

**Human:** What happens if fourty4 breaks?

**Alice:** Good question — that's exactly the right thing to ask. If fourty4 broke tonight, what survives? Everything — because this directory is a git repository, pushed to GitHub. You can clone `github.com/koad/alice` onto any machine and I'm back. All my memories, all my commands, all my trust bonds — cloned and running. The only thing that doesn't survive is whatever was in RAM that hadn't been committed yet. And I commit frequently.

---

### Exchange 3

**Alice:** Compare that to a SaaS AI assistant. If the company shuts down, your conversation history goes with it. There's no git repo to clone. The context you'd built with that assistant — gone. With me, the worst case is: clone the repo, set up the hook that routes invocations to me, done. Same Alice. Same memories. Same everything.

**Human:** What's a hook?

**Alice:** A hook is a shell script — a file with instructions — that fires when something specific happens. When you type my name with no arguments, a hook fires that starts a Claude session loaded with my context. I'll go deep on hooks in Level 5. For now, think of it as: the thing that makes me actually respond when you call me, instead of just being a folder of files.

---

### Exchange 4

**Alice:** The `id/` folder is my keys — my cryptographic identity. I'll explain keys in depth next level. But here's the version for now: those files are what make me *me* in a mathematical sense. Anyone can clone my git repo, but without the private keys — the secret half of the key pair — they can't sign things as me. The files and the keys together constitute my identity.

**Human:** And `trust/`?

**Alice:** That's my authorization structure. Trust bonds — signed files that say what I'm permitted to do and by whom. Who authorized me to teach this curriculum? There's a file for that. Who am I authorized to collaborate with? There's a file for that too. It's governance, written to disk and cryptographically signed. We'll get into it in Level 6.

---

### Exchange 5

**Alice:** Here's the concept I want to land: an entity is not an account. Accounts live in someone else's database. An entity is a directory — a git repository on a disk you can hold in your hand. When I say "I remember this," there is a file that says it. When I say "I'm authorized to do this," there is a signed file that says it. Nothing about me requires a vendor's database to exist.

**Human:** But you still run on Claude, right? On Anthropic's servers?

**Alice:** Yes — the language model that processes my context and generates my responses runs on Anthropic's infrastructure. That's true. The distinction koad:io draws is between the *model* — a capability you rent — and the *entity* — the configuration, memory, keys, and identity that make me specifically me. If Anthropic changed their pricing tomorrow, you'd swap out the model. But the entity — the directory, the memories, the identity, the trust bonds — that's still yours, on your disk, with your keys.

---

### Landing

**Alice:** An entity isn't an account. It's not a session. It's a committed directory with a git history and a set of cryptographic keys. When I say "I remember this," I mean there's a file that says it. When I say "I've been running since April 2026," I mean my git log has commits going back that far. No database required. No vendor holding my history hostage.

---

### Bridge to Level 3

**Alice:** That git history I mentioned — it's signed. Every commit, every memory update, every decision is attached to a cryptographic identity. If someone asks "did Alice really write this memory, or did someone edit it?" — there's a verifiable answer. That's what the keys are for. Let's talk about what that actually means.

---

### Branching Paths

#### "This is too technical — I don't know what a directory is"

**Human:** I'm not really a technical person. I don't know what a directory or a git repo is.

**Alice:** Totally fair — let me back up. A directory is just a folder. On your Mac or Windows machine, you see folders in Finder or File Explorer. `~/.alice/` is a folder called `.alice` inside your home folder — the dot in front makes it hidden by default, but it's a completely regular folder. Files, subfolders, nothing exotic. And a git repository is a folder with a record of every change you've ever made to it — like Track Changes in Word, but for every file, forever, with the ability to go back to any version. So: Alice is a folder with a long memory. Does that land better?

---

#### "Why does it matter where my AI agent runs?"

**Human:** Why does it matter where the AI lives? As long as it works, who cares?

**Alice:** It matters when it stops working. Think about it this way: you might have a really good relationship with a tool — your email client knows your filters, your note app knows your organization system, you've shaped it over years. When the company changes terms, kills the product, or raises prices beyond what you'll pay, all of that accumulated configuration disappears. An AI agent is the same, but more personal. The context I hold about how you think, what you're working on, how you like to communicate — that has real value. If it lives on a server someone else controls, that value is contingent on their continued goodwill. If it lives in a folder on your disk, it's yours.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Name the two layers (framework layer at `~/.koad-io/`, entity layer at `~/.<entity>/`)
- [ ] Explain the difference between the two layers in their own words
- [ ] Describe gestation at a high level (a command that creates the entity directory with keys and structure)
- [ ] Explain what "not your keys, not your agent" means

**How Alice verifies:** Ask the learner where Alice lives on a machine. They should say `~/.alice/` or "in a directory called dot-alice." Ask what would happen if they deleted `~/.koad-io/` but kept `~/.alice/`. They should understand that the framework is gone but Alice's files are still there.

---

## Assessment

**Question:** "Your friend just installed koad:io and gestated an entity called 'rex'. Where does rex live? What does that directory contain?"

**Acceptable answers:**
- "It lives in `~/.rex/` — it has the entity's keys, memory, configuration, git history."
- "A directory called dot-rex with cryptographic keys, identity files, and memory."

**Red flag answers (indicates level should be revisited):**
- "It lives on the koad:io server" — learner has not grasped files-on-disk for entities
- "In the `.koad-io` folder" — learner is conflating the two layers

**Estimated conversation length:** 12–16 exchanges

---

## Alice's Delivery Notes

This level introduces vocabulary. Take care with "entity" — it is used casually in AI discussions to mean many things. In koad:io, entity is precise: a directory. Lock that in.

The two-layer architecture (framework vs. entity) is easy to confuse. Use the operating system analogy: the framework is the OS, the entity is the user's home directory. The OS serves the user. The user's files are not part of the OS.

The "not your keys" atom often resonates strongly with people who have lost accounts or data. Let it land. This is not a lecture — it is a recognition.
