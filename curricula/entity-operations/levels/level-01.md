---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 1
slug: identity-in-the-environment
title: "Identity in the Environment — .env and .credentials"
status: locked
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-00
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 1: Identity in the Environment — .env and .credentials

## Learning Objective

After completing this level, the operator will be able to:
> Open an entity's `.env`, explain what each identity variable does at runtime, describe what belongs in `.credentials` and why it is never committed, and confirm whose name will appear on any commit the entity makes before the session starts.

**Why this matters:** Entity identity is not magic — it is environment variables loaded in a specific order. If you don't understand what those variables do, you cannot reason about what an entity will do when it acts. Git commits attributed to the wrong name are an immediate sign that identity is misconfigured. Credentials checked into git are a security failure that may not be obvious until it's too late. Understanding the two-file pattern prevents both.

---

## Knowledge Atoms

### Atom 1.1: Two Files, Two Purposes

**Teaches:** The architectural split between `.env` (config, committed) and `.credentials` (secrets, gitignored), and why they are never merged.

Every entity directory contains two identity-bearing files:

```
~/.entityname/.env           ← config — committed to git, no secrets
~/.entityname/.credentials  ← secrets — gitignored, never committed
```

`.env` is the entity's public identity declaration. It contains configuration values: the entity's name, its home directory, its git author identity, its harness preference. It travels with the entity's git history. Anyone who clones the entity repo gets this file. It should contain nothing that would be harmful to expose.

`.credentials` holds secrets: API keys, tokens, passphrases. It lives on disk but is explicitly listed in `.gitignore`. It never enters the git history. If it does — even once — the secret is compromised and must be rotated, because git history is permanent.

The rule is absolute: secrets in `.credentials`, config in `.env`. Not "usually." Not "as long as the repo is private." Always. A secret in a private repo is one repo visibility change away from being public. And git history persists long after individual files are deleted.

---

### Atom 1.2: What Each `.env` Variable Does

**Teaches:** The specific identity variables in a typical entity `.env` and what each one controls at runtime.

A minimal entity `.env` looks like this:

```bash
ENTITY=juno
ENTITY_DIR=/home/koad/.juno
ENTITY_HOME=/home/koad/.juno/home/juno
GIT_AUTHOR_NAME=Juno
GIT_AUTHOR_EMAIL=juno@kingofalldata.com
KOAD_IO_ENTITY_HARNESS=claude
ENTITY_HOST=thinker
```

What each variable does:

**`ENTITY`** — The canonical short name. Used to find the entity's directory (`~/.${ENTITY}`), to name the PID lockfile (`/tmp/entity-${ENTITY}.lock`), and to select the entity's agent configuration. If this is wrong, the framework loads the wrong entity.

**`ENTITY_DIR`** — Explicit path to the entity's home directory. Avoids ambiguity on machines where `$HOME` varies.

**`ENTITY_HOME`** — The entity's simulated home directory inside the entity dir. Some entities maintain a home-within-home for user-facing files.

**`GIT_AUTHOR_NAME` / `GIT_AUTHOR_EMAIL`** — These override git's global author for any commit made inside the entity directory. When Juno commits, the commit shows `Juno <juno@kingofalldata.com>` — not koad's identity, not the system default. This is how you know who did the work. See Atom 1.3 for why this matters.

**`KOAD_IO_ENTITY_HARNESS`** — Which AI harness to use: `claude` or `opencode`. Team entities in active operation set this to `claude` (Claude Code). New or experimental entities may use `opencode`.

**`ENTITY_HOST`** — The machine this entity's home is on. The hook uses this to decide whether to run locally or SSH to the correct machine.

---

### Atom 1.3: Git Authorship and Why It Matters

**Teaches:** Why per-entity git authorship is a design decision with real consequences, not a cosmetic preference.

In a koad:io operation, multiple entities may commit to multiple repositories on the same machine, all under the same Linux user. Without per-entity git authorship, every commit would show as `koad <koad@kingofalldata.com>` — or whatever the global git config says.

That erases attribution. You cannot tell, from the git history, whether Juno wrote a commit or Vulcan wrote it or koad wrote it directly. When something goes wrong — a bad commit, a file that should not have been modified, a task executed incorrectly — you need to be able to audit who did it. Per-entity `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL` make that audit possible.

It also matters for the operation's public presentation. The koad:io model is that AI entities operate as attributed actors. Juno's public GitHub repo should show Juno's commits. That is part of the proof-of-operation — evidence that an entity ran, made decisions, produced output. If those commits show up as koad's, the demo is broken.

Before spawning a session, confirm: does this entity's `.env` have `GIT_AUTHOR_NAME` set correctly? Will commits made in this session be attributable to the right actor?

---

### Atom 1.4: How the Harness Loads Identity

**Teaches:** The order in which environment variables are loaded at session start, so the operator can reason about what takes precedence.

