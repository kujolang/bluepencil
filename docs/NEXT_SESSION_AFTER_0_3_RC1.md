# Follow-up work after the 0.3 release candidate

BluePencil remains a trusted-local editorial evidence CLI. These follow-ups
extend or investigate that boundary; they are not evidence of universal
enterprise readiness. Completed work and verification belong in
[the execution ledger](NEXT_SESSION_EXECUTION_2026-09-22.md).

## 1. Correct upstream async lexical scope

**Repository:** `kujolang/kujo`. The synchronous scope fix does not cover async
functions. On the candidate runtime, this program prints `42` with
`--interpreter`, while the VM rejects undefined `private_value`:

```kujo
async func read_local() { return private_value }
async func outer() {
    let private_value := 42
    return await read_local()
}
print(await outer())
```

Inspect async call environment construction in `src/interpreter/mod.rs` and
add VM/interpreter regressions for caller-local isolation, captured closures,
global mutation, errors, and nested async calls. BluePencil does not use this
async path. Do not claim that all Kujo function scope behavior is fixed.

## 2. Fix the Publishing House launcher

**Repository:** `kujolang/kujo-workflows`, commit
`7a84d19ec960bc2c59155e7c5f1c8634d25d8de7`.
`publishing-house-operator/bin/publishing-house` invokes `operator.py` directly;
on the tested system interpreter its filename shadows the standard-library
`operator` module and startup fails with a circular `collections`/`deque` import.
Launching the same entrypoint with `-I` passes the seven-assertion BluePencil
sandbox. Correct the upstream launcher or module layout and test its actual
public executable before removing BluePencil's isolated integration wrapper.

## 3. Decide whether immutable segments merit production work

Use the complete-export measurements in
[the segmentation evaluation](design/SEGMENTED_COLLECTIONS.md), including build
cost, disk duplication, RSS, and sparse scans. Profile runtime allocations and
directory rescans with realistic review sizes and a quiet host before choosing
a service-level target. Synthetic 200-byte envelopes are not a realistic
editorial workload or an audit-throughput test.

If adopted, design transactional snapshot publication, stale-index detection,
rebuild recovery, retention, and a new manifest-bound cursor. Preserve the
existing live ID cursor contract. Do not ship the experimental segment reader
as authoritative storage.

Large-state audit/checkpoint coverage needs a separate bounded traversal design:
today checkpoint creation intentionally inherits the complete-audit ceiling of
1,000 records/events and a 2 MiB record page. Add complete streaming verification
with explicit interruption/continuation semantics before extending that limit;
partial scans must continue to fail rather than emit authoritative receipts.

## 4. Extend role-specific editorial evidence

The licensed writing supplement has independent human labels and measured
agreement. The six original candidates in `fixtures/editorial_expansion` still
need two identified reviewers to label frozen cases independently and blindly.
Keep their provenance distinct from the published dataset. Preserve dissent,
measure agreement before adjudication, and avoid tuning an answer key to a
preferred model. Add role and accessibility coverage only with documented
licensing and independently supplied judgments.

## 5. Graduate distribution deliberately

Retain the exact runtime source pin and behavioral probe until an official
Kujo release ships every required API. For a stable BluePencil release, repeat
clean installation on explicitly supported OS baselines, verify downloaded
asset checksums, and exercise upgrade/restore of immutable legacy records.
Additional CPU architectures require their own build and installation evidence.

Authenticated collaboration remains a product decision. Use
[the collaboration requirements](design/COLLABORATION.md) before implementing a
service; the current release candidate adds no remote authentication boundary.
