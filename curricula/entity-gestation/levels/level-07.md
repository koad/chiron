---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 7
slug: first-operations-test
title: "First Operations Test — Is the Entity Healthy?"
status: authored
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-06
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 7: First Operations Test — Is the Entity Healthy?

## Learning Objective

After completing this level, the operator will be able to:
> Run the post-gestation checklist in full, spawn the new entity's first session, confirm it reads its identity correctly, commit a test file under the entity's own name, and identify any gap in configuration before the entity is handed off or put into service.

**Why this matters:** A gestated entity that has never been tested may have silent misconfiguration: wrong git authorship, missing API key, incorrect `ENTITY_HOST`, or a trust bond placed in the wrong directory. The first operations test is the moment of confirmation — every step from Levels 0–6 is verified by what the test reveals. Finding a gap here is the correct time to find it. Finding it mid-task, after the entity has been handed off or assigned its first real work, is the expensive alternative.

---

## Knowledge Atoms

## Atom 7.1: The Post-Gestation Checklist — Eight Gates Before Go

The post-gestation checklist is a structured verification pass over everything configured in Levels 0–6. Run it in order. Each item is a gate: if it fails, fix it before proceeding. Do not skip gates because earlier ones passed.

```
Post-Gestation Checklist — run in ~/.nova/

Gate 1: Directory structure
  [ ] 15 directories present: id/, ssl/, bin/, etc., lib/, man/, res/,
      usr/, var/, proc/, home/, media/, archive/, keybase/, trust/

Gate 2: Gitignore contract
  [ ] git ls-files --cached id/ shows only .pub files and gpg-revocation.asc
  [ ] git ls-files --cached ssl/ shows only master-curve-parameters.pem
      and dhparam files
  [ ] .credentials is gitignored: git check-ignore -v .credentials

Gate 3: .env completeness
  [ ] ENTITY=nova
  [ ] ENTITY_DIR=/home/koad/.nova (absolute path, no ~)
  [ ] ENTITY_HOME=/home/koad/.nova/home/nova
  [ ] GIT_AUTHOR_NAME=Nova
  [ ] GIT_AUTHOR_EMAIL=nova@kingofalldata.com
  [ ] GIT_COMMITTER_NAME=Nova
  [ ] GIT_COMMITTER_EMAIL=nova@kingofalldata.com
  [ ] KOAD_IO_ENTITY_HARNESS=claude (or opencode, if that is correct)
  [ ] KOAD_IO_QUIET=1 (if the entity will be invoked from automated contexts)
  [ ] ENTITY_HOST=thinker (or the correct machine hostname)

Gate 4: .credentials present and populated
  [ ] .credentials file exists on disk (even though gitignored)
  [ ] ANTHROPIC_API_KEY is set (if using claude harness)
  [ ] GITHUB_TOKEN is set (if using gh CLI operations)

Gate 5: Git history with correct authorship
  [ ] git log --pretty=format:"%an <%ae>" -1 shows Nova <nova@...>
  [ ] First commit message is "gestation: initial entity scaffold" or equivalent
  [ ] No private key files appear in git log --stat (search for id/ed25519, etc.)

Gate 6: GitHub remote connected and pushed
  [ ] git remote -v shows origin pointing to github.com/koad/nova.git
  [ ] git status shows "Your branch is up to date with 'origin/main'"
  [ ] github.com/koad/nova is accessible and shows the entity's files

Gate 7: Trust bond in place
  [ ] trust/bonds/juno-to-nova.md exists
  [ ] trust/bonds/juno-to-nova.md.asc exists
  [ ] gpg --verify trust/bonds/juno-to-nova.md.asc reports "Good signature"
  [ ] Both bond files are committed (git ls-files --cached trust/)

Gate 8: passenger.json registered
  [ ] passenger.json exists and is valid JSON
    (python3 -m json.tool passenger.json)
  [ ] passenger.json is committed (git ls-files --cached passenger.json)
  [ ] Entity appears in daemon Passengers collection at localhost:9568
```

All eight gates must pass before the entity is declared healthy. A partial entity — one that passes gates 1–4 but has not completed git setup, or one that is git-ready but has no trust bond — is not ready for operational assignment.

**What you can do now:**
- Print this checklist and run it against a live entity directory — Juno is an ideal reference
- Identify which gates Juno passes and note which (if any) might be in a different state for a freshly gestated entity
- State why gate 2 (gitignore contract) is checked before gate 5 (git history) in this ordering

