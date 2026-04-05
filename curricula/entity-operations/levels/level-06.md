---
type: curriculum-level
curriculum_id: b7e2d4f8-3a1c-4b9e-c6d7-5e2f0a1b4c8d
curriculum_slug: entity-operations
level: 6
slug: memory
title: "Memory — What the Entity Remembers"
status: available
prerequisites:
  curriculum_complete:
    - alice-onboarding
  level_complete:
    - entity-operations/level-05
estimated_minutes: 20
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 6: Memory — What the Entity Remembers

## Learning Objective

After completing this level, the operator will be able to:
> Open an entity's `memories/` directory, read MEMORY.md to understand current context, add a new memory entry correctly, commit it, and explain why that memory is now available to future sessions while session-only state is not.

**Why this matters:** Entities do not have persistent conversations. Every session starts from a clean slate with one exception: committed memory files. An operator who does not understand this will repeat themselves constantly — re-briefing the entity on things it should already know, or wondering why an entity "forgot" something it was told two sessions ago. Memory is the mechanism by which an entity builds up operational knowledge over time. Managing it correctly is how you make an entity progressively more capable without starting from scratch every session.

---

## Knowledge Atoms

### Atom 6.1: Two Memory Layers — `memories/` and `~/.claude`

**Teaches:** The structural difference between committed long-term entity memory and session-behavior memory, and what lives in each.

Every koad:io entity has two memory layers with completely different persistence properties:

**Layer 1: `~/.entityname/memories/`** — Long-term entity memory. Files in this directory are committed to the entity's git repo. They travel with the entity across machines, across sessions, and across time. Any session on any machine that has a current clone of the entity repo has access to these files. This is the entity's knowledge base — what it has learned, what decisions have been made, what context is persistent and important.

**Layer 2: `~/.claude/projects/<project>/memory/`** — Session behavior configuration for the Claude Code harness. Files here configure how the harness behaves: auto-memory toggles, session preferences, UI behavior. This layer is not committed to the entity's git repo. It is local to the machine and the harness installation. It does not travel with the entity.

The practical distinction:

| | `memories/` | `~/.claude/` |
|---|---|---|
| Committed to git | Yes | No |
| Available on all machines | Yes (after pull) | No — machine-local |
| Available to all harnesses | Yes | No — harness-specific |
| Read by entity at session start | Yes, by CLAUDE.md instruction | Via harness config |
| Purpose | Operational knowledge, state, decisions | Session/UI behavior |

When you want an entity to remember something across future sessions: write it to `memories/` and commit it. When you want to change how the harness behaves on a specific machine: that lives in `~/.claude/`.

Most operational memory work happens in `memories/`. The `~/.claude/` layer exists but does not require active management for routine operations.

---

### Atom 6.2: MEMORY.md as Index

**Teaches:** What MEMORY.md is, how to read it, and why the index structure is important for context loading rather than ad-hoc file browsing.

`memories/MEMORY.md` is the index to all other memory files. It does not contain the memories — it contains one line per memory file, describing what that file covers. The pattern:

```markdown
# Entity Memory Index

- [identity](001-identity.md) — core identity and role
- [operational preferences](002-operational-preferences.md) — how this entity prefers to work
- [koad profile](user_koad.md) — operator profile, communication preferences
- [current state](project_current_state.md) — active work, blocked items, recent decisions
- [infrastructure](project_infrastructure.md) — machines, access, what lives where
```

Why this matters: at session start, the entity reads `CLAUDE.md`, which typically instructs it to "read memories/MEMORY.md and load the relevant context." The entity reads the index, identifies which files are relevant to the current session, and reads those files. Without an index, the entity would need to read every file in `memories/` or guess which ones matter — both inefficient.

The index is also the human's navigation tool. When you need to understand what an entity currently knows about a topic, you read MEMORY.md first. The one-line description tells you which file to open. You do not need to scan the directory for filenames.

How to read MEMORY.md:

```bash
cat ~/.entityname/memories/MEMORY.md
```

This is the starting point for understanding an entity's current context. Read it before any significant session to know what context the entity will load.

---

### Atom 6.3: When to Write a New Memory

**Teaches:** The criteria for deciding when a finding or decision warrants a new memory file, and what belongs in memory vs. in logs or research files.

Not everything that happens in a session becomes a memory. Memory files are for persistent operational context — things that should influence future sessions indefinitely or until explicitly updated. The test: "Will the entity need to know this in its next session? And the one after that?"

**Write a new memory when:**

