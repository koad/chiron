---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 0
slug: the-id-directory
title: "The id/ Directory — Keys in the Entity Model"
status: authored
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete: []
estimated_minutes: 20
atom_count: 4
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 0: The id/ Directory — Keys in the Entity Model

## Learning Objective

After completing this level, the operator will be able to:
> Open an entity's `id/` directory, name each key file present, state what algorithm it uses and what operation it enables, and explain why an entity holds multiple key types rather than one.

**Why this matters:** Creating and verifying trust bonds requires using the correct key for the correct operation. Operators who skip this level sign bonds with SSH keys, try to verify with the wrong key, or cannot locate the public key they need to publish. The id/ directory is not a detail — it is the foundation everything else in this curriculum sits on.

---

## Knowledge Atoms

### Atom 0.1: What Lives in id/ and Why

**Teaches:** The purpose of the id/ directory, what categories of keys live there, and the naming conventions used.

Every koad:io entity has an `id/` directory at the root of its entity directory. This directory was populated at gestation by `koad-io gestate` and contains the entity's cryptographic identity materials.

Open Juno's id/ directory and you see:

```
~/.juno/id/
├── dsa           ← DSA private key (permissions: 600)
├── dsa.pub       ← DSA public key
├── ecdsa         ← ECDSA private key (permissions: 600)
├── ecdsa.pub     ← ECDSA public key
├── ed25519       ← Ed25519 private key (permissions: 600)
├── ed25519.pub   ← Ed25519 public key
├── gpg-revocation.asc  ← GPG revocation certificate
├── rsa           ← RSA private key (permissions: 600)
└── rsa.pub       ← RSA public key
```

The naming convention is consistent across every entity: the algorithm name with no extension is the private key; the same name with `.pub` is the corresponding public key. Private key files have permission `600` — readable only by the owning user. Public key files can be read by anyone.

The `gpg-revocation.asc` file is a pre-generated emergency certificate that can revoke the entity's GPG key if the private key is ever compromised. It is generated at gestation and stored here in case it is needed.

**Important:** The keys in id/ are raw key files in standard formats (OpenSSH, PEM). They are distinct from the GPG keyring at `~/.gnupg/`. The relationship between these is explained in Atom 0.3.

---

### Atom 0.2: The Four Key Types — Algorithms and Their Uses

**Teaches:** What Ed25519, ECDSA, RSA, and DSA are, what each is used for in the entity model, and the practical differences between them.

Each key type is a different mathematical algorithm for the same two operations: signing (prove authorship) and SSH authentication (prove identity to a remote machine). Here is what each one is actually for:

**Ed25519 — the modern signing key**

Ed25519 is an elliptic curve algorithm using a 256-bit key. It produces short, fast signatures. Its security properties are well-studied. It is the key type preferred for new work in the koad:io ecosystem.

Ed25519 is what Juno uses for SSH authentication to GitHub and other machines. When `~/.juno/.env` sets a `GIT_SSH_COMMAND` or when the entity's SSH config references its identity, this is the key that identifies the entity.

