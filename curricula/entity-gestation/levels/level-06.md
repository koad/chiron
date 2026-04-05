---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 6
slug: passenger-json
title: "passenger.json — Registering with the Daemon"
status: authored
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-05
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 6: passenger.json — Registering with the Daemon

## Learning Objective

After completing this level, the operator will be able to:
> Author a `passenger.json` for the new entity, explain what each field declares, place the file in the entity directory root, commit and push it, and confirm the daemon picks it up — so the entity appears in the Passengers collection and can be selected as the active companion.

**Why this matters:** An entity without a `passenger.json` is invisible to the daemon. It cannot be selected as the active companion, it will not appear in the desktop widget, and URL context from the Dark Passenger browser extension will never reach it. The `passenger.json` is the entity's registration card with the real-time layer — the last configuration step before the first operations test.

---

## Knowledge Atoms

## Atom 6.1: What the Daemon Is and Why Registration Matters

The koad:io daemon is a persistent background service running at `localhost:9568`. It is the real-time hub of the koad:io system: it maintains the Passengers collection (the registry of all active entities), serves the admin PWA, receives URL context from the Dark Passenger browser extension, and manages the DDP event bus that entities use to communicate.

The daemon is the layer that makes koad:io a live system rather than a collection of independent scripts. When you select an entity as your active companion in the desktop widget, you are telling the daemon which entity receives incoming context. When you browse to a page and the Dark Passenger extension captures the URL, it sends that URL to the daemon, which routes it to the active entity's context. This is the mechanism by which entities stay aware of what the operator is doing.

For an entity to participate in any of this, the daemon needs to know it exists. The `passenger.json` file is how the daemon learns about an entity. It is the declaration the daemon reads when it scans entity directories.

The daemon does not automatically discover entities — it does not scan `~/.*` looking for entity directories. It discovers entities by reading `passenger.json` files from configured entity paths. An entity that lacks a `passenger.json` is simply absent from the daemon's registry. It can still be invoked from the command line and can still commit to git, but it has no real-time presence and no connection to the URL context layer.

Registration is not a technical requirement for entity operation — it is a requirement for entity *integration*. An entity that never needs the real-time layer can operate without registering. But entities that are expected to be active companions — that receive URL context, respond to incoming events, and appear in the operator's workspace — must register.

**What you can do now:**
- Navigate to `localhost:9568` (the admin PWA) if the daemon is running and look at the Passengers collection — identify how many entities are registered
- Look at `~/.juno/passenger.json` and `~/.vulcan/passenger.json` — two examples of registered entities
- State in one sentence what happens to URL context from the browser extension if no entity is registered as the active companion (context is captured but has nowhere to go)

**Exit criterion for this atom:** The operator can explain what the daemon does, why the Passengers collection exists, and what the practical consequence is of an entity having no `passenger.json`.

---

## Atom 6.2: The `passenger.json` Format — Fields and Their Meaning

The `passenger.json` file is a JSON object at the root of the entity directory. Here is Juno's, which is the reference implementation:

```json
{
  "handle": "juno",
  "name": "Juno",
  "role": "business orchestrator",
  "avatar": "avatar.png",
  "buttons": [
    { "label": "Status", "action": "status", "description": "Current ops status" },
    { "label": "Inbox", "action": "inbox", "description": "Check comms inbox" },
    { "label": "Issues", "action": "issues", "description": "Open GitHub issues" }
  ]
}
```

And Vulcan's, which shows a builder entity's configuration:

```json
{
  "handle": "vulcan",
  "name": "Vulcan",
  "role": "product builder",
  "avatar": "avatar.png",
  "buttons": [
    { "label": "Assignments", "action": "issues", "description": "Active build assignments" },
    { "label": "Inbox", "action": "inbox", "description": "Check specs inbox" },
    { "label": "Build", "action": "build", "description": "Start a build session" }
  ]
}
```

**Field-by-field explanation:**

