# Immutable segment evaluation

The production record store and ID-based cursors remain unchanged. The experiment
in `benchmarks/collections.kujo` evaluates a separately rebuildable snapshot near
the current 100,000-entry directory ceiling: 95,000 immutable records, with one
`review` per 1,000 records and all other records `review_finding`.
These are minimal synthetic storage envelopes, approximately 200 bytes each,
not domain-valid eight-dimension editorial reviews. The experiment measures
storage traversal and JSONL serialization, not semantic validation or audit.

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

## Completed 95,000-record experiment

[Dedicated Ubuntu CI run](https://github.com/kujolang/bluepencil/actions/runs/35773158655)
completed all twelve measurements at application commit `41e3949`, runtime
source `262b3e7517ac47edca843120dd8689c0c820d62e`. The Kujo summarizer
independently revalidated every downloaded count and ordinal sum.
[Raw results](../../benchmarks/results/collections-2026-09-22.json) and
[host details](../../benchmarks/results/collections-2026-09-22-host.txt) preserve provenance.

| Reader / selection | Records | Median wall ms | Median peak RSS bytes | Maximum retained JSON bytes |
| --- | ---: | ---: | ---: | ---: |
| Flat / complete | 95,000 | 59,949.07 | 698,810,368 | 101,000 |
| Segments / complete | 95,000 | 19,217.75 | 665,456,640 | 145,371 |
| Flat / sparse | 95 | 31,417.25 | 26,615,808 | 194 |
| Segments / sparse | 95 | 94.54 | 24,383,488 | 44,066 |

Generation took 29.71 seconds; snapshot construction took 94.01 seconds and
peaked at 704,925,696 RSS bytes. The authoritative fixture occupied 383,920 KiB;
the additional snapshot occupied 19,448 KiB. Full exports verified ordinal sum
4,512,452,500, sparse exports 4,465,000. Every run serialized the complete
selection. Segment reads were faster in this experiment, especially sparse
reads, but complete-export RSS remained large despite the small JSON budget.
This supports further profiling and snapshot design, not production adoption
or a universal speed guarantee. Earlier incomplete, contended local trials
were excluded from these results.
