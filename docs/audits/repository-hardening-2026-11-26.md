# BluePencil hardening, 2026-11-26

Baseline `88df35c`. Reviewed immutable records and recovery, confined read/write APIs, record and event pagination, audit reconciliation, artifact validation, the read-only operator adapter, and distribution checks.

- `f6f898d` separately bounds retained JSON, bytes read, and candidates scanned. Filtered-out records still consume read budget, and an empty page advances with its cursor. History, audit reconciliation and transaction inspection have their own input budgets. Transaction reads report stable failure states when confined reads fail. Existing publication order and recovery receipts remain compatible.
- `55efc6d` bounds each artifact read by its recorded size and limits aggregate artifact hashing in bulk validation. A complete result requires covering every candidate. The third 64 MiB fixture is deferred after two full hashes and remains individually valid with `--id`.

Focused fixtures failed on the baseline and passed afterward. A 17-record filtered fixture verifies continuation through a page with zero matches. A large consistent audit fixture confirms byte exhaustion reports incomplete without reporting unvisited items as missing events.

The full native gate passed with 304 baseline and 328 final assertions, including concurrency, interrupted recovery, compatibility, and the operator adapter contract. It used the checksum-verified public macOS x64 package binary whose runtime manifest matches source revision `262b3e7517ac47edca843120dd8689c0c820d62e`. The workflow builds that same source pin for each supported platform.
