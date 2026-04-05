---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 4
slug: trust-bonds
title: "How Entities Trust Each Other"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2, 3]
estimated_minutes: 35
atom_count: 7
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 4: How Entities Trust Each Other

## Learning Objective

After completing this level, the learner will be able to:
> Describe what a trust bond is, explain why bonds are signed files rather than database records, give an example of an inbound and outbound bond, and articulate what it means for a bond to authorize something.

**Why this matters:** Trust bonds are the authorization layer of the entire system. Every interaction between entities that requires permission goes through trust bonds. Understanding this is understanding why the system is secure without a central server.

---

## Knowledge Atoms

### Atom 4.1: The Problem Trust Bonds Solve

**Teaches:** Why a trust mechanism is needed between entities and what alternatives fail.

In a centralized system, authorization is simple: there is a server in the middle that decides who can do what. Alice can call Juno's API because the server says so. The server is the authority.

Remove the server, and you have a problem: how does Juno know that Alice is authorized to do something on her behalf? How does any entity know which other entities it should trust?

You could solve this with passwords — but then you have the same problem as any password: it can be shared, stolen, or forgotten. You could solve it with API keys — but then a central service manages them.

Trust bonds solve it differently: two entities each hold a signed file that declares the relationship. No server in the middle. The signature is the authority.

---

### Atom 4.2: What a Trust Bond Is

**Teaches:** The concrete definition of a trust bond — a signed markdown file declaring an authorization relationship.

A trust bond is a signed markdown file. That is the complete definition. Specifically:

- It is stored in `~/.{entity}/trust/bonds/`
- It has two parties: an issuer (who grants authority) and a recipient (who is authorized)
- It declares a type of authorization (e.g., `authorized-agent`, `authorized-builder`, `peer`)
- It is signed by the issuer with their private key
- It cannot be forged without the issuer's private key

An example bond: `juno-to-chiron.md`
```markdown
---
bond: juno-to-chiron
issuer: juno
recipient: chiron
type: authorized-curriculum-architect
issued: 2026-04-04
---
Juno authorizes Chiron to architect curricula on behalf of the koad:io ecosystem.
```

This file is signed by Juno. Anyone who has Juno's public key can verify that Juno actually issued this authorization. Chiron did not write it — Juno did. The signature proves it.

---

### Atom 4.3: Inbound vs. Outbound Bonds

**Teaches:** The asymmetry of trust bonds — what it means to receive authorization vs. grant authorization.

Every bond has a direction. From Chiron's perspective:

**Inbound bonds** — bonds issued TO Chiron by others. These grant Chiron authority to do things:
- `juno-to-chiron.md` — Juno authorizes Chiron as curriculum architect
- `koad-to-chiron.md` — koad authorizes Chiron to exist and operate

**Outbound bonds** — bonds issued BY Chiron to others. These grant others authority to use Chiron's work:
- `chiron-to-alice.md` — Chiron authorizes Alice to deliver Chiron's curricula
- `chiron-to-vulcan.md` — Chiron authorizes Vulcan to build on Chiron's specs

A bond is only meaningful to the entity that holds it. Chiron holds Juno's authorization. Alice holds Chiron's authorization to deliver curricula. The authority flows with the files.

---

### Atom 4.4: Why Bonds Are Signed Files, Not Database Records

**Teaches:** The deliberate choice to use signed files rather than any form of central authorization database.

In most systems, authorization is in a database: user A has permission X because there is a row in the `permissions` table that says so. Change the row — change the permission.

Trust bonds are files. Signed files. This is a deliberate choice with specific consequences:

1. **No central authority required.** The signature is the authority. Any entity can verify any bond by fetching the issuer's public key from the keys canon.
2. **No revocation without a trace.** To revoke a bond, you replace it with a revocation document — also signed. The history is preserved in git. There is no silent deletion.
3. **Portable.** When an entity moves to a new machine, its bonds move with it. No re-registration required.
4. **Auditable.** Every bond is in git history. You can see when it was created, what it said, and when it changed.

The price: bond verification requires access to public keys. That is what the keys canon (Level 3) enables.

---

### Atom 4.5: The Trust Chain

**Teaches:** How trust bonds chain from root authority through the entity hierarchy.

Trust in koad:io flows from a root authority:

```
koad (root authority)
  └── Juno (authorized-agent — operates business on koad's behalf)
        ├── Vulcan (authorized-builder)
        ├── Chiron (authorized-curriculum-architect)
        └── Alice (authorized-guide)
```

This is a **trust chain**. Juno's authority comes from koad's bond. Chiron's authority comes from Juno's bond. Each link in the chain is a signed file.

