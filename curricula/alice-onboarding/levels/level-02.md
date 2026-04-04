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
