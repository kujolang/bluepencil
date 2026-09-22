# Security and authority

BluePencil is an offline local CLI operating under PROPOSE. It records judgments;
it never grants publication approval or invokes a model/network service.

New records reserve an immutable transaction intent before publishing record and
creation-event files with atomic no-overwrite writes. `transaction --id ID`
inspects its owner and completion; `recover --id ID --owner TOKEN` safely replays
only the original bytes. It never deletes conflicting data. Legacy locks are
not cleared by age. An incomplete intent makes `audit` fail until recovered.
Atomicity and power-loss durability still depend on the filesystem/runtime.

Use trusted, access-controlled state and artifact directories. ID traversal and
managed-path/input-leaf symlinks are checked, but ancestor links and concurrent
path replacement are not fully confined. This is not a multi-tenant sandbox.
No user authentication, roles, encryption, or service isolation is provided.

Input secret-shaped keys are rejected recursively. This is a field-name guard,
not a content DLP scanner. Review text and artifacts may contain sensitive data.
HMAC helpers use a shared key; they do not establish a public-key trust chain.

`validate` checks domain records and attached artifact hashes. `audit` separately
reconciles record bytes against creation-event checksums and checks pending
transaction intents. `history` reads the event files. These local checksums are
not an external trust anchor: an owner able to rewrite all files can change both
sides. See the [readiness worklist](READINESS_REVIEW_2026-09-22.md).