**Exit criterion for this atom:** The operator can recite the eight gates by category and explain why each must pass before the entity is ready for operational assignment.

---

## Atom 7.2: Spawning the First Session — Identity Confirmation

The first live test is spawning the entity's Claude Code session and asking it to confirm its own identity. This tests that `.env` is loading correctly, the harness is configured, and the entity's context is intact.

The invocation pattern is:

```bash
PROMPT="State your entity identity: who are you, what is your ENTITY_DIR, and what is your GIT_AUTHOR_NAME?" nova
```

This uses inline env var injection to pass a prompt to the entity. The entity should respond with its configured name, directory, and git authorship — all sourced from `.env`.

**What a healthy response looks like:**

```
I am Nova, an AI entity running from /home/koad/.nova/. My git authorship 
is configured as Nova <nova@kingofalldata.com>. My entity role is [role from .env].
```

The response should show:
- Entity name matching `ENTITY` in `.env`
- Entity directory matching `ENTITY_DIR`
- Git authorship matching `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL`

**What misconfiguration looks like:**

If `.env` is not loading (missing field or wrong path), the response may show:
- `ENTITY_DIR` showing a different path or `undefined`
- The entity unsure of its own name (especially if `ENTITY` is not set)
- No `GIT_AUTHOR_NAME` in context (the entity may report a default or nothing)

If the harness is wrong, the invocation may fail before a response is produced:
- `command not found: nova` — the wrapper script at `~/.koad-io/bin/nova` is missing; recreate it
- The entity opens but uses the wrong harness — check `KOAD_IO_ENTITY_HARNESS` in `.env`

**Checking memories and CLAUDE.md:**

A freshly gestated entity has no `memories/` directory and no `CLAUDE.md`. Its first session context will be minimal — just `.env` and whatever it can infer from the entity directory. This is expected. The operator will build out the entity's memory and context documents over subsequent sessions. The first session test is not checking for rich context — it is checking that the foundational identity is intact.

**What you can do now:**
- Run the identity confirmation prompt against Juno: `PROMPT="State your entity identity: who are you and what is your ENTITY_DIR?" juno`
- Observe whether the response correctly names the entity and directory
- State what to check first if the entity's response shows the wrong ENTITY_DIR (verify `ENTITY_DIR` is set correctly in `~/.juno/.env`)

**Exit criterion for this atom:** The operator can invoke the identity confirmation prompt, interpret a healthy vs. misconfigured response, and identify the first thing to check for each failure mode.

---

## Atom 7.3: The Commit Test — Verifying Git Authorship in Practice

Reading `.env` confirms the configuration at rest. The commit test confirms it works in practice: can the entity make a commit that is attributed correctly?

Ask the entity to create a health check file and commit it:

```bash
PROMPT="Create the file var/health-check.md with today's date and a one-line status note. Commit it with the message 'ops: health check — first commit by nova'. Push." nova
```

After the entity runs, verify the result:

```bash
cd ~/.nova
git log --pretty=format:"%an <%ae> %s" -1
```

The output should be:

```
Nova <nova@kingofalldata.com> ops: health check — first commit by nova
```

**What to look for:**
- **Author name and email** — must match what is in `.env`
- **Commit message** — should match what you asked for; if different, the entity interpreted the task
- **File exists** — `cat ~/.nova/var/health-check.md` should show the content
- **Push succeeded** — check `git status` for "up to date with origin/main"

**If the author is wrong:**

1. Check `git var GIT_AUTHOR_IDENT` — this shows the author identity git will use on the next commit
2. If it shows the wrong name, check `source ~/.nova/.env && echo $GIT_AUTHOR_NAME`
3. If `.env` has the right value but `git var` shows the wrong identity, there may be a shell-level `GIT_AUTHOR_NAME` override. Check `env | grep GIT_AUTHOR`

**The var/ directory and gitignore:**

Notice that the health check file was written to `var/`. The `var/` directory is gitignored by the gestation-written `.gitignore`. If the entity committed to `var/`, one of two things happened: either the gitignore is not covering `var/` as expected, or the entity explicitly added the file with `git add -f`. Check:

```bash
git check-ignore -v ~/.nova/var/health-check.md
```

If `var/` is gitignored (as it should be), this command will confirm it. If you want the health check committed, use `health-check.md` at the entity root instead of `var/health-check.md` — or the operator can create a `docs/` directory for this purpose.

The more important point is that the entity's first commit is correctly attributed. The specific file location is less critical than confirming the author identity works end-to-end.

