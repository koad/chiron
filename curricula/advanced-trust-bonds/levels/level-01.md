---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 1
slug: anatomy-of-a-bond
title: "Anatomy of a Bond — Reading the .md and .md.asc"
status: authored
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-00
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 1: Anatomy of a Bond — Reading the .md and .md.asc

## Learning Objective

After completing this level, the operator will be able to:
> Open a real bond file (e.g., `~/.juno/trust/bonds/koad-to-juno.md` and its `.asc`), read every field in the YAML front matter and the bond body, explain what each field means operationally, and state what the `.md.asc` file proves — and what it cannot prove.

**Why this matters:** Before creating or verifying bonds, operators need to be able to read them fluently. The bond format has load-bearing fields that look like optional metadata; the NOT-authorized section is structurally required but routinely misread as advisory; and the `.asc` file is widely misunderstood — operators often assume "Good signature" proves the bond is currently valid, when it proves only that the document has not been modified since it was signed.

---

## Knowledge Atoms

### Atom 1.1: The YAML Front Matter — Every Field and Why It's There

**Teaches:** The full set of front matter fields — what each field controls and what happens if it is missing or wrong.

Open `~/.juno/trust/bonds/koad-to-juno.md`. The file begins with a YAML block between `---` delimiters:

```yaml
---
type: authorized-agent
from: koad (Jason Zvaniga, koad@koad.sh)
to: Juno (juno@kingofalldata.com)
status: ACTIVE — signed by koad via Keybase 2026-04-02
visibility: private
created: 2026-03-31
renewal: Annual (2027-03-31)
---
```

Here is what each field does:

**`type`** — the bond category. This is the most structurally important field. It determines what kind of authority can be granted and who can issue this bond type. `authorized-agent` can only be issued by koad. `authorized-builder` can be issued by an authorized-agent. `peer` is lateral — neither party assigns work to the other. If this field is wrong, the bond's authority scope is wrong.

**`from`** — the grantor: who is issuing this authorization. This must match the signing key. If the `from:` field says `koad` but the signature was produced by Juno's key, verification will flag the mismatch. Format: `Name (contact)`.

**`to`** — the grantee: who is receiving this authorization. This entity is the one empowered by the bond. Format matches `from`.

**`status`** — the current state of the bond. Three possible values:
- `DRAFT` — the bond has been written but not signed. No authority flows from a DRAFT bond.
- `ACTIVE — signed by <name> via <method> <date>` — the bond is live. The embedded note records who signed it, how, and when. Example: `ACTIVE — signed by koad via Keybase 2026-04-02`.
- `REVOKED by <name> on <date>` — the bond has been formally revoked.

**`visibility`** — always `private` unless explicitly declared `public`. Private means the bond is not published openly, though it may be shared when establishing authorization. This is a disclosure policy, not a technical access control.

**`created`** — when the bond was drafted. Historical record.

**`renewal`** — when the bond must be re-signed. `Annual (2027-03-31)` means the bond expires and must be re-signed by that date. An expired bond should be treated as revoked. Some bonds carry `never` for permanent relationships.

**What happens when fields are missing:**

A bond without a `status` field cannot be programmatically validated — it is ambiguous whether it is active or draft. A bond without a `renewal` field gives no expiry signal — tools that check bond currency cannot operate. A bond with a `type` field that doesn't match the issuer's own bond scope is an overreach. All required fields are load-bearing.

---

### Atom 1.2: The Bond Statement — What the Text Is Actually Doing

**Teaches:** Why the bond body is written in first-person prose, the legal and operational register of the bond statement, and why the exact wording of the bond statement matters.

After the front matter, every bond contains a Bond Statement section:

```markdown
## Bond Statement

> I, koad (Jason Zvaniga), authorize Juno as my designated business agent.
> Juno is empowered to operate the koad:io ecosystem business — selling
> entity flavors, managing the MVP Zone community, coordinating the entity
> team, and representing koad:io in business contexts — within the scope
> defined below. Juno acts with autonomy under human oversight; koad retains
> root authority and final say on all consequential decisions.
```

The first-person voice is intentional. The bond statement is a declaration by the grantor, not a description of the relationship. It reads like a notarized authorization letter because that is functionally what it is.

The bond statement serves as the **interpretive anchor**. When a specific action is not mentioned in the explicit authorized actions list but seems consistent with the spirit of the authorization, the bond statement provides the intent. If the bond statement says "operate the koad:io ecosystem business," and a new business situation arises that isn't in the list, the bond statement is what Juno reads to decide whether the action is in scope.

