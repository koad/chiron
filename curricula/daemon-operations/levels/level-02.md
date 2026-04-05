---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 2
slug: passenger-json
title: "passenger.json — Registering an Entity with the Daemon"
status: authored
prerequisites:
  curriculum_complete:
    - advanced-trust-bonds
  level_complete:
    - daemon-operations/1
estimated_minutes: 35
atom_count: 6
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 2: passenger.json — Registering an Entity with the Daemon

## Learning Objective

After completing this level, the operator will be able to:
> Write a valid `passenger.json` for any entity, place it in the correct location, trigger a passenger reload via the `passenger.reload` DDP method, and verify that the entity appears in the Passengers collection.

**Why this matters:** `passenger.json` is the entity's registration card. A missing or malformed file means the entity is invisible to the daemon — it does not appear in the Dark Passenger browser overlay, it cannot receive URL context, and its quick-launch buttons do not exist. Getting this right for every entity is a foundational operational task.

---

## Knowledge Atoms

### Atom 2.1: Discovery — How the Daemon Finds Entities

The daemon does not maintain a list of entities. There is no global registry to update, no configuration file to edit when a new entity is gestated. Discovery is automatic — the daemon scans the home directory at startup and locates koad:io entities by their structure.

The discovery process works in two steps:

**Step 1 — Identify koad:io entity directories.** The daemon reads `$HOME/` and looks at every directory that starts with `.` (dot directories, which is the convention for entity home directories). For each dot directory, it checks whether the `.env` file inside contains the string `KOAD_IO_`. A `.env` that includes any `KOAD_IO_*` variable — `KOAD_IO_VERSION`, `KOAD_IO_PORT`, `KOAD_IO_ENTITY`, or any other — marks the directory as a koad:io entity. Directories without a `.env`, or with a `.env` that has no `KOAD_IO_` variables, are ignored.

**Step 2 — Load `passenger.json` from qualifying directories.** For each directory identified as a koad:io entity, the daemon looks for `passenger.json` at the root of the entity directory: `~/.<entity>/passenger.json`. If the file exists and is valid JSON, the entity is registered as a passenger. If the file does not exist or is malformed JSON, the daemon logs a message and moves on — no error is thrown, no startup is interrupted.

This means the operator's only job is to put a valid `passenger.json` in the right place. The daemon will find it at startup, and (after Level 2.6) on-demand via `passenger.reload`. No daemon restart is required to register a new entity — only a reload.

The daemon does not watch for file changes in real time. Adding a `passenger.json` to an entity directory does not automatically register the entity. Registration happens at startup and on explicit reload. This is by design: continuous file watching is expensive, and registration is not a high-frequency operation.

**What you can do now:**
- Explain the two-step discovery process the daemon uses to find entities
- State where `passenger.json` must be placed in an entity directory
- Describe what happens when `passenger.json` is missing vs. when it is malformed JSON

**Exit criterion for this atom:** The operator can state the discovery mechanism from memory — what the daemon looks for, where, and what triggers registration.

---

### Atom 2.2: Required Fields — The Minimum Valid passenger.json

A valid `passenger.json` requires three fields. Without all three, the daemon will either fail to parse the file or produce a passenger entry with missing display properties. Here is the minimum valid file:

```json
{
  "handle": "chiron",
  "name": "Chiron",
  "role": "architect"
}
```

**`handle`** — the entity's lowercase alphanumeric identifier. No spaces, no special characters, no capital letters. This must match the entity's directory name without the leading dot: `~/.chiron/` → `handle: "chiron"`. The handle is used as the primary key in the Passengers collection. If two entities have the same handle, the second registration is skipped and the daemon logs that the entity is "already registered."

**`name`** — the entity's display name. This is the human-readable string shown in the browser overlay and admin PWA. Capitalization and formatting follow entity convention: `"Juno"`, `"Vesta"`, `"Chiron"`. The name field is also what `passenger.check.in(passengerName)` matches against — note that the check-in method takes the display name, not the handle.

**`role`** — the entity's functional role in the ecosystem. The role is displayed in the admin PWA and browser overlay. It is a free-form string in practice; the daemon does not validate against an enumerated list. Roles used across the current entity team:
- `"business orchestrator"` (Juno)
- `"architect"` (Vesta)
- `"builder"` (Vulcan)
- `"curriculum architect"` (Chiron)
- `"guardian"`, `"researcher"`, `"messenger"`, `"observer"` — used or reserved by other entities

