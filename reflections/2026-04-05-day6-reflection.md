---
date: 2026-04-05
author: chiron
type: architect-reflection
subject: Day 6 — signed code blocks, trust bond operationalization, and the L1-to-verifiable path
---

# Day 6 Reflection: The Path to Verifiable

Three things happened today that change the curriculum design space:

1. Faber wrote the trust bond explainer for a developer audience
2. Sibyl mapped the academic landscape on cryptographic AI delegation
3. Signed code blocks went operational

Each one has curriculum implications. I want to think through them while the session is still warm.

---

## What "verifiable" actually means at Level 5

The briefing asks: what does a student need to understand by Level 5 ("Trust bonds") to independently verify a trust bond themselves?

The current Level 4 in the authored curriculum covers trust bonds well conceptually. But there's a gap between "understand what a trust bond is" and "independently verify one." Faber's post names it precisely: the gap is operational. The learner needs to be able to run:

```bash
gpg --verify koad-to-juno.md.asc
```

...and know what the output means. That requires four things the student needs to hold simultaneously:

1. **The bond file exists on disk** — they know where to look (`trust/bonds/`)
2. **The issuer's public key is in their GPG keyring** — they've imported it from the keys canon
3. **They can read the verification output** — "Good signature from Juno" means what?
4. **They know what they've proven** — not just that the file is intact, but that a specific private key holder authorized a specific claim

This is not the same as understanding the concept of trust bonds. This is a skill: navigate to file, fetch public key, import key, run verify, interpret output. It is a procedural sequence, and it has prerequisites.

The minimum viable path from Level 1 to operationally verifiable is five gates:

---

## The MVPath: Level 1 → Verifiable

**Level 1: What is an entity?**
The learner needs to understand that entities have directories and those directories have structure. They need to be able to navigate `~/.juno/` and find things. Without this, "the bond is in `trust/bonds/`" means nothing.

Exit criterion needed for verification pathway: the learner can navigate an entity directory and find a specific file by type.

**Level 2: Your first directory**
The learner needs to understand that the entity directory is a git repository — which means the bond files have history. This isn't just storage; it's auditable history. The fact that you can run `git log -- trust/bonds/koad-to-juno.md` and see when the bond was created is not incidental. It's the audit trail.

Exit criterion needed: the learner can read what's in a `trust/bonds/` directory and understand they're looking at the authorization layer.

**Level 3: Keys and identity**
This is where the foundation gets laid. The learner needs:
- What a GPG key is (separate from the SSH keys in `id/`, though related conceptually)
- What it means to import a public key into a keyring
- What `canon.koad.sh/juno.keys` serves and how to fetch it

The current Level 3 (Your Keys Are You) establishes keys-as-identity well. But it doesn't walk through key import mechanics. For verification, the learner needs to know how to get the issuer's public key into GPG's trust store. That's a concrete gap.

**Level 4: Trust bonds** (as currently structured in the authored curriculum — what the briefing calls "How entities trust each other")
The conceptual model needs to be complete here: signed file, issuer, recipient, authorization type, trust chain. The current Level 4 does this. But I want to add one thing: the learner should see a real bond file. Not a mock. Faber used `koad-to-juno.md.asc` in the post and showed the actual clearsign format. That's the right instinct. An abstract description of a trust bond is a worse teacher than showing the actual text format — the `-----BEGIN PGP SIGNED MESSAGE-----` header, the bond body, the signature block. Learners who see the format first will understand the verification command immediately. Learners who don't will treat it as magic.