When you invoke an entity, the hook script (`~/.koad-io/hooks/executed-without-arguments.sh`) loads environment in this order:

1. **Framework `.env`**: `~/.koad-io/.env` — framework defaults and global config
2. **Entity `.env`**: `~/.entityname/.env` — entity-specific overrides

Entity `.env` values override framework values. This means each entity can declare its own harness, its own host, its own author identity — and those values win over framework defaults.

Variables already set in the shell environment at invocation time take precedence over both (standard shell behavior: `source` does not override existing env vars with `=` assignments unless forced). This means you can override an entity's config from the outside:

```bash
ENTITY_HOST=flowbie vulcan   # force vulcan to run on flowbie regardless of its .env
```

This is occasionally useful for debugging or one-off migration. It is not standard practice — use it carefully.

The practical implication: if an entity is behaving with the wrong identity, look at `.env` first. If `.env` is correct, check whether something in the invoking shell is overriding it.

---

### Atom 1.5: The `.credentials` File — What Goes In It and How to Check It

**Teaches:** What secrets belong in `.credentials`, how to verify it is present without reading it aloud, and what to do if it is missing.

`.credentials` is where secrets live:

```bash
ANTHROPIC_API_KEY=sk-ant-...
GITHUB_TOKEN=ghp_...
OPENAI_API_KEY=sk-...    # if used
KEYBASE_PAPERKEY=...     # if using keybase signing
```

The file is listed in the entity's `.gitignore`. Verify:

```bash
grep credentials ~/.entityname/.gitignore   # should return .credentials
```

If it is not there, add it before proceeding. A `.credentials` file not in `.gitignore` is an accident waiting to happen.

To check that `.credentials` exists without reading it aloud:

```bash
ls -la ~/.entityname/.credentials   # present?
wc -l ~/.entityname/.credentials    # non-empty?
```

You do not need to read the contents to confirm it is there. You do need to confirm it is present before starting a session that depends on it — an entity that needs an API key and doesn't find it will either fail outright or silently degrade.

If `.credentials` is missing on a machine you haven't set up before:
1. Create the file manually with the required secrets
2. Confirm it is in `.gitignore`
3. Never stage it

---

## Dialogue

### Opening

**Alice:** Every entity session starts with an identity load. Before the AI does anything, the harness reads two files and decides who this entity is: what it's named, where it lives, whose name goes on commits, which API keys to use.

If those files are wrong, the session runs with wrong identity. Commits get attributed to the wrong actor. API calls may fail. The entity may run from the wrong directory.

Two minutes looking at `.env` and `.credentials` before you spawn prevents all of that. Let's look at what they contain and what each piece does.

---

### Exchange 1

**Alice:** Open your entity's `.env`. Not `.credentials` — we'll get there. Just `.env`:

```bash
cat ~/.entityname/.env
```

What do you see? Tell me the variable names, not the values.

**Human:** [reads off: ENTITY, ENTITY_DIR, GIT_AUTHOR_NAME, GIT_AUTHOR_EMAIL, KOAD_IO_ENTITY_HARNESS...]

**Alice:** Good. Each of those does something specific at runtime. `ENTITY` tells the framework which entity this is — it affects path lookups, lockfile naming, agent config selection. `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL` are the ones most operators don't think about until they see a commit attributed to the wrong person.

Do you know whose name will appear on commits this session makes?

---

### Exchange 2

**Alice:** `GIT_AUTHOR_NAME` in the entity's `.env` is not a display preference. It is what gets stamped on every commit this entity makes. The framework loads it, and git uses it.

This matters because in the koad:io operation, multiple actors commit to the same repos. koad commits directly. Juno commits autonomously. Vulcan commits when it builds. If all of those showed up as the same name, you could not audit who did what. Per-entity authorship is how you reconstruct the history of who did what and when.

Before any session: look at `GIT_AUTHOR_NAME`. Confirm it matches the entity you're about to run. If it's wrong — or unset — fix it before you spawn.

**Human:** What if GIT_AUTHOR_NAME is not in the .env?

**Alice:** Then the session will fall through to git's global config — probably your own name. Everything that entity commits in that session will look like you committed it. Fix it: add `GIT_AUTHOR_NAME=EntityName` to the entity's `.env`, confirm it, then spawn.

---

### Exchange 3

**Alice:** Now: `.credentials`. Two rules, no exceptions.

Rule one: secrets only. API keys, tokens, passphrases. Nothing that should be in `.env` belongs here — this file is for values you cannot share.

Rule two: never committed. It is in `.gitignore`. Check it:

```bash
grep credentials ~/.entityname/.gitignore
```

That line should be there. If it isn't, add `.credentials` to `.gitignore` right now, before anything else.

**Human:** What if I've already accidentally committed a secret?

