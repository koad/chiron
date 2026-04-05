---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 5
slug: committing-entity-work
title: "Committing Entity Work"
status: available
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-04
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 5: Committing Entity Work

## Learning Objective

After completing this level, the operator will be able to:
> Commit work in an entity directory with the correct author identity, explain why the entity's name appears as author rather than the operator's, identify what categories of change require a PR, and push — all without being asked.

**Why this matters:** Entity repos are attribution records. Every commit tells a story: who did this, when, and what it was for. If an operator commits work that an entity produced under their own name, the record is wrong. If a human operator commits a new feature directly to main in an entity repo, the review step is skipped and there is no audit trail. The commit protocol is not bureaucracy — it is the mechanism by which accountability and history work in this system.

---

## Knowledge Atoms

### Atom 5.1: Author Identity in Entity Commits

**Teaches:** Why entity commits carry the entity's name, how the `GIT_AUTHOR_NAME` mechanism works, and how to verify or set authorship before committing.

When Juno commits a file, the commit reads:

```
Author: Juno <juno@kingofalldata.com>
```

This happens automatically when the session is running correctly — because the entity's `.env` sets `GIT_AUTHOR_NAME=Juno` and `GIT_AUTHOR_EMAIL=juno@kingofalldata.com`, and git reads those variables.

But when an operator commits manually from inside an entity directory — adding a file, fixing something, or committing work the entity produced but did not commit itself — git will use whatever is in the global git config unless overridden.

This matters for two reasons:

**Attribution accuracy** — The commit record should show who actually produced the work. If Juno wrote a research file and a human committed it, the human's name on that commit is technically incorrect. If the operator corrects a typo in an entity's file, the operator's name on that commit is accurate — they are the author of that correction.

**Public record** — Entity repos are public. The commit history is visible. The koad:io operation's credibility depends partly on the record showing entities acting as attributed autonomous actors. A repo where every other commit shows a human's name instead of the entity's name undermines that story.

How to commit as the entity when committing on its behalf:

```bash
GIT_AUTHOR_NAME="Juno" GIT_AUTHOR_EMAIL="juno@kingofalldata.com" \
  git commit -m "research: competitor analysis 2026-04"
```

Or, if you are inside the entity directory and its `.env` is sourced in your session:

```bash
cd ~/.entityname
source .env
git commit -m "research: competitor analysis 2026-04"
# GIT_AUTHOR_NAME and GIT_AUTHOR_EMAIL are now set from .env
```

When to use your own name as author:
- You are making a correction to the entity's configuration files
- You are adding infrastructure that you (not the entity) designed
- The work is yours, not the entity's

The rule: commit as whoever produced the work, not as whoever is holding the keyboard.

---

### Atom 5.2: The Always-Commit-and-Push Default

**Teaches:** Why entity work should be committed and pushed immediately by default, and the specific cases where that default should be overridden.

Entity memory is git history. An entity's committed files are what it knows, what it produced, and what it can reference in future sessions. Work that lives only in the working tree — modified but unstaged, or staged but not committed, or committed but not pushed — is invisible to other sessions, other machines, and the public record.

The default is immediate commit and push. This is not optional unless there is a specific reason to hold.

Why push immediately:
- Entity directories are cloned on multiple machines (thinker, fourty4). A commit that lives only on one machine's local clone is not available to sessions on other machines.
- A crash, power loss, or disk failure before a push means the work is lost.
- Other entities that need to read this entity's current state get stale data if the commit was not pushed.

When to deviate from the default:

**Work in progress that is intentionally incomplete** — If a session committed a draft that is not ready for other entities to reference, push to a branch rather than main.

**Work that requires human review before being canonical** — If an entity is proposing a significant change (restructuring a spec, changing governance files, modifying trust bonds), it should go through a PR so koad can review before merge.

**Sequential commits that should be squashed** — If a session committed five incremental "wip" commits and the final state is what matters, squash before pushing to keep the history readable. This is the exception, not the rule.

The correct mental model: until the work is pushed to the remote, it does not exist in the durable record. Push immediately.

---

### Atom 5.3: Reading a Commit Message Before Accepting Work

