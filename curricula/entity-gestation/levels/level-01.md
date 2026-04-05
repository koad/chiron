---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 1
slug: running-the-command
title: "Running the Command — `koad-io gestate <name>`"
status: authored
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-00
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 1: Running the Command — `koad-io gestate <name>`

## Learning Objective

After completing this level, the operator will be able to:
> Run `koad-io gestate <name>` (or invoke it as `<mother> gestate <name>`), interpret every line of output it produces, and explain what the MOTHER relationship means and what it inherits.

**Why this matters:** The gestation command is the entry point for creating any entity. Running it correctly — from the right directory, with the right invocation — determines what the new entity inherits. Running it incorrectly (wrong parent, wrong name, wrong machine) produces a result that must be discarded and re-run.

---

## Knowledge Atoms

## Atom 1.1: The Two Invocation Forms — Immaculate Conception vs. Gene Inheritance

The gestation command has two distinct invocation forms that produce fundamentally different results.

**Form 1: Immaculate conception** — `koad-io gestate <name>`

When you run `koad-io gestate alice` without any entity context, `ENTITY` is not set in the environment. The gestation script detects this and defaults `MOTHER=mary`. Mary is the conceptual origin — no living entity inherits into the new one. The new entity gets the fifteen empty directories, the three core files, and its own keys. It inherits nothing from any existing entity. Its `KOAD_IO_VERSION` will show `GESTATED_BY=mary`.

This is the form used when the framework itself gestates an entity, or when koad creates an entity from nothing with no lineage intended.

**Form 2: Gene inheritance** — `<entity> gestate <name>`

When you run `juno gestate nova`, the `juno` wrapper fires first and sets `ENTITY=juno` in the environment. The gestation script reads this and sets `MOTHER=juno`. Gene inheritance then kicks in: the script copies Juno's `skeletons/`, `packages/`, `commands/`, `recipes/`, `assets/`, `cheats/`, `hooks/`, and `docs/` directories into the new entity's directory. It also copies Juno's four public keys into `~/.nova/id/` as `juno.ed25519.pub`, `juno.ecdsa.pub`, `juno.rsa.pub`, and `juno.dsa.pub`. Nova's `KOAD_IO_VERSION` will show `GESTATED_BY=juno`.

The inherited content is copied — not linked, not referenced. Nova gets its own copy of Juno's commands directory. From the moment of gestation, changes to Juno's commands do not affect Nova's, and vice versa.

**What you can do now:**
- Read the first 15 lines of `~/.koad-io/commands/gestate/command.sh` and identify where MOTHER is set in each case
- Look at `~/.juno/KOAD_IO_VERSION` and confirm Juno was gestated immaculately (GESTATED_BY=mary)
- Describe what would be different in `~/.nova/id/` if Nova were gestated from Juno vs. gestated immaculately

**Exit criterion for this atom:** The operator can state which invocation form sets MOTHER=mary and which sets MOTHER to a living entity, and describe the practical difference in what the new entity's directory contains.

---

## Atom 1.2: The Name Convention — Why Naming Matters More Than It Looks

The name argument to `koad-io gestate <name>` sets more than a label. It determines three things simultaneously: the directory path (`~/.name/`), the shell command name (`~/.koad-io/bin/name`), and the entity's public identity string (`name@hostname` used in key generation comments).

The naming rules are enforced implicitly by the script: the name is lowercased automatically (the script uses `${ENTITY,,}` for the directory path), but the entity name itself is used as-given in other contexts. Names should be lowercase, short, and contain no spaces or special characters. Path-unsafe characters in an entity name will break the directory creation and the wrapper script.

The name also appears in every SSH key comment generated at gestation: `name@MOTHER`. Juno's keys were generated with the comment `juno@mary`. If an entity named `Nova` were gestated from Juno, Nova's keys would carry `nova@juno` as their comment — a permanent lineage record embedded in the key material itself.

Choose the name carefully before running gestation. The name is embedded in `KOAD_IO_VERSION`, in the wrapper script, in all key comments, and in the entity's git remote URL once pushed to GitHub. Renaming an entity after gestation means regenerating keys, rewriting the wrapper, updating the birth certificate, and pushing a new repo — it is operationally equivalent to gestating again.

