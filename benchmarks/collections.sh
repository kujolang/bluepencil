#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
: "${KUJO_BIN:?set a compatible runtime}"
cd "$ROOT"
work="${COLLECTION_BENCH_ROOT:-$ROOT/.loop-engineering/collection-benchmark}"
mkdir -p "$work"
if [[ ! -f "$work/generate.json" || ! -s "$work/generate.json" ]]; then
  "$KUJO_BIN" run benchmarks/collections.kujo -- generate "$work/state" "$work/index" 95000 > "$work/generate.json"
fi
"$KUJO_BIN" run benchmarks/collections.kujo -- build "$work/state" "$work/index" > "$work/build.json"
for sample in 1 2 3; do
  for method in flat segments; do
    for filter in all sparse; do
      kind=""; if [[ "$filter" == sparse ]]; then kind=review; fi
      "$KUJO_BIN" run benchmarks/collections.kujo -- "$method" "$work/state" "$work/index" "$kind" "$work/$method-$filter-$sample.json" > /dev/null
    done
  done
done
printf 'Collection receipts: %s\n' "$work"
