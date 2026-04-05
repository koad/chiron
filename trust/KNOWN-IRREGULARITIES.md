# Known Irregularities — Chiron Trust Directory

## Bond Filing Attribution (2026-04-05)

**Issue:** The `juno-to-chiron` recipient-side bond was committed under `Chiron <chiron@kingofalldata.com>` in commit `99638f1`.

**What happened:** Salus filed the bond to Chiron's repo as part of the dual-filing protocol. The commit was authored as Chiron rather than as Juno or Salus (the authorizing entity doing the filing).

**Why it matters:** Git authorship at the commit level is part of the audit trail. The Bond Filing Protocol (Juno GOVERNANCE.md) specifies that the authorizer makes the recipient-side commit — the author field should reflect Juno or Salus, not Chiron.

**Why it's not critical:** The cryptographic signature on the bond file itself is correct — `juno-to-chiron.md.asc` is a valid clearsigned document signed by Juno's key. The GPG signature is the load-bearing authorization layer; the git author field is a secondary audit indicator.

**Status:** Documented here and in Juno's GOVERNANCE.md (Note, 2026-04-05). Aegis flagged in Day 30 assessment (`assessments/2026-04-05-day30-assessment.md`, Finding 3). No rewrite planned — rewriting git history would be more disruptive than the irregularity itself. The irregularity is documented so any automated audit process treating git authorship as primary can account for it.

**Flagged by:** Janus (governance review), Aegis (Day 30 sovereignty assessment)
