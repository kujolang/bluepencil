# Changelog

## Unreleased

- Added exact-byte audit reconciliation and immutable transaction intent inspection/recovery.
- Added distinct report, history, and disagreement behavior plus seven offline evaluation commands.
- Tightened typed contracts and record schemas, added trusted-key lifecycle checks and deterministic format evaluation.
- Added an executable editorial walkthrough and cleanup for legacy test fixtures.

- Made record dry runs and invalid submissions side-effect-free.
- Preserved flags on `--version`, rejected missing option values and oversized integers, and validated Gregorian calendar dates.
- Added bounded record scan budgets and continuation cursors; incomplete validation/health scans now fail explicitly.
- Replaced recursive-directory locking with exclusive atomic lock files and disabled overwrite for new records/history and unforced exports.
- Made the launcher portable, aligned the record schema with legacy compatibility, and clarified library versus CLI capabilities.
- Added regression coverage and the September 2026 prioritized readiness worklist.

- Standardized README badge ordering and repository-local artifact ignores.
- Kept Loop Engineering evidence available locally while removing it from published source.

## 0.2.0 - 2026-08-14

- Preserved validation compatibility with immutable 0.1.0 records while emitting 0.2.0 records.
- Prevented audit-history conflicts from leaving partial records and added clean-retry regression coverage.
- Tightened timestamp, actor, secret-shape, state metadata, managed-directory, pagination, record-size, and artifact-size validation while eliminating duplicate record reads.
- Modularized the runtime and enforced eight-dimension ratings, reviewer/rubric identity, verdict taxonomy, and blocker precedence.
- Added atomic storage/export, per-record locks, bounded comparison/pagination, secret rejection, and corrupt-state diagnostics.
- Added production CI, domain/security suites, improved documentation, and a future worklist while preserving the 18-pair/23-role corpus.

## 0.1.0 - 2026-08-14

- Initial Kujo-native release with working local records, validation, contracts, fixtures, and safety boundaries.
