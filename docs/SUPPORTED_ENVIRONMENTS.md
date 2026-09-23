# BluePencil 0.3 supported environments

BluePencil is an offline, single-owner editorial evidence CLI. Support means the
versioned release gates exercise the listed runtime, native launcher, upgrades,
and installation paths. It does not imply enterprise certification or support
for arbitrary shared storage or every operating-system release.

| Bundle | Supported baseline / installation checks |
| --- | --- |
| Linux x64 | Ubuntu 22.04 and 24.04, glibc, local filesystem |
| Linux ARM64 | Ubuntu 24.04, glibc, local filesystem |
| macOS x64 | macOS 15 and 26, Intel |
| macOS ARM64 | macOS 15 and 26, Apple Silicon |
| Windows x64 | Windows Server 2022 and 2025; Windows 11 ARM via OS x64 emulation |

These rows are release acceptance targets: a stable tag is published only after
the corresponding build and installation jobs pass. Windows 11 x64 is expected
to be compatible but has no dedicated desktop-image verification in this matrix.
Other Linux distributions, musl/Alpine, older macOS, native Windows ARM64, UNC
paths, network filesystems, and case-sensitive filesystem edge cases beyond the
suite are outside the verified support matrix. Source builds are possible but
must pass the runtime probe and application gate before use.

The exact bundled runtime commit is
`262b3e7517ac47edca843120dd8689c0c820d62e`, with default optional features disabled.
BluePencil supports that bundle directly; an independently installed Kujo version
label is not a compatibility guarantee. No Rust, Python, Node, model provider,
network connection, or separate Kujo installation is needed for the core CLI.
The optional external Publishing House consumer has its own dependencies.

## Installation evidence

Every archive is extracted into a path containing spaces. Tests execute the
public POSIX or Windows `.cmd` launcher with a new home/temp/state directory,
without inherited configuration or credentials, and with a system-only PATH
that contains neither Kujo nor a Rust toolchain. They create, validate, audit,
checkpoint, verify, and completely export a review, then exercise historical
upgrade/restore fixtures.

Linux uses an offline minimal Ubuntu container with no toolchain installed.
Windows/macOS use fresh hosted VMs with a restricted child environment; the
VM images themselves contain development tools, so these are not claims of
pristine consumer OS images. Dedicated macOS smoke runs deny network access;
Windows smoke runs block outbound traffic for the bundled executable. The
archive includes the runtime and dependency notices/source required for its
redistribution. SHA-256 detects downloaded-byte changes; archives are not signed
installers or notarized applications. macOS may require the user to explicitly
allow a downloaded executable under their organization's policy.

## Operating envelope

Use a trusted, access-controlled local directory and cooperating writers.
Immutable record creation is concurrency-tested; audit/checkpoints and backups
require quiesced writers. Preserve the entire state directory, configuration,
and bound artifacts. Independently retain checkpoint receipts outside that state.
There is no automatic publication, remote authentication, tenancy, encryption,
retention enforcement, power-loss guarantee, or protection against the directory
owner rewriting every local file.

- Inputs and records: 1 MiB. Bound artifacts: 64 MiB with streaming hashing.
- Pages: at most 1,000 candidate records and 2 MiB retained serialized record JSON.
- Complete audit/checkpoint creation: at most 1,000 records/events and a complete
  2 MiB record page. Exceeding these bounds fails; split work into independently
  managed states before reaching them.
- Directory scans: at most 100,000 entries, including markers and other files.
  Streaming exports paginate but are not snapshots under concurrent writes.
- Memory is operation-dependent. The synthetic 95,000-record complete-export
  experiment peaked around 700 MB; the JSON budget is not a process memory cap.
  Provision memory headroom and benchmark realistic workloads before scaling.

See [upgrade and restore](UPGRADING.md), [security](security.md), and the
[stable release evidence](STABLE_RELEASE_0_3.md).
