---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 0
slug: what-gestation-produces
title: "What Gestation Produces — The Anatomy of a New Entity"
status: authored
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete: []
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 0: What Gestation Produces — The Anatomy of a New Entity

## Learning Objective

After completing this level, the operator will be able to:
> Walk through every directory and file that `koad-io gestate` creates, explain why each one exists, and distinguish which files are committed to git versus gitignored from the moment of creation.

**Why this matters:** Operators who run the gestation command without understanding its output cannot evaluate whether it succeeded or reason about what they are configuring in subsequent steps. Understanding the anatomy of a gestated entity is the prerequisite for everything that follows.

---

## Knowledge Atoms

## Atom 0.1: The Entity Directory — A Unix Filesystem in Miniature

The single most important thing to understand about a gestated entity is where it lives and what the layout means. When gestation runs, it creates a single directory at `~/.entityname/` — for an entity named `alice`, that is `~/.alice/`. Everything the entity is, owns, or produces lives inside that one directory. The entity directory is not a config file or a namespace — it is a complete, portable artifact.

The directory structure mirrors a Unix filesystem layout. You will find `bin/`, `etc/`, `lib/`, `man/`, `res/`, `usr/`, `var/`, `proc/`, `home/`, `media/`, and `archive/` alongside entity-specific directories `id/`, `ssl/`, and `keybase/`. This is intentional. The sovereignty analogy is literal: the entity has its own rootfs-like home. It has a place for executables (`bin/`), configuration (`etc/`), libraries (`lib/`), runtime state (`var/`), process files (`proc/`), and personal home space (`home/`). When you understand the Unix filesystem, you understand what goes where in an entity directory.

The entity directory is also a git repository. Its entire history is the entity's fossil record — every configuration decision, every key publication, every document added. This means the entity is portable: clone the repo to another machine and the entity can run there. The git history is not an implementation detail; it is the entity's biography.

**What you can do now:**
- Open `~/.juno/` and identify each directory by its Unix filesystem analogue
- State why the entity directory structure being a git repo is a sovereignty property, not just a version control convenience
- Point to `~/.juno/` as the complete portable artifact and explain what "portable" means operationally

**Exit criterion for this atom:** The operator can describe the entity directory as a self-contained unit with a Unix-inspired layout, name at least five subdirectories by purpose, and explain what portability means for an entity.

---

## Atom 0.2: Core Directories — What Each One Holds

Fifteen directories are created at gestation. Every entity gets all fifteen regardless of what it will eventually do. Here is what each holds:

**`id/`** — Cryptographic identity keys. This is where the entity's SSH keys (ed25519, ecdsa, rsa, dsa — each as a public/private pair) and GPG revocation certificate live. The private key files in `id/` are never committed to git. The public keys (`.pub` files) are committed and published.

**`ssl/`** — Elliptic curve key material for secure communications. Contains `master-curve.pem`, `device-curve.pem`, `relay-curve.pem`, `session.pem`, `master-curve-parameters.pem`, and dhparam placeholders. These are generated with `openssl` at gestation. All `.pem` files in `ssl/` are gitignored — they are private material.

**`keybase/`** — Reserved for Keybase identity material. Gitignored entirely. Human operators use Keybase for trust signing; entity identity connects here.

**`bin/`** — Entity-specific executable scripts and wrappers. This is the entity's private `bin/` directory for commands it defines internally.

**`etc/`** — Configuration files for services the entity runs or depends on. Analogous to `/etc` on a Unix system.

**`lib/`** — Libraries and shared code the entity carries. Not the framework — the entity's own shared assets.

**`man/`** — Manual pages and documentation stubs. Reserved for documentation the entity generates about its own capabilities.

**`res/`** — Resources: data files, static assets, reference material the entity uses.

**`usr/`** — User-space files: anything that doesn't fit a more specific directory. Operator-added content often lands here.

**`var/`** — Runtime variable data: logs, spool files, state that changes during operation. `var/` is gitignored — it is ephemeral.

**`proc/`** — Process and PID files for running services. `proc/` is gitignored — it is runtime state, not configuration.

**`home/`** — The entity's home directory subtree. `home/<entityname>/` is the entity's personal space — analogous to `/home/alice` in the broader system. The `.cache/` subdirectory inside the entity's home is gitignored.

**`media/`** — Media files: images, audio, video the entity references or produces.

**`archive/`** — Historical material, deprecated files, and records the entity keeps but does not actively use. Gitignored by default.

**`keybase/`** — (Covered above.)

**What you can do now:**
- Open `~/.juno/` and locate each of the fifteen directories
- State whether each directory's contents are committed to git or gitignored, and explain the reasoning
- Explain why `var/` and `proc/` are gitignored while `etc/` and `bin/` are committed

**Exit criterion for this atom:** The operator can list all fifteen directories and classify each as committed-by-default or gitignored, with a one-sentence rationale for each class.

---

