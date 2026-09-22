# BluePencil readiness review — 2026-09-22

## Assessment

**Not yet universally useful or enterprise-ready.** BluePencil is a useful
Kujo-native local editorial-record foundation. The CLI enforces a bounded
review contract and stores evidence; it does not implement an authenticated
editorial service, complete audit verification, or all the workflows implied
by the earlier completed worklist.

Scope: all seven runtime modules, five original test suites, launcher,
validation scripts, CI, JSON schemas, root files, and public documentation.
The calibration corpus remains checksum-bound by the original tests; this
review did not reassess the editorial quality of all corpus prose. This is an
engineering review, not compliance certification or a formal security scan.

## Enhancements delivered

- Dry-run and rejected review submissions no longer initialize state.
- `--version --json` preserves flags and produces parseable JSON; missing flag
  values and unknown direct dispatch commands fail explicitly.
- Timestamp checks enforce month lengths and Gregorian leap years; excessive
  integer input fails before conversion.
- Calibration scoring rejects non-array observed judgments.
- Listing reads at most 1,000 candidate records, including corrupt or filtered
  records, and returns a continuation cursor. It can no longer accumulate an
  unlimited corrupt-record warning list in one call.
- Full-state validation and doctor fail explicitly when coverage is truncated.
- Exclusive atomic lock files replace recursive directory creation. New records
  and history events use atomic no-overwrite writes. Unforced export also uses
  no-overwrite at the write operation rather than relying only on a precheck.
- Launcher uses `KUJO_BIN` or PATH; record schema includes required contract
  version and accepts the runtime's supported 0.1.0/0.2.0 record versions.
- README describes real CLI behavior, library-only helpers, trust boundaries,
  pagination, runtime verification, and the repository layout.

Root cleanup: `bluepencil.kujo` is the intentional public two-line dispatcher.
`kujo.toml`, VERSION, LICENSE, AGENTS.md, README, and CHANGELOG have distinct
purposes. There is no redundant root implementation to move or delete.

## Verification and limits

The baseline gate passed all 47 original assertions on installed Kujo 1.4.0.
The final gate passed 69 assertions across six suites with zero failures,
plus CLI/JSON/hygiene checks. The enhanced gate adds regression checks for dry runs, argument errors,
calendar dates, overflow, malformed calibration data, bounded corrupt scans,
resumable pagination (including prefix-related IDs), partial validation/doctor,
and exclusive lock behavior. A four-process competing-write check produced
exactly one successful write, one record/event pair, and no stale locks.
Run `KUJO_BIN=/path/to/kujo bash scripts/validate.sh`; it also checks fixture
and schema JSON syntax, CLI smoke behavior, repository hygiene, and whitespace.
JSON syntax checks are not JSON Schema validation.

The repository-requested sibling `kujo/target/release/kujo` binary was absent;
testing uses `/Users/robertdevore/.local/bin/kujo` (1.4.0). The minimum 1.0.1
runtime and CI-pinned revision have not been revalidated here. Codex Security
could not initialize: its plugin raised `TypeError: unsupported operand
type(s) for |: 'type' and 'NoneType'`. No formal scan was completed.

The 1,001-record regression fixtures establish behavior, not performance SLOs.
No cross-platform, power-loss, hostile filesystem race, or large-byte memory
benchmark is claimed. Preserve those distinctions when presenting the project.

## Next-session worklist

Each item requires source changes and verification before being marked done.
Priorities reflect local data integrity before broader product features.

### P1 — storage and trust boundaries

- [x] **BP-01: Reconcile records with creation events.** `validate_record` in
  `src/core.kujo` checks payload and artifact hashes but never reads the stored
  event checksum. The existing legacy-compatibility test rewrites record bytes
  and still validates, demonstrating that schema validity is distinct from
  historical integrity. Add a separate audit verifier that reports missing,
  altered, duplicate, and orphan events; test record tampering, event tampering,
  and legitimate legacy records. Do not imply protection against a filesystem
  owner who can rewrite both sides without an external trust anchor.
- [x] **BP-02: Add crash recovery and lock ownership.** `save_new` writes record
  then history and rolls back on caught failure; process death between writes
  bypasses rollback and lock release. Add a recoverable transaction protocol,
  ownership metadata, and explicit stale-lock inspection/recovery. Inject
  failures at each persistence boundary; prove retries never delete another
  writer's data. Do not clear locks merely because they are old.
- [ ] **BP-03: Confine filesystem operations.** `validate_state_path` checks the
  final state path and `initialize` checks managed leaves; `ensure_tree` accepts
  linked ancestors. Ordinary path-based read/write operations also leave
  check/use races. Evaluate Kujo's descriptor-relative beneath-root I/O before
  changing the declared minimum runtime. Test ancestor links, dangling links,
  concurrent replacement, output paths, and platform `/tmp` aliases. Until then,
  require trusted directories and cooperating writers.

