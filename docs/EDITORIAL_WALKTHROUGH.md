# From a blocker to reviewed evidence

Run from a checkout with the supported Kujo runtime on PATH:

```sh
kujo run examples/editorial_walkthrough/run.kujo -- /tmp/my-bluepencil-demo
```

Choose a new state directory for each run. The script prints its state and
export path plus this checked summary:

```json
{
  "reviews": 2,
  "calibrations": 1,
  "dimension_disagreements": 8,
  "initial_blockers": 1,
  "revised_blockers": 0,
  "calibration_matches": 2,
  "audit_verified": 3,
  "exported_records": 3
}
```

The first review records an unsupported claim as a blocker. The second records
an independent review after evidence is attached to the payload; it receives a
passing verdict. Both judgments remain immutable and inspectable. The program
does not decide that the source is convincing or authorize publication.

The same operations are available directly through the CLI:

```sh
bluepencil review --state /tmp/review-demo \
  --input examples/editorial_walkthrough/blocked.json \
  --id review-blocked --actor reviewer-one --timestamp 2026-09-22T12:00:00Z --json
bluepencil review --state /tmp/review-demo \
  --input examples/editorial_walkthrough/revised.json \
  --id review-revised --actor reviewer-two --timestamp 2026-09-22T12:01:00Z --json
bluepencil disagreements --state /tmp/review-demo \
  --id review-blocked --other-id review-revised --json
bluepencil calibrate --state /tmp/review-demo \
  --input examples/editorial_walkthrough/calibration.json --actor reviewer-two --json
bluepencil calibration-score --input examples/editorial_walkthrough/blind_run.json --json
bluepencil report --state /tmp/review-demo --json
bluepencil audit --state /tmp/review-demo --json
bluepencil export --state /tmp/review-demo --output /tmp/review-demo/evidence.json --json
```

`disagreements` returns the original verdicts, reviewers, rubrics, blockers, and
each changed dimension. `report.page_summary` counts only the current page;
follow `next_cursor` while `truncated` is true. `history` lists actual events.
`audit` checks local record/event consistency separately from domain validation.

If a process stops during a new record write, inspect its durable intent:

```sh
bluepencil transaction --state /tmp/review-demo --id review-blocked --json
bluepencil recover --state /tmp/review-demo --id review-blocked --owner OWNER_FROM_INSPECTION --json
```

Recovery publishes only exact original bytes and never deletes conflicts. It
is safe to repeat. The owner token identifies the intent; it is not an
authentication credential. Legacy lock files need operator inspection and are
never cleared because of age.

The implementation demonstrates Kujo modules, typed boundary checks, structured
JSON, hashing, atomic file publication, and deterministic functions. Read
[`src/domain.kujo`](../src/domain.kujo),
[`src/transaction.kujo`](../src/transaction.kujo), and
[`examples/editorial_walkthrough/workflow.kujo`](../examples/editorial_walkthrough/workflow.kujo)
alongside the [Kujo language specification](https://github.com/kujolang/kujo/blob/main/docs/LANGUAGE_SPEC.md)
and [standard-library reference](https://github.com/kujolang/kujo/blob/main/docs/STANDARD_LIBRARY.md).
`tests/walkthrough_test.kujo` binds this summary to executable behavior and
validates every exported record against the repository schema.
