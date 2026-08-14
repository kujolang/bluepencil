# BluePencil

Editorial quality and calibration records across eight dimensions, blockers, verdicts, and reviewer disagreement.

BluePencil 0.1.0 is an independently installable, local-first Kujo tool. It requires no hosted service, Chain of Command, WebOps, or sibling Publishing House tool. The canonical entrypoint is `bluepencil.kujo`; `bin/bluepencil` contains no product logic.

## CLI

Commands: review; compare; calibrate; style; brand; claims; format; accessibility; disagreements; report; validate; doctor; version; init; show; export; history. Run `./bin/bluepencil help` for flags. Mutations require `--actor`; JSON input uses `--input`. Common flags include `--json`, `--dry-run`, `--state`, `--output`, `--config`, and `--force`. Exit codes: 0 success, 1 validation/operation failure, 2 usage error.

State defaults to `.bluepencil/`. Immutable JSON records and append-only history use atomic writes. IDs reject traversal; symlinks and oversized inputs are rejected. See [contracts](docs/contracts.md), [security](docs/security.md), and [quickstart](examples/quickstart.md).

Test with `/Users/robertdevore/2026/Kujolang/kujo-repos/kujo/target/release/kujo run tests/test.kujo`, then run `./bin/bluepencil doctor --json`.

0.1.0 covers the documented local records, fixtures, validation, checksums, deterministic fixed-time IDs, and structured export. It does not manufacture human judgment, consent, rights, approval, or causation. Deterministic checks validate structure and corpus integrity; premium editorial judgment remains human or optional-adapter work.
