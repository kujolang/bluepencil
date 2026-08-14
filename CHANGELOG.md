# Changelog

## 0.2.0 - 2026-08-14

- Preserved validation compatibility with immutable 0.1.0 records while emitting 0.2.0 records.
- Prevented audit-history conflicts from leaving partial records and added clean-retry regression coverage.
- Tightened timestamp, actor, secret-shape, state metadata, managed-directory, pagination, record-size, and artifact-size validation while eliminating duplicate record reads.
- Modularized the runtime and enforced eight-dimension ratings, reviewer/rubric identity, verdict taxonomy, and blocker precedence.
- Added atomic storage/export, per-record locks, bounded comparison/pagination, secret rejection, and corrupt-state diagnostics.
- Added production CI, domain/security suites, improved documentation, and a future worklist while preserving the 18-pair/23-role corpus.

## 0.1.0 - 2026-08-14

- Initial Kujo-native release with working local records, validation, contracts, fixtures, and safety boundaries.