## Atom 0.3: The Files Created at Gestation — Birth Certificate, Gitignore, and the Minimal .env

Three files are written directly by the gestation script before it does anything else: `.gitignore`, `KOAD_IO_VERSION`, and `.env`. Each one serves a foundational purpose.

**`.gitignore`** is written first, before keys are generated. This is deliberate: the private keys that gestation is about to create must be excluded from git before they exist. The gitignore written by gestation covers all four private SSH key files in `id/` by name (`id/ed25519`, `id/ecdsa`, `id/rsa`, `id/dsa`), all SSL private key material in `ssl/` (the `.pem` files), the runtime directories `proc/` and `var/`, and the entity home cache. Operators who have worked with existing entities like Juno will notice that Juno's `.gitignore` is more comprehensive — that is because it was expanded after gestation. The gestation-written `.gitignore` is the minimum safe floor.

**`KOAD_IO_VERSION`** is the entity's birth certificate. It records four fields: `GESTATED_BY` (the MOTHER entity or `mary` for immaculate conception), `GESTATE_VERSION` (the git short hash of `~/.koad-io/` at the moment of gestation), `BIRTHDAY` (timestamp in `YY:MM:DD:HH:MM:SS` format), and `NAME`. Juno's birth certificate shows `GESTATED_BY=mary`, `GESTATE_VERSION=1854ba3`, `BIRTHDAY=26:03:30:22:05:44`, `NAME=juno`. This file is committed to git. It is the first thing anyone reading the entity's repo sees about its origins.

**`.env`** is written as a minimal two-line skeleton: `KOAD_IO_BIND_IP=127.0.0.1` and `METEOR_PACKAGE_DIRS=$HOME/.koad-io/packages`. That is all. The gestation script deliberately writes no more — the rest of the identity fields (entity name, git authorship, harness selection) must be added by the operator. This is not an oversight. An entity that ships with hard-coded identity fields for the wrong entity name is worse than one that ships with an incomplete `.env`. Level 2 covers the full `.env` configuration.

**What you can do now:**
- Read `~/.juno/KOAD_IO_VERSION` and interpret each field
- Read `~/.juno/.gitignore` and identify which section protects private keys vs. which protects runtime files
- Describe what a fresh `.env` contains after gestation (two lines) and what is missing

**Exit criterion for this atom:** The operator can read `KOAD_IO_VERSION` and correctly state what each field records, explain why `.gitignore` is written before key generation, and recite the two fields in the minimal `.env` from memory.

---

## Atom 0.4: The Entity Wrapper Command — How the Entity Gets Its Name in the Shell

Gestation creates one file outside the entity directory: a wrapper script at `~/.koad-io/bin/<entityname>`. For an entity named `alice`, this file is `~/.koad-io/bin/alice`. This is what makes the entity's name a shell command.

The wrapper script is four lines:

```bash
#!/usr/bin/env bash

export ENTITY="alice"
koad-io "$@";
```

It sets `ENTITY` to the entity's name, then passes all arguments to `koad-io`. From that point on, every `koad-io` command knows which entity is active because `ENTITY` is set in the environment. When you run `alice test`, the wrapper fires, sets `ENTITY=alice`, and calls `koad-io test`. When you run `alice gestate nova`, the wrapper fires, sets `ENTITY=alice`, and calls `koad-io gestate nova` — which the gestation command reads as `MOTHER=alice` because `ENTITY` is set when it runs.

The wrapper is made executable with `chmod +x` during gestation. It is placed in `~/.koad-io/bin/`, which is on the `$PATH` as part of the koad:io framework installation. This means the entity name becomes available as a command immediately after gestation, without any further shell configuration.

This indirection is the command discovery system. It is why all entity commands live under `koad-io` and why the entity name is not a separate program — it is a named entry point into the same framework runtime, with identity pre-loaded.

**What you can do now:**
- Read `~/.koad-io/bin/juno` and identify what the wrapper sets and what it delegates to
- Explain why running `juno gestate nova` sets MOTHER=juno in the gestation script
- Describe what would happen if the wrapper file were deleted (the entity name would no longer be a shell command, but the entity directory and all its content would be unaffected)

**Exit criterion for this atom:** The operator can read any entity wrapper, explain what it does in two sentences, and trace the ENTITY environment variable from wrapper invocation through to gestation's MOTHER detection.

---

## Atom 0.5: What Is and Is Not in a Fresh Gestation — The Anatomy Checklist

After gestation completes, the entity directory contains exactly the following committed material:

```
~/.entityname/
├── .gitignore          ← committed; protects private keys and runtime dirs
├── KOAD_IO_VERSION     ← committed; birth certificate
├── .env                ← committed; minimal skeleton (2 lines)
├── id/
│   ├── ed25519.pub     ← committed; Ed25519 public key
│   ├── ecdsa.pub       ← committed; ECDSA public key (521-bit)
│   ├── rsa.pub         ← committed; RSA public key (4096-bit)
│   ├── dsa.pub         ← committed; DSA public key
│   └── gpg-revocation.asc  ← committed; pre-generated GPG revocation cert
└── ssl/
    ├── master-curve-parameters.pem  ← committed; curve parameters (public)
    ├── dhparam-2048.pem             ← committed; placeholder or generated
    └── dhparam-4096.pem             ← committed; placeholder or generated
```