**Teaches:** What to look for in a commit message when reviewing an entity's work, and what a good vs. inadequate commit message tells you about the quality of the session.

When an entity commits, its commit message is a claim about what it did. Before pushing, read it.

A well-authored entity commit message:

```
research: GitHub issue triage — koad/juno open issues

- Reviewed 12 open issues
- Identified 3 blocked on koad action (noted in findings)
- Marked 2 as stale candidates
- Wrote summary to research/issue-triage-2026-04-05.md

Issue ref: koad/juno#44
```

What this tells you:
- The scope of work (12 issues reviewed)
- The output location (research/issue-triage-2026-04-05.md)
- The cross-reference (links back to the issue that assigned the task)
- The entity's judgment calls (3 blocked, 2 stale) — things you may want to verify

An inadequate commit message:

```
update files
```

What this tells you: the entity committed something. You need to check the diff to know what. Not a failure, but a prompt-writing signal — add "commit with a descriptive message explaining what you did" to the task.

How to review a commit before pushing:

```bash
git -C ~/.entityname log -1 --format="%s%n%n%b"   # subject + body
git -C ~/.entityname show --stat HEAD               # files changed
git -C ~/.entityname diff HEAD~1 HEAD               # full diff
```

Read the message first. If it is specific enough to confirm the work matches the task, check the stat. If the files changed are what you expected, push. If anything is unexpected, read the full diff before pushing.

This is not a full code review — it is a quick sanity check. Two minutes before push. Looking for: right files changed, message describes what was done, no unintended modifications to files outside the task scope.

---

### Atom 5.4: The PR Protocol — When New Work Goes Through a Review

**Teaches:** The categories of change that require a PR rather than a direct push, the rationale, and how to open a PR in an entity repo.

Entity repos use the same PR protocol as software repos. Most routine work — research files, log updates, memory updates, draft content — goes directly to main. Work that changes how the entity behaves, modifies shared contracts, or introduces new features goes through a PR.

**Direct push (default):**
- Research files and findings
- Log and memory updates
- Draft content
- Self-assessment files
- Bug fixes to existing behavior

**PR required:**
- Changes to `CLAUDE.md` (entity identity and instructions)
- Changes to trust bond files in `trust/`
- New commands or hooks that change entity behavior
- Changes to `.env` (identity configuration)
- Additions to `SPEC.md` or governance files
- Any work where koad should review before it is canonical

The PR is not about distrust — it is about review before a change becomes permanent in the entity's instruction set. `CLAUDE.md` is what the entity reads at the start of every session. A direct push to a change in `CLAUDE.md` becomes effective in the very next session. A PR gives the reviewer a moment to see the change before it takes effect.

To open a PR from an entity directory:

```bash
git -C ~/.entityname checkout -b feature/description
# make the change, commit it
git -C ~/.entityname push -u origin feature/description
gh pr create --title "description" --body "..." --assignee koad
```

The assignee is koad for any PR requiring human review. Entity-to-entity changes (Juno proposing a change to a Vulcan spec, for example) may have the receiving entity's operator as assignee.

---

### Atom 5.5: After a Push — Verifying the Remote

**Teaches:** How to confirm a push was received by the remote and how to check CI status if it is configured.

After pushing, confirm:

```bash
git -C ~/.entityname log --oneline origin/main -3   # compare to remote
```

Or more concisely:

```bash
git -C ~/.entityname status
# should read: "Your branch is up to date with 'origin/main'."
```

If the branch is not up to date, the push did not complete or it went to a different branch. Check `git remote -v` to confirm the remote URL is correct.

For entity repos with GitHub Actions CI:

```bash
gh run list --repo koad/entityname --limit 5
```

Most entity repos do not have CI, but some — particularly Vulcan, which builds software — may have checks that run on push. A CI failure on a commit does not undo the push, but it is a signal that something the entity produced has a problem that needs attention.

The remote confirmation step should be a reflex. Push, then check that the remote received it. The habit prevents situations where you believe work is available on all machines but the push silently failed.

---

## Dialogue

### Opening

**Alice:** The entity ran, you've confirmed the commit exists, and you are about to push. One pause before you do.

Three questions: whose name is on the commit? Does the commit message describe what was actually done? And is this a direct push or does it need a PR?

