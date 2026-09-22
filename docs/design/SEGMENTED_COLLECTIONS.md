# Immutable segment evaluation

The production record store and ID-based cursors remain unchanged. The experiment
in `benchmarks/collections.kujo` evaluates a separately rebuildable snapshot near
the current 100,000-entry directory ceiling: 95,000 immutable records, with one
`review` per 1,000 records and all other records `review_finding`.

Build the snapshot only while writers are quiesced. The prototype scans the
existing store, groups each bounded page by record type, writes immutable JSON
segments, and records each segment's checksum, type, byte count, and record count
in a manifest. Reads verify checksums and skip nonmatching types. This is a
performance experiment under trusted fixture ownership, not a new production
storage format or independent tamper-evidence mechanism.

Both measured readers serialize every selected record as JSONL to the same
output sink. Compare complete exports and uniformly sparse filters, not only the
first page. Receipts include elapsed time, count, ordinal sum, peak process RSS,
and maximum retained serialized JSON bytes. The last quantity is a bookkeeping
budget, not a heap/RSS guarantee: parsed objects and the runtime add memory. Build
time and duplicate on-disk storage must also be included in adoption decisions.

The snapshot contract is explicitly `bluepencil.segment-experiment/1`. Its order
is manifest-segment order then record order within the segment, which differs
from the live store's lexical ID order. It must not consume or emit the existing
`--after` cursor. A production snapshot API would need a new cursor containing
manifest digest, segment number, and offset, with validation against that exact
immutable manifest. Existing live cursors retain their current documented
behavior, including visibility of concurrent additions and lack of snapshot
isolation.

Before production adoption, implement transactional manifest publication,
bounded manifest/shard discovery, safe rebuild after interruption, source/index
consistency verification, stale-index policy, migration and rollback, integrity
checks against authoritative records, and snapshot lifecycle/retention controls.
Do not trade confined record reads for an unsafe SQLite path or silently treat
an index as authoritative evidence.

Reproduce on a trusted disposable fixture path:

```bash
KUJO_BIN=/absolute/runtime bash benchmarks/collections.sh
```

The runner retains fixtures and raw receipts under the ignored
`.loop-engineering/collection-benchmark` directory for inspection. Remove only
that directory when its evidence has been summarized. Three fresh-process samples
per implementation/filter are measured after one snapshot build. Host contention
and warmed filesystem caches limit interpretation; these are diagnostic local
comparisons, not a production throughput guarantee.