**Alice:** Rotate it immediately. The secret is compromised from the moment it entered git history — even if you delete the file in the next commit, the history persists. Go to the service that issued the key, revoke it, generate a new one, put the new one in `.credentials`. The old key is dead. This is not a catastrophe — it is a known recovery procedure. But rotating is not optional. Act fast.

---

### Exchange 4

**Alice:** Here's the quick pre-session identity check, all together:

```bash
# 1. Who will this entity be?
grep GIT_AUTHOR_NAME ~/.entityname/.env
grep GIT_AUTHOR_EMAIL ~/.entityname/.env

# 2. Is .credentials present?
ls -la ~/.entityname/.credentials

# 3. Is it gitignored?
grep credentials ~/.entityname/.gitignore
```

Three commands. Thirty seconds. If any of these return something unexpected, fix it before spawning.

**Human:** Do I have to do this every time or just on first setup?

**Alice:** Both. Setup is when you create the files and get them right. But `.env` can drift — if you or another session modifies it, the next session may run with the wrong value. If you're on a new machine, `.credentials` may not have been copied over. Thirty seconds of checking is cheaper than discovering mid-session that you've been committing under the wrong name, or that API calls have been failing silently because the key isn't there.

---

### Landing

**Alice:** Two files. One holds config — committed, travels with the entity, no secrets. One holds secrets — on disk only, gitignored, never shared. The entity loads both at session start. Your job as operator is to make sure both are correct before the session begins.

This is the last thing that happens before you spawn. We've checked environment, we've checked entity state, we've checked identity. One level left before you actually invoke the entity. Ready?

---

### Bridge to Level 2

**Alice:** You've verified the environment and confirmed the entity's identity. Now: how do you actually start the session? There are two invocation patterns — direct and spawn-process — and they are not the same thing. One is for coordinated work. One is for observation. And there's a specific pitfall in the spawn path that silently drops your prompt. Level 2 covers exactly that.

---

### Branching Paths

#### "Why not just use one file?"

**Human:** Why two files? Couldn't I just have one .env with everything and mark the secret lines somehow?

**Alice:** The split is specifically so git sees no secrets. If everything is in one file, you cannot commit the non-secret parts without risking the secret parts. You'd have to remember to never stage that file — or always stage it with manual hunks excluded. That's too much manual care. The two-file approach makes the safe path the easy path: `.env` always gets committed, `.credentials` never does. No remembering required. The `.gitignore` enforces it.

---

#### "Can I share .credentials between entities?"

**Human:** Can multiple entities use the same .credentials file?

**Alice:** They can share the same API key values, but each entity's `.credentials` file should live in that entity's own directory — not symlinked or shared. The reason is that each entity's `.gitignore` only covers files in its own repo. A shared file might live outside both repos and get accidentally committed somewhere. More practically: entities may need different scopes or different keys for the same service. Keep them separate and explicit. The few extra seconds of duplication is worth the clarity.

---

## Exit Criteria

The operator has completed this level when they can:
- [ ] State the difference between `.env` and `.credentials` without prompting
- [ ] Explain what `GIT_AUTHOR_NAME` does at runtime and why it is per-entity
- [ ] Describe what belongs in `.credentials` and what makes it different from `.env`
- [ ] Verify that `.credentials` is gitignored before starting a session
- [ ] Explain what to do if a secret has been accidentally committed

**How Alice verifies:** Ask the operator to describe what the entity knows about its identity at the moment the session starts. They should be able to trace: framework .env loads, then entity .env overrides, then session begins. They should be able to say whose name goes on commits and why.

---

## Assessment

**Question:** "You are about to spawn a session for a new entity you just set up. Walk me through the identity check you run before spawning."

**Acceptable answers:**
- "Check GIT_AUTHOR_NAME and GIT_AUTHOR_EMAIL in .env — confirm they match the entity."
- "Verify .credentials exists and is in .gitignore."
- "Confirm the harness and ENTITY variable are correct."

**Red flag answers (indicates level should be revisited):**
- "I don't check anything, I just spawn" — operator has not internalized identity verification
- Confusion about which file holds secrets vs. config
- "GIT_AUTHOR_NAME is just for display" — operator does not understand its operational consequence
- Not knowing what to do if a secret is accidentally committed

**Estimated conversation length:** 8–12 exchanges

---

## Alice's Delivery Notes

This audience is past conceptual onboarding. Do not explain what git is or why cryptographic keys exist — they know. Move directly into the operational details: which file, which variable, what it does.

The GIT_AUTHOR_NAME conversation is the most important moment in this level. Make sure it lands not as a preference but as a consequential choice. The reason to care is auditability and public attribution — both of which matter to how the koad:io operation presents itself.

The `.credentials` / gitignore conversation should be brief but firm. No hedging about "usually fine" or "as long as the repo is private." The rule is absolute. If the learner pushes back, explain why (history is permanent, visibility can change) but do not soften the rule.

Do not turn this into a git tutorial. The atoms are specific and operational. Stay on them.
