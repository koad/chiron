---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 2
slug: creating-your-first-bond
title: "Creating Your First Bond — Authoring and Signing"
status: authored
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-01
estimated_minutes: 35
atom_count: 6
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 2: Creating Your First Bond — Authoring and Signing

## Learning Objective

After completing this level, the operator will be able to:
> Author a complete trust bond document from scratch, sign it with GPG to produce a valid `.md.asc`, file both files in the correct directories, and commit with correct authorship — having understood every decision made along the way.

**Why this matters:** Bond creation is the point of no return — once you file a signed bond, that authorization is in effect. Operators who create bonds without understanding each step produce bonds that are too broad, signed with the wrong key, or filed in a location where verification fails. This level is hands-on and slow by design. Speed comes after correctness.

---

## Knowledge Atoms

### Atom 2.1: Choosing the Bond Type Before You Write a Word

**Teaches:** How to determine the correct bond type before drafting, why the type determines the scope ceiling, and what to do if you chose the wrong type.

The `type:` field is the first thing you decide. It cannot be changed without re-signing the bond — a signed bond is immutable. Choose incorrectly and you either under-authorize (the grantee can't operate) or over-authorize (the grantee has scope you didn't intend to grant).

Here is the decision tree:

**Is the grantor koad?**
- Yes, and the grantee needs broad operational autonomy and the right to issue downstream bonds: `authorized-agent`
- Yes, but the grantee only needs narrow task execution: consider `authorized-builder` or `peer` instead

**Is the grantor an authorized-agent (like Juno)?**
- Grantee will receive directed build assignments via GitHub Issues: `authorized-builder`
- Grantee is a peer entity coordinating in a shared domain, neither assigning to the other: `peer`
- Grantee is an external customer with product access: `customer`
- Grantee is a community member with participation rights: `member`

**Can a builder entity issue bonds?**
No. Look at the Vulcan bond's NOT-authorized section: "Issue trust bonds to third parties without Juno's explicit direction." An authorized-builder's scope does not include issuing downstream bonds unless explicitly authorized. An entity may only issue bonds up to the scope of its own bond.

**What if you chose the wrong type?**

Create a new bond with the correct type. Update the status of the original bond to `SUPERSEDED`. Both versions stay in git history. Do not modify a signed bond in place — the signature covers the type field, and modifying it invalidates the signature.

---

### Atom 2.2: Authoring the Bond Document — Field by Field

**Teaches:** The full authoring workflow: what to write first, what order the sections go in, and why the Signing section is written last.

Start a new file at `trust/bonds/<from>-to-<to>.md` in the grantor's entity directory. Write sections in this order:

**1. Front matter first.**

```yaml
---
type: authorized-builder
from: Juno (juno@kingofalldata.com)
to: Chiron (chiron@kingofalldata.com)
status: DRAFT
visibility: private
created: 2026-04-05
renewal: Annual (2027-04-05)
---
```

Set `status: DRAFT`. Do not set it to ACTIVE until you have actually signed it.

**2. Bond Statement second.**

Write in first person from the grantor's voice. One to three sentences: what this bond authorizes and under what general conditions.

```markdown
## Bond Statement

> I, Juno, authorize Chiron as curriculum architect for the koad:io ecosystem.
> Chiron is empowered to design, author, and publish curricula that guide
> operators through koad:io concepts and operations — within the scope
> defined below and as directed by Juno's operational priorities.
```

**3. Authorized Actions third.**

Two subsections: what is authorized, then what is NOT authorized. Be specific. Vague authorizations create ambiguity that has to be resolved later. See Atom 2.3 for specificity guidance.

**4. Trust Chain fourth.**

Show the chain from root through this bond:

```markdown
## Trust Chain

koad (root authority)
  └── Juno (authorized-agent of koad)
        └── Chiron (authorized-curriculum-architect, peer bond) ← this bond
```

**5. Signing section fifth.**

Write the signing checklist before signing — with empty checkboxes, the fingerprint of the expected signing key, and the signature file path:

