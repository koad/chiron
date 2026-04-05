---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 3
slug: git-initialization-and-github
title: "Git Initialization and GitHub Setup"
status: authored
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-02
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 3: Git Initialization and GitHub Setup

## Learning Objective

After completing this level, the operator will be able to:
> Initialize the gestated entity directory as a git repository, create the GitHub repo, connect the remote, make the first commit with correct authorship, and push — so the entity's history begins with a clean, attributed record.

**Why this matters:** The entity directory is not a git repo at gestation time — the gestation script creates the files but does not run `git init`. The operator must do this, and must do it after configuring `.env`, so that the very first commit is attributed correctly. A misattributed first commit is cosmetically fixable but operationally embarrassing: it is the entity's birth record.

---

## Knowledge Atoms

## Atom 3.1: Why the Gestation Script Does Not Run `git init`

The gestation script creates directories and files. It does not initialize a git repository. This is a deliberate design decision, and understanding it prevents a common mistake.

If `git init` ran during gestation, the first commit would need to run immediately after — otherwise the working tree is in a half-initialized state that confuses subsequent commands. But the first commit requires a configured identity in `.env`, which the gestation script deliberately leaves incomplete. Running `git init` before `.env` is configured would mean the first commit either fails (no identity set) or uses the wrong identity (system git config instead of entity identity).

The sequence is:
1. Gestate — creates files, generates keys
2. Configure `.env` — sets identity, authorship, harness
3. Initialize git — `git init` inside the entity directory
4. Create GitHub repo and add remote
5. First commit — attributed correctly because `.env` is already configured
6. Push

Steps 3-6 cannot safely precede step 2. The gestation script handles step 1 only. The operator owns steps 2-6. This separation is explicit and load-bearing.

This also means that a gestated entity directory is not automatically tracked anywhere. Its files exist on disk. If the machine fails before `git init` and the first push, the entity exists only locally. The operator is responsible for getting the entity into git and onto GitHub promptly after gestation.

**What you can do now:**
- Confirm that `~/.juno/` is a git repo by running `git -C ~/.juno status` — it returns output rather than an error
- Confirm that `~/.juno/` has a `~/.juno/.git/` directory, which is the git repository metadata
- State what would happen if you ran `git commit` inside a freshly gestated entity directory before running `git init` (it would fail: not a git repository)

**Exit criterion for this atom:** The operator can explain why the gestation script omits `git init`, state the correct sequence (gestate → configure → init → create remote → commit → push), and confirm that a freshly gestated directory has no `.git/` directory.

---

## Atom 3.2: `git init` and Local Git Configuration

Initializing git in the entity directory is a single command run from inside that directory:

```bash
cd ~/.entityname
git init
```

This creates the `.git/` directory and initializes an empty git repository. The default branch name depends on the system git configuration — on most current systems, `git init` creates a `main` branch. Verify with `git branch` after initialization. If the branch is named `master`, rename it to `main` for consistency with koad:io conventions:

```bash
git branch -m main
```

After `git init`, set local git configuration scoped to the entity directory:

```bash
git config user.name "Nova"
git config user.email "nova@kingofalldata.com"
```

This records the identity directly in `.git/config`, separate from — but consistent with — the `GIT_AUTHOR_NAME` in `.env`. The two sources reinforce each other. `GIT_AUTHOR_NAME` in the environment takes precedence at runtime, but the local git config is a useful fallback and appears in `git config --list --local` for inspection.

Note: Do not use `git config --global` for entity identity. Global git config applies to all git operations for the user account, not just this entity's directory. Entity git identity must be scoped locally so that operating in the entity's directory uses the entity's authorship, and operating in other directories uses whatever identity is appropriate there.

After `git init` and config, verify the configuration:

```bash
git config --list --local | grep user
```

This should show exactly the name and email you set.

**What you can do now:**
- Verify `~/.juno/.git/config` contains a `[user]` section with Juno's name and email (`cat ~/.juno/.git/config`)
- Explain why `git config --global` would be wrong here (it would affect all git operations for the koad user account)
- State the branch name convention for koad:io entity repos (main, not master)

**Exit criterion for this atom:** The operator can run the complete local git initialization sequence from memory: `git init`, `git branch -m main`, and `git config user.name` / `git config user.email` scoped locally.

---

## Atom 3.3: Creating the GitHub Repository

The GitHub repository for an entity is its public identity on the internet. Creating it requires the `gh` CLI, which must be authenticated to GitHub for the correct account.