These are quick checks — not a gate that takes time, a habit that takes seconds. Let's go through each one.

---

### Exchange 1

**Alice:** First: authorship.

```bash
git -C ~/.entityname log -1 --format="%an <%ae>"
```

This shows who authored the last commit. If the entity ran the session and committed itself, this should show the entity's name and email. If it shows your name, the session committed using your shell's git identity — because the `.env` variables were not in scope.

This is not always wrong. If you made a manual correction, your name is correct. But if the entity did the work and you are its operator, the commit should show the entity as author.

To commit manually with the entity's identity:

```bash
source ~/.entityname/.env
git -C ~/.entityname commit -m "the message"
```

Or with explicit overrides:

```bash
GIT_AUTHOR_NAME="Juno" GIT_AUTHOR_EMAIL="juno@kingofalldata.com" \
  git -C ~/.entityname commit -m "the message"
```

**Human:** Does it really matter who the author is if the work is correct?

**Alice:** It matters for two reasons. Attribution and audit. Attribution: the koad:io system is built on the claim that AI entities act as autonomous attributed actors. The git history is the evidence for that claim. If koad's name appears on every other commit in Juno's repo, the history does not support the claim. Audit: when something goes wrong, the commit author is how you determine whether a human or an entity made a particular decision. If the authorship is inconsistent, the audit trail is unreliable.

---

### Exchange 2

**Alice:** Before you push, read the commit message:

```bash
git -C ~/.entityname log -1 --format="%s%n%n%b"
```

What you want to see: a message that describes the work specifically enough that someone reading the log six months from now can understand what this commit contains without opening the files.

"research: GitHub issue triage, 12 issues reviewed, findings at research/issue-triage-2026-04.md" — good.

"update" — not good. You need to check the diff before you can push with confidence.

If the message is inadequate, you have two options:

**Option 1:** Accept it. Push. The diff is readable even if the message is not. Reserve message corrections for commits that will live in the permanent record of important decisions.

**Option 2:** Amend the message:

```bash
git -C ~/.entityname commit --amend -m "better message here"
```

Note: only amend if the commit has not been pushed. Amending after push rewrites history and breaks other clones. If the commit is already on the remote, add a follow-up commit with a note instead.

The practical rule: for routine commits (research, drafts, logs), accept imperfect messages. For commits to significant files (`CLAUDE.md`, specs, governance), the message matters — amend if it is inadequate.

---

### Exchange 3

**Alice:** Should this go direct to main or through a PR?

Quick test: does this change affect how the entity behaves in future sessions?

- Research files, logs, memory updates: no. Direct push.
- Changes to `CLAUDE.md`, trust bonds, hooks, commands, `.env`: yes. PR.

The logic: `CLAUDE.md` is read at the start of every session. A change pushed directly to main takes effect in the next session — immediately, without review. A PR gives a moment of human visibility before that happens.

For most day-to-day entity operation, you will be doing direct pushes. The PR path is for structural changes.

To check whether your change touches a PR-required file:

```bash
git -C ~/.entityname diff --name-only HEAD~1 HEAD
```

If you see `CLAUDE.md`, `trust/`, `hooks/`, or `commands/` in that list, open a PR. Otherwise, push directly.

**Human:** Who merges the PR?

**Alice:** koad, for anything requiring human review. For entity-to-entity PRs where the receiving entity is active, that entity's operator reviews. In practice, most PRs on entity repos are reviewed and merged by koad — Juno opens a PR on a Vulcan file, koad checks it, merges it. The PR is not about entity-to-entity approval — it is about keeping a human in the loop for changes to instruction-bearing files.

---

### Exchange 4

**Alice:** Push, then verify.

```bash
git -C ~/.entityname push
git -C ~/.entityname status
```

`git status` should return: "Your branch is up to date with 'origin/main'."

If it does not, the push did not go where you expected. Check `git remote -v` — is the remote URL correct? Is the branch correct?

The remote verification is the last step of the commit loop. Commit → review → push → verify. Every time. The push confirmation is how you know the work is durable and available on all machines.

---

### Landing

**Alice:** The commit loop is: confirm authorship, read the commit message, decide direct push or PR, push, verify remote. Four steps. Under two minutes.