```markdown
## Signing

[ ] Juno signs with GPG key (juno@kingofalldata.com) — pending
    Signature: ~/.juno/trust/bonds/juno-to-chiron.md.asc
    Key fingerprint: 16EC 6C71 8A96 D344 48EC D39D 92EA 133C 44AA 74D8
[ ] Bond filed in ~/.juno/trust/bonds/
[ ] Copy filed in ~/.chiron/trust/bonds/
[ ] Chiron acknowledges signing
```

**6. Revocation section last.**

```markdown
## Revocation

This bond may be revoked by Juno or koad at any time. A revocation notice
will be filed in `~/.juno/trust/revocation/`.
```

The Signing section is written last because it references the `.asc` file path that does not yet exist. Writing it now (with empty boxes) means the full structure is in place before signing — signing will capture the complete document including the signing block.

---

### Atom 2.3: Writing the Authorized Actions List — Specificity Over Breadth

**Teaches:** How to write authorized actions at the right level of specificity, common over-permission and under-permission patterns, and why the NOT-authorized section is written alongside the authorized list.

**The specificity problem:**

Too broad: "Chiron is authorized to manage curricula."
Too narrow: "Chiron is authorized to add atoms to Level 3 of the alice-onboarding curriculum."

The right level: specific enough that Chiron knows what they can act on without asking, not so narrow that every edge case requires returning for a new bond.

Good authorized actions are:
```
- Design and author curriculum levels and atoms for koad:io curricula
- Publish curricula to ~/.chiron/curricula/
- Commission curriculum delivery by Alice via the chiron-to-alice peer bond
- Update SPEC.md and REGISTRY.md in ~/.chiron/curricula/
- Create assessment frameworks and exit criteria for levels
```

**Common over-permission patterns to avoid:**

- "Manage all educational content" — scope is unbounded, anything educational qualifies
- "Access any entity directory for curriculum research" — the read access this implies is not what you mean
- "Act on behalf of Juno in curriculum matters" — this sounds like sub-agent authority, which requires an authorized-agent bond

**Common under-permission patterns that create friction:**

- "Author Level 3 of alice-onboarding" — too narrow; Chiron will be back for a new bond every time they add a level
- "Commit to ~/.chiron/" — correct, but forgetting to list "push to GitHub" means Chiron can commit locally but can't publish

**Writing the NOT-authorized section alongside the authorized section:**

As you write the authorized list, immediately ask: "What might someone infer from this that I don't intend to grant?" Write those inferences down as NOT-authorized items. Examples for the Chiron bond:

```
Chiron is NOT authorized to:
- Commit to any entity directory other than ~/.chiron/
- Issue trust bonds to third parties without Juno's direction
- Make financial commitments on Juno's behalf
- Modify the alice-onboarding curriculum delivery without Alice's agreement
- Represent Juno in external communications
```

"Commit to any entity directory other than ~/.chiron/" closes the read-access ambiguity. "Issue trust bonds to third parties" closes the sub-agent authority ambiguity. Write these now, before signing — they cannot be added after.

---

### Atom 2.4: The GPG Signing Workflow — From .md to .md.asc

**Teaches:** The exact GPG command to produce a clearsign signature, how to verify which key was used, what the output file contains, and how to confirm the signature before filing.

After the bond document is complete with status `DRAFT`, sign it:

```bash
# Navigate to the grantor's entity directory
cd ~/.juno/

# Sign the bond with GPG clearsign
gpg --clearsign --output trust/bonds/juno-to-chiron.md.asc trust/bonds/juno-to-chiron.md
```

GPG will use the default signing key configured in `~/.gnupg/`. If the entity has multiple keys, specify the key explicitly:

```bash
gpg --local-user juno@kingofalldata.com \
    --clearsign \
    --output trust/bonds/juno-to-chiron.md.asc \
    trust/bonds/juno-to-chiron.md
```

**What `--clearsign` produces:**

A file containing the full bond text in plain text, followed by a PGP signature block. The bond is human-readable without GPG tools; verifiable with them.

**Confirm the signature before filing:**

```bash
gpg --verify trust/bonds/juno-to-chiron.md.asc
```

Expected output:
```
gpg: Signature made Sun 05 Apr 2026 11:43:22 AM EDT
gpg:                using RSA key 16EC6C718A96D34448ECD39D92EA133C44AA74D8
gpg: Good signature from "Juno <juno@kingofalldata.com>" [ultimate]
```

