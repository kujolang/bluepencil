# Security and authority

BluePencil is an offline local CLI operating under PROPOSE. It records judgments;
it never grants publication approval or invokes a model/network service.

New records reserve an immutable transaction intent before publishing record and
creation-event files with atomic no-overwrite writes. `transaction --id ID`
inspects its owner and completion; `recover --id ID --owner TOKEN` safely replays
only the original bytes. It never deletes conflicting data. Legacy locks are
not cleared by age. An incomplete intent makes `audit` fail until recovered.
Atomicity and power-loss durability still depend on the filesystem/runtime.

Use trusted, access-controlled state and artifact directories. Descriptor-relative reads, writes, and directory pages open each component
without following links, beneath a trusted volume root. Static checks reject
linked state, input, output, and artifact components; the native operation
enforces the boundary against concurrent ancestor replacement. Only known
macOS root-owned `/tmp`, `/var`, and `/etc` aliases are normalized. UNC paths,
arbitrary device paths, traversal, and alternate data streams are rejected.
Windows canonical verbatim drive prefixes are normalized; reserved device names
and trailing-dot/space aliases are rejected. Forced exports
cannot overwrite managed record/history/transaction/lock files or metadata.
Regular hard links and filesystem-owner modification remain outside this boundary. This is not a multi-tenant sandbox.
No user authentication, roles, encryption, or service isolation is provided.

Input secret-shaped keys are rejected recursively. This is a field-name guard,
not a content DLP scanner. Review text and artifacts may contain sensitive data.
HMAC verification uses the native constant-time verifier and a bounded explicit
trusted-key file. HMAC helpers use a shared key; they do not establish a public-key trust chain.

`validate` checks domain records and attached artifact hashes. `audit` separately
reconciles record bytes against creation-event checksums and checks pending
transaction intents. `history` reads the event files. These local checksums are
not an external trust anchor: an owner able to rewrite all files can change both
sides. See the [readiness worklist](READINESS_REVIEW_2026-09-22.md).
