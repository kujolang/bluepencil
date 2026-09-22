# Runtime and platform contract

This revision requires Kujo commit `ee6ce1dabd6629be33b3241b0ab9b5a970256c56`
from `kujolang/kujo` (version label 1.4.0), recorded in
[`runtime-requirements.json`](../runtime-requirements.json). This is a source
pin, not a claim that every released 1.4.0 binary has these APIs.

```bash
git clone https://github.com/kujolang/kujo.git kujo-runtime
cd kujo-runtime
git checkout ee6ce1dabd6629be33b3241b0ab9b5a970256c56
cargo build --release --no-default-features --locked
# Set KUJO_BIN to this checkout's absolute target/release/kujo path.
# On Windows, the executable is target/release/kujo.exe.
```

From the BluePencil checkout, run `"$KUJO_BIN" run scripts/runtime_probe.kujo`
and `KUJO_BIN="$KUJO_BIN" bash scripts/validate.sh`. Use `bin/bluepencil.cmd`
for Windows cmd/PowerShell, or `bin/bluepencil` for POSIX shells. The Windows
validation job uses Git Bash for orchestration and also exercises the native
cmd launcher. CI builds the same source pin on Linux, macOS, and Windows.
See the workflow for Windows OpenSSL build prerequisites.

The official macOS x64 Kujo 1.0.1 binary was downloaded, verified against its
published SHA-256, and tested with the runtime probe. It fails with an undefined
`create_temp_dir` primitive. The previous 1.0.1 minimum is therefore withdrawn.
The probe verifies behavior, including bounded descriptor-relative directory
pages, rather than trusting a version string.

The gate runs four rounds of four competing writers starting from uninitialized
state, then kills writers after intent, record, and event publication and
verifies explicit recovery. These are process-crash tests, not power-loss tests.
Native conformance additionally exercises symlink/dangling ancestors and
concurrent replacement on Unix. Windows directory junctions are exercised by
application fixtures; this does not establish coverage for every reparse type.

`tests/consumer_test.kujo` validates an editorial-review receipt against the
vendored Publishing House schema and mirrors its request identity, artifact
checksum, and no-publication-effect boundary. The schema's repository, exact
revision, and checksum are in `fixtures/publishing_house/provenance.json`.
This is an offline contract integration, not a live operator run.


## Verification evidence

The application suite passes 201 assertions on Linux, macOS, and Windows,
including native Windows launcher smoke, concurrent first initialization,
process-kill recovery, JSONL completion receipts, and the pinned consumer fixture.
The native runtime passes 14 filesystem tests on Linux/macOS and nine on Windows,
plus a VM/interpreter/capability parity test on each platform.

- [Native conformance and full Linux/macOS gate](https://github.com/kujolang/bluepencil/actions/runs/35753820636): Windows native checks also passed; that run exposed CRLF conversion of a checksum-bound fixture, subsequently fixed with `.gitattributes`.
- [Application matrix after Windows fixture fixes](https://github.com/kujolang/bluepencil/actions/runs/35757398282).
- [Runtime branch artifact guard](https://github.com/kujolang/kujo/actions/runs/35754163279): canonical ignore rules synchronized; this follow-up changes no runtime code.

CI caches are keyed by exact runtime commit, OS, architecture, and build profile.
A cache is saved only after native conformance and parity pass. Application
validation and the behavioral runtime probe run even when that verified build
is reused. Cached builds are not a substitute for conformance on a new pin.

The prior installed/sibling runtime labeled 1.4.0 lacks `list_dir_beneath` and
fails the doctor test; use the pinned build rather than relying on its label.
No full Kujo repository test-suite or power-loss guarantee is implied by these
scoped runtime checks.