- A significant operational preference was established ("always use tail -20, never cat output files")
- A blocker was resolved that affects future work ("koad resolved issue #44 — proceed with X, not Y")
- A key person, system, or context was characterized in a way the entity should carry forward ("koad is the operator; prefers brief status updates, not long explanations")
- A constraint was discovered that applies to all future work in a domain ("fourty4 does not have access to the internal API — all fourty4 tasks must use the public endpoints")
- A decision was made that should not be revisited ("the team voted on the April budget — CAD 1,000 ceiling, already ratified")

**Do not write a memory for:**

- Session logs and activity records — those belong in `LOGS/` or `var/log/`
- Research findings on specific topics — those belong in `research/` as dated files
- Temporary notes that will be resolved within a session or two — write them as a log entry, not a memory
- Information that is already in `CLAUDE.md` — duplication between CLAUDE.md and memory files creates confusion about which is authoritative

The heuristic: if you would put it in a `research/` file, it's research. If you would put it in a `LOGS/` file, it's a log. If it needs to influence every future session until further notice — it's a memory.

---

### Atom 6.4: Adding a Memory Correctly

**Teaches:** The exact steps to add a new memory: create the file, add an index line to MEMORY.md, commit, push — and why each step is load-bearing.

Adding a memory is a three-step operation:

**Step 1: Create the memory file**

```bash
# Choose a filename that describes the category
# Convention: feedback_<topic>.md for preferences/decisions, project_<topic>.md for ongoing context
# Use underscores, no spaces
cat > ~/.entityname/memories/feedback_output_reading.md << 'EOF'
# Output Reading

Always check git log first after a session — if there is no new commit, the work was not done.
Use tail -20 on output files, not cat.
The .result field in non-interactive session JSON is the clean output.
EOF
```

**Step 2: Add an index line to MEMORY.md**

```bash
# Open MEMORY.md and add a line at the appropriate position
# Format: - [display name](filename.md) — brief description
```

The index line:
```markdown
- [output reading](feedback_output_reading.md) — git log first, tail not cat, .result for JSON
```

The description should be short enough to scan in one second and specific enough to know whether to open the file.

**Step 3: Commit and push both files immediately**

```bash
cd ~/.entityname
git add memories/feedback_output_reading.md memories/MEMORY.md
git commit -m "memory: add output reading preferences"
git push
```

Commit both the new file and the updated MEMORY.md in the same commit. If you commit only the memory file and forget MEMORY.md, the index does not reflect the new file — the entity may not load it at the next session start.

Why push immediately: as with all entity work, an uncommitted or unpushed memory is invisible to other machines and other sessions. Push is part of the write.

---

### Atom 6.5: Memory Across Harness Switches

**Teaches:** What persists when an entity switches harnesses (from Claude Code to opencode or another harness), what does not, and how to audit memory state when the context feels stale.

When an entity switches harnesses — from Claude Code to opencode, or to a different Claude version — the committed memory files in `memories/` survive unchanged. The git history is harness-agnostic. The next session on any harness that reads `CLAUDE.md` will have access to everything in `memories/`.

What does not carry over: session state in `~/.claude/`. This is harness-specific and machine-specific. Auto-memory files that the harness created locally do not transfer to a new harness on a new machine.

The practical implication: if an entity moves to a new machine or switches harnesses, pull the entity directory and check `memories/MEMORY.md`. The committed memories are current. Anything the prior harness stored only locally is gone — but if it mattered, it should have been committed to `memories/` explicitly.

When memory feels stale or the entity seems to be missing context it should have:

**Check 1: Is the entity directory current?**
```bash
cd ~/.entityname && git pull && git log --oneline -5
```

If the last commit was days ago and you have been working in the entity since then, there are committed memories on another machine that have not been pulled here.

**Check 2: Is the memory file indexed?**
```bash
grep "the topic" ~/.entityname/memories/MEMORY.md
```

A memory file that exists in `memories/` but is not indexed in MEMORY.md may not be loaded by the entity. Check the index.

**Check 3: Is the content of the memory file correct?**
```bash
cat ~/.entityname/memories/relevant_file.md
```

Memory files can become outdated. A file that described the current state of a project two months ago may now be misleading. Update it if the information has changed. Stale memory is worse than no memory — it directs the entity toward old context.

When a memory is clearly outdated:
```bash
# Update the file
vim ~/.entityname/memories/project_current_state.md
# Commit the update
git commit -am "memory: update current state — project X completed, Y now active"
git push
```

