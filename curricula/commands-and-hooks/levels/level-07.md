---
type: curriculum-level
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_slug: commands-and-hooks
level: 7
slug: command-and-hook-together
title: "Command + Hook Together — A Complete Entity Skill"
status: scaffold
prerequisites:
  curriculum_complete:
    - entity-gestation
  level_complete:
    - commands-and-hooks/level-06
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 7: Command + Hook Together — A Complete Entity Skill

## Learning Objective

After completing this level, the operator will be able to:
> Design and deliver a complete entity skill that uses both a command (operator-initiated) and a hook (system-initiated) in coordination, test it end-to-end in the practice entity, and explain how the skill generalizes to any entity capability they need to build.

**Why this matters:** Operators who treat commands and hooks as independent tools build entities with split personalities — capable of direct control or automation, but not both, and not in coordination. A complete entity skill uses commands to expose capability to operators and hooks to expose capability to automated systems. Both facets are needed for an entity to function as both a product and a collaborator.

---

## Knowledge Atoms

## Atom 7.1: Designing the Skill — What Problem Does It Solve?

<!-- SCAFFOLD: Walk the operator through the design step before writing any code. A complete entity skill has three questions: (1) What does the operator invoke directly? (the command) (2) What does another entity or system invoke via PROMPT? (the hook) (3) Do they share logic, or are they completely independent? Good skill design answers all three. Use a concrete example for the integration exercise: a `report` skill. The command `practice report` generates a status report for the practice entity (reads `KOAD_IO_VERSION`, counts files in `commands/`, lists recent git commits). The hook handles an automated prompt like "generate a status report and save it" by running the same logic and saving the output to `var/reports/`. The command is the operator's shortcut to the same capability the hook exposes to automation. -->

---

## Atom 7.2: Extracting Shared Logic — The Library Pattern

<!-- SCAFFOLD: When a command and a hook do related work, the common logic belongs in a shared function or script rather than duplicated in both files. Cover the library pattern: create `~/.practice/lib/report.sh` that contains the report generation logic as a bash function. Both `commands/report/command.sh` and `hooks/executed-without-arguments.sh` source this file and call the function. The command formats the output for a human terminal. The hook formats the output for machine use (saves to file, returns result as the hook's output). Cover why this matters at scale: entities with 20+ commands and a complex hook will have significant logic that belongs in shared library files, not duplicated. Introduce `source "$ENTITY_DIR/lib/report.sh"` as the pattern. -->

---

## Atom 7.3: The Integration Exercise — Build, Test, Verify

<!-- SCAFFOLD: The hands-on integration exercise. The operator builds the `report` skill: (1) write `lib/report.sh` with the shared logic, (2) write `commands/report/command.sh` that sources it and formats for terminal, (3) update `hooks/executed-without-arguments.sh` to handle a "generate report" prompt by calling the same function and saving output. Then test three scenarios: (1) `practice report` — operator command, terminal output, (2) `PROMPT="generate a status report" practice` — automated invocation, output saved to `var/reports/`, (3) `practice` — interactive invocation, normal Claude Code session (hook interactive path). All three should succeed. The log in `var/hooks/` should show the two non-interactive invocations. -->

---

## Atom 7.4: Signed Policy Blocks — What Juno's Hook Has That Yours Doesn't (Yet)

<!-- SCAFFOLD: Return to the GPG-signed policy block in Juno's `executed-without-arguments.sh` that was deferred from Level 4. Cover what it is: a clearsigned assertion about the hook's policy (what harness it uses, whether it accepts remote triggers, what it logs). The signature proves that Juno's author (koad, using Juno's key) explicitly authorized this policy. A powerbox that verifies hooks can check the signature before executing — if the block is tampered with, verification fails and the hook is blocked. This is VESTA-SPEC-033 (signed code blocks) applied to hooks. The practice entity hook does not have this block — it is an optional enhancement for production entities where tamper detection matters. Cover where to learn how to author and sign policy blocks: advanced-trust-bonds (covers the signing protocol) and the VESTA-SPEC-033 spec. -->