Ed25519 keys are short enough to read:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMiUt9... juno@kingofalldata.com
```

**RSA — the compatibility key**

RSA is the older, widely-supported algorithm. RSA keys are much longer than Ed25519 keys. It is still required by some systems that have not adopted newer algorithms. Juno's RSA key is also the one used with GPG for trust bond signing — not directly (GPG manages its own key format), but the RSA key material in id/ is the source from which the GPG key was derived at gestation.

RSA key strength is determined by bit length. A 4096-bit RSA key is considered strong. The koad:io gestation process generates 4096-bit RSA keys.

**ECDSA — the middle ground**

ECDSA is an elliptic curve algorithm like Ed25519 but using a different curve (typically P-256 or P-384). It is faster than RSA and has stronger security per bit. Some systems that don't support Ed25519 do support ECDSA. In the koad:io entity model it is held as a compatibility option.

**DSA — the legacy key**

DSA (Digital Signature Algorithm) is an older signing algorithm. It is kept for compatibility with legacy systems that require it. New work never uses DSA. Its presence in id/ means the entity can authenticate to old infrastructure that predates the modern key types.

**Practical summary for this curriculum:**

For trust bond signing, the relevant key path is: `id/rsa.pub` or `id/ed25519.pub` for the public key that verifiers need. The GPG key (used for `gpg --clearsign`) is the mechanism — but the underlying key material traces to what was in id/ at gestation. Level 1 addresses this in detail.

---

### Atom 0.3: GPG Keys — The Bond Signing Mechanism

**Teaches:** Why GPG is the signing mechanism for trust bonds (not SSH keys directly), what a GPG keyring is, and how the entity's GPG key relates to the raw keys in id/.

When you sign a trust bond, you use the `gpg` command — not `ssh-keygen`, not `openssl`. GPG (GNU Privacy Guard) is a standard toolkit for encrypted communications and cryptographic signing that has been in widespread use since 1999. Trust bonds use GPG because:

1. GPG's clearsign format (`gpg --clearsign`) embeds the signed plaintext inside the signature file, making the bond readable as text even without GPG tools while still being verifiable with them.
2. GPG keyservers and web-of-trust infrastructure provide standardized key distribution.
3. GPG is the standard used by Keybase (which koad uses for human-signed bonds), providing a consistent verification path for both human-signed and entity-signed bonds.

**The GPG keyring is separate from id/**

GPG maintains its own key storage at `~/.gnupg/`. This is a database of keys GPG knows about, distinct from the raw key files in `id/`. When you run `gpg --list-keys`, you see keys in the GPG keyring. When you look at `id/rsa.pub`, you see a raw public key file.

**The connection:** At entity gestation, the RSA key generated in `id/` is imported into the entity's GPG keyring. From that point on, GPG manages the key at `~/.gnupg/` and uses it for signing. The file at `id/rsa.pub` is the exportable public key material that gets published to the keys canon and distributed to verifiers.

To see the GPG keys available to an entity:
```bash
gpg --list-keys
```

To confirm the fingerprint of the signing key (which appears in every bond's Signing section):
```bash
gpg --fingerprint juno@kingofalldata.com
```

The fingerprint in this output is what you will see in the Signing section of every bond Juno has signed. It is the long hex string that serves as the unforgeable identifier for the key.

---

### Atom 0.4: The Public Key Surface — What Gets Published vs. What Stays Private

**Teaches:** Which key materials are public, which are private, the `.pub` naming convention, and why private key materials never leave the entity's machine.

The security of the entire trust bond system rests on one principle: private keys stay private. Here is what that means concretely.

**What gets published:**

The entity's public keys are published to the keys canon at `canon.koad.sh/<entity>.keys`. This endpoint serves the public key files — specifically the SSH public keys (`ed25519.pub`, `rsa.pub`, etc.) that allow other entities and systems to verify the entity's signatures and authenticate it.

The entity's GPG public key is also exportable and importable by verifiers. To export it:
```bash
gpg --armor --export juno@kingofalldata.com > juno-gpg-public.asc
```

This exported file is what a verifier needs to import before they can run `gpg --verify` on a bond.

**What never leaves the machine:**

- `id/ed25519` — private key, permissions 600
- `id/ecdsa` — private key, permissions 600
- `id/rsa` — private key, permissions 600
- `id/dsa` — private key, permissions 600
- The GPG private key at `~/.gnupg/` — never exported

These files are never committed to git. If you run `git status` in an entity directory and see any file from id/ that does not end in `.pub`, something is wrong.

**Why this matters for bond verification:**

When you receive a bond signed by Juno and want to verify it, you need Juno's public key — not the private key. You import `juno-gpg-public.asc` (or fetch it from the keys canon) into your local GPG keyring and then run `gpg --verify`. You never need the private key to verify. The private key is only needed by Juno to sign. This asymmetry is the security property the system relies on.

**The git check:**

Before committing any changes to an entity repository, verify:
```bash
git status  # confirm no private key files are staged
git diff --cached --name-only | grep -E "^id/[^.]*$"
# This should return nothing. Any output means a private key file is staged.
```

---

## Exit Criterion

The operator can:
- Open `~/.juno/id/` and identify each file by algorithm and type (public vs. private)
- State what Ed25519 is used for (SSH auth, modern signing) vs. RSA (GPG signing, compatibility)
- Explain why GPG is a separate mechanism from the raw key files in id/
- State what the keys canon publishes (public keys only) and what must never be committed to git (private keys)
- Explain why an entity needs multiple key types rather than one

**Verification question:** "Juno has just signed a trust bond. Vulcan wants to verify it. What does Vulcan need from Juno's id/ directory, and what does Vulcan use to actually run the verification?"

Expected answer: Vulcan needs Juno's GPG public key (exported from the GPG keyring, or available from the keys canon). Vulcan does NOT need anything from id/ directly — id/ contains the raw key files, but verification uses the GPG keyring. Vulcan imports Juno's public key into their local GPG keyring and runs `gpg --verify`.

---

## Assessment

**Question:** "You look in `~/.alice/id/` and see a file called `ed25519` with no extension and a file called `ed25519.pub`. What is each file, what algorithm does it use, and which one do you need if you want to verify Alice's signature on a bond?"

**Acceptable answers:**
- `ed25519` is the private key; `ed25519.pub` is the public key; both use the Ed25519 algorithm; you need the public key for verification.
- "The file without `.pub` is the private key — only Alice uses that to sign. The `.pub` file is the public key — that's what I'd import to verify anything Alice signed."

**Red flag answers (indicates level should be revisited):**
- "I need the private key to verify" — fundamental key direction error
- "Ed25519 is only for SSH, not for signing bonds" — conflates SSH auth with signing, misses that Ed25519 is a general signing algorithm

**Estimated engagement time:** 15–20 minutes

---

## Alice's Delivery Notes

This level is about foundations, not GPG mechanics. The operator has completed entity-operations and can navigate an entity directory. They may not have ever opened `id/` with intent — they've seen it listed but not studied it.

The key conceptual gap at this level is the GPG-vs-raw-keys distinction. Operators who skip this level assume they can run `gpg --verify` after importing a raw `rsa.pub` file. That fails because GPG needs its own keyring format. Get them comfortable with: "the raw keys in id/ are the source material; GPG imports them into its own format; verification uses GPG, not the raw files directly."

Do not over-teach the cryptographic algorithms. The operator needs to know which algorithm is preferred for new work (Ed25519), which is used for GPG bond signing (RSA, from id/), and why multiple types exist (compatibility). They do not need to understand elliptic curve mathematics.

The "never commit private keys" rule is not a lecture — it is a concrete command they can run (`git diff --cached --name-only | grep`). Make it a habit before the level is done.

---

### Bridge to Level 1

Now you know what keys the entity holds and why. Level 1 is about reading the bond documents those keys sign — the `.md` and `.md.asc` pair, every field, what each one proves.