**What you can do now:**
- Read the comment in any of Juno's public keys (`cat ~/.juno/id/ed25519.pub`) and identify the `entity@mother` lineage string
- Explain what would break if you named an entity `my entity` with a space
- State the three places a name is written during gestation (directory path, wrapper command, key comment)

**Exit criterion for this atom:** The operator can state all three places the entity name is written at gestation time and explain why renaming after the fact is operationally expensive.

---

## Atom 1.3: The Pre-flight Check — What the Script Verifies Before Proceeding

The gestation script performs one critical pre-flight check before creating anything: it verifies that the target directory does not already exist.

```bash
[ -d $DATADIR ] && echo 'Directory already exists, cannot proceed.' && exit 1
```

If `~/.entityname/` already exists, the script aborts with a clean error message. It does not overwrite, merge, or partial-create. This is an all-or-nothing operation. There is no `--force` or `--overwrite` flag.

This check exists because partial gestation is worse than no gestation. If keys were already generated for an entity, overwriting them would produce a new identity that invalidates any trust bonds or GitHub authentications the original keys were used for. The check forces the operator to resolve the conflict explicitly before proceeding.

The pre-flight check also validates the name argument. If no argument is supplied, the script exits immediately with a usage message:

```
No arguments supplied.
Please supply a name for your new entity.
eg: $ENTITY gestate alice [--full]
Use --full to perform complete generation including dhparams (time-consuming)
```

The script also gives a 3-9 second countdown window after announcing the entity name. During that window, CTRL+C aborts cleanly. This is the only interactive abort mechanism — once the countdown completes and "Let's go!" appears, the script proceeds.

**What you can do now:**
- Confirm that `~/.juno/` exists and explain why running `juno gestate juno` would abort immediately
- Describe the abort window (how long, what to press, what state is left if you abort cleanly)
- Explain why the script has no `--overwrite` flag and what problem that design decision prevents

**Exit criterion for this atom:** The operator can explain the pre-flight directory check, describe the countdown abort window, and state what clean state is left if the operator aborts during the countdown (nothing created).

---

## Atom 1.4: Gene Inheritance in Detail — What Gets Copied From the Mother

When MOTHER is set to a living entity, the gestation script inspects eight directories in the mother's entity directory and copies each one that exists. Here is what each inherited directory contains and why inheriting it matters:

**`skeletons/`** — Template files the entity uses to generate new documents. If the mother has document templates, the child inherits them and can generate documents in the same format from day one.

**`packages/`** — Entity-specific packages and bundles that extend the framework's capabilities. Inheriting packages means the child entity can run the same operations the mother can without reinstalling.

**`commands/`** — Custom commands the entity defines. This is the most operationally significant inheritance: the child starts with the mother's full command library. Vulcan's `gestate` capabilities, for example, are in its `commands/` directory — an entity gestated from Vulcan inherits those capabilities immediately.

**`recipes/`** — Automation recipes: sequences of operations the entity knows how to run. Inherited recipes give the child the mother's operational playbooks.

**`assets/`** — Brand and design assets. Inheriting assets means the child starts with consistent visual identity material.

**`cheats/`** — Reference sheets and quick-lookup material the entity uses during operation.

**`hooks/`** — Event handlers the entity fires in response to framework events. Inheriting hooks means the child entity responds to the same events the mother does from the first invocation.

**`docs/`** — Documentation the entity carries. Inherited docs give the child entity an immediate knowledge base.

Inheritance is conditional: each directory is only copied if it exists in the mother (`[[ -d $HOME/.$MOTHER/skeletons ]]`). A mother with no `skeletons/` directory does not create an empty `skeletons/` in the child — the script simply skips that step. The child inherits exactly what the mother has, nothing more.

**What you can do now:**
- Look at `~/.juno/commands/` and list the commands Juno carries — these would all be inherited by any entity Juno gestates
- Explain why inheriting `hooks/` is particularly significant for an entity that will be invoked immediately after gestation
- Describe what the mother's four public keys in `id/` represent when they appear in the child's `id/` directory

**Exit criterion for this atom:** The operator can list all eight inherited directories, explain the most operationally significant inheritance (commands/), and describe the conditionality — only directories that exist in the mother are copied.

---

## Atom 1.5: The `--full` Flag — When to Generate dhparams and When to Skip