---

## Atom 7.5: The Builder Path Completes — What You Can Now Build

<!-- SCAFFOLD: The closing atom. The operator has completed all five Builder Path curricula. Cover what they can now do: gestate a new entity from scratch (entity-gestation), configure its identity and trust position (entity-gestation + advanced-trust-bonds), author commands that use the cascade environment correctly (commands-and-hooks Levels 1–3), write a production-safe hook that handles both invocation modes (commands-and-hooks Levels 4–6), design a complete entity skill that works for both operator control and automation (commands-and-hooks Level 7). Connect this to the koad:io commercial model: every entity they can now build is a product — something they can gestate, configure, and share via koad:io. The Builder Path is the path to shipping. They are on the other side of it. Close with the natural next curriculum: multi-entity orchestration (running the team, reading distributed output, the GitHub Issues protocol at scale). -->

---

## Exit Criterion

The operator can:
- Design a skill that specifies what the command exposes and what the hook exposes
- Extract shared logic into a library file and source it from both command and hook
- Test all three invocation scenarios for a complete skill (command, automated, interactive)
- Explain what a signed policy block is and where to learn to author one
- State the five Builder Path curricula and what each taught

**Verification question:** "You want to add a `summarize` skill to a new entity. It should work when an operator types `<entity> summarize` AND when another entity sends `PROMPT='summarize the latest activity'`. Where do you write the logic and what files are created?"

Expected answer: Shared logic in `lib/summarize.sh`. Command at `commands/summarize/command.sh` (sources the lib, formats for terminal). Hook logic in `hooks/executed-without-arguments.sh` handles the prompt pattern "summarize..." by sourcing the lib, running the function, and returning the output.

---

## Assessment

**Question:** "A colleague says: 'I wrote my entity's capability as a command. I do not need a hook because operators will always call it directly.' What is missing from this reasoning?"

**Acceptable answers:**
- "The command is not callable by other entities via automated PROMPT invocation. If another entity needs to trigger this capability autonomously, it has no mechanism to do so. The hook is what makes the capability accessible to automation. Without it, the entity cannot be part of a multi-entity workflow."
- "Commands are operator-initiated. Automated orchestration uses the hook. An entity with only commands cannot be a team participant — it can only be controlled by a human."

**Red flag answers (indicates level should be revisited):**
- "That's correct — hooks are optional" — technically true but misses the automation consequence
- "They could just call the command.sh directly" — this bypasses the cascade, environment injection, and invocation contract; not a correct pattern

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

<!-- SCAFFOLD: The integration exercise is the payoff for seven levels of curriculum. Alice should treat it as a celebration, not a test. The operator has built something real and working — a practice entity with commands, a hook, shared library logic, and end-to-end test coverage. Acknowledge that.

Atom 7.4 (signed policy blocks) is a brief awareness delivery — two to three minutes, not a deep dive. The point is to close the loop on the mysterious block in Juno's hook that the operator saw at Level 4. "You saw it, now you know what it is, here is where to learn to make your own." Do not teach GPG clearsigning here — that is advanced-trust-bonds territory.

Atom 7.5 (Builder Path completion) is Alice's opportunity to frame the full journey. The operator started with no knowledge of commands or hooks and ended with a working entity skill. They are now capable of building entities that work as both tools (commands) and team members (hook). That is the transition from user to builder that the Builder Path exists to enable.

After Level 7, suggest the operator clean up the practice entity: commit all the work they have done (the commands, hook, lib files, and README updates) so the practice entity's history captures what was built. This makes it a reference artifact, not just a throwaway. Some operators will keep it as a template for future entity authoring. -->

---

### What Comes Next

The Builder Path is complete. You can gestate entities, authorize them with trust bonds, and teach them to act with commands and hooks. The natural next step is `multi-entity-orchestration`: running the full koad:io team, reading distributed output, coordinating entities via GitHub Issues, and designing multi-step workflows where entities hand off work to each other.
