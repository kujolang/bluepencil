# BluePencil

[![Version](https://img.shields.io/badge/version-0.2.0-black)](VERSION)
[![License](https://img.shields.io/badge/license-MIT-lightgrey)](LICENSE)
[![built with Kujo](https://img.shields.io/badge/built%20with-Kujo-white.svg)](https://github.com/kujolang/kujo)
[![CI](https://github.com/kujolang/bluepencil/actions/workflows/validate.yml/badge.svg)](https://github.com/kujolang/bluepencil/actions/workflows/validate.yml)

BluePencil is a Kujo-native editorial review and quality-calibration system. It
combines deterministic contract checks with independent human or optional-model
judgment across consequence, distinctiveness, insight, defensibility, craft,
brand integrity, format fidelity, and strategic purpose.

## Readiness and scope

BluePencil 0.2.0 is a local editorial evidence CLI written in
[Kujo](https://github.com/kujolang/kujo). It records human judgments, enforces
all eight ratings and blocker precedence, compares records, and binds optional
artifacts by SHA-256. The vendored calibration corpus contains 18 blind pairs
covering 23 Publishing House roles.

It is not yet a universal enterprise platform. Use a trusted local state
directory with cooperating writers. There is no authenticated multi-user
service. Immutable transaction intents support explicit recovery, and `audit`
reconciles record bytes against creation events. Review
the [September readiness assessment and next-session worklist](docs/READINESS_REVIEW_2026-09-22.md)
before relying on it for regulated or shared-host workflows.

Evaluation commands provide blind calibration scoring/trends, trusted-key HMAC
bundle verification and upgrade checks, deterministic format checks, and
adapter/accessibility receipt checks. Receipt declarations do not independently
prove offline execution, redaction, accessibility compliance, or editorial
quality. See the [executable editorial walkthrough](docs/EDITORIAL_WALKTHROUGH.md)
and [workflow contracts](docs/WORKFLOWS.md).

## Quick install

```bash
git clone https://github.com/kujolang/bluepencil.git
cd bluepencil
# If kujo is not on PATH:
export KUJO_BIN=/absolute/path/to/kujo
export PATH="$PWD/bin:$PATH"
bluepencil --version --json
bluepencil doctor --json
```

This revision requires the source-pinned Kujo runtime in
[`runtime-requirements.json`](runtime-requirements.json), including the new
`list_dir_beneath` API. A version label alone is insufficient; released 1.0.1
is unsupported. Build and compatibility instructions are in
[Runtime support](docs/RUNTIME_SUPPORT.md). Run `kujo run scripts/runtime_probe.kujo`
before using an independently supplied runtime.
No model service is invoked by the baseline CLI.

## Quick start

```bash
bluepencil init --json
bluepencil review --input fixtures/core.json \
  --actor editorial-reviewer --timestamp 2026-08-14T12:00:00Z --json
bluepencil validate --json
bluepencil report --limit 100 --json
```

## Commands

| Command | Purpose |
| --- | --- |
| `review` | Create a structured eight-dimension review and verdict. |
| `compare` | Compare two immutable reviews without flattening disagreement. |
| `calibrate` | Record a blind calibration judgment with reviewer and rubric identity. |
| `style`, `brand`, `claims`, `format`, `accessibility` | Record focused deterministic or semantic findings. |
| `disagreements` | Compare two review judgments, dimensions, and blockers using `--id` and `--other-id`. |
| `report` | List records with explicit per-page type, verdict, and blocker totals. |
| `history`, `audit` | Read creation events and reconcile record/event integrity. |
| `transaction`, `recover` | Inspect an immutable intent and resume exact-byte publication using its owner token. |
| `validate`, `show`, `export` | Verify and emit portable review evidence. |
| `export-stream`, `report-stream` | Emit bounded JSONL pages and a final completion receipt. |
| `calibration-score`, `calibration-trend` | Score supplied blind judgments and ordered run trends. |
| `bundle-verify`, `bundle-upgrade` | Authenticate a bundle using an explicit trusted key; check version compatibility. |
| `format-check`, `accessibility-check`, `adapter-check` | Evaluate supplied content rules or validate clearly labeled declarations. |
| `doctor`, `version` | Report health and compatibility. |

Allowed verdicts are `pass`, `pass_with_queries`, `revise`, `blocked`, `reject`,
and `unverified`. Ratings are `EXCEPTIONAL`, `STRONG`, `ADEQUATE`, `WEAK`,
`FAILED`, and `UNVERIFIED`. Any blocking finding makes `pass` and
`pass_with_queries` invalid.

Common flags include `--state`, `--config`, `--input`, `--actor`, `--timestamp`,
`--id`, `--other-id`, `--path`, `--type`, `--after`, `--limit`, `--output`,
`--force`, `--dry-run`, and `--json`. Inputs and records are limited to 1 MiB,
artifacts to 64 MiB, and queries to 1,000 records.

State defaults to `.bluepencil/`. Record IDs reject traversal; checks reject
symlinks throughout state, input, output, and artifact paths. Secret-shaped input keys, malformed
JSON, incompatible schema majors, duplicate IDs, and bound artifact checksum
drift are rejected. Descriptor-relative I/O rejects symlink traversal, including ancestor replacement
between checks and use. State still requires trusted ownership and access controls. Sensitive values under ordinary text keys are not detected.
BluePencil operates under PROPOSE and never approves publication or rewrites
source artifacts.

Listing and export return `truncated` and `next_cursor`. When truncated, pass
`--after` with that cursor to continue. Each page reads at most 1,000 candidate
records, including corrupt and filtered records, so a page may be empty while
still having a continuation. Native enumeration retains at most 1,001 names and fails above 100,000 directory
entries; retained record JSON is capped at 2 MiB per page. `validate` and `doctor` fail with
an incomplete-scan error when more records remain; use `validate --id ID` for
individual records. `doctor` checks readability, not full domain validity.
For larger collections, `export-stream` and `report-stream` emit JSONL to stdout.
Consumers must require the final `ok: true`, `data.complete: true` receipt;
discard a partial stream on failure. These scans are not snapshots under
concurrent writes. `--output` is rejected for streams; redirect stdout.
`--dry-run` validates a proposed record without creating state; it does not
reserve an ID or guarantee a subsequent write can succeed.

## Calibration and verification

The vendored corpus includes 18 blind A/B pairs spanning every role. Tests bind
its manifest checksum and distinguish structural integrity from semantic
judgment. Run the complete local/CI gate:

```bash
bash scripts/validate.sh
```

The canonical entrypoint is `bluepencil.kujo`; all runtime logic lives in
`src/`. See [contracts](docs/contracts.md) and [security](docs/security.md).

## Repository layout

- `bluepencil.kujo`: public two-line entrypoint importing `src.core`.
- `src/`: CLI dispatch, arguments, domain rules, storage, and library helpers.
- `bin/bluepencil`, `bin/bluepencil.cmd`: shell and Windows launchers using `KUJO_BIN` or PATH.
- `tests/`, `fixtures/`, `schemas/`: executable checks and portable examples/contracts.
- `scripts/`: runtime probing, validation, concurrent writers, and crash orchestration.
- `benchmarks/`: repeatable first-page latency and peak-RSS measurements.
- `docs/`: contracts, security boundaries, historical reviews, and future work.

The root entrypoint, manifest, version, license, and project documentation are
intentional public files; no duplicate root implementation remains. All
application behavior and test assertions remain in Kujo.
