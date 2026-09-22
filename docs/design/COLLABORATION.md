# Collaboration boundary

Decision for this implementation: retain the offline local CLI. No user request
for an authenticated service has been received. This is an implementation default,
not evidence that a hosted service is unwanted forever. Revisit with a named
service owner and actual collaboration workloads before adding remote access.

Local use requires trusted filesystem ownership and cooperating writers. Actor
names are provenance assertions, not authenticated identities. Separate state
roots by team/project and use OS access controls; BluePencil does not enforce
tenant isolation or roles. Never expose its launcher directly through an HTTP
endpoint or share a writable state directory with untrusted users.

Back up metadata, records, history, and transaction intents together while writers
are quiesced. Keep backups and optional checkpoint receipts under independently
managed access. Restore into a separate directory and run audit plus checkpoint
verification before switching users to the restored state. The local operator
owns encryption, retention, deletion, access review, and restore testing. No
recovery-time or recovery-point objective is promised by the CLI.

## Prerequisites for any future service

A service proposal must resolve every row with a named accountable owner and
executable acceptance evidence. These requirements do not authorize deployment.

| Area | Required decision and evidence |
| --- | --- |
| Tenancy | Tenant identifier from authenticated context, never user-supplied filesystem paths; isolation model and cross-tenant negative tests. |
| Identity and roles | Identity provider, reviewer/auditor/administrator permissions, revocation, session expiry, service accounts, and separately controlled publication approval. Actor strings cannot substitute for authentication. |
| Retention | Per-tenant schedules for artifacts, reviews, audit evidence, backups, and deletion requests; documented conflict resolution for immutable evidence and required deletion. |
| Privacy | Data classification, upload limits, redaction policy, encryption and key ownership, operator access logging, provider opt-in, and residency requirements. |
| Backups | Consistent capture, encryption, separate custody, restore drills, and measured RPO/RTO agreed by the service owner. |
| Operations | Named deployment/on-call owner, patch policy, resource quotas, rate limits, timeout/cancellation handling, monitoring, incident response, and rollback. |
| Audit | Authenticated event identity, independently anchored receipts, bounded verification, and clear limitations when administrators control storage and keys. |
| Compatibility | Versioned API, idempotent writes, snapshot-aware pagination, migration/rollback tests, and portable offline export. |

Existing local functional tests do not establish any of these service guarantees.
