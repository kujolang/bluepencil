# Bounded scan measurements

Measured on macOS x64 with the optimized source-pinned runtime, comparing
BluePencil `275fbbf` against `60d2f2d`. Each sample starts a fresh CLI process;
fixture generation occurs outside the measured process. Wall time covers the
first `list_records` call, and RSS is the process peak including runtime/import
cost. Three samples per case; medians below. Concurrent host activity makes
these diagnostic measurements, not SLOs or a controlled speed ranking.

| Corpus | Implementation | Files | Returned records | Median ms | Median peak MiB |
| --- | --- | ---: | ---: | ---: | ---: |
| normal | baseline | 1001 | 1000 | 3891.0 | 31.48 |
| normal | enhanced | 1001 | 1000 | 3440.0 | 30.86 |
| sparse-filter | baseline | 1001 | 0 | 3365.0 | 22.48 |
| sparse-filter | enhanced | 1001 | 0 | 3437.8 | 24.16 |
| corrupt | baseline | 1001 | 0 | 2402.4 | 24.58 |
| corrupt | enhanced | 1001 | 0 | 2287.1 | 24.26 |
| maximum-size | baseline | 24 | 24 | 389.3 | 37.09 |
| maximum-size | enhanced | 24 | 2 | 62.6 | 20.11 |

Normal, sparse-filter, and corrupt corpora contain 1,001 files. A sparse page
examines 1,000 nonmatching records and returns zero records with continuation;
a corrupt page returns 1,000 warnings and continuation. Maximum-size uses 24
records with 1,040,000-byte padding. The enhanced maximum-size page returns two
records and continuation because its compact JSON budget is 2 MiB; the baseline
returns all 24. The smaller first-page memory footprint does not mean the
complete corpus export takes less total time. Streaming verifies continued
progress separately.

The enhanced normal/corrupt medians are lower, while sparse-filter latency and
RSS are slightly higher. No universal speedup is claimed. The durable gain is a
fixed retained-record byte budget and bounded native directory enumeration.
Only 1,001 candidate names are retained; scans above 100,000 total entries fail
explicitly. Every page rescans the directory, so very large collections may need
an indexed storage design. Record JSON budgets do not cap total process RSS:
parsing, runtime overhead, and one candidate record require additional memory.

Raw samples and provenance: [`results-2026-09-22.json`](../benchmarks/results-2026-09-22.json).
Reproduce with a disposable checkout of baseline `275fbbf`:

```bash
"$KUJO_BIN" run benchmarks/run.kujo -- "$KUJO_BIN" /absolute/baseline /absolute/results.json
```

The runner writes its measurement worker into the baseline's ignored
`.loop-engineering` directory and removes all generated record corpora.
