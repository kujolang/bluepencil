# Contracts

Contract 1.0.0. BluePencil owns: Review Request; Review Record; Dimension Rating; Blocking Finding; Non-Blocking Finding; Calibration Run; Reviewer Disagreement; Revision Request; Review Verdict. Records carry schema/tool versions, stable IDs, actor, timestamp, provenance, command, and payload. Consumers accept compatible 1.x, preserve safe unknown payload metadata, and reject incompatible majors. JSON uses `ok/data/error/tool_version/contract_version`. Offline upstream fixtures identify repository, tag, schema, and checksum.

The hardening API additionally defines blinded calibration scoring and ordered disagreement trends; HMAC-SHA256 rubric/prompt bundle envelopes with explicit same-major compatibility; offline local-model conformance with pre-invocation redaction gates; deterministic rule packs for newsletter, social, case-study, and audiovisual-script work; declared accessibility capability evidence; and reports bounded to 10,000 reviews in batches of at most 1,000.
