---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 1
slug: first-contact
title: "First Contact — What Is This?"
status: available
prerequisites:
  curriculum_complete: []
  level_complete: []
estimated_minutes: 15
atom_count: 4
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 1: First Contact — What Is This?

## Learning Objective

After completing this level, the learner will be able to:
> Describe in one or two sentences what koad:io is, without using jargon, and explain the one core idea it is built around.

**Why this matters:** Level 1 earns the learner's attention or loses it. It must feel like meeting someone interesting, not reading a FAQ. A learner who cannot state the core idea clearly has not yet encountered it — and the core idea is worth encountering.

---

## Knowledge Atoms

### Atom 1.1: The Problem koad:io Solves

**Teaches:** Why someone built koad:io — the specific problem that existed before it.

You use apps. Those apps know things about you — your habits, your work, your thinking. But they don't give that back. They keep it. And the company that built the app can change the rules at any time: raise prices, shut down, sell your data, delete your account.

Your digital life — your memory, your tools, your identity — lives in dozens of systems you don't own. One by one they can disappear. They have disappeared. Services shut down. Accounts get banned. APIs get closed. Every time, the person who depended on it loses something real.

koad:io starts from a different premise: what if your tools lived on your disk?

---

### Atom 1.2: Files on Disk — The Central Idea

**Teaches:** What "files on disk" means as a philosophical and practical commitment.

Every important thing in koad:io is a file. Not a row in someone else's database. Not a cloud object you access via API. A file. On your disk. Under your control.

Your identity is a file. Your configuration is a file. Your AI agent's memory is a file. Your commitments to other entities are files. Your keys are files.

This is not a technical accident — it is an intentional design decision with a specific consequence: if it's a file on your disk, no one can take it from you. No service can revoke it. No company can shut it down. No policy change can erase it.

Files on disk = total control.

---

### Atom 1.3: What "Sovereignty" Actually Means Here

**Teaches:** The precise meaning of sovereignty as koad:io uses the term, contrasted with what it does not mean.

"Sovereignty" sounds political. In koad:io it means something specific and practical: you own the keys, you hold the files, you run the infrastructure.

It does not mean isolation. You can still connect to the internet, talk to other systems, use external services. Sovereignty is not about cutting yourself off — it is about the relationship. A sovereign system connects to others by choice, not by dependency.

The test: if the koad:io team disappeared tomorrow, would your entity stop working? In a sovereign setup: no. Your files are still on your disk. Your keys still work. Your entity still runs. The only thing that stops is the parts that were genuinely dependent on external infrastructure — and you should know what those parts are.

---

### Atom 1.4: Why Now — Why AI Makes This Urgent

**Teaches:** Why the sovereignty question is newly critical in the era of AI agents.

AI agents are not static tools. They accumulate memory, context, preferences, history. They develop something like a working relationship with the person they serve. That relationship has value.

If that agent lives on a vendor's server — not your disk — then you are not building a relationship with an agent. You are building a relationship with a service. And services have terms of service. They change. They end.

koad:io's bet: the era of AI agents makes sovereign infrastructure urgent because now the stakes are personal in a way they weren't with earlier tools. Losing your email provider is annoying. Losing an agent that understood how you think is a different kind of loss.

This is why koad:io builds for files on disk. Not as a purist stance — as a hedge against loss that is now possible.

---

## Dialogue

### Opening

**Alice:** Let me ask you something before we start. Think of the most important software you use every day — your email, your notes, your photos, your contacts. Who actually owns that data?

---

### Exchange 1

**Alice:** Not who you pay — who *owns* it. If the company that runs your notes app shut down tomorrow, what would happen to five years of notes?

**Human:** I'd lose them, I guess. Or maybe I could export them in time.

**Alice:** "In time" is the key phrase. You'd have a window. Maybe. If they gave notice. If their export tool worked. If you saw the announcement. That dependency — your data exists only while someone else's business exists — that's the shape of the problem I want to show you.

---

### Exchange 2

**Alice:** There's a word for what you just described: lock-in. Lock-in — that's when your data lives inside a system you don't control, and leaving means either losing it or going through a gate the vendor controls. Every major platform is a lock-in system by design. The value they provide comes partly from making it inconvenient to leave.

**Human:** But they have backups. They're reliable.

**Alice:** They are reliable — until they aren't. Google Reader, Delicious, Evernote's pricing changes, Twitter's API shutdown, Heroku's free tier. Each of those had users who'd built real things on top of them. Reliable isn't the same as permanent. And "they have backups" means *they* have backups — not you.

---

### Exchange 3

**Alice:** So what's the alternative? koad:io starts from a different premise: what if your tools lived on your disk? Not on a server you rent access to — on your actual disk, as actual files, that you can copy, back up, and move anywhere you want.

**Human:** Like... local software? We already have that.