The naming convention for entity repositories is `koad/<entityname>` — the organization or user account that owns the entity repos, followed by the entity name in lowercase. For team entities: `koad/juno`, `koad/vulcan`, `koad/veritas`. For an operator gestating their own entity outside the koad team: `<their-github-username>/<entityname>`.

Create the repository with:

```bash
gh repo create koad/nova --public --description "Nova — <one-line description>"
```

The `--public` flag is the correct default for team entities. Entities are products — their public repo is cloneable by anyone who wants to run the entity. A private entity repo defeats the sovereignty proposition: if the entity's configuration and identity are locked behind a private repo, cloning and running it independently is not possible.

After creating the repo, add the remote to the local git repository:

```bash
git remote add origin git@github.com:koad/nova.git
```

Verify the remote is configured correctly:

```bash
git remote -v
```

This should show `origin` pointing to `git@github.com:koad/nova.git` for both fetch and push.

Note: `gh repo create` can also be run with `--source .` to create the repo and add the remote in one step. Either approach is valid. The manual `git remote add` approach makes the operation explicit and is easier to verify.

**What you can do now:**
- Read `~/.juno/.git/config` and confirm the `[remote "origin"]` section points to `git@github.com:koad/juno.git`
- Explain why team entity repos are public rather than private
- State the `gh repo create` command you would run for an entity named `veritas` owned by the `koad` organization

**Exit criterion for this atom:** The operator can state the naming convention, run the `gh repo create` command with the correct flags, and verify the remote is configured correctly with `git remote -v`.

---

## Atom 3.4: The First Commit — Staging, Message, and Verification

The first commit is the entity's public birth record. It should be clean: correct authorship, correct content (no private keys), and a conventional commit message.

Before staging anything, run the final pre-commit verification:

```bash
cd ~/.entityname
git var GIT_AUTHOR_IDENT
```

Confirm the output shows the correct name and email. If it shows your personal git identity, stop — fix `.env` before proceeding.

Stage the files:

```bash
git add .gitignore KOAD_IO_VERSION .env id/ ssl/
```

Do not use `git add .` or `git add -A` without checking what would be staged. The `.gitignore` should already protect private keys from appearing in `git status`, but verifying before adding is the correct habit. Run `git status` after staging and before committing:

```bash
git status
```

The staged files should be: `.gitignore`, `KOAD_IO_VERSION`, `.env`, the public key files in `id/` (`.pub` files and `gpg-revocation.asc`), and the public ssl files (`master-curve-parameters.pem`, `dhparam-2048.pem`, `dhparam-4096.pem`). No file without `.pub` from `id/` should appear. No `.pem` file from the private set should appear.

Run the additional check:

```bash
git diff --cached --name-only | grep -E "^id/[^.]|ssl/(master|device|relay|session)-curve|ssl/session"
```

This should return nothing. Any output means a private key file is staged — unstage it immediately with `git reset HEAD <file>`.

Commit with the conventional first-commit message:

```bash
git commit -m "gestation: initial entity scaffold"
```

After committing, verify authorship:

```bash
git log --pretty=format:"%an <%ae> %H" -1
```

This should show `Nova <nova@kingofalldata.com>` followed by the commit hash. If it shows a different name, the commit is misattributed. Fix `.env`, then amend: `git commit --amend --reset-author --no-edit` and re-verify.

**What you can do now:**
- Run `git log --pretty=format:"%an <%ae>" -1` in `~/.juno/` and confirm the first commit is attributed to Juno
- Explain the additional private key check (`git diff --cached --name-only | grep`) and when to run it
- State what `git commit --amend --reset-author` does and when it is appropriate to use

**Exit criterion for this atom:** The operator can produce the complete pre-commit verification sequence from memory, state the conventional first-commit message, and verify authorship in the git log after committing.

---

## Atom 3.5: Pushing and Verifying the GitHub Repository

The first push publishes the entity's birth record to GitHub. This is the moment the entity becomes publicly accessible.

```bash
git push -u origin main
```

The `-u` flag sets `origin/main` as the upstream tracking branch for the local `main` branch. After this, `git push` and `git pull` without arguments will use this tracking relationship.

After the push completes, verify the repository on GitHub:

```bash
gh repo view koad/nova --web
```

Or navigate directly to `https://github.com/koad/nova` in a browser.

The verification checklist for the first push:

1. **KOAD_IO_VERSION is visible** — the birth certificate should appear in the repository's file listing. Open it and confirm `NAME=nova`, `GESTATED_BY` shows the correct mother, and `BIRTHDAY` shows the gestation timestamp.