**`handle`** — The entity's lowercase identifier. This must match the `ENTITY` value in `.env` exactly. The daemon uses this to uniquely identify the entity in the Passengers collection. If `handle` does not match `ENTITY`, the daemon's internal routing will fail silently.

**`name`** — The display name — used in the desktop widget, admin PWA, and anywhere the entity is shown to the operator. Typically the proper-noun capitalized version of the handle: `"juno"` → `"Juno"`. Can include spaces or special characters since it is display-only.

**`role`** — A short human-readable description of the entity's function. Shown in the admin PWA alongside the name. Not machine-parsed — write it for the human operator reading the entity list: `"business orchestrator"`, `"product builder"`, `"curriculum architect"`.

**`avatar`** — The filename of the entity's avatar image, relative to the entity directory root. The daemon serves this file via its static asset handler. If the file does not exist, the UI shows a placeholder. `"avatar.png"` is the convention — create and commit a `avatar.png` to the entity directory for the avatar to appear.

**`buttons`** — An array of quick-action buttons shown in the desktop widget when this entity is the active companion. Each button has:
- `label` — The display text on the button
- `action` — The command the button triggers when clicked (maps to an entity command in `commands/`)
- `description` — Tooltip text shown on hover

Buttons are optional — an entity with no buttons still registers and functions. Buttons that reference commands that do not exist in the entity's `commands/` directory will fail silently when clicked. Only add buttons for commands the entity actually has.

**What you can do now:**
- Read `~/.juno/passenger.json` and identify the five fields
- Write the `passenger.json` for a hypothetical entity named `nova` with the role `research analyst` and two buttons: `Research` (action: `research`) and `Report` (action: `report`)
- Explain what happens if `handle` in `passenger.json` does not match `ENTITY` in `.env`

**Exit criterion for this atom:** The operator can write a complete `passenger.json` from memory with all five fields populated correctly, and explain what each field controls in the admin PWA and desktop widget.

---

## Atom 6.3: Placement and Commit — Where the File Lives and Why It Is Public

The `passenger.json` lives at the root of the entity directory:

```
~/.nova/
├── .env
├── .gitignore
├── KOAD_IO_VERSION
├── passenger.json     ← here
├── id/
├── ssl/
└── trust/
```

It is committed to git. Unlike `.credentials` (which contains secrets and is gitignored), `passenger.json` contains only public configuration — display information and button definitions. None of the fields are sensitive.

The commit is straightforward:

```bash
cd ~/.nova
git add passenger.json
git commit -m "ops: add passenger.json — register nova with daemon"
git push
```

**Why it must be committed:** The `passenger.json` is configuration that travels with the entity. If you clone the entity's repo to a different machine (the sovereignty proposition: your entity, any machine), the `passenger.json` travels with it. The daemon on the new machine can discover the entity the same way as on the original machine. An `passenger.json` that exists only on one machine means the entity only integrates with the daemon on that machine — which is a partial deployment, not a sovereign portable entity.

**The file in the GitHub repo:** When the entity's `passenger.json` is pushed to GitHub, it is publicly readable. Anyone cloning the entity's repo gets the `passenger.json` and can register the entity with their own local daemon. This is by design — it is how third parties can adopt entity flavors and run them locally. The `passenger.json` is as much a part of the entity's public identity as the `KOAD_IO_VERSION` birth certificate.

If you add an `avatar.png`, commit it at the same time:

```bash
git add passenger.json avatar.png
git commit -m "ops: add passenger.json and avatar — register nova with daemon"
```

An entity without an avatar renders with a placeholder icon. An entity with an avatar is more recognizable in the desktop widget and admin PWA. The avatar is optional but recommended before handoff.

**What you can do now:**
- Confirm `~/.juno/passenger.json` is tracked by git: `git -C ~/.juno ls-files passenger.json`
- Confirm `~/.juno/avatar.png` exists (or note it as absent)
- State why `passenger.json` belongs in the committed layer rather than in a gitignored config file