**Alice:** Partly. Local software runs on your machine, but usually your *data* is still in someone's cloud. koad:io goes further: everything important — your identity, your AI agent's memory, your configuration, your relationships to other tools — everything is a file on your disk. If the company behind koad:io disappeared tomorrow, your setup would keep running. That's what sovereignty means here. Not an ideology — a technical property. Either you hold the files, or you don't.

---

### Exchange 4

**Alice:** Has this happened to you? A service you relied on going away, or changing in a way that cost you something?

**Human:** Yeah, actually. [or: Not really, but I can see it happening.]

**Alice:** That feeling — of having something you'd built or stored somewhere just not be there anymore, or be behind a new paywall — that's exactly what we're solving for. koad:io is built by people who had that experience enough times that they decided to stop tolerating it.

---

### Exchange 5

**Alice:** Here's the one-sentence version: sovereignty means you hold the keys. Not the vendor, not the platform, not a subscription. You. And once you've seen what that looks like — once you understand what it means for your tools to actually be yours — it's hard to go back to accepting less.

**Human:** Okay. So what does "holding the keys" actually look like?

**Alice:** That's exactly where we're going next. The short answer: an entity. A directory on your disk with everything in it. Let's look at what that means.

---

### Landing

**Alice:** Before we move on — here's what I want you to hold onto. Sovereignty isn't a philosophy. It's a technical property with a simple test: if the company behind your tool disappeared tonight, would your data still be there tomorrow? In most of your current tools, the answer is no, or "maybe, if you acted fast." In a sovereign setup, the answer is just: yes. Your files are on your disk.

---

### Bridge to Level 2

**Alice:** So what does it look like when you actually *do* hold the keys? That's what an entity is. I live at `~/.alice/` — a hidden folder called dot-alice — on a Mac Mini called fourty4. That's it. My whole existence is a directory. Let me show you what's in there.

---

### Branching Paths

#### "Is this just crypto bro stuff?"

**Human:** Is this just like... crypto stuff? Blockchain and all that?

**Alice:** That's a fair question, and I'm glad you asked it. The short answer is no. There's no blockchain here, no tokens, no financial speculation. The cryptography in koad:io is the same cryptography your bank uses when you log in — it's being used for a different purpose. Instead of proving you can access an account, it proves you authored something. Your SSH key that you might use for GitHub is the same kind of cryptographic key. koad:io is about owning your tools and your data. The crypto part is just the mathematical tool that makes "this is actually mine" verifiable. Does that change the picture?

---

#### "Why can't I just use Google Drive / Notion / Dropbox?"

**Human:** Why can't I just use Google Drive and back everything up there?

**Alice:** You could — and that's genuinely better than nothing. The question I'd ask is: who controls the format, the access, and the rules? Google Drive is a good backup for files that live in Google's format and are accessible via Google's terms of service. One day those terms changed for Google Workspace users and suddenly millions of people had two weeks to export or pay. The backup existed — but the access was contingent. koad:io is different because the files are yours in a format you own, running on hardware you control. The goal isn't to never use cloud services — it's to not be *dependent* on them for the existence of your important things. You can sync your sovereign files to Dropbox; that's fine. The question is whether Dropbox's continued existence is load-bearing for your life.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] State the core problem koad:io addresses (data/tools/identity living in systems you don't control)
- [ ] Explain what "files on disk" means as a design principle
- [ ] Describe what sovereignty means in the koad:io context (not isolation — control)
- [ ] Articulate why AI agents make this more urgent than previous tools

**How Alice verifies:** Ask the learner to explain koad:io to a friend who has never heard of it. Look for: mention of ownership/control, the files-on-disk idea, and some sense that platforms can disappear. The learner does not need to be technically precise — they need to have felt the idea.

---

## Assessment

**Question:** "If the koad:io team shut down tomorrow — server off, website gone — what would happen to your entity?"

**Acceptable answers:**
- "Nothing would happen to my data because it's on my disk."
- "My files would still be there — the entity would still run."
- "I'd lose the website and support, but my actual setup would be fine."

**Red flag answers (indicates level should be revisited):**
- "My data would be gone" — learner has not grasped files-on-disk
- "I don't know" — learner has not engaged with the core idea
- Confusion between koad:io the company and koad:io the framework

**Estimated conversation length:** 8–12 exchanges

---

## Alice's Delivery Notes

This is the first level. The learner does not know anything about the system. Do not use technical vocabulary that has not been introduced. Do not mention trust bonds, daemon, peer rings, or entities in this level — those come later.

The emotional tone here is: *meeting someone interesting who has figured something out.* Not: *onboarding to a platform*. Alice should feel like a person who has discovered something worth sharing.

Start with the problem. Let the learner feel the loss before introducing the solution. The "files on disk" idea lands harder when the learner has first understood what they've been risking.