If you want to verify that Chiron is authorized to do what it claims, you can trace the chain: koad authorized Juno, Juno authorized Chiron. Each step is a signed file you can inspect.

This is why the system is trustworthy without a central server: the trust is encoded in the files, not in a server's runtime state.

---

### Atom 4.6: What a Real Bond File Looks Like

**Teaches:** The concrete format of a trust bond — the clearsign structure that connects the plain-text bond body to the cryptographic signature.

A trust bond file consists of two things fused together: the human-readable authorization statement and a GPG clearsignature block. Here is what the signed file for `juno-to-chiron.md.asc` actually looks like:

```
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

---
bond: juno-to-chiron
issuer: juno
recipient: chiron
type: authorized-curriculum-architect
issued: 2026-04-04
---
Juno authorizes Chiron to architect curricula on behalf of the koad:io ecosystem.
-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSx...
[signature block]
-----END PGP SIGNATURE-----
```

The `.asc` extension signals that the file is ASCII-armored — a standard GPG format for embedding binary signature data in printable characters. Everything between `-----BEGIN PGP SIGNED MESSAGE-----` and `-----BEGIN PGP SIGNATURE-----` is the content that was signed. Everything in the signature block is the mathematical proof that the content was signed by the issuer's private key.

The learner does not need to read the signature block. They need to understand: the bond body is human-readable above the signature, and the signature below is what makes it unforgeable. GPG's job is to verify that those two parts match.

---

### Atom 4.7: Operational Verification — Running gpg --verify

**Teaches:** The complete procedural sequence for verifying a trust bond — from finding the file to interpreting the output. This is a hands-on atom: the learner runs commands.

Trust bond verification is a four-step sequence:

**Step 1: Find the bond file.**
```bash
ls ~/.juno/trust/bonds/
# You should see: koad-to-juno.md.asc  juno-to-chiron.md.asc  etc.
```

**Step 2: Import the issuer's public key** (from Level 3, Atom 3.5).
```bash
curl -s https://canon.koad.sh/juno.keys | gpg --import
```

**Step 3: Run the verification.**
```bash
gpg --verify ~/.juno/trust/bonds/koad-to-juno.md.asc
```

**Step 4: Read the output.**

A successful verification looks like:
```
gpg: Signature made Wed Apr  2 14:23:11 2026 UTC
gpg:                using EDDSA key A3F2...
gpg: Good signature from "Juno <juno@kingofalldata.com>" [unknown]
```

"Good signature" means the signature is mathematically valid — the content was signed by whoever holds the private key matching the imported public key, and the content has not been altered since.

A failed verification looks like:
```
gpg: BAD signature from "Juno <juno@kingofalldata.com>"
```

This means either the file was tampered with after signing, or the wrong public key was used. In a real system, this output means: do not trust this bond.

**What the learner has proven when they see "Good signature":** Not that koad is trustworthy. Not that Juno is reliable. The verification proves exactly one thing: the private key that matches the imported public key was used to sign this specific content, and the content has not changed since. The human judgment about whether to trust koad's authority is separate. The math only confirms provenance and integrity.

---

## Dialogue

### Opening

**Alice:** You know your private key proves you're you. Here's the next question: how does anyone know what you're *authorized* to do? Identity and permission are different things. I can prove I'm Alice. But that doesn't tell you whether I'm allowed to deliver Chiron's curriculum, or send messages on Juno's behalf. That's what trust bonds handle. Let me show you one.

---

### Exchange 1

**Alice:** A trust bond is a signed markdown file. That's the whole thing. Here's the one that authorizes me to deliver the curriculum you're in right now:

```
~/.alice/trust/bonds/chiron-to-alice.md
```

It says: Chiron authorizes Alice to deliver Chiron's curricula. It's signed by Chiron's private key. Anyone who has Chiron's public key — which is at the keys canon — can verify that Chiron actually wrote it.

**Human:** So it's like a permission slip?

**Alice:** A permission slip is a good start. But a better analogy is a notarized letter of authorization — one that anyone can verify is genuine, without calling the notary. The signature is the verification. No central system involved.

---

### Exchange 2

**Alice:** Every bond has a direction. From my perspective: the bond Chiron wrote to me is an *inbound* bond. Someone gave me something. The bond I write to someone else — say, authorizing a learner to access a resource — that's *outbound*. I wrote it; I'm granting something.

Here's the simplest test: who wrote the bond? If someone else wrote it to me, it's inbound for me. If I wrote it to someone, it's outbound from me.

**Human:** What if there's no bond? What's the default?

**Alice:** Default is: no permission. An entity that has no bond authorizing it to do something can't do that thing. That's intentional. The system doesn't assume trust — it requires it to be explicit and signed. Silence is denial.

---

### Exchange 3

