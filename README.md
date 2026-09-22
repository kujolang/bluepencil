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
service, crash-recovery journal, or full audit-history reconciliation. Review
the [September readiness assessment and next-session worklist](docs/READINESS_REVIEW_2026-09-22.md)
before relying on it for regulated or shared-host workflows.

`src/hardening.kujo` exposes tested library helpers for calibration scores,
HMAC bundle authentication, format rule lists, declared adapter/accessibility
receipts, and in-memory verdict counts. These are not wired into dedicated CLI
workflows. Receipt declarations do not independently prove offline execution,
redaction, accessibility compliance, or editorial quality. The report helper
accepts an existing array; it is not a streaming file reader or a measured
performance benchmark.

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

The declared minimum is Kujo 1.0.1; this review was tested with Kujo 1.4.0.
CI builds the revision pinned in `.github/workflows/validate.yml`. The minimum
version and other operating systems still need a compatibility matrix.
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
| `disagreements`, `report`, `history` | List stored records (currently aliases, not specialized analysis or audit-event readers). |
| `validate`, `show`, `export` | Verify and emit portable review evidence. |
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
symlinks at managed paths and input leaves. Secret-shaped input keys, malformed
JSON, incompatible schema majors, duplicate IDs, and bound artifact checksum
drift are rejected. These checks are not a sandbox against hostile concurrent
filesystem changes. Sensitive values under ordinary text keys are not detected.
BluePencil operates under PROPOSE and never approves publication or rewrites
source artifacts.

Listing and export return `truncated` and `next_cursor`. When truncated, pass
`--after` with that cursor to continue. Each page reads at most 1,000 candidate
records, including corrupt and filtered records, so a page may be empty while
still having a continuation. Directory enumeration/sorting and accumulated
record bytes are not yet globally bounded. `validate` and `doctor` fail with
an incomplete-scan error when more records remain; use `validate --id ID` for
individual records. `doctor` checks readability, not full domain validity.
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
- `bin/bluepencil`: portable shell launcher using `KUJO_BIN` or `kujo` on PATH.
- `tests/`, `fixtures/`, `schemas/`: executable checks and portable examples/contracts.
- `scripts/`: validation orchestration and Kujo JSON syntax checks.
- `docs/`: contracts, security boundaries, historical reviews, and future work.

The root entrypoint, manifest, version, license, and project documentation are
intentional public files; no duplicate root implementation remains. All
application behavior and test assertions remain in Kujo.