The following are gitignored from the moment of creation:

```
id/ed25519         ← private SSH key
id/ecdsa           ← private SSH key
id/rsa             ← private SSH key
id/dsa             ← private SSH key
ssl/master-curve.pem
ssl/device-curve.pem
ssl/relay-curve.pem
ssl/session.pem
proc/
var/
home/<entity>/.cache/
```

Notice what a fresh gestation does NOT contain: no `README.md`, no `commands/`, no `skills/`, no `memories/`, no `CLAUDE.md`. These are added by the operator after gestation — they are the entity's identity and operational content, not its structural skeleton. When you look at Juno's directory and see `GOVERNANCE.md`, `BUSINESS_MODEL.md`, `commands/`, `memories/`, and dozens of other files, you are looking at months of post-gestation work. The gestation script produces the skeleton. The operator builds the entity.

If a MOTHER was specified, the operator inherits more content — `skeletons/`, `packages/`, `commands/`, `recipes/`, `assets/`, `cheats/`, `hooks/`, `docs/`, and the mother's four public keys copied into `id/`. This is gene inheritance: the child entity starts with the mother's capabilities rather than an empty skeleton. Level 1 covers this in detail.

**What you can do now:**
- Run `git log --oneline` in `~/.juno/` and identify the first commit to confirm what was in the initial push
- Open `~/.juno/id/` and verify that no private key files (files without `.pub`) are present in the repo tree (they exist on disk but are gitignored)
- State what a gestated entity does NOT have that a fully operational entity like Juno does have, and explain why the difference is deliberate

**Exit criterion for this atom:** The operator can produce the committed-vs-gitignored checklist from memory, distinguish fresh gestation output from a mature entity's directory, and explain why the gestation script leaves the skeleton incomplete rather than writing a full identity.

---

## Exit Criterion

The operator can:
- Name all fifteen directories created by gestation and classify each as committed or gitignored
- Identify the three files written by the gestation script (`.gitignore`, `KOAD_IO_VERSION`, `.env`) and explain each one's purpose
- Read `KOAD_IO_VERSION` and interpret every field
- Explain the wrapper script at `~/.koad-io/bin/<entity>` and what it does
- Distinguish the skeleton produced by gestation from the mature content of an operational entity like Juno

**Verification question:** "You run `koad-io gestate nova`. The command completes. What is in `~/.nova/id/` that is committed to git, and what is there that is gitignored?"

Expected answer: Committed — the four `.pub` files (ed25519.pub, ecdsa.pub, rsa.pub, dsa.pub) and the gpg-revocation.asc. Gitignored — the four private key files (ed25519, ecdsa, rsa, dsa) with no extension.

---

## Assessment

**Question:** "A colleague looks in `~/.nova/` right after gestation and says 'the .env is almost empty — only two lines. Did something go wrong?' How do you respond?"

**Acceptable answers:**
- "No, that's correct. The gestation script intentionally writes only `KOAD_IO_BIND_IP` and `METEOR_PACKAGE_DIRS`. All identity fields — entity name, git authorship, harness — are added by the operator in the next step."
- "That's the expected minimal .env. The script doesn't write identity fields because they vary by entity and by the operator's intent. You configure them before the first git operation."

**Red flag answers (indicates level should be revisited):**
- "Something went wrong — rerun gestation" — misunderstands the intentional minimal .env
- "You can skip .env configuration if the defaults are fine" — no defaults exist for identity fields; there is nothing to fall back to

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

The operator completing this level has worked with existing entities — they have navigated Juno's directory, assigned tasks, committed work. They know what a mature entity directory looks like. The gap is that they have never seen a freshly gestated one.

The core learning here is the difference between the skeleton and the entity. Lead with a comparison: show Juno's directory (dozens of files, months of work) alongside the checklist of what gestation actually produces (fifteen empty directories, three files, eight public key files). That contrast lands the lesson better than any description.

The wrapper script at `~/.koad-io/bin/<entity>` surprises operators who assumed entities were programs. Make sure they understand that the entity name is a shell alias into the koad:io runtime, not a standalone binary. This has practical consequences: deleting the wrapper breaks the shortcut, but the entity itself is untouched.

Do not dive into key cryptography here — that belongs to Level 4. This level is purely anatomical: what files exist, where they are, what each is for, what is committed. Keep it grounded in directory listings and the actual files operators can open and read.

---

### Bridge to Level 1

Now you know what gestation produces. Level 1 is about running the command — the two invocation forms, the MOTHER relationship, the `--full` flag, and interpreting the output as it runs.