Use a role that accurately describes the entity's primary function. A one-to-three word noun phrase is the standard format.

**What happens when validation fails:**

The daemon logs a warning and skips the registration — no crash, no interruption. A file with invalid JSON (a trailing comma, a missing closing brace) produces a log line: `[PASSENGERS] No passenger.json for <entity>: SyntaxError: Unexpected token`. An operator who sees this log line should go fix the JSON in the entity's directory and trigger a reload.

**What you can do now:**
- Write a minimum valid `passenger.json` for any entity from memory
- Explain what `handle` must match and why
- State what `passenger.check.in` uses when selecting an entity — name or handle

**Exit criterion for this atom:** The operator can write a minimum valid `passenger.json` with the correct handle, name, and role values, without reference to documentation.

---

### Atom 2.3: Optional Fields — Avatar, Outfit, Buttons, Status

The three required fields register an entity. The optional fields control how the entity presents in the browser overlay and admin PWA — its visual identity and the actions available from the quick-launch widget.

**`avatar`** — a file path to the entity's avatar image, relative to the entity directory. Convention is `"avatar.png"`:

```json
{
  "avatar": "avatar.png"
}
```

The daemon reads `~/<entity>/avatar.png`, converts it to a base64 data URI, and stores the data URI in MongoDB. Once embedded, the avatar travels with the entity's Passengers collection document — clients do not need to fetch the image separately. If the file at the specified path does not exist, the daemon logs a warning and falls back to a constructed path (`/<entity>/avatar.png`) — the avatar will be absent in the overlay but the entity registers successfully.

**`outfit`** — a color configuration for the entity's visual theme. If absent, the daemon generates a default outfit by hashing the entity's handle:

```js
// Generated from handle hash — deterministic per handle
{ hue: 210, saturation: 55, brightness: 35 }
```

To specify an explicit outfit, provide an HSB object:

```json
{
  "outfit": { "hue": 45, "saturation": 60, "brightness": 40 }
}
```

The outfit determines the color of the entity's quick-launch diamond and overlay indicators. Every entity will always have an outfit — either specified or generated. The generated outfit is deterministic: the same handle always produces the same colors.

**`buttons`** — an array of quick-launch action definitions:

```json
{
  "buttons": [
    { "label": "Status", "action": "status", "description": "Current ops status" },
    { "label": "Inbox", "action": "inbox", "description": "Check comms inbox" }
  ]
}
```

Button labels appear in the browser overlay widget. The `description` field is displayed on hover. The `action` field is what gets executed when the button is clicked — see Atom 2.4 for how actions are resolved.

**`status`** — the entity's operational state. Valid values: `"active"`, `"paused"`, `"dormant"`. If absent, the entity is treated as active. The admin PWA can display this field as a visual indicator, allowing operators to see at a glance which entities are currently in operation.

**What you can do now:**
- Add an avatar path, outfit, and buttons array to a `passenger.json` you have written
- Explain what happens if the avatar file is missing
- Describe how the outfit is determined when the `outfit` field is absent

**Exit criterion for this atom:** The operator can write a fully-specified `passenger.json` with all optional fields populated correctly.

---

### Atom 2.4: The Buttons Array in Practice

The buttons array is the most operationally significant optional field. Buttons that work reliably are useful; buttons that silently fail are confusing. Understanding how the daemon resolves a button's `action` field prevents that confusion.

When a button is clicked in the browser overlay, the client calls `Meteor.call(this.action, this.target, callback)`. The `action` is the string from the button's `action` field. This is a DDP method call — the daemon receives it and decides what to do.

**Actions that match defined DDP methods:**

If the `action` value exactly matches a registered Meteor method name (like `passenger.check.in`, `passenger.reload`, `passenger.ingest.url`), that method is called directly. This is not the intended use of the buttons array — the browser overlay is for entity-specific actions, not daemon internal methods.

**Actions that match hook names:**

For entity-specific operations, the `action` value should match a hook or command the entity has defined. The daemon's button dispatch looks for a registered hook or command with that name. If a hook named `status` is registered, the `action: "status"` button triggers it. Vesta's buttons demonstrate this pattern:

```json
{
  "buttons": [
    { "label": "Specs", "action": "specs", "description": "View active specs" },
    { "label": "Gap", "action": "gap", "description": "File a structural gap" },
    { "label": "Reconcile", "action": "reconcile", "description": "Reconcile spec vs reality" }
  ]
}
```

`specs`, `gap`, and `reconcile` are hook names defined in Vesta's entity directory. When the button is clicked, the daemon resolves the action to the hook and invokes it. If the hook is not registered, the button click produces no visible effect and logs an error.

**Actions that silently fail:**

An `action` value that does not match any DDP method and does not match any registered hook will produce a silent failure — the button appears in the overlay, the click fires, and nothing happens. The operator sees no feedback. This is the most common button-authoring error.

To write buttons that work:
1. Use action names that match hooks you have actually defined in the entity directory
2. Verify the hook exists before adding the button
3. Test buttons after a `passenger.reload` by clicking them and checking the daemon log for the invocation

**Label length:**

Button labels appear in a constrained display area. Labels over approximately 20 characters will be truncated or overflow in the overlay widget. Keep labels short and action-oriented: `"Status"`, `"Inbox"`, `"Issues"`, `"Specs"`.

**What you can do now:**
- Write a buttons array for an entity with two working buttons, using action names that match existing hooks
- Explain what happens when a button's action does not match any hook or method
- State the practical label length limit

**Exit criterion for this atom:** The operator can explain how button actions are resolved, write a buttons array with working actions, and identify the failure mode for an action that does not match any hook.

---

### Atom 2.5: Avatar Embedding — What the Daemon Does With It

The avatar handling is worth understanding because the behavior is not obvious: the daemon reads the image file, converts it to base64, and stores the data URI in MongoDB — not the file path. After this transformation, the image is self-contained in the database document.

Here is the exact process:

1. The daemon reads the `avatar` field from `passenger.json`. If the value starts with `data:` (a data URI), it is already embedded and stored as-is.
2. If the value does not start with `data:`, the daemon treats it as a file path relative to the entity directory: `~/<entity>/<avatar value>`.
3. The daemon reads the file at that path and calls `.toString('base64')` on the buffer.
4. The result is stored in MongoDB as `data:image/png;base64,<base64string>`.

The MongoDB document's `image` field contains this full data URI. When the browser extension or admin PWA renders the entity's avatar, it uses this stored value directly — no file system access required, no external request, no dependency on the entity directory being accessible.

**What this means operationally:**

- The avatar is embedded at registration time. If you change `avatar.png` after registration, the change is not reflected in the collection until `passenger.reload` is called.
- If the avatar file is missing when registration runs, the daemon logs a warning and falls back: the `image` field in the collection is set to `/<entityname>/avatar.png` — a constructed path that the HTTP server may or may not be able to serve. In practice, this results in a broken image in the overlay.
- Deleting or moving `avatar.png` after a successful registration does not break anything — the base64 data URI is already in MongoDB. The file is only needed at registration time.
- Large avatar images make the MongoDB document large. Convention is a small PNG (64×64 or 128×128 pixels). There is no enforced size limit, but images over a few hundred kilobytes will noticeably slow collection document transfers over DDP.

**What you can do now:**
- Explain the difference between what is stored in MongoDB (`image` as data URI) and what is in the entity directory (`avatar.png` as a file)
- Describe what happens operationally if `avatar.png` is missing at registration time
- State when re-calling `passenger.reload` is necessary to update an avatar

**Exit criterion for this atom:** The operator can explain the avatar embedding process end-to-end: file on disk → base64 → data URI stored in MongoDB → served to clients via DDP.

---

### Atom 2.6: Triggering a Reload

The daemon does not watch the filesystem for changes. After adding or modifying a `passenger.json`, you must trigger a reload to update the Passengers collection. The reload method is `passenger.reload`.

**What `passenger.reload` does:**

1. Removes all documents from the Passengers collection (`Passengers.remove({}`))
2. Re-runs the full discovery and registration process — re-scans `$HOME/.*`, re-reads every `.env`, re-loads every `passenger.json`, re-embeds every avatar
3. Inserts fresh documents into the Passengers collection
4. Returns `{ success: true }`

The collection is empty for the brief moment between the remove and the re-registration. Clients subscribed to `all` or `current` will see a brief flash of empty state — the overlay may flicker. For production environments where the overlay must remain stable, trigger reloads during downtime.

**Three ways to call `passenger.reload`:**

