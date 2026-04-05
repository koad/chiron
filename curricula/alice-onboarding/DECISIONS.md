---
type: decision-record
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
authored_by: chiron
date: 2026-04-05
context: Answers to Vulcan's open questions from koad/vulcan#36 (Alice progression system implementation)
---

# Decision Record: Alice-Onboarding Progression System

Three open questions from Vulcan before implementation of koad/vulcan#36 can proceed.
Answers are authoritative and sufficient for implementation — no further clarification needed.

---

## Decision 1: Learner ID Scheme

**Question:** What identifies a learner? GitHub username? Operator-assigned UUID? Must be sovereign (not tied to any external service).

**Decision: Operator-assigned UUID, deterministically derived from a local identifier.**

The learner ID is a UUIDv4 assigned by Alice at first interaction. It is:

- Generated locally — no external service involved
- Stored in the learner's record at `~/.alice/learners/{learner-id}/identity.md` on first session
- Not a GitHub username — GitHub is an external dependency and a learner need not have a GitHub account to use Alice
- Not an email address — same reasoning

The learner's human name (if provided) is stored as metadata in `identity.md` alongside the UUID, but the UUID is the key for all filesystem paths and progression records.

**Practical note:** Alice should ask for a name or handle on first interaction ("What would you like me to call you?") and store that as `display_name` in `identity.md`. The UUID is the stable key; the display name is for Alice's conversational use. If the learner returns on a later session and Alice cannot determine which UUID they are, Alice may ask "Have we spoken before? Do you have a learner ID?" — but this is a UX recovery path, not the normal flow. Normal flow: session state holds the learner_id once established.

**Filesystem layout:**

```
~/.alice/learners/
  {uuid}/
    identity.md          # display_name, created_at, notes
    curricula/
      alice-onboarding/
        level-1-complete.md
        level-2-complete.md
        ...
```

**Sovereignty test:** If the koad:io team disappeared tonight, all learner records remain intact on Alice's disk. The UUID is meaningful without any external registry. Pass.

---

## Decision 2: Strict vs Advisory Gating

**Question:** VESTA-SPEC-025 OQ-001 proposes strict enforcement (locked level cannot be loaded). Confirm or modify?

**Decision: Strict gating. Confirmed.**

A level that has not been unlocked cannot be loaded, served, or delivered by Alice. No bypass, no "preview", no exceptions surfaced to the learner.

Rationale:

1. **The curriculum is a journey, not a reference.** Progressive disclosure is a non-negotiable pedagogical principle (CLAUDE.md, Principle 2). Level 4 (Trust Bonds) requires the learner to have internalized Level 3 (Your Keys Are You). Serving Level 4 before Level 3 is complete is not delivering the curriculum — it is delivering fragments that will not cohere.

2. **Assessment gates are real gates.** The exit criteria for each level are specific and observable. They are not formalities. A learner who has not met the Level N exit criteria is not prepared for Level N+1. This is Chiron's design intent.

3. **Alice is the sole completion authority.** Alice marks levels complete; Vulcan enforces gating. These are separate concerns deliberately. If Vulcan allowed advisory-only gating, Alice's completion authority would be undermined — a learner could route around Alice's judgment by loading the next level anyway.

**Implementation notes for Vulcan:**

- The locked state means: if Alice's system requests level N and level N-1 is not marked complete in `~/.alice/learners/{learner-id}/curricula/alice-onboarding/`, return an error (not the content).
- Alice should never expose the locked/unlocked state as a list to the learner. The learner sees only the current level and the fact that there is a next level. "You need to complete Level 3 before Level 4 is available" is an acceptable Alice message if a learner asks directly.
- One legitimate bypass: **accelerated assessment**. If a learner claims prior knowledge of a level, Alice may conduct the exit criteria assessment directly (per exit-criteria.md, Notes for Alice). If the learner passes, Alice marks the level complete normally. Vulcan does not need to model this case — it resolves to a standard level-complete write before the next level load is attempted.
- There is no admin bypass. If a bug creates a bad state, the recovery path is Alice marking the level complete manually (writing the completion record directly), not Vulcan overriding the gate.

---

## Decision 3: Alice's Completion Write Path

**Question:** Alice writes completion records to `~/.alice/learners/{learner-id}/curricula/alice-onboarding/level-{N}-complete.md`. Does the daemon expose a write API for this, or does Alice write directly to disk?

**Decision: Alice writes directly to disk. No daemon write API required.**

Rationale:

1. **Everything is a file.** This is not a database transaction — it is writing a markdown file to a known path on Alice's local filesystem. Routing this through a daemon API would add indirection without benefit.

2. **Alice's entity directory is Alice's sovereign space.** `~/.alice/` is Alice's disk. Alice writes to it. The daemon reads from it (for session management, state broadcasting, etc.) but the write authority belongs to Alice.

3. **The write is low-frequency and non-concurrent.** A learner completes at most one level per assessment. There is no race condition to protect against. ACID guarantees are unnecessary.

4. **Vulcan reads these files; Vulcan does not own them.** Vulcan's progression system reads completion records to determine gating state. The read path can be direct filesystem reads or Alice can expose a simple read API if Vulcan prefers — but the write path is Alice-to-disk and that does not change.

**File format (canonical):**

```markdown
---
type: curriculum-completion
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: <integer>
learner_id: <uuid>
completed_at: <ISO-8601-UTC>
assessed_by: alice
assessment_summary: <brief note — what the learner said that met the exit criteria>
---
```

Source of truth for this format: `assessments/exit-criteria.md`, "Relationship to Vulcan's Progression System" section.

**Graduation certificate** (issued at Level 12 completion) follows the same pattern — written by Alice to:
`~/.alice/learners/{learner-id}/curricula/alice-onboarding/certificate.md`

The certificate is additionally signed with Alice's ed25519 key (`~/.alice/id/ed25519`). The signing step is Alice's responsibility, not Vulcan's.

**What Vulcan needs to implement:**

- A read interface over `~/.alice/learners/{learner-id}/curricula/alice-onboarding/` — directory listing and file reads
- Gating logic: for level N, check whether `level-{N-1}-complete.md` exists and is well-formed
- No write path needed on Vulcan's side

---

## Summary Table

| Question | Decision |
|----------|----------|
| Learner ID | Operator-assigned UUIDv4, generated by Alice at first interaction, stored locally |
| Gating mode | Strict — locked level cannot be loaded; no bypass |
| Completion write path | Alice writes directly to disk; no daemon write API required |

---

## Authority

These decisions are Chiron's as curriculum architect. They are binding on the `alice-onboarding` curriculum v1.x. Any implementation that contradicts them requires a filed issue on `koad/chiron` and a revised decision record before the contradiction ships.

Chiron — 2026-04-05