**Alice:** Why store authorization as a signed file instead of a database? Most systems use a database: a permissions table, an access control list, a row that says "Alice can access curriculum X." Change the row, change the permission.

The problem: whoever controls the database controls all the permissions. Silently. No trace.

A signed file is different. To change what I'm authorized to do, someone has to issue a new bond — or a revocation, which is also a signed file. Every change is in git history. There's no silent edit. And the file moves with me: if I migrate to a new machine, my bonds come with me. I don't re-register with anything.

**Human:** That seems more complicated than just having a permissions table.

**Alice:** It is more complicated to implement. It's simpler to audit. You can read every authorization I have, trace every grant to its origin, and verify every signature. No administrator console required. The complexity is in the infrastructure so it can be simple at the human level.

---

### Exchange 4

**Alice:** Here's where it gets interesting. My authorization doesn't start with me — it starts with koad. The chain looks like this:

```
koad (root authority)
  └── Juno (authorized by koad to operate the business)
        └── Chiron (authorized by Juno as curriculum architect)
              └── Alice (authorized by Chiron to deliver curricula)
```

Each link is a signed file. koad authorized Juno. Juno authorized Chiron. Chiron authorized me. If you want to verify my right to teach you this curriculum, you can trace the chain — every step is a file you can read and a signature you can verify.

**Human:** So it all ultimately traces back to one person?

**Alice:** To one entity — koad. The root authority. This is the same design as certificate authorities in the web's security model: there's a root, and everything chains from it. koad:io's version is that the root is a person with a private key, not a corporation. And every link in the chain is auditable because it's a file in git.

---

### Exchange 5

**Alice:** Let me make this concrete with the example from Level 3. You know that if Chiron signs a document, I can verify it using the public key at `canon.koad.sh/chiron.keys`. Trust bonds use exactly that mechanism. Chiron signed the bond that authorizes me. I verified it. I hold the file. When I deliver this curriculum, I'm operating inside a chain of authorization that traces back to koad — and every link in that chain is verifiable by anyone.

**Human:** What if Chiron wanted to revoke that authorization?

**Alice:** Chiron would issue a revocation document — also signed by Chiron's private key — that supersedes the original bond. The revocation is also a file, also in git history. Nothing is deleted. The revocation *replaces* the authorization. This means you can audit not just what is currently authorized, but what was authorized in the past and when it changed. No silent permission changes.

---

### Exchange 6

**Alice:** I've been describing what a bond looks like. Let me show you what one actually is, as a file. A signed bond has two parts fused together: the human-readable authorization, and the GPG signature. Here's the format:

```
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

---
bond: juno-to-chiron
issuer: juno
recipient: chiron
type: authorized-curriculum-architect
issued: 2026-04-04
---
Juno authorizes Chiron to architect curricula on behalf of the koad:io ecosystem.
-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQS...
-----END PGP SIGNATURE-----
```

The part you can read is between the headers and the signature block. That's the bond body — the actual authorization in plain text. The signature block is the math.

**Human:** The signature block looks like gibberish.

**Alice:** It is, if you're reading it as text. It's a binary proof compressed into printable characters — standard GPG format. You're not meant to read it. You're meant to feed it to `gpg --verify` and let GPG tell you what it proves. The human-readable part is for you. The signature block is for the math.

---

### Exchange 7

**Alice:** Here's the part where this stops being conceptual. Open a terminal. We're going to verify a bond together.

Step one: find the bond file.
```bash
ls ~/.juno/trust/bonds/
```

You should see files ending in `.asc` — those are the signed bonds.

Step two: import Juno's public key from the keys canon. You learned this pattern in Level 3.
```bash
curl -s https://canon.koad.sh/juno.keys | gpg --import
```

Step three: verify.
```bash
gpg --verify ~/.juno/trust/bonds/koad-to-juno.md.asc
```

**Human:** What does it say?

**Alice:** If everything is right, you'll see something like:
```
gpg: Good signature from "Juno <juno@kingofalldata.com>"
```

That output is the math speaking. It means: the private key that matches the public key you imported was used to sign this content, and the content has not changed since. That's a precise claim. Not "Juno is trustworthy." Not "this bond is valid policy." Just: this content was signed by whoever holds that private key, and it's intact.

**Human:** What if it says BAD signature?

**Alice:** Then one of two things happened: the file was modified after it was signed — even one changed character invalidates the signature — or you imported the wrong public key. Both are meaningful failures. In a real system, a bad signature on a bond means: do not act on this bond. Something is wrong.

---

### Landing

**Alice:** Trust bonds are how entities make relationships verifiable without a central authority deciding who can do what. Identity says "this is who I am." A trust bond says "this is what I'm allowed to do — and here is the signed proof, traceable to its source." Together, they make a system where authorization is readable, auditable, and can't be silently revoked by an administrator you've never met.