Memory maintenance is an ongoing operator responsibility. The entity cannot update its own memory about events that happened outside its sessions. Decisions made in conversation, blockers resolved by koad, changes in priority — these need to be written by an operator into memory if they are to persist.

---

## Dialogue

### Opening

**Alice:** Entities do not remember conversations. Every session starts from what is committed to disk. If you told the entity something important last week and it was not written to a memory file and committed, the entity does not know it.

This is not a limitation to work around — it is the design. Files on disk, committed to git, available to any session, auditable, persistent. The session log is the working memory. The memory files are the long-term memory. Understanding which is which is the difference between an entity that gets smarter with each session and one that you have to brief from scratch every time.

---

### Exchange 1

**Alice:** Open an entity's memory index:

```bash
cat ~/.entityname/memories/MEMORY.md
```

This is the entity's map of what it knows. One line per topic. Read it before you spawn a session where context matters.

What you're looking for: is the current state of the entity's priorities here? Is the context you need to reference in the task already in a memory file? If yes, you can write a more concise prompt — the entity will load this context at session start. If no, you either add it to the prompt or write it to memory first.

**Human:** How does the entity actually load this context? Does it read the files automatically?

**Alice:** The instruction is in `CLAUDE.md`. Typically: "read memories/MEMORY.md at session start and load the relevant files." The entity follows this instruction, reads the index, identifies which files are relevant to the current task, and loads them. The entity selects which files to load based on relevance — not every file every session, just the ones that apply. That is why the one-line descriptions in the index matter: they are how the entity decides what to load.

---

### Exchange 2

**Alice:** When should you write a new memory? The test is whether future sessions need to know this.

Session-by-session research findings: not a memory. Put them in `research/`.

A decision that was made and should not be revisited: memory. "koad approved the April budget at CAD 1,000 — do not propose changes." An entity that does not have this will keep raising the budget question. One memory file closes it.

An operational preference you have now discovered: memory. "Use tail -20 on output files, not cat." Now every future session knows this without you needing to say it in the prompt.

Context about a specific person or system: memory. "fourty4 does not have access to the internal API — use public endpoints only for fourty4 tasks." This constraint needs to persist.

The heuristic: if you are about to put the same sentence in a task prompt for the third time, it belongs in a memory file instead. Write it once, commit it, and never include it in a prompt again.

---

### Exchange 3

**Alice:** How to add a memory. Three steps, all required.

Step one: create the file:

```bash
cat > ~/.entityname/memories/feedback_new_topic.md << 'EOF'
# New Topic

The relevant information, written clearly and concisely.
This should be a standing fact, decision, or preference — not a narrative of how it was reached.
EOF
```

Step two: add the index line to MEMORY.md:

```bash
# Add to the end of ~/.entityname/memories/MEMORY.md:
# - [new topic](feedback_new_topic.md) — one sentence describing what this covers
```

Step three: commit both files together and push:

```bash
cd ~/.entityname
git add memories/feedback_new_topic.md memories/MEMORY.md
git commit -m "memory: add [topic description]"
git push
```

All three steps. If you write the file and forget to update MEMORY.md, the index is stale. If you forget to commit, the memory is local only. If you forget to push, the memory is not available on other machines.

**Human:** Can the entity write its own memory files?

**Alice:** Yes — that is one of the things you can ask an entity to do in a task prompt. "Write a memory file summarizing the key decisions from this session, add it to MEMORY.md, commit and push." The entity will write the file in the correct format, update the index, and commit it. This is how the entity accumulates operational knowledge autonomously — you do not have to write every memory manually. You can delegate the memory-writing step to the entity after significant sessions.

---

### Exchange 4

**Alice:** One more thing: memory goes stale. A file that described the project state two months ago may now be wrong. An outdated memory file is worse than no memory file — it directs the entity toward the wrong context.

Periodic memory review is part of operator maintenance. For active entities (sessions running weekly or more), reviewing memory every month or two is reasonable. For dormant entities being reactivated, always review memory before the first session.

How to spot a stale memory:
- The filename uses a date: `project_state_2026-03.md` — this is probably outdated
- The content references an "ongoing" project that has since concluded
- The content contains predictions that have since been resolved

When you find a stale file:
- Update it: edit and re-commit
- Archive it: move to an `archive/` subdirectory in memories and remove the MEMORY.md entry
- Delete it: if the information is no longer relevant

The entity will not identify stale memory on its own. It reads what is there and acts on it. Keeping the memory files current is an operator responsibility.

