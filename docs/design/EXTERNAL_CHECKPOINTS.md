# Independent audit checkpoints

Status: implemented by `checkpoint-create` and `checkpoint-verify`; verification tests are in `tests/checkpoints_test.kujo`.

An optional checkpoint binds the exact bytes of records, creation events, and
transaction intents to an independently retained digest. It supplements the
existing local audit. It grants no publication authority.

The first implementation uses independently stored SHA-256 digests, not signing.
There is no signing key to generate, rotate, export, or accidentally keep beside
the records. The checkpoint custodian must store the receipt outside the state
tree, under a different security principal or offline/immutable storage. A path
outside the tree is a necessary placement check, not proof of independent custody.
The operator must authenticate the checkpoint's origin through that custody
channel. An attacker who can rewrite both state and checkpoint defeats this mode.

Checkpoint creation first requires a complete successful local audit. It hashes
ordered file identities, byte counts, and SHA-256 values using a versioned,
length-delimited accumulator. Metadata is included. Creation repeats the scan
and fails if the digest changes. Operators must quiesce writers during capture;
two equal observations are not a linearizable snapshot against an adversary.
Capture inherits the current complete-audit budget (1,000 records/events and a 2 MiB record page); exceeding it fails explicitly. No partial checkpoint is published. The completed JSON receipt is bounded and
written atomically without replacement.

Verification reads an explicitly supplied checkpoint, validates its version and
shape, and recomputes the accumulator from the chosen state. It rejects changed,
missing, or added managed `.json` files and reports the expected/observed digest. A
coordinated rewrite of record, event, and intent must fail verification against
a checkpoint retained before that rewrite, even if local audit passes.

Checkpoints identify the source state for provenance but verification may target
a restored copy at a different path. Physical paths are excluded from the state
digest. A checkpoint never deletes, restores, or modifies records. Archive the
original receipt alongside backup provenance; test restoration into a separate
folder before treating a backup as recoverable.

A future signature mode would require a separately approved custody design:
offline private keys, pinned public-key identity, rotation and revocation history,
and explicit verification policy. Shared-secret HMAC is not a substitute for
publicly verifiable independent signatures.

## Usage

Provision the custody directory separately, then quiesce writers:

```bash
bluepencil checkpoint-create --state .bluepencil \
  --output /independent-custody/review-checkpoint.json \
  --custodian archive-operator --json
bluepencil checkpoint-verify --state /restored/bluepencil \
  --checkpoint /independent-custody/review-checkpoint.json --json
```

A passing result establishes byte identity to the supplied receipt. It does not
authenticate the custodian's identity or establish that the receipt was protected.
Managed evidence means metadata plus `.json` files in records/history/transactions;
locks, directory markers, exports, and other auxiliary files are not checkpointed.