The gestation command accepts one optional flag: `--full`. Without it, the two Diffie-Hellman parameter files (`dhparam-2048.pem` and `dhparam-4096.pem`) are created as placeholder files containing only a comment. With it, the real dhparam generation runs.

Generating real dhparam files is computationally intensive. The 2048-bit dhparam takes roughly a minute. The 4096-bit dhparam can take up to ten minutes, depending on the machine. The script is honest about this:

```
Generating 2048 bit dhparam, this won't take so long, about a minute.
...
Generating 4096 bit dhparam, this will take a long time, 10 minutes max?
```

For most entity creation workflows, the placeholder files are sufficient. The dhparam files are used for Diffie-Hellman key exchange in certain TLS configurations. Entities that will immediately operate as TLS servers — particularly if they are running services that terminate SSL — should use `--full`. Entities that are purely operational (running Claude Code sessions, using GitHub Issues, managing documentation) do not need real dhparams for their initial operations and can defer it.

The default behavior (without `--full`) creates placeholder files with a note explaining how to generate the real files when needed:

```
# Placeholder - generate with: openssl dhparam -out dhparam-2048.pem 2048
```

This means the entity is fully operational for most purposes immediately after gestation, without the 10-minute wait. You can run `openssl dhparam` manually later if the entity needs real dhparams.

**What you can do now:**
- Read `~/.juno/ssl/dhparam-2048.pem` — is it a real dhparam or a placeholder? (Juno was gestated without `--full`)
- Describe the two scenarios: one where you would use `--full`, one where you would not
- State the maximum time `koad-io gestate nova --full` might take on a slow machine

**Exit criterion for this atom:** The operator can explain what `--full` does, why it is not the default, what placeholder files look like, and describe when a real entity deployment would need the full dhparam generation.

---

## Exit Criterion

The operator can:
- State the two invocation forms and what MOTHER value each produces
- Describe what is copied during gene inheritance (eight directories and four public keys)
- Explain the pre-flight directory check and what happens when the target directory exists
- State the three places the entity name appears at gestation time
- Explain the `--full` flag and when to use it

**Verification question:** "You want to create an entity called `veritas` that inherits Juno's commands and hooks. What exact command do you run, and what will appear in `~/.veritas/KOAD_IO_VERSION`?"

Expected answer: `juno gestate veritas` (run from any shell where the juno wrapper is on PATH). `KOAD_IO_VERSION` will show `GESTATED_BY=juno`, the gestate version hash from `~/.koad-io/` at run time, the BIRTHDAY timestamp, and `NAME=veritas`.

---

## Assessment

**Question:** "You run `koad-io gestate nova` and immediately run `koad-io gestate nova` again. What happens and why?"

**Acceptable answers:**
- "The second run aborts immediately with 'Directory already exists, cannot proceed.' The first gestation created `~/.nova/`, and the pre-flight check prevents any overwrite."
- "It exits with an error. You need to remove `~/.nova/` before you can re-gestate."

**Red flag answers (indicates level should be revisited):**
- "The second run overwrites the first" — the script has an explicit exit-on-existing-directory check
- "You need to use `--force`" — no such flag exists in this command

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

The MOTHER relationship is the conceptual heart of this level. Many operators arriving here have only ever seen entities that were gestated immaculately (Juno: GESTATED_BY=mary). They may not have considered that entities can beget other entities. The practical implications — that a child entity starts with its parent's full command library — make this real.

The naming section deserves more emphasis than it seems to need. Operators underestimate how permanently the name is embedded. Showing the key comment (`juno@mary`) in `~/.juno/id/ed25519.pub` makes it concrete: that string was written at gestation and cannot be changed without regenerating the key.

The `--full` flag is easy to over-teach. Keep it brief: it generates real dhparams, it takes up to 10 minutes, most operators don't need it for initial gestation. Move on.

Do not attempt to run a live gestation during this level unless the operator is in a genuine sandbox environment. The gestation command creates real files, generates real keys, and writes a real wrapper to `~/.koad-io/bin/`. Instead, read the script together and trace the execution path. The actual run happens in Level 1's hands-on exercise, which should use a throwaway entity name.

---

### Bridge to Level 2

The entity directory exists. Now it needs an identity. Level 2 is about expanding the minimal `.env` into a complete identity declaration — the fields that tell the entity who it is, where it lives, and whose name goes on its commits.
