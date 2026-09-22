# Publishing House editorial adapter

`bin/bluepencil-phase-adapter` consumes one UTF-8 phase request on stdin through
EOF, capped at 1 MiB. It runs Kujo with filesystem-read capability only and uses
isolated imports. It never writes review state, contacts a model, or publishes.
The operator owns the subprocess deadline and must close stdin. Configure
`PUBLISHING_HOUSE_PHASE_TIMEOUT_SECONDS` explicitly; a byte cap does not prevent a
producer from stalling before EOF.

The only supported phase is `editorial-review`, index 4. Supply an existing
review through this item extension:

```json
{
  "bluepencil_review": {
    "path": "/absolute/state/records/review-example.json",
    "sha256": "<exact review-file SHA-256>",
    "source_sha256": "<reviewed source artifact SHA-256>"
  }
}
```

The review must be a valid BluePencil review record, bind the item's ID as
`payload.artifact_id`, identify its actor as `payload.reviewer_id`, and contain
artifact metadata produced by `review --path`. The adapter rechecks source bytes
and review bytes. Only `pass` or `pass_with_queries` without blockers advances the
editorial phase. Blocked, rejected, revision-needed, and unverified judgments
return a failure so the operator retains its phase and retry/blocker policy.

A successful receipt binds item, phase, source digest, reviewer, request digest,
and review artifact. `external_effect` is always false and authority is PROPOSE.
Repeating identical input returns an identical receipt. Existing immutable review
and source evidence must remain under trusted custody; this adapter cannot
prevent a privileged owner from rewriting both evidence and its supplied hashes.
Actor identity is asserted local provenance, not authenticated service identity.

The adapter rejects every other phase, including approval-publication. Install
it only for an editorial-review route; a global operator adapter needs an
explicit router for other phases. It does not turn editorial pass into approval.

Contracts are vendored in `fixtures/publishing_house`; tests use a disposable
local operator state with no publication adapter or live credentials.

Run the actual external operator sandbox (seven assertions):

```bash
KUJO_BIN=/absolute/pinned/kujo \
OPERATOR_ROOT=/absolute/kujo-workflows/publishing-house-operator \
REPOS_ROOT=/absolute/kujo-repos \
bash scripts/verify_operator_sandbox.sh
```

This separate integration needs the external consumer and its existing runtime;
neither is a dependency of BluePencil. The harness launches the real operator
entrypoint with Python's `-I` isolation because its current `operator.py` filename
otherwise shadows the standard-library `operator` module on the tested host.
The operator's normal shell launcher still needs that upstream correction.
The sandbox clears inherited environment variables, uses disposable state and
profiles, and verifies accepted evidence, rejected checksum drift, and deadline
failure without advancing to publication.
The real consumer integration was exercised on macOS x64. The shell adapter
requires a POSIX shell; the three-platform application matrix validates its
Kujo receipt logic, not the external operator on every operating system.