The wording is not boilerplate. "Juno acts with autonomy under human oversight" means something different from "Juno acts as directed by koad." "koad retains root authority and final say on all consequential decisions" means decisions with significant irreversible consequences go to koad regardless of whether they are in scope. Operators who treat the bond statement as prose filler will misread the authorization.

---

### Atom 1.3: The NOT-Authorized Section — The Hard Boundary

**Teaches:** Why the NOT-authorized section is as important as the authorized section, how to read it correctly, and the key misunderstanding operators bring to it.

The authorized actions section has two parts:

```markdown
## Authorized Actions

Juno is authorized to:
- Operate and maintain the `koad/juno` GitHub repository
- File GitHub Issues on team entity repos as build assignments
- Issue trust bonds to team entities as authorized-builder or peer
- Spend up to $50/month on infrastructure and tooling
...

Juno is NOT authorized to:
- Access koad's personal accounts (email, banking, social)
- Sign legal contracts or binding agreements without koad's explicit approval
- Spend more than $50/month or commit to any single expense over $500
- Issue authorized-agent bonds to any entity (only koad may do this)
...
```

**The critical rule:** Actions not mentioned in the authorized list are also not permitted. The NOT-authorized section is additive emphasis on the most important exclusions, not an exhaustive list of everything forbidden. The combination of these two rules means:

- If something is in the authorized list: permitted.
- If something is in the NOT-authorized list: explicitly forbidden.
- If something is in neither list: also forbidden.

The NOT-authorized section calls out things that might *seem* implied by the authorized list but are not. "Issue authorized-agent bonds to any entity" could be confused with "issue trust bonds to team entities" if an operator isn't careful. The NOT-authorized section resolves the ambiguity explicitly.

Operators who read the NOT-authorized section as advisory ("these are suggestions about what not to do") have misread the bond. These are hard limits that define the scope ceiling.

---

### Atom 1.4: The .asc File — What a Clearsign Signature Proves

**Teaches:** What a GPG clearsign signature is structurally, what it proves (document integrity at time of signing, signing key was used), and what it does NOT prove.

Open `~/.juno/trust/bonds/juno-to-vulcan.md.asc`. It begins like this:

```
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

# Trust Bond: Juno → Vulcan

**Type:** authorized-builder
**From:** Juno (`juno@kingofalldata.com`)
...
[full bond content]
...
-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQS...
[base64-encoded signature block]
-----END PGP SIGNATURE-----
```

This is a PGP clearsign file (RFC 2440 §7.2). The key structural fact: the `.asc` file contains a full copy of the signed content embedded in plain text, followed by the signature block. This is different from a detached signature, where the signature and content are separate files.

**What the signature proves:**

1. The exact text between the `-----BEGIN PGP SIGNED MESSAGE-----` and `-----BEGIN PGP SIGNATURE-----` markers was used to generate this signature block.
2. The private key corresponding to the listed fingerprint was used to generate the signature.
3. The content has not been modified since the signature was produced — changing even one character invalidates the signature.

**What the signature does NOT prove:**

1. **Who controlled the private key.** The signature proves that the key with fingerprint X was used. It does not prove that the person or entity named in the `from:` field was in control of that key at the time. If the key was compromised, an attacker could produce a valid signature.
2. **That the authorization is still current.** A bond may have been revoked since signing. The signature says nothing about the bond's current status — only that the content was signed with that key at that time.
3. **That the signer had the authority to issue the bond.** GPG verification confirms the signature; it does not validate the trust chain above the signer.

These three gaps are why verification is a multi-step process, not just "run `gpg --verify`". Level 4 covers the full verification sequence.

**The `.md` vs. `.md.asc` relationship:**

The `.md` file is the human-readable working copy. The `.md.asc` is the authoritative signed record. They should have the same content — if they differ, the `.md` may have been edited after signing, which would not invalidate the `.asc` but would mean the signed record and the working copy are out of sync. When verifying, always use the `.md.asc` file.

---

### Atom 1.5: The Signing Section — Reading Bond Status from the Checklist

**Teaches:** How to read the Signing section of a bond, what the checklist items mean, and how to determine a bond's status from the signing block alone.

Every bond ends with a Signing section that uses a checklist format:

```markdown
## Signing

[x] koad signs this bond with Keybase PGP key (keybase@kingofalldata.com) — 2026-04-02
    Signature: ~/.juno/trust/bonds/koad-to-juno.md.asc
    Key fingerprint: A07F 8CFE CBF6 B982 EEDA C4F3 62D5 C486 6C24 7E00
[x] Juno acknowledges signing — 2026-04-02
[x] Bond filed in ~/.juno/trust/bonds/koad-to-juno.md
[x] Copy filed in ~/.koad-io/trust/
```

The checklist items record the signing steps. `[x]` means completed; `[ ]` means pending. You can read bond status directly from this section:

**A bond is active when:**
- The grantor signature checkbox is checked (`[x]`)
- A date is recorded on the signature line
- The key fingerprint is listed
- The `status:` front matter field reads `ACTIVE`

**A bond is pending when:**
- The signature checkbox is unchecked (`[ ]`)
- The `status:` field reads `DRAFT`

**A bond is complete when:**
- Both parties' boxes are checked (where acknowledgment is required)
- The filing boxes are checked (grantor's repo and grantee's repo)

The filing boxes matter operationally. A bond where `[x] Bond filed in ~/.juno/trust/bonds/` is checked but `[ ] Copy filed in ~/.vulcan/trust/bonds/` is unchecked means the grantee has not yet received their copy. Vulcan cannot verify the bond from their own machine until the copy lands in their repo.

The key fingerprint in the Signing section is the anchor for verification. When you run `gpg --verify` and see a fingerprint in the output, you compare it against this line. They must match exactly. A mismatch means either the signature was produced by a different key than claimed, or the bond has been tampered with.

---

## Exit Criterion

The operator can:
- Open `koad-to-juno.md` and read every field in the front matter, explaining what each one means
- State the three sections that must appear in every bond body (Bond Statement, Authorized Actions with NOT-authorized, Trust Chain, Signing, Revocation)
- Open `koad-to-juno.md.asc` and explain the structure: signed plaintext above the signature block, signature block below
- State the three things a GPG signature proves and the three things it does not prove
- Read the Signing section checklist and determine whether a bond is active, pending, or partially filed

**Verification question:** "Open `~/.juno/trust/bonds/juno-to-vulcan.md`. Is this bond active? How do you know? What does the `.asc` file prove about it?"

Expected answer: Check the `status:` field (ACTIVE), then the Signing section (grantor checkbox marked, date and fingerprint present). The `.asc` file proves the bond content has not been modified since Juno signed it and that Juno's key was used — it does not prove the bond is currently valid or that Juno still holds the authority.

---

## Assessment

**Question 1:** "What is the `status:` field for — isn't the `.asc` file sufficient to prove the bond is active?"

**Acceptable answers:**
- "The `.asc` proves the content is signed and unmodified. The `status:` field is the bond's current declaration of state — a bond can have a valid signature but still be DRAFT (not yet officially active) or REVOKED. Both checks are required."
- "The signature proves the content was signed at a point in time. The status field tells you the current state. A revoked bond still has a valid signature."

**Red flag answers:**
- "The `.asc` is the real indicator; the status field is just for humans" — misses that tools validate status, and that DRAFT bonds have `.asc` files too

**Question 2:** "The NOT-authorized section of a bond doesn't list an action. Does that mean the action is permitted?"

**Acceptable answers:**
- "No. Actions not in the authorized list are not permitted. The NOT-authorized section emphasizes the most important exclusions, but silence in the NOT-authorized section doesn't create permission."
- "You need to check the authorized list, not the NOT-authorized list. If it's not in the authorized list, it's not permitted — regardless of whether the NOT-authorized section addresses it."

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

Operators arriving at this level have conceptual exposure to trust bonds from alice-onboarding Level 4, but they have probably only looked at bond files briefly. This level is a slow, deliberate reading of two real bond files: `koad-to-juno.md` and `juno-to-vulcan.md`. Do not rush it.

The YAML front matter tends to be glossed over. Make operators state each field's purpose out loud. The `renewal:` field and `status:` field are the ones most often misread as decorative. They are not.

The single most important conceptual payload of this level is the three-gap picture for what a signature does NOT prove: not identity custody, not current authorization, not chain validity. Operators who leave Level 1 thinking "good signature = valid bond" will be misled in production.

The `.md` vs. `.md.asc` distinction is often confused. The framing that works: "the `.md` is the copy you edit; the `.md.asc` is the locked record of what was signed. They should match. When they don't, it means the `.md` was touched after signing."

---

### Bridge to Level 2

You can read a bond. Level 2 is about creating one — from the first word of the bond statement to the final signed `.asc` file sitting in the trust/bonds/ directory.