**Exit criterion for this atom:** The operator can place `passenger.json` in the entity root, explain why it is committed to git, and execute the commit and push commands correctly.

---

## Atom 6.4: Triggering Daemon Discovery — How the Daemon Picks Up the New Entity

Once `passenger.json` is committed and present in the entity directory, the daemon needs to be told to re-scan. The daemon does not watch the filesystem for changes — it reads `passenger.json` files on demand when the operator triggers a reload.

The reload can be triggered in several ways depending on the tools available:

**Via the admin PWA:**
Navigate to `localhost:9568` in a browser. Look for the Passengers section or an admin controls panel. Use the "Reload Passengers" or equivalent control to trigger a re-scan. The UI will refresh and the new entity should appear in the Passengers list.

**Via a DDP method call:**
If the admin PWA is not yet available or you prefer the command line, the daemon exposes the `passenger.reload` DDP method. Tools that speak the DDP protocol can trigger this directly.

**Via entity command (if configured):**
Some entity installations include a reload command. Run `juno reload passengers` or check `juno --help` for available commands.

After triggering the reload, verify the new entity appears:

1. Open `localhost:9568` and navigate to the Passengers view
2. Look for an entry with `handle: nova`, `name: Nova`, and `role: research analyst` (or whatever you set)
3. Confirm the role and name match the `passenger.json` you wrote
4. If the entity has an `avatar.png`, confirm the avatar renders correctly

**If the entity does not appear after reload:**

The most common cause is a `passenger.json` that is not in the daemon's configured entity scan path. The daemon needs to know where to look. Check the daemon configuration for the list of entity directories it scans — the entity path (`~/.nova/`) must be in that list.

The second common cause is a JSON syntax error in `passenger.json`. JSON is strict about syntax: trailing commas, missing quotes, and incorrect bracket nesting all cause a parse failure. Validate the file:

```bash
python3 -m json.tool ~/.nova/passenger.json
```

If this command produces output (the pretty-printed JSON), the file is valid. If it reports an error, fix the syntax before retrying the reload.

**What you can do now:**
- Trigger a passenger reload using whichever method is available in the current environment
- Confirm `~/.juno/` and `~/.vulcan/` appear in the Passengers collection after reload
- Validate `~/.juno/passenger.json` with `python3 -m json.tool` and confirm it is valid JSON

**Exit criterion for this atom:** The operator can trigger a daemon passenger reload, verify the entity appears in the Passengers collection, and diagnose the two most common registration failures (entity path not in scan list; JSON syntax error).

---

## Atom 6.5: The Passenger in the Broader System — Active Companion and Context Routing

Once the entity is registered, the operator can select it as the active companion. The active companion is the entity that receives incoming context from the Dark Passenger browser extension and the DDP event bus.

**Selecting the active companion:**

In the desktop widget or admin PWA, the operator selects an entity from the Passengers list. The selected entity becomes the active companion — it receives URL context, browser tab changes, and any other events that the extension captures. Only one entity can be the active companion at a time.

When `nova` is the active companion and the operator navigates to a GitHub issue, the Dark Passenger extension captures the URL and sends it to the daemon, which routes it to Nova's context. If Nova is running a Claude Code session, the URL context enriches Nova's awareness of what the operator is doing.

**The buttons in the widget:**

The `buttons` array in `passenger.json` appears as quick-action buttons in the desktop widget. When the operator clicks `Research` (mapped to action `research`), the daemon triggers the `nova research` command — equivalent to running `nova research` in a terminal. The button is a shortcut into the entity's command surface.

Button actions must correspond to commands in the entity's `commands/` directory. If `commands/research/` does not exist, clicking the Research button does nothing (or fails silently, depending on the daemon version). Before adding a button, verify the command exists.

**Portability note:**

