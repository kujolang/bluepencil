# Next-session execution ledger

Scope: every item in NEXT_SESSION_2026-09-22.md. This ledger records evidence;
unchecked items remain part of the active goal.

| Item | Required completion evidence | Status |
| --- | --- | --- |
| Distribution | Primitive upstream/release evidence; checksummed platform binaries; installation and application smoke in a clean environment | Candidate runtime in Kujo PR #11; checksummed bundle workflow added; verification/release pending |
| Indexed large collections | Rebuildable index/segmentation evaluation near the directory ceiling; complete-export and sparse-filter latency, RSS, retained bytes; preserved/versioned cursors | 95,000-record experiment running; prototype and cursor boundary documented |
| Independent checkpoints | Custody/verification design; optional independently retained evidence; coordinated-rewrite detection; tamper/restore tests | Implemented; 13 focused checks pass; full gate pending |
| Editorial evaluation | Expanded licensed examples; independent reviewer labels with provenance; inter-reviewer agreement; semantic versus structural claims kept separate | Six original MIT candidates added; agreement statistics have 8 passing unit checks; independent labels still required |
| Operator adapter | Real phase request/receipt implementation; identity, immutable digest, timeout and no-publication enforcement; disposable offline operator integration | Read-only adapter and actual offline operator sandbox harness implemented; candidate runtime verification pending |
| Collaboration | Explicit service decision and corresponding tenancy, roles, retention, privacy, backup/restore, and deployment ownership requirements | Local CLI retained by default; requirements recorded in design/COLLABORATION.md |

Preserve the offline CLI, immutable records and creation history, bounded I/O,
symlink confinement, and PROPOSE-only publication boundary. All application,
fixture, and test behavior remains in Kujo. Do not substitute generated labels
for independent judgments or mark a queued release/verification as completed.
