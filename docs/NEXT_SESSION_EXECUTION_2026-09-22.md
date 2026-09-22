# Next-session execution ledger

Scope: every item in NEXT_SESSION_2026-09-22.md. This ledger records evidence;
all six items are complete within their stated scope.

| Item | Required completion evidence | Status |
| --- | --- | --- |
| Distribution | Primitive upstream/release evidence; checksummed platform binaries; installation and application smoke in a clean environment | Complete: Kujo PR #11 merged at 78d8725; v0.3.0-rc.1 published from e70621f with Linux x64, macOS ARM64 and Windows x64 bundles; all downloaded checksums verified; platform and clean offline Ubuntu gates pass |
| Indexed large collections | Rebuildable index/segmentation evaluation near the directory ceiling; complete-export and sparse-filter latency, RSS, retained bytes; preserved/versioned cursors | Complete: all 12 dedicated-CI measurements exported 95,000/95 records with verified ordinal sums; latency, RSS, retained bytes, build/disk costs and versioned cursor boundary recorded |
| Independent checkpoints | Custody/verification design; optional independently retained evidence; coordinated-rewrite detection; tamper/restore tests | Complete: 13 checkpoint assertions and the full local gate pass; custody and restored-state verification documented |
| Editorial evaluation | Expanded licensed examples; independent reviewer labels with provenance; inter-reviewer agreement; semantic versus structural claims kept separate | Complete: 18 licensed HelpSteer2 pairs with 54 original annotations; pairwise agreement 77.78%, Fleiss kappa 0.5531; byte-exact import reproduction and 22 agreement/corpus assertions pass. Six additional original candidates remain explicitly unlabeled |
| Operator adapter | Real phase request/receipt implementation; identity, immutable digest, timeout and no-publication enforcement; disposable offline operator integration | Complete: 15 adapter assertions, 6 artifact-boundary assertions, and 7 actual consumer sandbox assertions pass, including checksum rejection and timeout; isolated external-consumer launch required |
| Collaboration | Explicit service decision and corresponding tenancy, roles, retention, privacy, backup/restore, and deployment ownership requirements | Complete: local CLI retained by default; requirements recorded in design/COLLABORATION.md |

Preserve the offline CLI, immutable records and creation history, bounded I/O,
symlink confinement, and PROPOSE-only publication boundary. All application,
fixture, and test behavior remains in Kujo. Do not substitute generated labels
for independent judgments or mark a queued release/verification as completed.

## Final verification and publication

- [BluePencil PR #1](https://github.com/kujolang/bluepencil/pull/1) merged at
  `474e0f8e153e3091338ea4c63242c4a58bf3ef65`.
- [Published candidate](https://github.com/kujolang/bluepencil/releases/tag/v0.3.0-rc.1)
  targets `e70621f6d058fd5149df9646eb8eeadfa32d67e6`, whose complete
  [three-platform gate](https://github.com/kujolang/bluepencil/actions/runs/35775127345)
  passes. All three published archives were downloaded again and checked against
  their SHA-256 files. Subsequent ledger-only changes do not change those assets.
- [Kujo PR #11](https://github.com/kujolang/kujo/pull/11) merged at
  `78d8725d2219bf14b34a91ad8ca789a57295ac5e` after all checks passed at
  `2a4dbe169cd889856fa6d762899f7f8892027327`. The
  [full release gate](https://github.com/kujolang/kujo/actions/runs/35773553645)
  includes 153/153 runnable Kujo fixtures, six documented skips, and the Rust
  suites. Optional cargo-audit/cargo-deny were unavailable; no successful
  dependency audit is claimed. Upgrade, filesystem, artifact-install and LSP
  platform matrices also passed before merging.
- Local application verification: 244 assertions across 20 suites plus seven
  two-assertion process receipts, 258 checks total. Real external consumer
  integration: seven assertions on macOS x64. Imported corpus: byte-exact
  regeneration. See the adapter documentation for the isolated consumer wrapper.
- [Complete collection benchmark](https://github.com/kujolang/bluepencil/actions/runs/35773158655):
  twelve verified full/sparse exports; committed raw metrics and host provenance.

The exact bundled runtime pin remains
`262b3e7517ac47edca843120dd8689c0c820d62e`. Later upstream integration changes
correct reference inventories and an external CLI module; Rust sources and Cargo
inputs are identical. Upstream merge does not imply that an official Kujo
version already ships these APIs. The release is a trusted-local candidate,
not an authenticated enterprise service.
