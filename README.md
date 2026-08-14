# BluePencil

[![Version](https://img.shields.io/badge/version-0.2.0-black)](VERSION)
[![CI](https://github.com/kujolang/bluepencil/actions/workflows/validate.yml/badge.svg)](https://github.com/kujolang/bluepencil/actions/workflows/validate.yml)
[![License](https://img.shields.io/badge/license-MIT-lightgrey)](LICENSE)
[![built with Kujo](https://img.shields.io/badge/built%20with-Kujo-white.svg)](https://github.com/kujolang/kujo)

BluePencil is a Kujo-native editorial review and quality-calibration system. It
combines deterministic contract checks with independent human or optional-model
judgment across consequence, distinctiveness, insight, defensibility, craft,
brand integrity, format fidelity, and strategic purpose.

## Readiness posture

BluePencil is ready for serious local review workflows with immutable review
records, explicit reviewer and rubric identity, blocker precedence, structured
verdicts, deterministic comparison, atomic storage, and the complete 18-case
blind calibration corpus covering all 23 Publishing House roles. It does not
average away blockers or claim that corpus integrity automates editorial taste.

See the [production review](docs/PRODUCTION_READINESS_REVIEW.md) and
[next-session worklist](docs/NEXT_SESSION.md).

## Quick install

```bash
git clone https://github.com/kujolang/bluepencil.git
cd bluepencil
export KUJO_BIN=/absolute/path/to/kujo
export PATH="$PWD/bin:$PATH"
bluepencil --version --json
bluepencil doctor --json
```

Kujo 1.0.1 or newer is required. Hosted models are optional, never baseline.

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
| `disagreements`, `report`, `history` | Inspect bounded review and disagreement records. |
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

State defaults to `.bluepencil/`. Traversal, symlinks, secret-shaped fields,
malformed JSON, incompatible schema majors, duplicate IDs, unsafe overwrite,
and checksum drift fail closed. BluePencil operates under PROPOSE and never
approves publication or rewrites source artifacts.

## Calibration and verification

The vendored corpus includes 18 blind A/B pairs spanning every role. Tests bind
its manifest checksum and distinguish structural integrity from semantic
judgment. Run the complete local/CI gate:

```bash
bash scripts/validate.sh
```

The canonical entrypoint is `bluepencil.kujo`; all runtime logic lives in
`src/`. See [contracts](docs/contracts.md) and [security](docs/security.md).