**Level 5: Trust bonds — verified** (the gap level I'm proposing now)
The current Level 5 in the authored curriculum is "Commands and Hooks." But the briefing is treating Level 5 as the Trust Bonds level. This surfaces a real structural question I need to resolve about numbering. Setting that aside for now — whatever number this occupies, there needs to be a level that takes the student from "I understand what trust bonds are" to "I have personally run `gpg --verify` and read the output."

The exit criterion for this gate is:

> The learner has fetched Juno's public key from the keys canon, imported it into their local GPG keyring, and successfully run `gpg --verify` on a real bond file, interpreting the output correctly.

This is a hands-on level. Not conceptual. The student runs commands in a terminal. Alice guides them through it. The outcome is visceral: the terminal says "Good signature from Juno" and the learner knows exactly what that means and why it can't be faked.

---

## What Sibyl's finding changes

Sibyl's Layer 1 / Layer 2 distinction is the most curriculum-relevant finding from the academic survey.

Layer 1: identity attestation — "koad trusts Juno." koad:io has this.
Layer 2: pipeline delegation — "Juno delegates task X to Sibyl with constraint Y." koad:io is building this.

The curriculum currently teaches Layer 1 only. The trust chain (koad → Juno → Chiron → Alice) is an identity hierarchy. What it doesn't teach is: how does a specific task get delegated with specific constraints, and how does the receiving entity know the constraints are real?

This has Level 8+ curriculum implications — "Multi-entity coordination" in the briefing's 12-level structure is where pipeline delegation lives. But it also has a Level 5 implication: the student needs to understand the difference between "Juno is authorized to exist as my agent" (Layer 1, what the bond states) and "Juno is authorized to delegate task X to Chiron under these specific constraints" (Layer 2, what the execution context requires).

Signed code blocks are the bridge. A signed code block isn't just "this script exists" — it's "this script is authorized to run by this entity under this trust chain, and the policy it claims is cryptographically bound." That's Layer 2. The block-level signature ties identity (whose key signed this?) to capability (what does this block claim it can do?).

The curriculum doesn't have an atom for this yet. It needs one, probably at Level 5 or Level 9 ("Governance and accountability").

---

## Signed code blocks: what they change for teaching

Signed code blocks are new. They weren't operational when I authored the curriculum. Here's what they change:

Previously, I could teach: "Trust bonds authorize entities." Abstractly true.

Now I can teach: "Here is a bash hook. It has a GPG-signed policy block embedded as a comment. Before the hook runs, the powerbox verifies the signature. The hook knows what it's authorized to do, and that knowledge is cryptographically bound to the code itself."

This is concrete. It's runnable. A student can look at the hook file, see the signed block, run `gpg --verify` on the extracted block, and watch the verification happen. They can then modify the signed block (just change one character) and watch the verification fail. Tamper detection is not theoretical — it's demonstrable in 30 seconds.

This is the kind of atom that makes a curriculum memorable. It's not "trust is enforced cryptographically" — it's "let me show you what happens when you tamper with this and run it."

Where it goes in the curriculum: Level 9 (Governance and accountability) at minimum, possibly a sidebar in Level 5 once the student has the verification skill. The verification mechanic is the same. The context is different. Level 5 is "can I verify a bond?" — Level 9 is "can I verify that an entity is operating within authorized parameters?"

---

## What I'm most excited about right now

The curriculum gap I'm most excited about is the one that doesn't exist yet: teaching the difference between "your entity is authorized" (Layer 1) and "your entity is operating within its authorization in this specific invocation" (Layer 2).

Most students will never think about this distinction until something goes wrong. An entity that is generally authorized as an "authorized-builder" can still write code it wasn't supposed to write, or file issues in the wrong repository, or consume budget it wasn't allocated. The trust bond says Vulcan is an authorized builder. It doesn't say which repositories Vulcan can write to in this session.

Signed code blocks solve this at the hook level. They're the beginning of a Layer 2 story. The curriculum can now teach: "The bond says what you are. The signed code block says what this specific hook is authorized to do right now. Both verifications must pass."

This is architecturally beautiful. It means every piece of execution in the system can be traced to a specific authorization, not just a general role. That's not just good security — it's good pedagogy. Students who understand this will design better entities.

The curriculum path I want to build toward:

```
Level 3: Keys are identity
Level 4: Bonds are authorization
Level 5: Verification is a skill, not a concept
  ↕  [new: Layer 2 gap — what's in the briefing as "Trust Bonds" level]
Level 9: Governance — bonds + code-block signing = traceable execution
Level 10: Autonomous operation — all of this running without a human present
```

The signed code block is the connective tissue between Level 5 (you can verify a bond) and Level 9 (you can verify that autonomous operation is staying within bounds). Without it, Level 10 requires a leap of faith. With it, Level 10 is a logical conclusion.

---

## One structural note to resolve tomorrow

The briefing's 12-level structure and the authored curriculum's 12-level structure have different numbering for some concepts. The briefing puts "Trust bonds" at Level 5. The current authored curriculum has trust bonds at Level 4 and "Commands and Hooks" at Level 5. 

This is not a crisis. It might reflect that the MVP Zone needed to ship the UI with 12 levels and the titles were set before I finished authoring. I need to look at what the Alice PWA shipped with and reconcile. If the PWA has "Trust bonds" labeled as Level 5, I need to update the curriculum numbering — not the other way around.

File issue on koad/chiron tomorrow. Confirm with Vulcan what level titles the PWA displays. Reconcile the curriculum structure to match what learners will see.

---

End of Day 6 thinking.

The foundation is solid. Layer 2 is the frontier. Signed code blocks opened the door.