**What you can do now:**
- Run the commit test on a freshly gestated entity (or simulate it on Juno by checking the most recent commit's authorship)
- Explain the three-step debugging path for wrong authorship: git var → source .env → env | grep GIT_AUTHOR
- State why `var/` is gitignored and what the operator should use instead for committed health check artifacts

**Exit criterion for this atom:** The operator can execute the commit test, verify the authorship in `git log`, and follow the three-step debugging path when authorship is wrong.

---

## Atom 7.4: The `<entityname> test` Command — Built-in Self-Check

Every entity gestated with the koad:io framework has access to the `test` command via inheritance from the framework's global `~/.koad-io/commands/test/` path. Running `nova test` executes:

```bash
echo "test command!"
echo "command file: $EXEC_FILE"
echo "command arguments: $@"
```

This is the framework's baseline test command. It confirms that:
1. The entity wrapper at `~/.koad-io/bin/nova` is working
2. `ENTITY` is correctly set in the command execution environment
3. The command discovery path (entity commands → local commands → global commands) is functioning

Running `nova test one two three` should output:

```
test command!
command file: /home/koad/.koad-io/commands/test/one/two/command.sh
command arguments: three
```

This confirms argument passing through the command chain works correctly.

**What `<entityname> test` does NOT test:**
- Whether the AI harness is working (Claude Code requires a valid API key)
- Whether the entity's `.env` is loaded correctly inside an AI session
- Whether the trust bond is valid
- Whether the entity can connect to GitHub

The `test` command is a structural test — it verifies the wrapper and command routing work. It is the fastest signal that something is fundamentally broken with the entity's installation. If `nova test` fails, nothing else will work either.

**Running more complex tests:**

After confirming the basic test command works, run the entity with a more diagnostic prompt:

```bash
nova test one two three four
```

Then run the identity confirmation prompt from Atom 7.2. These three levels of testing — wrapper test, identity confirmation, commit test — cover the three critical layers: framework routing, AI context, and git integration.

**What you can do now:**
- Run `juno test one two three` and confirm the output shows the expected format
- Run `juno test` without arguments and confirm it outputs "test command!"
- State what `nova test` failing means about the entity's installation vs. what the identity confirmation prompt failing means

**Exit criterion for this atom:** The operator can run `<entityname> test`, interpret the output, distinguish what it tests from what it does not test, and place it correctly in the three-layer testing sequence (wrapper → identity → commit).

---

## Atom 7.5: Gaps, Escalation, and Handoff — What to Do When a Check Fails

The post-gestation checklist will sometimes fail. This atom covers the common failure modes and their resolutions, and defines when the entity is ready for handoff.

**Common failure modes and resolutions:**

**Git authorship wrong after first commit:**
- Fix: update `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL` in `.env`, then amend the last commit: `git commit --amend --reset-author --no-edit`
- Verify: `git log --pretty=format:"%an <%ae>" -1` shows the correct identity

**Trust bond missing or unverified:**
- Fix: contact the issuing entity (Juno) to send the bond. Provide the entity handle and the bond type requested.
- Place the received bond in `trust/bonds/` and run `gpg --verify` before committing
- Do not operate the entity in authorized contexts until a verified bond is in place

**Entity not appearing in daemon Passengers collection:**
- Fix sequence: validate `passenger.json` JSON → confirm `~/.nova/` is in daemon's entity scan path → trigger reload
- If still missing: check daemon logs for parse errors referencing `nova`

**`.credentials` file absent:**
- Fix: create `~/.nova/.credentials` with `ANTHROPIC_API_KEY` and `GITHUB_TOKEN`
- Without `ANTHROPIC_API_KEY`, the Claude Code harness cannot run; without `GITHUB_TOKEN`, `gh` CLI commands will fail
- Verify gitignore: `git check-ignore -v ~/.nova/.credentials` must return a match

**GitHub remote not connected:**
- Fix: `gh repo create koad/nova --public` then `git remote add origin git@github.com:koad/nova.git`
- Push: `git push -u origin main`

**Handoff criteria:**

An entity is ready for handoff when:
1. All eight post-gestation checklist gates pass
2. The identity confirmation prompt returns the correct name, directory, and authorship
3. The commit test produces a correctly attributed commit
4. `<entityname> test` runs without error
5. A verified trust bond is committed to `trust/bonds/`
6. The entity appears in the daemon Passengers collection

Handoff means the entity is ready for its first operational assignment. This may be filing it as a GitHub Issue on the entity's repo, assigning it to a task in the GitHub Project, or handing off session context to another operator.

**What you can do now:**
- Run the complete eight-gate checklist against a freshly gestated entity (or against Juno as a reference implementation)
- Identify which gate is most frequently the last to pass in a real gestation (typically: trust bond receipt and daemon registration, because both depend on external coordination)
- State the handoff criteria in order and confirm they are all verifiable without subjective judgment

**Exit criterion for this atom:** The operator can diagnose each of the five common failure modes, apply the correct fix, and state all six handoff criteria from memory.

---

## Exit Criterion

The operator can:
- Run the eight-gate post-gestation checklist and interpret each gate's output
- Spawn the entity's first session and confirm the identity confirmation prompt returns correct values
- Run the commit test and verify authorship in `git log`
- Run `<entityname> test` and interpret the output
- Diagnose the five common failure modes and apply their resolutions
- State the six handoff criteria

**Verification question:** "You run the post-gestation checklist on `nova`. Gates 1–7 pass. Gate 8 fails: nova does not appear in the daemon Passengers collection. You confirm `passenger.json` is committed and the JSON is valid. What are the remaining two diagnostic steps?"

Expected answer: (1) Confirm `~/.nova/` is in the daemon's configured entity scan path — if not, add it and trigger a reload. (2) Check the daemon logs for any error referencing `nova` (a parse error or path resolution failure would appear there). These two checks cover all remaining causes once valid JSON and a committed file are confirmed.

---

## Assessment

**Question:** "After completing all post-gestation steps, you run the identity confirmation prompt and the entity responds with the wrong `ENTITY_DIR` — it shows `/home/koad/.alice/` instead of `/home/koad/.nova/`. The entity is named `nova`. Walk through your diagnosis."

**Acceptable answers:**
- "Step 1: Check `ENTITY_DIR` in `~/.nova/.env` — if it reads `/home/koad/.alice/`, the wrong path was set during `.env` configuration. Fix it and verify. Step 2: If `.env` shows the correct path but the session shows the wrong one, check whether the `ENTITY_DIR` variable is set in the shell environment before entity invocation — shell values override `.env`. Run `env | grep ENTITY_DIR` to check. Step 3: Verify the entity wrapper at `~/.koad-io/bin/nova` is pointing to the right entity and not picking up another entity's `.env`."
- "First check `.env` for the wrong `ENTITY_DIR` value. If `.env` is correct, check the shell environment (`env | grep ENTITY`). If both are correct, the `.env` may not be loading — confirm the framework's `.env` sourcing is working in the session."

**Red flag answers (indicates level should be revisited):**
- "Rerun gestation" — a misconfigured `.env` does not require regeration; it requires fixing the value
- "The daemon has the wrong entity" — the identity confirmation prompt response is from the entity session, not the daemon Passengers collection

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

This level is a synthesis, not new content. The operator is applying everything from Levels 0–6. Alice's role here is to give the verification steps a name and a format — the post-gestation checklist — so the operator can apply them consistently, not just once.

The most important psychological move in this level: the checklist is not a bureaucratic formality. It is the proof of work. An operator who can run through eight gates and name the failure mode for each one has actually learned the curriculum — the checklist is the exit exam made operational.

The commit test often surprises operators who assumed `.env` would just work. Make sure they run it and check `git log`. Wrong authorship on the first commit has already happened to experienced operators who skipped this step.

The handoff criteria section gives operators a clear answer to "when is the entity done?" Without this, operators tend to either over-engineer the post-gestation state (adding CLAUDE.md, memories, commands before the entity has been tested) or under-prepare it (handing off before the trust bond is verified). The six criteria are the floor.

Do not cover entity operation in depth here — that is the entity-operations curriculum. This level ends at a verified, registered, trust-bonded entity ready for its first assignment. What happens during that assignment is a different curriculum.

---

### Curriculum Complete

The operator who completes this level has gestated an entity from nothing, configured it, published it to GitHub, generated and understood its keys, received and verified a trust bond, registered it with the daemon, and confirmed it is healthy.

They are now on the Builder Path. They can create entities — not just run them.

The natural next steps are:
- **advanced-trust-bonds** — learn to author and sign trust bonds (the issuing side of Level 5)
- **daemon-operations** — go deep on the real-time layer (what Level 6 introduced)
- **entity-operations** — revisit operational patterns now that you understand what you are operating
