# BluePencil product worklist after readiness hardening

These are proposed product directions, not a claim that BluePencil is a universal
enterprise service. Preserve the local offline CLI, immutable records, explicit
publication-authority boundary, and evidence-based readiness claims.

- [x] **Distribution:** upstream/release the pinned Kujo filesystem primitive,
  then publish checksummed platform binaries and a clean-machine installation
  test. Do not replace the source pin with a version label before the required
  APIs ship in that release.
- [x] **Indexed large collections:** evaluate a rebuildable index or segmented
  immutable store for collections approaching the 100,000-entry scan ceiling.
  Compare complete-export throughput, sparse filters, retained bytes, and RSS;
  preserve current cursor semantics or explicitly version the new contract.
- [x] **Externally anchored audit evidence:** design optional signed checkpoints
  or independently stored digests. Local checksums cannot detect an owner who
  rewrites records, events, and transaction intents together. Define key custody
  and verification before implementing a signing feature.
- [x] **Editorial quality evaluation:** expand the 18-pair corpus with licensed,
  independently labeled examples and inter-reviewer agreement measurements.
  Keep semantic quality claims separate from passing structural tests.
- [x] **Operator adapter:** build a dedicated Publishing House adapter around
  the verified phase-receipt fixture, including request identity, immutable
  artifact checksums, timeout behavior, and no-publication-effect enforcement.
  Exercise it in a disposable offline operator sandbox before any live workflow.
- [x] **Collaboration requirements:** decide whether an authenticated service is
  wanted. If so, specify tenancy, roles, retention, privacy, backups, restore
  objectives, and deployment ownership before adding remote access to the CLI.

Start with distribution, then use actual user workloads to prioritize scale or
editorial evaluation. These items extend the verified local program's scope;
they do not retroactively turn its current boundary into an enterprise claim.

All six items are complete within the scope above. See the
[execution ledger](NEXT_SESSION_EXECUTION_2026-09-22.md) for verification and
[the new worklist](NEXT_SESSION_AFTER_0_3_RC1.md) for remaining product work.
