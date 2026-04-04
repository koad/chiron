# command: juno outreach send

**Status:** planned  
**Owner:** juno  
**Priority:** high

## Purpose
Trigger sponsor outreach for an approved target — coordinate template selection, Veritas quality gate, and Mercury delivery.

## Usage
```
juno outreach send <target> <template>
```

## Expected Output
- Pre-send summary showing target, template, and personalization
- Veritas gate result (PASS/FAIL)
- Confirmation that Mercury queued the send
- GitHub issue created to track response

## Implementation Plan
- Load target profile and selected template
- Run Veritas quality gate (fact-check claims)
- Require koad approval (interactive confirmation)
- Invoke Mercury to send via appropriate platform
- Create tracking issue on koad/juno

## Dependencies
- Approved outreach templates
- Mercury platform credentials (koad/juno#11)
- Veritas review command
- koad explicit approval before send
