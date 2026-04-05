---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 0
slug: before-the-session
title: "Before the Session — Environment Check"
status: available
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete: []
estimated_minutes: 20
atom_count: 4
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 0: Before the Session — Environment Check

## Learning Objective

After completing this level, the operator will be able to:
> Walk through the pre-session checklist from memory — verify identity and location, pull the entity directory, confirm the framework is present — and explain why each step is a gate, not a formality.

**Why this matters:** Most new-operator errors happen before the session starts. A stale entity directory, the wrong hostname, a missing framework binary — these don't announce themselves. They produce confusing behavior halfway through a task. The pre-flight sequence is boring until the one time it catches something. After that, it becomes a reflex.

---

## Knowledge Atoms

### Atom 0.1: Why "Ready" Has a Checklist

**Teaches:** What can go wrong before a session begins and why checking manually is the correct posture.

An entity session has dependencies you cannot see from inside it. The session reads from files. It commits to git. It may reach out to other machines. If any of those dependencies are wrong — stale, missing, or pointed at the wrong place — the session will still start. It will just work on bad inputs.

The entity will not say "your entity directory is three commits behind." It will read the stale state and act on it. It will not say "you are on flowbie, not thinker." It will run on whichever machine it finds itself on. It will not say "the framework is outdated." It will use whatever is there.

This means the pre-flight sequence is your responsibility, not the entity's. You are the operator. Checking the environment before you spawn is part of the job — the same way a pilot checks instruments before takeoff, not because instruments usually fail, but because the one time they do, you want to know before you're in the air.

Four checks. Two minutes. Every time.

---

### Atom 0.2: Identity and Location — `whoami` and `hostname`

**Teaches:** Why the first two commands are identity and location, and what to do when they are wrong.

Before anything else:

```bash
whoami
hostname -s
```

These two commands answer: who am I and where am I?

Each entity in koad:io has a home machine and a primary user account. Juno lives on `thinker`. Alice lives on `fourty4`. If you are operating Juno and `hostname -s` returns `flowbie`, stop. You are on the wrong machine. Continuing means the session will run from the wrong environment, with wrong paths, and any commits will land on that machine's local clone.

The correct response to a location mismatch is not to proceed carefully — it is to stop, SSH to the correct machine, and begin there.

`whoami` catches a different error: operating from the wrong user context. Entities on multi-user machines run as specific users. If you are operating as `koad` in a machine where Juno runs as `juno`, path assumptions may break and key access will be wrong.

Neither check takes more than a second. If they pass, continue. If they fail, stop.

---

### Atom 0.3: The Entity Directory — `git pull` Before Every Session

**Teaches:** Why git pull on the entity directory is mandatory before every session, and what "stale state" costs.

The entity directory is a live git repository. Other sessions, other machines, other operators — anyone with push access — may have committed changes since the last time you pulled. Those changes include:

- Updated memory files (what the entity currently knows)
- New task assignments (issues referenced in CLAUDE.md or logs)
- Modified skills or commands
- Changed configuration

If you skip the pull, the session reads old state. It may re-do work already done. It may miss a new constraint. It may commit on top of changes it doesn't know about and produce a merge conflict that another session will have to resolve.

```bash
cd ~/.entityname
git pull
```

This is not optional. It is not "usually fine to skip." Do it every time. The session you're about to start will act on whatever files are in that directory. Make sure they are current.

Also check `git status` after the pull. Uncommitted local changes from a previous session? Review them before starting. Stale working tree edits are another class of "the entity will act on this without knowing it's contested."

---

### Atom 0.4: Framework Check — Is `~/.koad-io/` Present and Current?

**Teaches:** What the framework layer provides and how to verify it is in a usable state before invoking an entity.

The framework layer at `~/.koad-io/` provides the commands that make entity invocation work: the `juno`, `vulcan`, `alice` binaries in `~/.koad-io/bin/`, the hook scripts in `~/.koad-io/hooks/`, the global commands in `~/.koad-io/commands/`.

If the framework is missing, outdated, or broken, entity invocation fails — sometimes silently. The entity binary in your PATH is a symlink or wrapper that depends on the framework being present.

Quick checks:

```bash
ls ~/.koad-io/               # framework directory exists
ls ~/.koad-io/bin/           # entity binaries present
cat ~/.koad-io/KOAD_IO_VERSION   # version recorded
```

If you are on a machine you have not used recently:

```bash
cd ~/.koad-io && git pull    # pull framework updates
```

Framework issues are less common than entity directory issues, but when they occur they are harder to diagnose mid-session. Two seconds now saves fifteen minutes of confusion later.

---

## Dialogue

### Opening

**Alice:** You've completed onboarding — you know what entities are, what trust bonds do, what the two-layer architecture looks like. Now we're going to make things actual. The first thing we're going to cover isn't how to spawn an entity. It's what to check before you do.

This might feel like we're stalling before the good part. We're not. Every operator error I've seen in the first week comes back to skipping a pre-session check. So: four checks, two minutes, then you spawn. Let's go through each one.

---

### Exchange 1

**Alice:** Two commands. Before anything else, every time:

```bash
whoami
hostname -s
```

These tell you who you are and where you are. In the koad:io system, those two things are not ambient facts — they are specific, intentional, and load-bearing. Juno lives on `thinker`. Alice lives on `fourty4`. If you run Juno from `flowbie`, you're running Juno somewhere Juno doesn't live. Paths break. Keys may not be present. Commits land in the wrong clone.

When do you stop? If either answer is wrong for the entity you're about to run — stop there. SSH to the correct machine. Start over.

