# Contracts

Contract 1.0.0. BluePencil owns: Review Request; Review Record; Dimension Rating; Blocking Finding; Non-Blocking Finding; Calibration Run; Reviewer Disagreement; Revision Request; Review Verdict. Records carry schema/tool versions, stable IDs, actor, timestamp, provenance, command, and payload. Consumers accept compatible 1.x, preserve safe unknown payload metadata, and reject incompatible majors. JSON uses `ok/data/error/tool_version/contract_version`. Offline upstream fixtures identify repository, tag, schema, and checksum.
