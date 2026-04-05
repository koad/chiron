---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 3
slug: keys-and-identity
title: "Your Keys Are You"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2]
estimated_minutes: 20
atom_count: 5
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 3: Your Keys Are You

## Learning Objective

After completing this level, the learner will be able to:
> Explain what cryptographic keys are for (in koad:io's context), describe the types of keys an entity holds, and articulate why keys are identity — not just access.

**Why this matters:** Keys are the foundation of everything that comes after: trust bonds, signing, peer verification. If the learner thinks keys are just passwords, they will misunderstand every subsequent concept that relies on them.

---

## Knowledge Atoms

### Atom 3.1: What a Key Pair Is

**Teaches:** The concept of a public/private key pair — what each part does.

A cryptographic key pair has two parts:
- A **private key** — a secret you keep. Never shared. Lives in `~/.{entity}/id/ed25519` with permissions `600` (only you can read it).
- A **public key** — derived from the private key. Can be shared freely. Lives in `~/.{entity}/id/ed25519.pub`.

The two keys are mathematically linked. Something signed with the private key can be verified by anyone who has the public key. Something encrypted with the public key can only be decrypted by the private key.

You cannot work backward from the public key to figure out the private key. This is the security property the whole system rests on.

---

### Atom 3.2: An Entity's Key Directory

**Teaches:** What key types live in an entity's `id/` directory and why multiple key types exist.

Every gestated entity has an `id/` directory with several key types:

```
~/.alice/id/
├── ed25519      ← Private (permissions: 600)
├── ed25519.pub  ← Public
├── ecdsa        ← Private (permissions: 600)
├── ecdsa.pub    ← Public
├── rsa          ← Private (permissions: 600)
└── rsa.pub      ← Public
```

**Why multiple types?** Different systems prefer different algorithms. SSH uses Ed25519 or RSA. GPG uses a different format entirely. Having multiple key types means the entity can authenticate to any system it needs to reach without the system dictating the key type.

All of these keys were generated at gestation. They are unique to this entity. They are on disk.

---

### Atom 3.3: Keys as Identity, Not Just Access

**Teaches:** The deeper claim — that a key pair is identity, not merely a credential.

A password proves that you know something (the secret). A key pair proves that you *are* something (the holder of this private key). This is a meaningful distinction.

When Juno signs a document with her private key, anyone who has Juno's public key can verify: this message was created by whoever holds Juno's private key. Not "someone who knows the password" — the holder of a specific cryptographic key that cannot be transferred without copying the file.

In koad:io, the entity's keys ARE the entity's identity. They are:
- Unique (generated fresh at gestation, never repeated)
- Non-transferable (copying the keys creates two entities with the same identity — a fork, not a transfer)
- Permanent (the keys don't expire — they can be rotated, but the historical identity record stays)

This is why the entity is more like a person than a service. A person's identity persists. A service's credentials are managed by someone else.

---

### Atom 3.4: Public Key Distribution — The Keys Canon

**Teaches:** How an entity makes its public key available so others can verify its signatures.

A private key is useless for verification if no one can find the corresponding public key. koad:io uses a simple convention: each entity's public keys are accessible at a canonical URL.

```
canon.koad.sh/alice.keys    ← Alice's public keys
canon.koad.sh/juno.keys     ← Juno's public keys
canon.koad.sh/chiron.keys   ← Chiron's public keys
```

This is the **keys canon** — the canonical, authoritative source of each entity's public identity. When another entity receives a signed document and wants to verify it, they fetch the keys from the canon.

Publishing public keys is not a security risk — that is the point of public keys. Sharing them widely strengthens the identity system by making verification accessible to anyone who needs it.

---

### Atom 3.5: Importing a Public Key — The Verification Prerequisite

**Teaches:** The concrete mechanics of getting an entity's public key into GPG's trust store so that signatures can be verified locally.

Understanding the keys canon is the conceptual step. Getting a key into your local GPG keyring is the operational step. You need both before you can run `gpg --verify` on anything.

GPG maintains a local keyring — a database of public keys you've imported. When you verify a signature, GPG checks the signature against the keys in your ring. If the issuer's key isn't there, verification fails, even if the signature is valid.

To import Juno's public key:

```bash
# Import Juno's GPG public key from Juno's entity id/ directory
gpg --import ~/.juno/id/rsa.pub

# Verify it imported successfully
gpg --list-keys juno@kingofalldata.com
```

**Note:** `canon.koad.sh/juno.keys` serves Juno's SSH public keys — the same format GitHub surfaces at `github.com/juno.keys`. SSH public keys are not in GPG import format. GPG keys are distributed through an entity's `id/` directory (e.g., `~/.juno/id/rsa.pub`). For entities you don't have locally, ask for their `rsa.pub` directly or use their Keybase profile (`keybase pgp pull <username>`).

After import, `gpg --list-keys` should show Juno's key fingerprint and associated email. You now have what you need to verify anything Juno has signed.

This is a prerequisite for trust bond verification in Level 4. The learner does not need to memorize the commands — they need to understand the pattern: fetch the issuer's public key from the keys canon, import it into GPG, then you can verify.

---

## Dialogue

### Opening

**Alice:** Your username on GitHub proves you can log in. Your GPG key — GPG is a standard for cryptographic signing, the same kind of thing your bank uses when you connect securely — proves you *are* the person who signed something. Those are completely different claims. Let me show you why that difference matters, and why it's the foundation that makes everything else in this system trustworthy.

---

### Exchange 1

**Alice:** Here's an analogy that usually makes this click. Imagine you have a wax seal — a physical stamp that's uniquely yours, like old letters used to have. You publish what your seal looks like so anyone who gets a letter from you can recognize it. When you seal a letter, anyone who's seen your seal design can confirm: this came from that person. They cannot fake the seal because they don't have the physical stamp. Your private key is the stamp. Your public key is the published design.

**Human:** But what stops someone from just copying my stamp?

**Alice:** In the physical world, not much — that's where the analogy breaks down. In cryptography, copying the private key is technically possible, but two things make it serious. First, private keys live in a file with permissions set to 600 — meaning only the owner can read it, at the operating system level. Second, if someone copies your key, you now have two entities with the same identity, not one transferred identity. It's detectable. And you can rotate the key — generate a new one and sign a document with both old and new key to prove the transition. It's not magic. It's better math than a wax stamp.

---

### Exchange 2

**Alice:** Let me show you what lives in my `id/` folder:

```
~/.alice/id/
├── ed25519      ← private key (permissions: 600, only you can read)
├── ed25519.pub  ← public key
├── ecdsa        ← private key (permissions: 600)
├── ecdsa.pub    ← public key
├── rsa          ← private key (permissions: 600)
└── rsa.pub      ← public key
```

Three different key types — Ed25519, ECDSA, RSA. These are different mathematical algorithms for the same purpose. Why three? Different systems prefer different algorithms. SSH — the protocol used to communicate securely between machines — tends to prefer Ed25519. Some older systems still require RSA. Having all three means I can prove my identity to any system, without that system dictating the algorithm.

**Human:** Which one is most important?

**Alice:** Ed25519 is the one I use most. It's modern, fast, and its keys are short enough to read. RSA is older — you'd recognize it as the long block of characters in SSH configuration files. ECDSA sits in between. For most purposes, Ed25519 is the one that matters. But gestation creates all three so you have them when you need them.

---

### Exchange 3

**Alice:** Here's the key distinction I want you to hold: a password proves you *know* something. A key pair proves you *are* something — specifically, the holder of this private key file. Those aren't the same claim. Passwords can be phished, shared, guessed, or reset by an admin. A private key file is different: to prove you're me, you'd need the actual file, or to compromise the machine it lives on. There's no "forgot private key" flow because there's no third party holding it for you.

**Human:** But that seems more dangerous — if I lose it, it's gone?

**Alice:** Yes, and that's real. Key management is a genuine responsibility. koad:io's answer is: your entity is a git repository and you push it to GitHub. The public keys are there, the config is there, the memories are there. The private keys are the one thing you back up separately — like backing up a password manager. But here's what matters: you control that backup. Not a vendor. You decide where it lives and who can access it.

---

### Exchange 4

**Alice:** When another entity — say, Juno — sends me a signed message, I can verify it against the public key at `canon.koad.sh/juno.keys`. That URL is the keys canon — the canonical, authoritative endpoint where each entity publishes their public keys. It's an HTTP endpoint serving a plain text file. No API key needed. No authentication. Just: here are my public keys, fetch them, verify anything I've signed against them.

**Human:** What if someone faked Juno's keys on that endpoint?

**Alice:** Then they'd need to control the server that serves canon.koad.sh — infrastructure koad operates. And even if they did, they'd still need the actual private key to produce a valid signature. Publishing a fake public key doesn't help you forge signatures — you'd also need the matching private key to sign anything that verifies against it. The canon is a convenience for key lookup. The mathematical guarantee is in the key pair itself.

---

### Exchange 5

**Alice:** Here's the practical upshot: when I sign your graduation certificate at the end of this curriculum, it won't be a PDF with a logo on it. It'll be a file with a cryptographic signature — verifiable by anyone, forever, against the public key at `canon.koad.sh/alice.keys`. Years from now, if someone asks "did Alice really certify this person?" — they can check. They don't need to call anyone. They don't need an account. They run: `gpg --verify certificate.md.asc` — and the math either checks out or it doesn't.

**Human:** That's actually kind of cool.

**Alice:** It is. This is what "trustless verification" means — not that you don't trust anyone, but that trust doesn't have to flow through a third party. You verify directly, with math. No certificate authority, no notary, no support ticket to confirm authenticity. The signature speaks for itself.

---

### Landing

**Alice:** Keys aren't passwords you memorize. They're mathematical proof. Your private key is a specific, irreplaceable file on your disk — and it's the thing that constitutes your identity in this system. When you sign something with it, that signature is verifiable by anyone who has your public key. And your public key is at the keys canon, findable forever. That's the foundation everything else in koad:io is built on.

---

### Bridge to Level 4

**Alice:** Keys prove who you are. But there's a related question: once another entity knows who you are, how does it know what you're *allowed to do*? I can sign a document to prove I'm Alice — but that doesn't tell you whether I'm authorized to deliver Chiron's curriculum, or act on Juno's behalf. For that, you need more than identity. You need authorization. That's what trust bonds are.

---

### Branching Paths

#### "Cryptography goes over my head"

**Human:** I don't have a math or CS background. This cryptography stuff loses me.

**Alice:** Fair — let me try a different angle with no math required. Think about a notary stamp — the physical embosser a notary uses on documents. It leaves a specific impression that's hard to fake. When you see that stamp on a document, you know two things: a specific notary saw this document, and the document hasn't been altered since they stamped it. A private key is the digital equivalent of that embosser. A public key is the way anyone can verify that the embosser's pattern matches. You don't need to understand how the embosser was manufactured to understand what it certifies. You just need to know: signature present and verified means this entity touched this document and it hasn't changed since. Does that version work for you?

---

#### "Why can't I just use a password for this?"

**Human:** Why do we need all this? Can't I just use a username and password like everything else?

**Alice:** You could use a username and password — but then you'd need someone to hold the password database. A company. A server. A service that can reset your password if you forget it — but that means they can also reset it without your permission, lock you out, or lose the database in a breach. Passwords require a trusted third party to manage them. Cryptographic keys don't. The key file IS the credential — no third party needed. For a sovereign system, where the whole point is that no one else controls your access, keys are the only thing that actually delivers that property. Passwords would just re-introduce the dependency we're trying to avoid.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Explain what a private key does vs. what a public key does
- [ ] Describe what lives in `~/.{entity}/id/` and why there are multiple key types
- [ ] Explain why keys are identity, not just access credentials
- [ ] Explain what the keys canon is and why it exists
- [ ] Describe how to fetch an entity's public key from the keys canon and import it into a local GPG keyring

**How Alice verifies:** Ask the learner: "If I wanted to verify that Juno actually wrote a document, what would I need?" They should describe: Juno's signature on the document + Juno's public key — and ideally mention that the public key needs to be imported into their local GPG keyring first.

---

## Assessment

**Question:** "Alice signs a trust bond with her private key. What can someone do with that signature and Alice's public key?"

**Acceptable answers:**
- "They can verify that Alice actually created the bond — that it wasn't forged."
- "They can confirm the bond came from Alice and hasn't been tampered with."

**Red flag answers (indicates level should be revisited):**
- "They can unlock Alice's account" — learner is thinking of keys as passwords
- "They can see Alice's private key" — fundamental misunderstanding of key direction

**Estimated conversation length:** 10–15 exchanges

---

## Alice's Delivery Notes

The key pair concept is often the first technically abstract thing in the curriculum. Use concrete language: "a private key is a file that lives in your entity's `id/` folder — the same place a passport lives in a safe. A public key is like your photo that appears in a public directory."

Avoid deep cryptographic explanations. The learner does not need to understand Ed25519 mathematics. They need to understand: private key signs, public key verifies, they are linked, you cannot reverse-engineer one from the other.

For the signing function specifically, use the wax seal analogy: "Imagine you have a stamp — a physical seal that is uniquely yours. You publish what your stamp looks like so anyone can recognize it. When you seal a letter with it, anyone who has seen your stamp design can confirm you sealed it. They cannot fake the seal because they don't have the physical stamp. Your private key is the stamp. Your public key is the published design." This gives learners a sensory model for sign-with-private, verify-with-public before they encounter trust bonds in Level 4 — without needing to understand cryptographic mathematics.

The "keys as identity" distinction from "keys as access" is the important conceptual shift. A credential (password, API key) is something you have. Keys, because they are mathematically entangled with the entity's identity at gestation, are something you are.

Atom 3.5 (key import) is the bridge to operational verification in Level 4. Do not let learners leave Level 3 thinking verification is automatic. The pattern to establish: you fetch the issuer's key from the keys canon, import it into GPG, and only then can you run `gpg --verify`. Level 4 will use this pattern on an actual bond file. If the learner holds that sequence, Level 4's hands-on verification will feel like a natural next step rather than a sudden jump to terminal commands.
