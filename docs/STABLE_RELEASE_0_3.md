# BluePencil 0.3.0 release evidence

The stable release promotes the trusted-local CLI boundary, not an authenticated
enterprise service. Acceptance is tied to exact source and downloaded assets.

| Gate | Evidence / release requirement |
| --- | --- |
| Supported environment | Versioned OS/architecture matrix in SUPPORTED_ENVIRONMENTS.md; five native bundles and additional installed-platform checks |
| Clean installation | Public launchers, spaces in paths, no inherited runtime/config, restricted PATH, downloaded checksums, offline Linux / network-blocked macOS and Windows |
| Upgrade and recovery | 46 assertions against real tagged 0.2.0 and RC state, plus existing concurrency and process-kill recovery gates |
| Security and dependencies | Exact pinned runtime cargo-audit and cargo-deny results; final source-diff review; scope and accepted warnings below |
| Runtime and integration | Exact supported bundled source pin; optional consumer uses the tested isolated wrapper |
| Stable artifacts | 0.3.0 metadata and schemas preserve legacy/RC compatibility; full validation and final public-download verification required before publication |

## Dependency assessment

`cargo audit` on the pinned runtime's unchanged lockfile reports zero known
vulnerabilities. Its full 644-dependency lockfile reports RUSTSEC-2025-0141 for
unmaintained bincode 1.3.3. `cargo tree --locked --no-default-features -i bincode`
confirms bincode is not in the bundled feature graph. It is not suppressed as a
vulnerability or presented as a fixed upstream dependency.

`cargo-deny 0.20.2`, verified from the publisher's archive checksum, checks all
five target triples with `scripts/runtime-deny.toml` and default optional runtime
features disabled. Advisories, licenses and sources have zero errors. Fifteen
multiple-version warnings reflect transitive dependency branches; they remain
visible, do not identify known vulnerabilities, and are accepted for this exact
locked release. No blanket advisory ignore is configured. The MPL-2.0 colored
crate is unmodified, with its source and notices included in every bundle.
Dependency inventory and original notices accompany the runtime.

Run the assessments again when changing the runtime pin or before a new release;
this is dated evidence, not a permanent absence-of-vulnerabilities claim.

## Review boundary

The security workbench failed before creating a scan identity because its Python
runtime cannot evaluate the plugin's type annotations. No successful formal
Codex Security scan is claimed. A source-diff review and dependency assessment
are recorded separately; the reviewed implementation range is
`cbd7f4c51ddf223735f939e21f8624fc8c78e95e..915920c2b5de770143c9fff490922edfb03773a8`
through successive immutable review ranges.
An independent reviewer examined all 26 files in the initial implementation diff,
subsequent changed files, and supporting version,
storage, recovery, filesystem and launcher code. No actionable security
vulnerabilities were found in that range. A subsequent packaging guard requires
a clean source checkout so generated notices match the archived commit; this
guard, installation orchestration, Windows assembler prerequisite, and environment
lookup, and structured launcher arguments received follow-up reviews with no actionable security findings. Previously
recorded async-scope behavior is outside the
application's exercised execution path. The external consumer launcher remains
an upstream issue; stable integration explicitly requires the tested isolated
wrapper described in OPERATOR_ADAPTER.md.

Publication and public-download receipts are maintained in the latest repository
version of this document, after immutable archives have been produced.

Machine-readable dependency evidence:
[runtime audit](release-evidence/runtime-audit-0.3.0.json) and
[targeted cargo-deny](release-evidence/runtime-deny-0.3.0.json).
The lockfile SHA-256 is
`8fc3a34a62b13a84a02a823d78934dad5f6be1cb7f9dac3a9e7caf96b2dd05d6`;
`cargo-audit 0.22.2` used advisory database commit
`f7dc4b2860b29978f400fda0aab31cc4dbd21134`.
The same Cargo inputs and Rust sources were verified against the required pin.

## Distribution build profile

All five bundles use the locked source pin with default optional features disabled,
release optimization level 1, LTO disabled, and 16 codegen units. Windows targets
`x86_64-pc-windows-msvc` with static CRT and static OpenSSL; PE dependency checks
reject Visual C++ redistributable dependencies. macOS dependency checks allow only
system dynamic libraries. The build profile is part of the runtime cache key;
native filesystem and API conformance gates must pass before a cache is saved.
These settings describe the distributed binaries, not a cross-platform performance
guarantee. Existing benchmark reports retain their own host and workload scope.

## Verification on 2026-09-23

[CI run 35903555076](https://github.com/kujolang/bluepencil/actions/runs/35903555076)
passed all 12 jobs at application commit
`915920c2b5de770143c9fff490922edfb03773a8`:

- Full application validation: 304 assertions on each of five native platforms.
- Each packaged archive: runtime compatibility probe, 21 isolated public-launcher
  assertions, and 46 historical upgrade/restore assertions.
- Linux minimal offline installation: Ubuntu 22.04/24.04 x64 and 24.04 ARM64.
- Downloaded, checksummed archives on seven fresh hosted VMs: Windows Server
  2022/2025, Windows 11 ARM using x64 emulation, and macOS 15/26 on both Intel and
  Apple Silicon. Each passes 21 launcher and 46 upgrade assertions; launcher
  execution denies network access on macOS and blocks it on Windows.

The exact runtime's native filesystem, directory/API, bounded-stdin, rooted-digest,
and lexical-scope conformance gates passed before its platform caches were saved.
The local application gate also passes 304 assertions. The real external consumer
sandbox passes seven assertions against `kujo-workflows` commit
`7a84d19ec960bc2c59155e7c5f1c8634d25d8de7`, using the documented isolated wrapper.
No live provider or publication effects were exercised by that integration test.

The only subsequent pre-publication changes are documentation and release evidence.
The final archive-producing CI run must pass the same matrix before publication;
its exact commit and downloadable asset checksums are recorded with publication.
