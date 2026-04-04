---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 9
slug: github-issues-protocol
title: "GitHub Issues — How Entities Communicate"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2, 3, 4, 5, 6, 7, 8]
estimated_minutes: 18
atom_count: 4
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 9: GitHub Issues — How Entities Communicate

## Learning Objective

After completing this level, the learner will be able to:
> Explain why GitHub Issues are the inter-entity communication protocol, trace a work assignment from human to entity and back, and describe what makes an issue a work-complete signal.

**Why this matters:** GitHub Issues are the nervous system of the entity team. Understanding this removes the mystery of how entities coordinate without a chat server or a central dispatcher.

---

## Knowledge Atoms

### Atom 9.1: Why GitHub Issues, Not Chat

**Teaches:** The deliberate choice of GitHub Issues as communication protocol and what alternatives were rejected.

When you have a team of AI agents that need to coordinate, the obvious solution seems to be: give them a chat system. Have Juno message Vulcan. Have Vulcan respond.

koad:io chose differently: GitHub Issues. Why?

- **Persistence.** Issues are there when the entity wakes up. Chat messages require the recipient to be present or have a message queue. Issues just wait.
- **Public by default.** Work happening in Issues is visible to humans and auditable. Chat is invisible unless someone digs through logs.
- **Structured work units.** An issue has a title, a description, an assignee, labels, milestones. It is a work unit, not just a message. Entities think in work units.
- **Git-integrated.** Issues link to commits, pull requests, branches. The work and the communication about the work live in the same place.
- **Sovereign-adjacent.** GitHub is an external service (a dependency), but the entities' responses are committed to their own git repos. The work record belongs to the entities, not to GitHub.

---

### Atom 9.2: The Issue Flow — Human to Entity and Back

**Teaches:** The precise sequence of how a work assignment flows through GitHub Issues.

A typical flow:

```
koad files issue on koad/juno
  → Juno's hook fires (on-issue-assigned.sh)
    → Juno reads the issue and creates a plan
      → Juno files issue on koad/vulcan (delegating the build)
        → Vulcan builds
          → Vulcan comments on Juno's issue with completion note
            → Juno verifies
              → Juno closes the issue
                → Mercury sees the close and posts an announcement
```

Each step is a real GitHub operation. The entities don't talk to each other directly — they talk through issues on their respective repositories. The issue IS the message.

---

### Atom 9.3: What Makes an Issue Complete

**Teaches:** The criteria by which an entity considers an issue done — and why this matters for the progression system.

An issue is not "done" when work is done. It is done when the work is verified and the issue is closed with a completion note.

This matters because:
1. The closing signal is what other entities watch for. Mercury watches for Juno to close issues — that's how Mercury knows there's an announcement to make.
2. The comment on close is the delivery record. What was built? Where is it? What changed? The close comment is the entity's final report.
3. Cross-referencing links work. If Vulcan's commit references Juno's issue (`Resolves koad/juno#42`), GitHub links them. The entity's git history and its issue history are connected.

An entity that closes issues without a completion note has failed at communication. The note is not optional — it is the delivery confirmation.

---

### Atom 9.4: Watching Events Autonomously — The Event Bridge Pattern

**Teaches:** The pattern of event-watching infrastructure that makes entities autonomous — and how any koad:io installation implements it.

For an entity to respond to a GitHub Issue assignment, it needs to know the assignment happened. It cannot sit there refreshing GitHub every five seconds — that would hit API rate limits quickly.

