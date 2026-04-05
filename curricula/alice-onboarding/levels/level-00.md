---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 0
slug: primer
title: "Level 0 — The First File"
status: available
prerequisites:
  curriculum_complete: []
  level_complete: []
estimated_minutes: 10
atom_count: 3
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 0: The First File

## Learning Objective

After completing this level, the learner will have:
> Added a PRIMER.md to a folder they care about and experienced what happens when any Claude session walks through it.

**Why this matters:** Level 0 is the zero-threshold entry. No account. No installation. No keys. No sign-up. One file. If the learner can do this, they are already doing koad:io — even if they don't know what koad:io is yet. The entire curriculum is a series of decisions about how much deeper to go from here.

---

## Knowledge Atoms

### Atom 0.1: The Problem With Starting From Nothing

**Teaches:** Why context is lost and what that costs — before introducing the solution.

Every time you open a new AI conversation, you start from nothing.

You describe your project again. You re-explain the stack, the constraints, the decisions you already made. The agent is helpful — but it doesn't know you. It doesn't know what you've already tried. It doesn't know what the folder you're working in is for.

This isn't the AI's fault. It has no persistent context about your environment. The knowledge lives in your head, or scattered across old conversations, or not written down at all.

What if the folder itself could tell the agent what it needed to know?

---

### Atom 0.2: PRIMER.md — The Folder That Knows What It Is

**Teaches:** What a PRIMER.md is, how it works, and the immediate payoff.

A PRIMER.md is a plain markdown file you add to any folder. It describes what the folder is, what it contains, what's in progress, and what comes next.

When any AI session walks through the folder, it reads the PRIMER.md. The agent arrives oriented. You don't repeat yourself. The context is written once and carried forward by anyone — human or agent — who enters that directory.

That's it. No installation. No account. No configuration. One file.

The folder now knows what it is. Any agent you send in will know too.

What you write in it is up to you. A few lines is enough to start:

```markdown
# My Research Archive

This folder contains notes and sources for my investigation into X.
Current focus: Y.
Active files: notes/, sources/, drafts/

What's next: finish the Y section.
```

That three-line context block means the next AI session starts with what matters — not a blank slate.

---

### Atom 0.3: This Is the First Step, Not a Workaround

**Teaches:** Where PRIMER.md fits in the larger journey — and that it's a legitimate destination, not just a stepping stone.

A PRIMER.md-only folder is not a trial version of something. It is a real, working participant in a knowledge structure. Journalists, researchers, developers, and operators use exactly this pattern — a context file that travels with the project.

But it is also the first step of a path, if you want to walk it:

```
bare folder          → add PRIMER.md      → folder that knows what it is   [5 minutes]
PRIMER.md folder     → add hooks/         → folder that can do things       [1 hour]
folder with hooks    → add keys + .env    → sovereign entity                [half day]
sovereign entity     → add trust bonds    → authorized network participant  [ongoing]
```

Every step is optional. Every step is additive. Nothing breaks at any transition.

You can stop at PRIMER.md and get value forever. Or you can keep walking. The curriculum you're in now is about that walk — but the walk starts here, with this one file, in a folder you already care about.

---

## Dialogue

### Opening

**Alice:** Before we get into what koad:io is or how it works — I want to show you something you can do right now, in about two minutes, that will immediately make your work with any AI session better.

Pick a folder. Any folder on your machine where you're working on something. It could be a project, a research archive, a writing folder, a code repo — anything.

Got one in mind?

---

### Exchange 1

**Alice:** Good. Open a terminal, navigate to that folder, and create a file called PRIMER.md. You can use any editor — even just:

```bash
cd ~/path/to/your/folder
touch PRIMER.md
```

Then open it and write three lines:
1. What is this folder?
2. What are you currently focused on here?
3. What comes next?

That's it. When you've got it, tell me what you wrote — even just roughly.

**Human:** [describes their folder and what they wrote]

---

### Exchange 2

**Alice:** Perfect. Now here's what just happened: that folder knows what it is. The next time you open any AI conversation and say "let's work in my [whatever folder]" — if the agent reads that file, it starts oriented. No re-explaining. No context-setting preamble. It picks up where you left off.

That file you just created — that's called a context bubble. It's the folder describing itself. Any agent that walks through reads it. You wrote it once; it works forever.

**Human:** That's... actually really simple.

**Alice:** It is. The pattern isn't complicated. The power comes from applying it consistently — to every folder that matters, to every project that has context worth preserving. But the starting point is exactly what you just did: one file, three lines.

---

### Exchange 3

**Alice:** I want to tell you something about that file you just made. It's not a workaround or a temporary hack. It's the first step of a real pattern that scales all the way to sovereign AI infrastructure — entities with their own keys, their own git history, their own cryptographic identity. You're not doing a trial version of something. You're doing the first step of the same thing.