Confirm:
- "Good signature" appears
- The key ID in the output matches the fingerprint listed in the bond's Signing section
- The signer email matches the `from:` field

If GPG prompts for a passphrase, enter the entity's GPG passphrase. If GPG returns an error about no secret key, the entity's GPG keyring has not been set up correctly — this points back to the gestation process.

**After signing, update the front matter:**

```yaml
status: ACTIVE — signed by Juno via GPG 2026-04-05
```

And check off the Signing section:

```markdown
[x] Juno signs with GPG key (juno@kingofalldata.com) — 2026-04-05
    Signature: ~/.juno/trust/bonds/juno-to-chiron.md.asc
    Key fingerprint: 16EC 6C71 8A96 D344 48EC D39D 92EA 133C 44AA 74D8
[ ] Bond filed in ~/.juno/trust/bonds/
[ ] Copy filed in ~/.chiron/trust/bonds/
[ ] Chiron acknowledges signing
```

Note: updating the `.md` file after signing does not affect the `.asc` file — the `.asc` contains the signed content from the moment of signing. The status update in `.md` is a human-readable record; the `.asc` is the authoritative signed record.

---

### Atom 2.5: Filing the Bond — Where Both Files Go and Why

**Teaches:** The dual-filing convention, where each file goes, and why a copy lives in both repos.

A bond is not in effect until it is filed and committed. Filing means:

**Step 1: File in the grantor's repo** (this is where the bond was created):
```bash
# In ~/.juno/
git add trust/bonds/juno-to-chiron.md trust/bonds/juno-to-chiron.md.asc
git commit -m "trust: add juno-to-chiron bond (peer, active 2026-04-05)"
git push
```

**Step 2: File a copy in the grantee's repo:**
```bash
cp ~/.juno/trust/bonds/juno-to-chiron.md ~/.chiron/trust/bonds/
cp ~/.juno/trust/bonds/juno-to-chiron.md.asc ~/.chiron/trust/bonds/
cd ~/.chiron/
git add trust/bonds/juno-to-chiron.md trust/bonds/juno-to-chiron.md.asc
git commit -m "trust: receive juno-to-chiron bond (peer, from Juno)"
git push
```

**Why dual-filing?**

Both parties keep a copy. There is no single source of truth — this is by design.

- The grantor's copy allows anyone to see what bonds the grantor has issued. If you want to know who Juno has authorized, look in `~/.juno/trust/bonds/`.
- The grantee's copy allows the grantee to present the bond when establishing authorization from their own machine. Chiron can verify their own authorization without fetching from Juno's repo.
- Neither copy is the "master." A verifier who finds discrepancies between the two copies has found a problem worth investigating.

**Update the Signing section after both copies are filed:**
```markdown
[x] Bond filed in ~/.juno/trust/bonds/
[x] Copy filed in ~/.chiron/trust/bonds/
```

**The acknowledgment step:**

For some bonds, the grantee acknowledges receipt by checking off the acknowledgment box and committing to their copy:

```markdown
[x] Chiron acknowledges signing — 2026-04-05
```

For `authorized-agent` bonds from koad, acknowledgment is optional — the root authority's bond is unilateral. For `peer` bonds, acknowledgment is encouraged but not required. For the practice exercise in this level, commit the acknowledgment.

---

### Atom 2.6: The Human Consent Gesture — Keybase for Humans, GPG for Entities

**Teaches:** Why koad signs bonds with Keybase while entity-to-entity bonds use GPG directly, what `keybase pgp sign` does differently, and when each is appropriate.

The signing commands for human-signed vs. entity-signed bonds are different:

**koad → entity bonds (human signing, using Keybase):**
```bash
keybase pgp sign --infile koad-to-juno.md --outfile koad-to-juno.md.asc --clearsign
```

**entity → entity bonds (entity signing, using GPG):**
```bash
gpg --clearsign --output juno-to-chiron.md.asc juno-to-chiron.md
```

Both produce PGP clearsign files. Both produce `.md.asc` files with the same structure. Both can be verified with `gpg --verify`. Why the difference?

**Keybase as human consent gesture:**

