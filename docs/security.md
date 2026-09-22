# Security and authority

BluePencil is an offline local CLI operating under PROPOSE. It records judgments;
it never grants publication approval or invokes a model/network service.

Records and creation events use atomic no-overwrite writes, with exclusive
per-record lock files for cooperating writers. Atomicity applies to each file,
not the record/event pair. A killed process can leave a stale lock or orphan
record; automated recovery and audit reconciliation remain open.

Use trusted, access-controlled state and artifact directories. ID traversal and
managed-path/input-leaf symlinks are checked, but ancestor links and concurrent
path replacement are not fully confined. This is not a multi-tenant sandbox.
No user authentication, roles, encryption, or service isolation is provided.

Input secret-shaped keys are rejected recursively. This is a field-name guard,
not a content DLP scanner. Review text and artifacts may contain sensitive data.
HMAC helpers use a shared key; they do not establish a public-key trust chain.

`validate` checks domain records and attached artifact hashes. It does not
reconcile record bytes with creation-event checksums. `history` currently lists
records rather than audit-event files. A local user with filesystem write access
can change data. See the [readiness worklist](READINESS_REVIEW_2026-09-22.md).