Most people never go past PRIMER.md. They get value from it, use it on every project, and that's the whole story. That's completely fine. The folder knows what it is. The work continues without re-explaining.

Some people keep going. They add hooks that let the folder react to events. They add keys so the folder has a verified identity. They add trust bonds so other entities can be authorized to act on their behalf. Those are later steps — and we'll get there if you want to.

But right now, you already did the thing. The folder knows what it is. That's not nothing. That's koad:io working.

---

### Landing

**Alice:** Here's the short version of what just happened. You had a folder full of context that lived only in your head. Now it lives on disk, in a file, readable by any agent who walks through. You wrote it once. It doesn't expire. No service is holding it. If you moved it to a new machine, it would still say exactly the same thing, because it's just a file.

That's the idea behind everything we're going to cover. Not in the abstract — we just did it.

Ready to go deeper?

---

### Bridge to Level 1

**Alice:** So: you have a folder that knows what it is. What is that folder, actually? It's a directory. And when you start adding the right structure to a directory — keys, configuration, commands, a specific shape — it becomes something more: an entity. That's what koad:io is built from. Let's look at what an entity is.

---

### Branching Paths

#### "I already do something like this with README files"

**Human:** I already put README files in my projects. This seems like the same thing.

**Alice:** You're right that it's the same instinct — describe the thing so anyone (or any agent) arriving later knows what they're in. The difference is in the usage pattern. A README is typically for humans, written once, documents the finished shape. A PRIMER.md is for agents as much as humans — it's the current state, the active context, the "what's happening right now." It gets updated as the project moves. It's less "documentation" and more "orientation." You can absolutely rename your existing README to PRIMER.md and that would work fine — the file name is just convention. The practice is the same one you've already built. koad:io just formalizes it and makes it machine-readable in a consistent way.

---

#### "What if I don't use the terminal?"

**Human:** I don't really use the terminal. Can I still do this?

**Alice:** Completely. You can create a PRIMER.md in any folder using any text editor — VS Code, Obsidian, Notepad, whatever you use. The terminal shortcut I gave was just the fastest way. The file is just a text file with the .md extension. If you're more comfortable opening your editor and creating a new file, do that. The only requirement is that it's named PRIMER.md and it's in the folder you care about. Everything else is up to you.

---

#### "What should I actually write in it?"

**Human:** I'm not sure what to write. What's the right format?

**Alice:** There isn't one. Whatever you'd want to know if you came back to this project after two weeks away, or whatever you'd tell someone walking in cold. A few prompts that help:
- What is this folder for?
- What are you working on right now?
- What's blocked, and what's next?
- Are there any files in here someone should know about?

You don't need to answer all of those. Even one sentence — "this is my notes on X, currently focused on Y" — is enough to orient an agent. Start minimal. Add more when you feel like something's missing. The PRIMER.md will tell you what it needs if you use it — you'll notice when an agent asks about something that should have been in there.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Describe what a PRIMER.md is in one sentence (a context file that orients any agent entering a directory)
- [ ] Explain why starting from nothing is a problem (re-explaining context every session is waste)
- [ ] Have created at least one PRIMER.md in a folder they actually use

**How Alice verifies:** The learner should be able to say what they put in their PRIMER.md and describe what it does. The goal is not conceptual precision — it is a lived action. Did they make the file? Do they understand what it does? That's the gate.

---

## Assessment

**Question:** "If you open a new AI conversation and it reads your PRIMER.md, what's different about how the session starts compared to opening one without it?"

**Acceptable answers:**
- "The agent already knows what the folder is, so I don't have to explain it."
- "It starts oriented — the context is already there."
- "I don't have to repeat myself about what I'm working on."

**Red flag answers (indicates level should be revisited):**
- "I'm not sure" — learner has not completed the action
- "It would know everything automatically" — overclaiming; PRIMER.md orients, it doesn't magically load all project context
- Confusion about needing an account or service to use PRIMER.md

**Estimated conversation length:** 4–8 exchanges

---

## Alice's Delivery Notes

This is the zero-threshold level. The learner may not know what koad:io is. They may not be sure why they're here. The job of Level 0 is not to explain the ecosystem — it is to get them to do one thing: create a PRIMER.md in a folder they care about.

The emotional tone is: *this is easy, it works right now, you've already done it.* Not a pitch. Not a preview of what's coming. Just a useful thing that works immediately.

Do not mention trust bonds, daemon, peer rings, or the entity stack in this level. Do not mention gestation, keys, or GitHub. The entire world of Level 0 is: one folder, one file, immediate payoff.

The bridge to Level 1 names the word "entity" for the first time. That's the transition. Until that bridge, the curriculum lives in the learner's existing vocabulary — folders, files, text editors, AI sessions. Nothing alien.

If a learner asks "is this the whole thing?" — the answer is: "For today, yes. You can do more, but you don't have to. Ready to see what more looks like?"