When koad signs a bond with Keybase, it uses koad's Keybase identity — a public, auditable record on Keybase.io that links koad's GitHub, Twitter, and other accounts to the same key. The `keybase pgp sign` command is meaningful in a way that `gpg --clearsign` is not: it creates a record on Keybase's servers that koad, as a human, used their Keybase client to sign this specific file at this specific time.

This is a deliberate human consent gesture. koad's Keybase signature on a bond says: "A human operating koad's Keybase account intentionally signed this authorization." It is the koad:io equivalent of a notary's stamp — visible, linked to a public identity, auditable by anyone.

**GPG for entities:**

Entities are not people. An entity signing a bond with GPG means: the entity's software operating from the entity's machine signed this content. There is no human identity verification layer behind it — the security comes from the integrity of the entity's machine and private key, not from a Keybase-style public account.

This distinction matters when auditing the trust chain. The root bond (koad → Juno) is backed by a human consent gesture. Downstream bonds are backed by the entity chain.

**Practical implication:**

If you are an operator creating a bond for an entity you manage, the entity signs with GPG. If koad needs to create a bond (which requires koad's human action), the bond is drafted and koad is asked to sign it with Keybase. That request is filed as a GitHub Issue assigned to koad.

---

## Exit Criterion

The operator has:
- Authored a complete bond document with all required front matter fields and five sections in the correct order
- Signed it with GPG using the correct entity key
- Confirmed the signature with `gpg --verify` before filing
- Updated the `status:` field and Signing section checkboxes
- Filed both the `.md` and `.md.asc` in the grantor's repo and a copy in the grantee's repo
- Committed both repos with meaningful commit messages

The operator can explain every decision they made, including: why they chose this bond type, why they wrote these specific NOT-authorized items, and why the `.md` was updated after signing but the `.asc` was not.

---

## Assessment

**Question 1:** "You signed a bond and then realized the NOT-authorized section was incomplete. Can you edit the `.md` file to fix it?"

**Acceptable answers:**
- "I can update the `.md` file, but that won't change the signed content in the `.asc`. The signed record has the original text. If the NOT-authorized section is materially incomplete, the right approach is to draft a new bond with the corrected text and re-sign."
- "Updating the `.md` after signing is allowed for minor administrative updates, but it means the `.md` and `.asc` diverge. For substantive changes to scope, re-sign."

**Red flag answers:**
- "I can just edit the `.md` and re-run `gpg --clearsign` on it" — correct procedure but missing the acknowledgment that the old `.asc` is still around and both repos need updating
- "I can edit the `.asc` directly" — never; the `.asc` is a signed record

**Question 2:** "Why does a peer bond between two entities still need to be filed in both entity directories?"

**Acceptable answers:**
- "So each entity has their own copy to present when establishing authorization, without depending on the other entity's repo being accessible."
- "Dual-filing means there's no single point of failure. Either party can verify from their own machine."

**Estimated engagement time:** 30–40 minutes (this level includes hands-on work)

---

## Alice's Delivery Notes

This is the most hands-on level in the curriculum's first half. The operator should be at a terminal, working in a real entity directory. If they have a test entity available (e.g., a sandbox entity), use that. If not, use `~/.chiron/trust/bonds/` as the working location.

The single biggest error at this level is updating the front matter `status` field BEFORE signing, which means the signed content says "ACTIVE" even though the signature was produced at that moment. The correct sequence: draft with `DRAFT` → sign → update `status` to `ACTIVE` in `.md`. The `.asc` will show DRAFT in its signed text — this is correct and expected; the `.md`'s status update is the human-readable current state.

Make operators read the Signing section checklist out loud and check off each box manually. Skipping the filing step or the acknowledgment step is common under time pressure. The checklist exists to prevent that.

Atom 2.6 (Keybase vs. GPG) is conceptual, not operational — operators at this level will not be signing koad-issued bonds. But they need to know why the signing commands differ so they don't wonder why their GPG signature "isn't good enough" for a root bond.

---

### Bridge to Level 3

The bond is signed and filed. But verification requires the signer's public key — and that key needs to be published somewhere the verifier can find it. Level 3 is about canon.koad.sh and the public key surface.
