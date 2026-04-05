---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 4
slug: cryptographic-keys
title: "Cryptographic Keys — What Was Generated and Why"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-03
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 4: Cryptographic Keys — What Was Generated and Why

## Learning Objective

After completing this level, the operator will be able to:
> Locate every key file in `id/` and `ssl/`, name what each one is for, explain why private keys are gitignored while public keys are committed, describe the C comment on each key (the `entity@mother` pattern), and explain what would need to happen if a private key were compromised.

**Why this matters:** Key generation happens automatically during gestation, but most operators do not look at what was generated. An operator who cannot name their entity's keys cannot reason about what breaks if a key is lost, what each key authorizes, or why the gitignore rules are structured the way they are. This is a conceptual level — the keys already exist. The operator learns what they are holding.

---

## Stub Coverage

- The four SSH key types in `id/`: ed25519 (fast, modern, preferred for agent identity), ecdsa (521-bit, NIST curve, broad compatibility), rsa (4096-bit, maximum legacy compatibility), dsa (generated but deprecated — why it still exists in the scaffold)
- The SSL elliptic curve keys in `ssl/`: master-curve.pem, device-curve.pem, relay-curve.pem, session.pem — what each role is and why they use AES-256 passphrase protection (the entity name as passphrase — a known convention, not high security)
- The `entity@mother` comment pattern on each key: this is the identity stamp, readable with `ssh-keygen -l -f id/ed25519.pub`
- The gitignore contract for keys: private keys are gitignored; public keys (`.pub` files) are committed — why the public key is safe to share and the private key is not
- Key compromise recovery: rotate immediately, file a note in the entity's CLAUDE.md, update any trust bonds that reference the compromised key — this is not catastrophic, it is a known procedure

---

*(Stub — full atoms, dialogue, exit criteria, and assessment pending)*