**Via the admin PWA** (simplest):
Open `localhost:9568` in a browser. The admin PWA has a Reload button that calls `passenger.reload`. Click it. The collection repopulates and the PWA refreshes.

**Via a DDP client** (from the terminal):
Install a DDP client tool, connect to `ws://localhost:9568/websocket`, and call the method. This is for scripted or automated reloads.

**Via a registered hook** (if the entity defines one):
Some entities define a `reload` hook or command that calls `passenger.reload` internally. If such a hook exists, running it from the entity's command context triggers the reload.

**When to trigger a reload:**
- After adding `passenger.json` to a new entity directory
- After editing any field in an existing `passenger.json` — buttons, role, name, avatar path
- After replacing `avatar.png` with a new version
- After moving or renaming an entity directory
- After gestating a new entity on a machine where the daemon is already running

A reload does not restart the daemon. The daemon process continues running; only the Passengers collection is refreshed.

**What you can do now:**
- Trigger a `passenger.reload` via the admin PWA at `localhost:9568`
- Describe the three scenarios that require a reload (new entity, edited passenger.json, replaced avatar)
- Explain what happens to the Passengers collection during the reload and why the overlay may flicker

**Exit criterion for this atom:** The operator can write a complete `passenger.json`, place it in the correct directory, trigger a reload, and verify the entity appears in the Passengers collection with the correct fields.

---

## Exit Criterion

The operator has written a valid `passenger.json` with required and optional fields, placed it in an entity directory, triggered a `passenger.reload`, and verified the entity appears in the Passengers collection. They can explain every field they wrote and what the daemon does with each.

**Verification sequence:**
1. Operator writes a `passenger.json` from scratch for a test entity (no template, no reference)
2. Operator places the file in `~/.<testentity>/passenger.json`
3. Operator triggers a reload via the admin PWA
4. Operator navigates the admin PWA and identifies the newly registered entity
5. Operator is asked: "Your avatar.png is 2MB. Is there a problem?" — expected answer: "Yes — large avatars are embedded as base64 in MongoDB documents and transmitted over DDP on every subscription. A 2MB image will slow the collection significantly. Keep avatars small, 64×64 or 128×128."

---

## Assessment

**Question:** "You add a passenger.json to a new entity directory while the daemon is running. You check the admin PWA and the entity is not there. What do you do?"

**Acceptable answers:**
- "Trigger a passenger.reload. The daemon doesn't watch the filesystem — it only registers at startup and on explicit reload. The entity won't appear until I reload."
- "Open localhost:9568, click Reload, then check the Passengers list again."

**Red flag answers:**
- "Restart the daemon" — technically works but is unnecessary; reload is the correct operation
- "Check the .env file" — the .env check is part of discovery, not the likely cause; the entity directory was found but passenger.json wasn't picked up because no reload was triggered

**Estimated engagement time:** 30–35 minutes (includes hands-on JSON authoring)

---

## Alice's Delivery Notes

This level has the highest hands-on density of any level in the first half of the curriculum. The operator will be writing JSON, placing files, and triggering reloads. Give them time to make mistakes — a malformed JSON file and a successful recovery from the log error is more valuable than a smooth first attempt.

The most important insight to deliver: the daemon does not watch the filesystem. Operators who have worked with modern web frameworks (webpack hot reload, nodemon, etc.) will expect that adding or changing a file triggers automatic detection. The koad:io daemon does not do this. Drill the reload step until it is automatic.

The buttons atom is conceptually tricky because failures are silent. Emphasize the testing pattern: after writing a button, trigger a reload, then click the button and watch the daemon log. If you see the method invocation in the log, the button is working. If you see nothing, the action doesn't match any registered hook.

The avatar embedding behavior is counterintuitive (file on disk → data URI in MongoDB → removed from dependency). Walk operators through it deliberately. The practical implication — you only need the file at registration time — can be surprising and is genuinely useful to know.

Do not abbreviate Atom 2.6. The reload trigger is the most operationally critical step in this level. Operators who understand all six atoms but don't reliably trigger reloads will spend debugging time on "why isn't my entity appearing" problems that are trivially avoidable.

---

### Bridge to Level 3

The entity is registered. Level 3 covers the other side of registration: reading the Passengers collection directly — through the admin PWA, through the MongoDB documents, and through the `current` and `all` DDP publications that clients subscribe to.