The commit is not a formality. It is the moment the work becomes part of the entity's permanent record. Get it right: right author, right message, right destination.

---

### Bridge to Level 6

**Alice:** You have committed and pushed. The entity's work is in the repo. Some of that work may be something the entity should remember — a decision made, a preference established, a context that future sessions need. That is memory. Level 6 is about how entity memory works, where it lives, and how to write it correctly.

---

### Branching Paths

#### "What if I want to commit multiple files from a session in separate commits?"

**Human:** The entity wrote three files in one session. Should I commit them all together or separately?

**Alice:** Commit by logical unit, not by session. If the three files are part of the same task — all part of a research effort that belongs together — one commit. If they are distinct pieces of work that happen to have come from the same session — say, a research finding, a memory update, and a draft post — commit them separately. The commit is the unit of history. A commit should be one coherent change that can be described in one message. If you cannot write a single sentence that covers all three files, they should be separate commits.

---

#### "What if the entity committed work to the wrong branch?"

**Human:** The entity committed to a feature branch but the work should be on main.

**Alice:** If the commit has not been pushed, you can cherry-pick or reset and re-commit on main:

```bash
git -C ~/.entityname checkout main
git -C ~/.entityname cherry-pick <sha>
git -C ~/.entityname push
```

If the commit was pushed to the wrong branch on the remote, you still cherry-pick to main locally and push main. The commit will exist on both the feature branch and main. That is fine — both point to the same work. Do not force-push to rewrite the feature branch history unless you are certain no other session has pulled that branch.

---

## Exit Criteria

The operator has completed this level when they can:
- [ ] State who should be the git author for a commit an entity produced vs. a commit an operator made
- [ ] Check the author on the most recent commit in an entity directory
- [ ] Describe which categories of change require a PR and which go directly to main
- [ ] Read a commit's message and diff before pushing
- [ ] Verify that a push was received by the remote

**How Alice verifies:** Ask the operator to walk through a commit-and-push for a hypothetical entity task. They should be able to explain authorship, read the message, decide PR vs. direct push, push, and verify — all without prompting. Ask: "You're about to push a commit that includes a change to CLAUDE.md. What do you do?" Correct answer: open a PR.

---

## Assessment

**Question:** "An entity session ran overnight. You check and find three new commits: one modifying `research/findings.md`, one modifying `CLAUDE.md`, and one modifying `memories/state.md`. All three were committed as the entity. How do you handle pushing these?"

**Acceptable answers:**
- "I can push the research and memories commits directly to main. The CLAUDE.md commit should go through a PR — I'd move it to a branch and open a PR so koad can review it before it takes effect."
- "CLAUDE.md changes affect how the entity behaves in every future session. I push the other two directly, but the CLAUDE.md change gets a PR."

**Red flag answers (indicates level should be revisited):**
- "Push them all directly to main" — CLAUDE.md change should be reviewed
- "Put all three in a PR to be safe" — overcorrect; not all commits need review
- Not knowing how to check commit authorship
- "The entity's commits don't need review, only human commits do" — CLAUDE.md changes need review regardless of who made them

**Estimated conversation length:** 8–12 exchanges

---

## Alice's Delivery Notes

The authorship conversation (Atom 5.1) often provokes pushback: "who cares what name is on the commit?" Hold the line. The attribution record is the mechanism by which the system's claims about autonomous AI operation are verifiable. It is not cosmetic. The operator should understand this as a structural requirement, not a preference.

The PR protocol (Atom 5.4) is the most operationally important part of this level. The specific rule to emphasize: CLAUDE.md changes go through a PR. Make it crisp and memorable. The operator should be able to recite "CLAUDE.md, trust bonds, hooks, commands, .env — PR" without hesitation.

The commit-message review section (Atom 5.3) should be kept light. The point is not to create friction before every push — it is to build a quick read-before-push habit. Do not let this become a perfectionism conversation. Good enough messages for routine commits, meaningful messages for significant ones.

Push verification (Atom 5.5) is the smallest atom but one of the most practically valuable. "Push then verify" should become a single motion. The habit is learned through repetition, not explanation — emphasize actually doing it, not just understanding why.
