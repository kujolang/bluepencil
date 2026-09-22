# Next-session execution ledger

Scope: every item in NEXT_SESSION_2026-09-22.md. This ledger records evidence;
unchecked items remain part of the active goal.

| Item | Required completion evidence | Status |
| --- | --- | --- |
| Distribution | Primitive upstream/release evidence; checksummed platform binaries; installation and application smoke in a clean environment | Candidate runtime in Kujo PR #11; all three platform gates and clean offline Ubuntu installation pass at 41e3949; final publication pending |
| Indexed large collections | Rebuildable index/segmentation evaluation near the directory ceiling; complete-export and sparse-filter latency, RSS, retained bytes; preserved/versioned cursors | Complete: all 12 dedicated-CI measurements exported 95,000/95 records with verified ordinal sums; latency, RSS, retained bytes, build/disk costs and versioned cursor boundary recorded |
| Independent checkpoints | Custody/verification design; optional independently retained evidence; coordinated-rewrite detection; tamper/restore tests | Complete: 13 checkpoint assertions and the full local gate pass; custody and restored-state verification documented |
| Editorial evaluation | Expanded licensed examples; independent reviewer labels with provenance; inter-reviewer agreement; semantic versus structural claims kept separate | Complete: 18 licensed HelpSteer2 pairs with 54 original annotations; pairwise agreement 77.78%, Fleiss kappa 0.5531; byte-exact import reproduction and 22 agreement/corpus assertions pass. Six additional original candidates remain explicitly unlabeled |
| Operator adapter | Real phase request/receipt implementation; identity, immutable digest, timeout and no-publication enforcement; disposable offline operator integration | Complete: 15 adapter assertions, 6 artifact-boundary assertions, and 7 actual consumer sandbox assertions pass, including checksum rejection and timeout; isolated external-consumer launch required |
| Collaboration | Explicit service decision and corresponding tenancy, roles, retention, privacy, backup/restore, and deployment ownership requirements | Local CLI retained by default; requirements recorded in design/COLLABORATION.md |

Preserve the offline CLI, immutable records and creation history, bounded I/O,
symlink confinement, and PROPOSE-only publication boundary. All application,
fixture, and test behavior remains in Kujo. Do not substitute generated labels
for independent judgments or mark a queued release/verification as completed.