**Human:** What do I do if I'm on the wrong machine?

**Alice:** Exit. SSH to the right one. The machines in the infrastructure have SSH wrappers in `~/.koad-io/bin/` — `fourty4`, `flowbie`, `thinker`. From any of the three you can reach the others. The correct response to "wrong machine" is never "proceed carefully." It's "go to the right machine."

---

### Exchange 2

**Alice:** Next: the entity directory.

```bash
cd ~/.entityname
git pull
git status
```

The entity directory is a live repo. Memory files, task state, configuration — these change between sessions. If you skip the pull, you're running the entity on stale state. The entity won't notice. It will just act on whatever files are in front of it.

The `git status` after the pull matters too. If there are uncommitted changes from a previous session — files modified but never staged — they are still there. They will affect the session. Review them before you start.

**Human:** What if git pull shows conflicts?

**Alice:** Resolve them before spawning. A conflict means two sessions diverged on the same file. That's a state you need to understand and reconcile — not hand off to a new session to figure out. Look at what conflicted, decide which version is correct, resolve and commit. Then proceed.

---

### Exchange 3

**Alice:** Last check: the framework.

```bash
ls ~/.koad-io/bin/
cat ~/.koad-io/KOAD_IO_VERSION
```

The entity binaries in your PATH point into `~/.koad-io/`. If the framework is missing or broken, entity invocation fails. This is less common, but if you're on a machine you haven't used in a while — or a machine where the framework was recently updated — pull it:

```bash
cd ~/.koad-io && git pull
```

That's the full pre-flight: identity check, entity pull, framework check. Two minutes. Every session. You're not being paranoid — you're being an operator.

**Human:** This seems like a lot of overhead every time.

**Alice:** It becomes a reflex. You'll run these as one motion — three commands, look at the output, proceed or stop. The first time you catch something — and you will — you'll understand why it's worth it. Usually everything is fine. The value comes from the one time it isn't.

---

### Landing

**Alice:** Here's the frame for this whole curriculum. You are an operator. An operator's job is not just to give the entity tasks — it's to ensure the conditions are right for the entity to do good work. The entity will run whatever environment it finds. Your job is to make sure that environment is correct before the session starts.

The pre-flight is step zero of every session. Not because you don't trust the system — because you understand it well enough to know what it depends on.

Ready to look at identity — how the entity knows who it is?

---

### Bridge to Level 1

**Alice:** So you've checked where you are and that the entity directory is current. But what does the entity itself know about its identity? That lives in `.env` and `.credentials` — two files with very different purposes. Level 1 is about those two files and what they control.

---

### Branching Paths

#### "Can I automate these checks?"

**Human:** Can I put these checks in a script so I don't have to run them manually?

**Alice:** You can, and that is a reasonable thing to build once you've run them manually enough times to trust your script. The reason I'm teaching them as manual steps first is that automation hides the output — you run the script, it passes, you proceed. That's fine when the script is correct. But the value of these checks is partly in *reading* the output. Seeing an unexpected hostname, noticing a conflict, catching a modified file you forgot about. A script that just passes/fails will catch some issues and silently miss others. Build the reflex manually first. Then automate if you want — just keep the output visible.

---

#### "What if I'm working remotely via SSH already?"

**Human:** I'm already SSH'd into the machine — does whoami/hostname still matter?

**Alice:** Yes, maybe more so. When you're SSH'd in, it's easy to lose track of which session is which, especially if you have multiple terminals open. `whoami` and `hostname -s` are how you confirm which shell is which before you do something consequential. Run them. Look at the output. Confirm it's what you think it is. Then proceed.

---

## Exit Criteria

The operator has completed this level when they can:
- [ ] List the four pre-session checks in order (identity, location, entity pull, framework check)
- [ ] Explain what each check is looking for and what the correct response to failure is
- [ ] State why the entity will not warn you about stale state or wrong location
- [ ] Have run the pre-flight sequence on at least one actual entity directory

**How Alice verifies:** Ask the operator: "Walk me through what you check before spawning a session, and why each step is there." The answer should demonstrate understanding of consequence — not just the commands, but what breaks if you skip them.

---

## Assessment

**Question:** "You open a terminal and you're about to spawn a Juno session to work on a task. What do you check first, and what would make you stop before spawning?"

**Acceptable answers:**
- "I check whoami and hostname — if I'm not on thinker, I stop and go there."
- "I pull the entity directory. If git pull shows conflicts, I resolve them first."
- "I look at git status after the pull — I don't want to start a session with uncommitted work I don't understand."

**Red flag answers (indicates level should be revisited):**
- "I just spawn and see what happens" — operator has not internalized the pre-flight
- "The entity would tell me if something was wrong" — incorrect; entity acts on whatever state it finds
- Inability to say what each check is for beyond "good practice"

**Estimated conversation length:** 6–10 exchanges

---

## Alice's Delivery Notes

This audience has completed alice-onboarding. Do not re-explain what entities are, what trust bonds are, or why sovereignty matters. They know. Treat them as someone who has the conceptual model and is now learning the operational practice.

The emotional register here is: *you are an operator now, and operators have checklists.* Not bureaucratic overhead — professional practice. The analogy to pilot pre-flight is useful. The value is in the one catch, not the ninety-nine passes.

Do not let the learner skip the exercise of actually running the checks on a real entity directory. This level is hands-on. Conceptual understanding is not enough — the learner should open a terminal and do it.

If the learner pushes back on the overhead, validate the feeling ("it does become a reflex") while holding the line ("run it anyway, at least until it has caught something for you"). Don't negotiate down to "skip it sometimes" — the whole point is consistency.