### P2 — scale, contracts, and useful workflows

- [ ] **BP-04: Bound bytes and directory enumeration.** `list_records` still
  sorts the complete directory and may hold up to 1,000 one-MiB records; export
  checks its eight-MiB cap after serialization. Add an aggregate byte budget,
  bounded iterator/index strategy, and truly incremental report/export output.
  Benchmark normal, sparse-filter, corrupt, and maximum-size corpora with wall
  time and peak RSS; keep pagination stable and measure before claiming gains.
- [x] **BP-05: Implement distinct report/history/disagreement commands.**
  `profile.list_commands` routes all three to the same record listing.
  Define report totals, pairwise disagreement semantics, and actual event
  history. Test pagination, record types, missing peers, and blocker preservation.
- [x] **BP-06: Integrate hardening helpers as real workflows.** The CLI does not
  import `src.hardening`. Specify commands and fixtures for blind scoring,
  rubric bundle verification, format rule evaluation, and accessibility evidence.
  Receipts must distinguish declarations from independently observed checks.
  HMAC is shared-secret authentication, not public-key signing; define key trust
  and rotation before presenting signed bundle distribution.
- [x] **BP-07: Tighten typed contracts.** Config values have key checks but lack
  complete type checks; `validate_record` accepts non-mutation commands and
  incompletely shaped artifact fields; finding array members are not validated.
  Bundle compatibility accepts missing/poorly formed versions. Add negative
  fixtures for every exported boundary, align JSON schemas, validate schemas
  against actual records, and preserve safe unknown metadata deliberately.
- [ ] **BP-08: Establish runtime and platform support.** Exercise the declared
  minimum and pinned runtime, Linux/macOS/Windows launch behavior, simultaneous
  first initialization, repeated competing writes, and fixture-only integration
  with Publishing House consumers. Document supported versions from evidence.

### P3 — release presentation and maintainability

- [x] **BP-09: Add an editorial walkthrough.** Show one complete review,
  comparison, blocker resolution, calibration, and exported evidence using
  versioned examples and expected CLI output. Link the Kujo language concepts
  demonstrated by real code. Keep claims synchronized through executable docs.
- [x] **BP-10: Improve maintainability and test hygiene.** Expand compressed
  domain/hardening code into readable functions, standardize error envelopes,
  remove unused helpers/imports, and clean temporary state in all old tests.
  Retain public entrypoint compatibility and add only behavior-focused tests.

Start with BP-01 through BP-03, then establish the BP-04 measurements. Feature
expansion should build on those storage guarantees rather than obscure them.

## Completion evidence (continuation)

BP-01: `src/audit.kujo`, `audit` CLI, and `tests/audit_test.kujo` (12 passing assertions) reconcile exact persisted bytes, event identities, duplicates, missing/orphan events, malformed events, and legitimate 0.1.0 records. Reports fail when coverage is incomplete. Local checksum reconciliation does not establish an external trust anchor.

BP-02: immutable transaction intents (`src/transaction.kujo`) replace transient locks for new writes. `transaction --id` exposes owner/completion; `recover --id --owner` idempotently publishes only exact original bytes. Legacy locks are never stolen. `tests/transaction_test.kujo` passes 24 checks covering interruption after intent/record/event publication, incorrect owner, duplicate creation, incomplete audit, record/event conflicts, and safe repeat recovery. No recovery path deletes a record or clears an age-based lock. Power-loss durability still depends on filesystem/runtime atomic-write guarantees.

BP-05/BP-06: report page totals, actual event-history pagination, blocker-preserving pairwise disagreements, blind scoring/trends, trusted-key bundle verification, upgrade checks, four format evaluators, and explicit declaration-only adapter/accessibility checks are CLI-accessible. `tests/workflows_test.kujo` passes 15 checks; `docs/WORKFLOWS.md` defines supplied-content and key rotation/revocation contracts.

BP-07: typed configuration, mutation-only records, artifact structure, finding entries, bundle versions/downgrades, and helper inputs are rejected at their boundaries. `tests/contracts_test.kujo` passes 27 checks including native JSON Schema validation of actual current and legacy records. Schemas preserve safe unknown metadata; runtime checks additionally enforce Gregorian dates, hashes, and secret-shaped fields.

BP-09: the versioned editorial walkthrough and expected summary are tested through `tests/walkthrough_test.kujo` (4 checks including three exported record schemas). See `docs/EDITORIAL_WALKTHROUGH.md` and `examples/editorial_walkthrough/`.

BP-10: domain/hardening/profile code is expanded, helper failures now carry error codes, unused storage helpers/imports are removed, and the original filesystem test suites clean their own temporary trees using a symlink-aware fixture cleanup helper. The public entrypoint remains intact. The combined gate passes 151 assertions across eleven suites, with JSON/schema, CLI, and repository hygiene checks.