2. **No private keys in the tree** — look at the `id/` directory in the GitHub UI. You should see only `.pub` files and `gpg-revocation.asc`. The four private key files (`ed25519`, `ecdsa`, `rsa`, `dsa`) should not be visible. If any private key file appears in the GitHub repo, treat it as a security incident: the key is compromised and must be regenerated.

3. **Correct authorship on the first commit** — click the commit in the GitHub UI and verify the author attribution shows the entity's name and email, not the operator's personal GitHub identity.

4. **`.env` is visible** — confirm the `.env` file appears in the repo with the identity fields correctly filled in.

5. **`.credentials` is not present** — confirm there is no `.credentials` file visible in the GitHub UI. Its absence confirms the gitignore is working correctly.

If any of these checks fail, the appropriate response depends on what failed. A missing file can be added and re-pushed. A misattributed commit should be amended before pushing further history. A private key in the repo requires treating the key as compromised, regenerating it, and reviewing the gitignore configuration.

After passing all five checks, the entity is publicly accessible and its history has begun correctly.

**What you can do now:**
- Open `https://github.com/koad/juno` and perform the five-point verification against Juno's live repository
- Confirm no private keys appear in Juno's `id/` directory on GitHub
- State what action to take if a private key file appears in the GitHub repo after a push (key is compromised — regenerate; do not just delete the file from the repo, because it is already in git history)

**Exit criterion for this atom:** The operator can perform the five-point GitHub verification checklist from memory and state the appropriate response to each possible failure.

---

## Exit Criterion

The operator can:
- Explain why `git init` is not part of the gestation script and state the correct sequence
- Run the complete local initialization sequence: `git init`, branch rename, local config
- Create a GitHub repo with `gh repo create` using the correct flags and naming convention
- Perform the pre-commit verification and stage files correctly
- Push with `-u` and run the five-point post-push verification checklist

**Verification question:** "You have gestated `veritas`, configured `.env`, and run `git init`. Before making the first commit, what do you run to confirm the commit will be attributed to Veritas?"

Expected answer: `git var GIT_AUTHOR_IDENT` — this shows the full author identity string git will use, incorporating environment variables from `.env`. Confirm it shows `Veritas <veritas@kingofalldata.com>` or whatever the configured identity is.

---

## Assessment

**Question:** "After pushing Veritas's first commit to GitHub, you open the repository and see a file named `rsa` (no extension) inside the `id/` directory. What does this mean and what do you do?"

**Acceptable answers:**
- "The private RSA key was committed and is now in git history. The gitignore did not protect it — either the gitignore was not written correctly or the file was explicitly staged. The key is compromised: anyone with access to the repository can use it. I must regenerate the RSA key, update any systems that trusted the old key, and review how the gitignore failed."
- "Private key exposure. I treat the key as compromised immediately. Regenerate, re-publish the public key, revoke the old key from any system that has it. Then fix the gitignore and amend or force-push to remove the key from git history — but the key itself must be treated as compromised regardless of history cleanup."

**Red flag answers (indicates level should be revisited):**
- "Delete the file and push again" — the key is already in git history; deleting it from HEAD does not remove it from history, and GitHub has already indexed it
- "It's fine if the repo is private" — private repos can become public; and access controls can fail; a private key should never be in git history

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

The sequence (gestate → configure → init → create remote → commit → push) must be presented as a mandatory order, not a suggested one. Operators who have worked with git before may instinctively reach for `git init` first. The reason to configure `.env` before `git init` is the first commit attribution — and the first commit is permanent.

The five-point GitHub verification checklist is the deliverable of this level. Present it explicitly as a checklist the operator runs every time they push a first commit for a new entity. Make it habitual, not optional. The private key check in particular should be treated as a non-negotiable safety gate.

The private key exposure answer in the assessment is intentionally severe. Operators who have never dealt with key compromise may underestimate it. Make clear: once a private key is in a public git repo, it is compromised. Git history rewriting does not make it safe — it was indexed, it may have been cloned, it was on GitHub's servers. The only safe response is to treat the key as burned and regenerate.

Do not over-teach `gh` CLI flags — the operator has used `gh` in entity-operations and can consult `gh repo create --help`. Focus on the naming convention, the `--public` requirement, and the remote configuration verification.

---

### Bridge to Level 4

The entity is in git, on GitHub, and publicly accessible. Level 4 is about the cryptographic keys that were generated during gestation — what each type is, what it is used for, and why the entity carries four SSH key types rather than one.
