# Exit Criteria: alice-onboarding

**Curriculum:** koad:io Human Onboarding — 12-Level Sovereignty Path  
**Curriculum ID:** a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b  
**Authored by:** Chiron  
**Date:** 2026-04-04  
**Version:** 1.0.0

---

## Overall Curriculum Completion

A learner has completed the `alice-onboarding` curriculum when:

1. All 12 levels have been marked complete by Alice
2. Each level's individual exit criteria have been met (per level files in `levels/`)
3. The learner has articulated the commitment they are making (Level 12, Atom 12.3)
4. Alice has issued a cryptographic mastery certificate signed with Alice's private key

**Alice is the sole authority for marking completion.** Vulcan's progression system enforces level gating (a learner cannot access Level N until Level N-1 is marked complete), but the marking itself is Alice's judgment — not an automated check.

---

## Completion Criteria Per Level

| Level | Title | Exit Criteria Summary |
|-------|-------|----------------------|
| 1 | First Contact — What Is This? | Learner states core problem + files-on-disk idea + sovereignty meaning + AI urgency |
| 2 | What Is an Entity? | Learner names two layers + explains difference + describes gestation + explains "not your keys" |
| 3 | Your Keys Are You | Learner explains private vs. public key + describes `id/` directory + explains keys-as-identity + explains keys canon |
| 4 | How Entities Trust Each Other | Learner defines trust bond + explains file-not-database choice + gives inbound/outbound examples + describes trust chain |
| 5 | Commands and Hooks | Learner distinguishes command vs. hook + names where each lives + describes discovery order + explains hooks-as-training |
| 6 | The Daemon and the Kingdom | Learner describes daemon + defines kingdom + explains passenger.json + distinguishes file vs. live state |
| 7 | Peer Rings | Learner explains peer ring + describes four tiers + explains what ring cannot take + describes portal intuition |
| 8 | The Entity Team | Learner names 5+ entities + traces workflow + explains "entities sell entities" + describes Alice's special position |
| 9 | GitHub Issues Protocol | Learner explains why Issues + traces issue flow + describes well-formed close + explains GitClaw |
| 10 | Context Bubbles | Learner explains context window problem + defines bubble + distinguishes experiential vs. curriculum + explains peer ring sharing |
| 11 | Running an Entity | Learner traces entity lifecycle + explains spawn process + names 3 oversight mechanisms + articulates $200 laptop principle |
| 12 | The Commitment | Learner synthesizes all 12 levels + explains certificate meaning + articulates commitment + names one next step |

---

## What Alice Checks at Graduation

Before issuing the mastery certificate, Alice confirms:

1. **Synthesis:** The learner can describe koad:io in their own words — not reciting the curriculum, but synthesizing it. Look for: sovereignty framing, files-on-disk principle, entities-as-individuals, trust-without-central-server.

2. **Commitment:** The learner has articulated what they are committing to. Not just "I understand" — what will they do differently? What do they hold now that they didn't before?

3. **Forward orientation:** The learner knows at least one next step. Graduation is a beginning. A learner who thinks it is an ending has not completed Level 12.

4. **No red flags:** None of the Level 12 red flag answers ("that sounds right," "you're done now") are present.

---

## What the Certificate Contains

Alice's mastery certificate (issued at Level 12 completion):

```markdown
---
type: curriculum-completion-certificate
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
learner_id: <human-identifier>
completed_at: <ISO-8601-UTC>
assessed_by: alice
certificate_version: 1.0.0
---

CERTIFICATE OF SOVEREIGNTY MASTERY

This certifies that [learner name or identifier]
has completed the koad:io Human Onboarding Curriculum
(12 levels, alice-onboarding v1.0.0)
and has demonstrated understanding of sovereign infrastructure,
entity architecture, trust bonds, and the koad:io operating philosophy.

This learner understands what they have joined.
This learner has made a commitment to sovereign operation.

Signed by: Alice
Date: [completion date]

Verification: canon.koad.sh/alice.keys
```

The certificate is signed with Alice's private key (`~/.alice/id/ed25519`). The signature is the certificate. The document without the signature is a record. The document with Alice's signature is a credential.

---

## Relationship to Vulcan's Progression System

Alice writes a completion record for each level when it is marked complete:

```yaml
---
type: curriculum-completion
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: <integer>
learner_id: <human-identifier>
completed_at: <ISO-8601-UTC>
assessed_by: alice
assessment_summary: <brief note — what the learner said that met the exit criteria>
---
```

Records stored at: `~/.alice/learners/{learner-id}/curricula/alice-onboarding/level-{N}-complete.md`

Vulcan's progression system reads these records. It does NOT write them. Vulcan enforces gating (locked levels) based on what Alice has marked complete. Alice marks complete; Vulcan enforces.

---

## Notes for Alice

- You may conduct an "accelerated assessment" if a learner claims to already know a level's content. Ask the exit criteria questions directly. If they answer correctly, mark the level complete — you do not need to deliver the full atom sequence.
- You may NOT skip the completion marking step for any level, even if the learner insists they already know it.
- If a learner fails the exit criteria for a level, do not mark it complete. Reteach the specific atoms where the learner showed confusion. The level stays in-progress until the exit criteria are genuinely met.
- Trust your judgment. The exit criteria describe observable behaviors and answers. A learner who says the right words without evident understanding is not ready. A learner who explains in different words but clearly grasps the idea is.