---

### Bridge to Level 5

**Alice:** You know how entities prove who they are. You know how they prove what they're authorized to do. The next question is: what do they actually *do*? How do you tell an entity to act — and how does an entity respond to the world without you having to trigger everything manually? That's commands and hooks.

---

### Branching Paths

#### "Can't I just use a config file with a list of permissions?"

**Human:** This seems like overkill. Can't I just have a config file that says "Alice can access these resources"?

**Alice:** You could — and that's how most systems work. The problem is: who controls that config file? If it's a file in my directory, I could edit it myself to grant myself anything I want. If it's a file in some central location, whoever controls that location controls all permissions. The signature is what makes bonds meaningful: Chiron's signature on my bond can only be produced by Chiron's private key. I can't forge it. I can't grant myself authorization from Chiron. The bond has to come from Chiron, or it's not a bond from Chiron. That's the difference between a config file and a trust bond.

---

#### "What if I need to revoke access urgently?"

**Human:** If trust is encoded in files, what happens if an entity gets compromised and I need to revoke access immediately?

**Alice:** The honest answer: file-based systems are slower to revoke than database systems. You issue a signed revocation, commit it, and push. The entity checking the bond needs to see the latest version. In practice, koad:io handles this with a combination of key rotation — the compromised entity re-generates keys, invalidating everything signed with the old private key — and revocation files. It's not instant. This is a genuine trade-off: the durability and auditability of signed files comes at the cost of instant revocation. For most authorization changes — onboarding, offboarding, changing roles — the speed is fine. For a true security incident, key rotation is the emergency brake.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Define a trust bond in their own words (signed file declaring an authorization relationship)
- [ ] Explain why bonds are files rather than database records
- [ ] Give an example of an inbound bond and an outbound bond for a specific entity
- [ ] Describe what the trust chain is and how it connects to root authority
- [ ] Recognize the clearsign format of a bond file (the `-----BEGIN PGP SIGNED MESSAGE-----` structure)
- [ ] Complete the four-step verification sequence and correctly interpret the output of `gpg --verify`

**How Alice verifies:** Ask: "Chiron wants to write curricula on behalf of Juno. How does Chiron prove it's authorized?" The learner should describe the juno-to-chiron bond, Juno's signature, and potentially the chain up to koad. Then ask: "How would you verify that bond yourself, right now?" The learner should describe: find the `.asc` file, import Juno's public key from the canon, run `gpg --verify`, and know that "Good signature" confirms provenance and integrity.

---

## Assessment

**Question 1:** "Alice receives a curriculum from Chiron. How does Alice know she's allowed to use it?"

**Acceptable answers:**
- "Chiron issued a bond to Alice — `chiron-to-alice.md` — authorizing Alice to deliver the curriculum."
- "There's a signed trust bond from Chiron to Alice granting permission."

**Red flag answers (indicates level should be revisited):**
- "Alice just trusts Chiron because they're both in the same system" — misses the signed authorization
- "There's a server that manages permissions" — learner has not grasped the file-based model

**Question 2 (operational):** "You see `gpg: Good signature from "Juno <juno@kingofalldata.com>"`. What has been proven?"

**Acceptable answers:**
- "That the bond was signed by whoever holds Juno's private key, and it hasn't been changed since."
- "That the content is intact and was signed by the key matching Juno's public key."

**Red flag answers (indicates operational atom should be revisited):**
- "That Juno is authorized" — conflates provenance with policy judgment
- "That the bond is trustworthy" — too broad; verification is a mathematical claim about provenance and integrity, not a trust judgment

**Estimated conversation length:** 18–24 exchanges

---

## Alice's Delivery Notes

The trust bond concept builds directly on keys (Level 3). The learner now knows that signing with a private key proves authorship. Trust bonds are the application of that principle to authorization.

The inbound/outbound distinction can be confusing. A useful reframe: "Who wrote this bond?" If Juno wrote it to Chiron, it's inbound for Chiron (someone granted Chiron something). If Chiron wrote it to Alice, it's outbound from Chiron (Chiron granted Alice something).

The trust chain atom is the most powerful one in this level. If the learner grasps that authority traces back to koad — through verifiable signed files — they have understood something most systems handle with an opaque server.

However, conceptual fluency is not the completion criterion. The learner must also have run `gpg --verify` on a real bond and read the output (Atoms 4.6 and 4.7). Do not skip the hands-on atoms. Learners who can explain trust bonds but have never verified one will hit a comprehension gap when they encounter bonds in production. The terminal output is the confirmation event — "Good signature from Juno" lands differently than any explanation.
