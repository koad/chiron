---
type: curriculum-bubble
id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
slug: alice-onboarding
title: "koad:io Human Onboarding — 12-Level Sovereignty Path"
description: "After completing all 12 levels, the learner understands sovereign infrastructure, can navigate an entity directory, articulates why trust bonds matter, and has made a cryptographically signed commitment to operating with sovereignty."
version: 1.3.1
authored_by: chiron
authored_at: 2026-04-04T12:00:00Z
owned_by: kingofalldata.com
signature: (pending — signed by Chiron on first authoring commit)

prerequisites: []

audience: "Humans new to the koad:io ecosystem. Basic CLI familiarity assumed (can open a terminal, run a command, understand what a directory is). No prior knowledge of sovereign infrastructure, trust bonds, or entity architecture required."
estimated_hours: 4.5

level_count: 13
atom_count_total: 60

is_shared: true
shared_with: ["*"]
license: cc-by

commissioned_by: https://github.com/koad/chiron/issues/1
---

# Curriculum: koad:io Human Onboarding — 12-Level Sovereignty Path

## Overview

This curriculum walks a complete newcomer from "What is koad:io?" to operating as a sovereign participant in the ecosystem. It is not a reference document — it is a journey. Each level is a knowledge gate. The learner cannot advance until they can demonstrate what the current level taught them. By Level 12 they have made a real commitment, verified with cryptography, that they understand what they have joined.

Alice delivers this curriculum conversationally, one level at a time. The learner's progress is tracked by Alice and Vulcan's progression system. The curriculum is designed for delivery over multiple sessions — a learner may complete 2–3 levels in a sitting and return for the rest.

## Entry Prerequisites

The learner can:
- Open a folder on their computer (any operating system)
- Create a text file (with any editor)

The learner does NOT need to:
- Know what a terminal is (Level 0 offers a terminal shortcut but accepts any text editor)
- Navigate on the command line

The learner does NOT need to:
- Know what an "entity" is
- Know what SSH is for
- Have any existing koad:io installation
- Know what GPG or sovereign infrastructure means
- Know what a terminal is (Level 0 accommodates any text editor)

These are taught by the curriculum itself.

## Completion Statement

After completing all 12 levels, the learner will be able to:
- Explain what koad:io is and why it was built, in their own words
- Describe the difference between a sovereign system and a platform-dependent one
- Navigate an entity directory (`~/.alice/`, `~/.juno/`) and read what they find
- Explain what trust bonds are, why they are signed, and what they authorize
- Describe the two-layer architecture (framework layer + entity layer)
- Explain what the daemon is and why a kingdom needs one
- Describe how peer rings work and what sponsorship unlocks
- Identify the team entities and their roles in the ecosystem
- Explain how GitHub Issues function as the inter-entity communication protocol
- Describe what context bubbles are and why knowledge must be portable
- Run a basic entity command and describe what happened
- Articulate what they are committing to by joining the koad:io ecosystem

---

## Level Summary

| # | Title | Atoms | Minutes |
|---|-------|-------|---------|
| 0 | The First File | 3 | 10 |
| 1 | First Contact — What Is This? | 4 | 15 |
| 2 | What Is an Entity? | 5 | 20 |
| 3 | Your Keys Are You | 5 | 20 |
| 4 | How Entities Trust Each Other | 7 | 35 |
| 5 | Commands and Hooks — How Entities Take Action | 4 | 20 |
| 6 | The Daemon and the Kingdom | 5 | 25 |
| 7 | Peer Rings — Connecting Kingdoms | 4 | 20 |
| 8 | The Entity Team | 4 | 20 |
| 9 | GitHub Issues — How Entities Communicate | 4 | 18 |
| 10 | Context Bubbles — Portable Knowledge | 4 | 20 |
| 11 | Running an Entity — From Concept to Operation | 5 | 25 |
| 12 | The Commitment — What You're Joining | 4 | 25 |

Full level content lives in `levels/`. See VESTA-SPEC-025 for the loading contract and progressive disclosure rules.

---

## Curriculum Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-04-04 | Initial authoring by Chiron. 12 levels, 54 atoms total. |
| 1.1.0 | 2026-04-04 | Revisions in response to Alice's review (APPROVE WITH NOTES). Level 3: added wax-seal signing analogy to delivery notes. Level 6: added kingdom-awareness exit criterion and second assessment question. Level 8: reordered atoms — pipeline first (8.1), then entity roster (8.2). Level 9 Atom 9.4: reframed as pattern-first (event bridge), GitClaw named as one implementation. Level 11: added delivery note for PWA sovereignty tension. |
| 1.2.0 | 2026-04-05 | Added Level 0: The First File. Zero-threshold entry point — PRIMER.md in any folder. 3 atoms, 10 minutes. No terminal or installation required. Addresses koad/chiron#3 (Iris recommendation). Entry prerequisites updated to reflect lower floor. Total: 13 levels, 57 atoms. |
| 1.3.0 | 2026-04-05 | Operational verification gap closed (Day 6 reflection). Level 3: added Atom 3.5 (GPG key import mechanics — fetch issuer key from canon, import into local keyring). Level 4: added Atom 4.6 (real bond file format — clearsign structure) and Atom 4.7 (operational verification — four-step gpg --verify sequence with output interpretation). Level 4 exit criteria updated to require hands-on verification, not just conceptual fluency. Level 4 estimated minutes: 25 → 35. Total: 13 levels, 60 atoms. |
| 1.3.1 | 2026-04-05 | Veritas fact-check corrections applied. Fix 1: Level 4 bond type `authorized-curriculum-architect` → `authorized-specialist` throughout (Atoms 4.2, 4.5, 4.6, dialogue Exchange 6). Fix 2: Levels 3 and 4 GPG import command corrected — `canon.koad.sh` serves SSH keys, not GPG keys; correct path is `gpg --import ~/.{entity}/id/rsa.pub` (Atom 3.5, Atom 4.7, Exchange 7). Fix 3: Level 5 hook examples (on-issue-assigned.sh etc.) marked as future/unimplemented; only live hook is `executed-without-arguments.sh`. Fix 4: Level 4 Atom 4.3 `koad-to-chiron.md` inbound bond removed — this bond does not exist in the live system; note added that authority flows koad → Juno → Chiron. Fix 5: Level 6 Atom 6.3 passenger.json schema corrected to match Alice's actual file (handle/name/avatar/outfit/buttons, not entity/role/version/description/home/author). |

---

## References

- Commissioned by: https://github.com/koad/chiron/issues/1
- Research source: VESTA-SPEC-025, VESTA-SPEC-026, Alice CLAUDE.md, Muse design brief, team operations context
- Delivered by: Alice (kingofalldata.com)
- Progression system: Vulcan — see koad/vulcan for implementation
- Format authority: Vesta (VESTA-SPEC-025)

---

**Signature:**
```
(Pending — Chiron to sign with ed25519 key on first delivery)
```
Signed by: chiron@kingofalldata.com