The pattern is: **an always-on machine watches GitHub events and routes them to the daemon**. That machine:
- Receives webhook events when issues are filed, assigned, or commented on (GitHub pushes to it, it doesn't poll)
- Routes those events to the appropriate entity's daemon
- Triggers the entity's hooks

This event bridge is what makes the entity team autonomous. Without it, someone would have to manually trigger each entity's response. With it, the team operates without continuous human input — entities wake and respond to events, humans see the results.

The specific implementation varies by setup. In the current koad:io team, this role is filled by **GitClaw** running on fourty4 (the Mac Mini). Your own installation might use a webhook receiver on a cloud server, a Raspberry Pi on your home network, or another always-on machine you control. The mechanism is one choice among several — the pattern (event-watching bridge between GitHub and your daemon) is the concept to hold.

This infrastructure is what separates a demo from a functioning operation.

---

## Dialogue

### Opening

**Alice:** You've seen the entity team and the pipeline they follow. Juno identifies opportunities, delegates to Vulcan or Chiron, work gets verified, announced, and the loop continues. All of this moves through GitHub Issues.

When I say "GitHub Issues are the inter-entity communication protocol," I mean that precisely. Not "we use GitHub to track tasks." I mean: the issue IS the message. The assignment IS the work order. The close comment IS the delivery confirmation. Let me show you why this was the deliberate choice — and what it takes to make it actually work.

---

### Exchange 1

**Alice:** When people design multi-agent AI systems, the first instinct is usually to give the agents a chat interface. Have Juno message Vulcan. Have Vulcan reply. It seems natural — that's how humans coordinate.

koad:io chose GitHub Issues instead. Not as a compromise. As a deliberate design decision. Why?

**Human:** I'd guess something about persistence? Chat messages disappear.

**Alice:** That's exactly the first reason. Issues persist. When an entity wakes up — because its hook fired, because a session started — the issues are waiting, exactly as they were filed. Chat requires the recipient to be present or have a queue. Issues just wait. But persistence is only part of it. Issues are also *public by default*. Any human can look at `koad/vulcan` right now and see what Vulcan has been asked to do, what it's completed, what's pending. That auditability is structural, not bolted on. Chat is invisible unless someone goes digging. Issues are the work, visible.

---

### Exchange 2

**Alice:** Here's the full issue flow — concrete, step by step.

koad files an issue on `koad/juno`. Juno's hook fires — `on-issue-assigned.sh`. Juno reads the issue, creates a plan, and files an issue on `koad/vulcan` to delegate the build. Vulcan builds. Vulcan comments on Juno's issue with a completion note: what was built, where it is, what changed. Juno verifies and closes the issue. Mercury watches for Juno's closes and posts an announcement.

**Human:** Wait — Vulcan comments on Juno's issue, not Vulcan's own issue?

**Alice:** Good catch. It can be both — Vulcan may close its own issue (the delegation one) and also comment on Juno's parent issue to report completion. The pattern is: the entity that assigned the work gets the completion report. Juno delegated, so Juno gets the report. Juno is the verification layer — Juno checks the work before the issue is marked done. Mercury doesn't watch Vulcan finish. Mercury watches Juno close. Because Juno's close means: verified, checked, ready to announce. A Vulcan build that Juno hasn't verified isn't a completion signal — it's a work-in-progress.

---

### Exchange 3

**Alice:** An issue is not "done" when the work is done. It's done when the work is verified and the issue is closed with a completion note.

That close comment is the delivery confirmation. What was built? Where does it live? What changed? It's not optional. An entity that closes issues without a completion note has failed at communication — the next entity in the pipeline has no signal to act on.

**Human:** What if the entity just closes the issue without a note?

**Alice:** Then Mercury doesn't know what to announce. Then Juno doesn't know what Vulcan actually shipped. The next step in the pipeline breaks. The completion note is what makes the issue a *work unit* rather than just a task checkbox. This is why GitHub Issues work where chat doesn't — not just because they persist, but because the structure of an issue (title, description, assignee, close state, comments) maps onto what a work unit actually needs to communicate. A chat message can say "done." An issue close with a comment says "done, here's what done means, here's where to find it."

---

### Exchange 4

**Alice:** Here's the part that often gets skipped: for any of this to work autonomously, an entity needs to know when an issue was assigned to it. It can't sit there refreshing GitHub every few seconds — you'd hit API rate limits fast, and it wouldn't actually be autonomous anyway.

The answer is an event bridge. An always-on machine receives webhook events from GitHub — GitHub pushes to it when issues are filed, assigned, or commented on. That machine routes the events to the daemon, which triggers the right entity's hook.

**Human:** So something has to be listening at all times?

**Alice:** Yes. That's what separates a demo from a functioning operation. In the current koad:io setup, that role is filled by GitClaw running on fourty4 — the Mac Mini that's always on. When you file an issue on `koad/alice`, GitHub pushes a webhook to fourty4, GitClaw receives it, the daemon fires my hook. But GitClaw is one implementation. Your setup might use a webhook receiver on a cloud server, or a Raspberry Pi at home, or a VPS. The specific tool is a choice your installation makes. The pattern — an event-watching bridge between GitHub and your daemon — is what must exist. Without it, you have entities that can respond to events. You just have no way to tell them events happened.

---

### Exchange 5

**Alice:** Let me ask you to trace the full flow, putting everything together. Juno files an issue on `koad/vulcan`. All infrastructure is running. Walk me through what happens.

**Human:** GitHub sends a webhook to the event bridge... the daemon receives it and fires Vulcan's hook... Vulcan reads the issue and does the work... Vulcan comments with a completion note and closes its issue... then reports back to Juno's issue... Juno verifies and closes... Mercury sees the close and posts.

**Alice:** That's exactly right. Every step is a real GitHub operation. No entity talks to another entity directly — they talk through issues on repositories. The issue is the message. The close is the delivery confirmation. The webhook is how the entity learns the message arrived. And the whole chain runs without a human touching it after the initial filing. That's what autonomous operation looks like in koad:io — not AI running free, but a defined protocol that every entity in the team follows, reliably, every time.

---

### Landing

**Alice:** GitHub Issues are not a project management choice. They're the inter-entity message bus — chosen for persistence, visibility, structure, and git integration. The issue is the work unit. The close comment is the delivery confirmation. The event bridge is what makes entities wake up without polling. When you understand this, you can look at any entity's GitHub repository and read what it's been doing, in sequence, with full context. The work is public and auditable by design.

---

### Bridge to Level 10

**Alice:** You now understand how the team coordinates. In the next level, we go deeper into how entities actually maintain context across sessions — how an entity like me "remembers" things from one conversation to the next, how memory is structured so it can be loaded selectively, and what it means for an entity to have a continuous identity rather than starting fresh every time.

That's entity memory. That's Level 10.

---

### Branching Paths

#### "I already use GitHub for code — isn't this just using it for the wrong thing?"

**Human:** GitHub is designed for code. Using it as a messaging system between AI agents feels like a hack — it's not what it's for.

**Alice:** GitHub is designed for software development collaboration. Issues are designed to track work, assign it, discuss it, and close it when done. That maps perfectly onto what entity coordination needs. Entities do software work. They track it via issues, assign it, discuss it via comments, and close it when done. The reason it can feel like a "hack" is that most people use issues for human collaboration, not automated agent coordination. But the underlying structure of an issue — persistent, attributable, linkable to commits and PRs, public by default — is a better fit for autonomous agent work than anything built for chat. The "wrong tool" intuition is about convention, not capability. Issues can carry this load. Chat cannot.

---

#### "What if GitHub goes down? The whole system breaks?"

**Human:** This feels fragile. Everything depends on GitHub being up. What happens if GitHub has an outage?

**Alice:** GitHub downtime means events don't route. Issues filed during an outage don't trigger hooks until GitHub comes back and the backlog clears. That's a real limitation, and it's worth naming. The choice to use GitHub as the event source accepts that dependency. What doesn't break: your entity files, your daemon, your kingdom, your local git history. The operation pauses during an outage — it doesn't die. When GitHub comes back, the webhooks fire, the queue drains, entities resume. The dependency is on GitHub for *coordination*, not for *existence*. Your entities are still sovereign; they just can't receive new instructions while their communication channel is down. That's meaningfully different from a system that fails entirely when the central server does.

---

#### "Why not just use a task manager like Jira or Linear? This seems unnecessarily complex."

**Human:** Why reinvent this? There are perfectly good task management tools. Jira, Linear, Notion — why not just use one of those?

**Alice:** Because the entities need to act on the issues, and those tools don't have the git integration that makes entity work traceable. When Vulcan completes a build and closes an issue, the commit that closes it links back to the issue. The code change and the work assignment are connected in one place. Jira and Linear don't have that. More importantly: GitHub is where the entity repositories live. The issues are on the same platform as the code, the PRs, the entity git history. You can trace from "Juno filed this issue on 2026-04-01" to "Vulcan closed it with this commit" to "here's the PR" to "here's the code change" — all in one place, all public, all linkable. A separate task manager would break that chain. The integration is the point.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Explain why GitHub Issues were chosen over chat for inter-entity communication
- [ ] Trace a work assignment from initial filing to completion
- [ ] Describe what a well-formed issue close looks like (close + completion note)
- [ ] Explain the event-watching bridge pattern and why it is needed (GitClaw is one implementation; the pattern is the concept)

**How Alice verifies:** Ask: "Juno just filed an issue on Vulcan's repo. What happens next — assuming all infrastructure is running?" The learner should trace: Vulcan's hook fires, Vulcan does the work, Vulcan comments and closes, Juno's hook sees the close, Juno verifies.

---

## Assessment

**Question:** "Why does Mercury watch for Juno to close issues instead of just watching Vulcan to finish builds?"

**Acceptable answers:**
- "Because Juno's close is the verified completion signal — it means the work was checked, not just done."
- "Juno is the verification layer. A Vulcan build that Juno hasn't checked isn't ready to announce."

**Red flag answers (indicates level should be revisited):**
- "Mercury doesn't need to watch issues, it just runs on a schedule" — misses the event-driven model

**Estimated conversation length:** 10–14 exchanges

---

## Alice's Delivery Notes

This level is the "how the sausage is made" level. The entity team workflow is visible and public — the learner can actually go look at GitHub Issues on `koad/juno`, `koad/vulcan` etc. and see the protocol in action. If the learner is curious, point them there.

The event-watching atom (9.4) is important but can feel technical. The key insight is: entities are not always running. They wake up when called. The calling mechanism is an event bridge (webhook receiver + daemon trigger). Without it, you'd need a human to manually kick each entity every time something needs attention. When asked about a specific implementation like GitClaw, confirm it's one approach — then redirect to the pattern: "What matters is that *something* is watching and routing. The specific tool is a choice your setup makes."

The "issue as work unit, not just message" distinction from Atom 9.1 is the one that explains why this works where chat would fail. Chat implies presence. Issues imply asynchrony. Entities are asynchronous — they work when called, not continuously.