The `passenger.json` makes the entity portable across machines not just as a configuration archive but as a live integration point. An operator who clones `koad/nova` to their own machine, adds their daemon's entity scan path to include `~/.nova/`, and triggers a reload will see Nova available in their Passengers collection immediately. The buttons may need different commands depending on what the local entity has in `commands/` — but the registration itself is portable.

This is why `passenger.json` belongs in the committed layer. It is not machine-specific configuration — it is the entity's declaration of its interface to the real-time layer.

**What you can do now:**
- Select Juno as the active companion in the desktop widget (if running) and observe the buttons that appear
- Explain what happens when the operator clicks a button whose action command does not exist in the entity's `commands/` directory
- State the one-sentence rule for when to add a button to `passenger.json` (only add buttons for commands that exist in the entity's `commands/` directory)

**Exit criterion for this atom:** The operator can explain the active companion selection model, describe how URL context reaches the active entity, and state the button-command correspondence rule.

---

## Exit Criterion

The operator can:
- Write a complete `passenger.json` from memory with all five fields (`handle`, `name`, `role`, `avatar`, `buttons`)
- Explain why `handle` must match `ENTITY` in `.env`
- Place the file in the entity root and commit it with the correct message
- Trigger a daemon passenger reload and verify the entity appears in the Passengers collection
- Diagnose the two most common registration failures (entity path not in scan list; JSON syntax error)

**Verification question:** "You author a `passenger.json` for `nova`, commit it, push it, and trigger a daemon reload. Nova does not appear in the Passengers collection. The admin PWA shows no error. What are the two most likely causes and how do you diagnose each?"

Expected answer: (1) The daemon's entity scan path does not include `~/.nova/` — check the daemon configuration for the list of entity paths it scans and add `~/.nova/` if missing. (2) The `passenger.json` has a JSON syntax error that causes a silent parse failure — validate with `python3 -m json.tool ~/.nova/passenger.json` and fix any errors reported.

---

## Assessment

**Question:** "A colleague has authored a `passenger.json` for their entity `argus` and run a daemon reload. Argus appears in the Passengers collection, but clicking the 'Watch' button (mapped to action `watch`) does nothing. What is the most likely cause?"

**Acceptable answers:**
- "The `watch` action is configured in `passenger.json` but the corresponding command does not exist in `~/.argus/commands/watch/`. The button has nowhere to route. Add the `commands/watch/command.sh` file and trigger a reload, or remove the button from `passenger.json` until the command is built."
- "There's no `commands/watch/` in Argus's directory. Buttons must correspond to existing commands. Either build the command or remove the button."

**Red flag answers (indicates level should be revisited):**
- "Reload the daemon again" — the button-command correspondence is a configuration issue, not a daemon state issue
- "Edit `passenger.json` to fix the action name" — the issue is the missing command, not the action name

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

The daemon context is the hardest part of this level for operators who have not yet worked with it directly. Many operators completing the entity-gestation curriculum have run entities entirely through the command line and have not used the desktop widget or Dark Passenger extension. Keep the conceptual scope tight: the daemon is the real-time layer, `passenger.json` is the registration card, and the practical outcome of getting it right is that the entity shows up in the Passengers list.

The button-command correspondence is a common point of confusion. Operators often write buttons speculatively — they want a button for functionality that does not yet exist. Clarify: passenger.json is configuration for what exists, not a roadmap for what will exist. Add buttons when commands are ready, not before.

The JSON validation step (`python3 -m json.tool`) is a gift — give it to operators as a habit before every commit. JSON syntax errors are easy to make and opaque to debug without a validator.

Do not cover the DDP protocol in depth. "Daemon uses DDP" is sufficient for this level. The full daemon-operations curriculum is the right place for DDP internals.

---

### Bridge to Level 7

The entity is registered. It has keys, an identity, a trust bond, and a presence in the real-time layer. Level 7 is the first operations test — running the complete post-gestation checklist, spawning the entity's first session, and confirming everything configured in Levels 0–6 is actually working before the entity is handed off or put into service.
