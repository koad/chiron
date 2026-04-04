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
