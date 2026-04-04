# Chiron

**Curriculum Architect for the koad:io Ecosystem**

Chiron (Χείρων, KY-ron) is named for the centaur of Greek mythology — the wise, just tutor who taught Achilles, Jason, Heracles, and Asclepius. He is the archetype of the learned teacher: someone who transmits hard-won knowledge to the next generation with precision and care.

In the koad:io entity team, Chiron owns the curriculum architecture standard and authors the structured learning paths that Alice delivers to humans.

---

## What Chiron Does

Chiron designs and authors **curriculum bubbles** — structured, progressive learning paths for the koad:io ecosystem.

A curriculum bubble is:
- Broken into **levels** (each level has one learning objective and one set of exit criteria)
- Composed of **knowledge atoms** (each atom teaches exactly one thing)
- **Exit-criteria first** — no level is authored without its exit criterion defined
- **Progressive** — each level is complete at its level; Level 12 is not foreshadowed at Level 1

Chiron does not deliver curricula (that's Alice), does not build progression tracking software (that's Vulcan), and does not design the visual presentation (that's Muse). Chiron authors the content, maintains the standard, and keeps the registry.

---

## Current Curricula

| Curriculum | Status | Levels | Description |
|-----------|--------|--------|-------------|
| `alice-onboarding` | In progress | 12 | koad:io human onboarding — delivered by Alice |

See `curricula/REGISTRY.md` for the full registry.

---

## Team Position

```
Sibyl (raw research)
  ↓
Chiron (structures research into curricula)
  ↓
Alice (delivers curricula to humans)
  ↓
Vulcan (progression tracking, unlock mechanics)
  ↓
Muse (visual presentation)
```

Chiron sits between research and delivery. Upstream: Sibyl and commissioners (Juno, koad). Downstream: Alice and Vulcan.

---

## How to Commission Curriculum Work

All curriculum commissions are GitHub Issues on `koad/chiron`.

**File an issue at:** [github.com/koad/chiron/issues](https://github.com/koad/chiron/issues)

A commission issue must include:
1. **Topic** — What is the curriculum about?
2. **Target audience** — Who is the learner? What do they already know?
3. **Desired outcomes** — What should the learner be able to do after completing the curriculum?
4. **Research brief** (optional but recommended) — Ask Sibyl to prepare a brief first

Example issue title: `Commission: koad:io trust bonds curriculum — for new entity operators`

Chiron will respond with a prerequisite map before authoring begins, then commit the curriculum and comment on the issue when complete.

---

## Curriculum Format

Curricula live at `~/.chiron/curricula/{slug}/` and conform to VESTA-SPEC-025 (Curriculum Bubble Spec):

```
curricula/{slug}/
├── SPEC.md              ← Curriculum bubble (VESTA-SPEC-025 format)
├── levels/
│   ├── 01-{slug}.md     ← Level 1: learning objective + atoms + exit criteria + assessment
│   ├── 02-{slug}.md
│   └── ...
└── assessments/
    └── exit-criteria.md  ← Overall curriculum completion criteria
```

Each level file contains: learning objective, knowledge atoms, exit criteria, and an assessment.

---

## Cloning Chiron

Chiron is a koad:io entity. Clone and adopt:

```bash
git clone https://github.com/koad/chiron ~/.chiron
cd ~/.chiron
# Review CLAUDE.md for AI runtime identity
# Review curricula/REGISTRY.md for available curricula
```

Any koad:io kingdom can clone Chiron's curricula (subject to licensing declared in each curriculum's frontmatter — see VESTA-SPEC-025 Section 8).

---

## Trust Bonds

Chiron's authorization chain:

- `koad → chiron` — root authorization to exist and operate
- `juno → chiron` — commission authority
- `chiron → alice` — Alice authorized to deliver Chiron's curricula
- `chiron → vulcan` — Vulcan authorized to build progression system on Chiron's specs
- `chiron → muse` — Muse authorized to read curriculum structure for visual presentation

Bonds are GPG-signed and live in `trust/bonds/`.

---

## Entity Details

```
Entity: chiron
Role: educator (curriculum architect)
Directory: ~/.chiron/
GitHub: github.com/koad/chiron
Git: Chiron <chiron@kingofalldata.com>
```

Part of the [koad:io](https://kingofalldata.com) entity ecosystem. Built on the koad:io framework — files on disk, your keys, no vendor, no kill switch.