---

### Landing

**Alice:** Memory is how an entity accumulates knowledge across sessions. Write it explicitly — it does not self-generate. Commit immediately — uncommitted memory does not persist. Keep it indexed — the MEMORY.md index is what the entity uses to navigate its own knowledge.

The three-step process: write the file, update MEMORY.md, commit both. Every time.

---

### Bridge to Level 7

**Alice:** The entity's memory is how it carries context across sessions internally. GitHub Issues are how it carries assignments and results across entities and across the team. Level 7 covers the issue protocol — how to file an issue that an entity can act on, and how the full lifecycle works from assignment to close.

---

### Branching Paths

#### "Can I just put everything in CLAUDE.md instead of memory files?"

**Human:** Why not put persistent context directly in CLAUDE.md instead of separate memory files?

**Alice:** CLAUDE.md is the entity's identity and standing instructions — it changes infrequently and requires a PR when it does. Memory files are operational state — they change frequently and can be committed directly. If you put all context in CLAUDE.md, every context update requires a PR review. That is the wrong level of ceremony for routine operational notes. More practically: CLAUDE.md grows too large if it accumulates all context. The `memories/` pattern keeps identity and instructions stable while letting operational knowledge grow freely. CLAUDE.md says "read memories/MEMORY.md" — that is the separation of concerns.

---

#### "What if two sessions write conflicting memory files?"

**Human:** What if two sessions run in parallel and both write to memory files at the same time?

**Alice:** You will get a merge conflict on push. The second push will fail, and you will need to resolve the conflict in the memory files — decide which version is correct, edit, commit the resolution, and push. This is one reason to avoid parallel sessions on the same entity when both are writing to memory. If you must run parallel sessions, scope their memory writes carefully so they write to different files. The lockfile prevents two simultaneous sessions on the same entity precisely to avoid this — parallel operation means parallel entities, not parallel sessions on the same entity.

---

## Exit Criteria

The operator has completed this level when they can:
- [ ] Describe the two memory layers and what persists in each
- [ ] Read MEMORY.md on an entity directory and identify what context the entity currently has
- [ ] Add a new memory file correctly: create the file, update MEMORY.md, commit both
- [ ] Explain what happens to session-harness state (`~/.claude`) when an entity moves to a new machine
- [ ] Identify a stale memory file and describe how to update or archive it

**How Alice verifies:** Ask the operator to add a test memory entry to an entity directory they have access to, following the three-step process. Verify that: the file was created with a clear description, MEMORY.md was updated with an index entry, both were committed together with a descriptive message, and it was pushed. If any step was skipped, return to that atom.

---

## Assessment

**Question:** "You had a productive session with Juno last week where koad made a key decision: no new entity gestations until the April budget review. That decision was not written to memory. You are about to spawn a new Juno session to plan the team. What do you do before spawning?"

**Acceptable answers:**
- "I write a memory file with the decision, update MEMORY.md, commit and push — so Juno has this context when it starts."
- "I check what's already in MEMORY.md, then add a new file documenting the budget decision with a clear index entry. I commit both before spawning."

**Red flag answers (indicates level should be revisited):**
- "I include the constraint in the task prompt" — correct as a workaround, but does not address the root issue: the constraint should be in memory so it applies to all future sessions without being repeated in every prompt
- "Juno will remember from last week" — incorrect; entities do not have conversational memory
- Not knowing that MEMORY.md must be updated along with the new file
- "I just tell Juno when the session starts" — same as the prompt workaround; does not persist

**Estimated conversation length:** 8–10 exchanges

---

## Alice's Delivery Notes

The most important conceptual point in this level is that entities have no conversational memory — only committed files. Operators who come from ChatGPT or other conversational AI tools will assume persistence. This assumption is wrong and causes repeated frustration. Make the distinction clear and make it early.

The three-step memory write process (Atom 6.4) must be taught as a complete unit. Operators who write the file but forget MEMORY.md, or who forget to push, will wonder why the entity does not have the memory they added. Do not let them leave this level without running through the three steps on an actual entity directory.

The "entity can write its own memory" point in Exchange 3 is worth emphasizing — it reframes memory from "operator chore" to "entity capability." An entity that is given a task with "write a memory summary when done" accumulates knowledge autonomously. That is a powerful pattern.

Stale memory (Atom 6.5) should be taught as a routine maintenance responsibility, not an edge case. Active entities accumulate context quickly. Operators who never review memory will eventually have entities acting on outdated information with no indication that anything is wrong.
