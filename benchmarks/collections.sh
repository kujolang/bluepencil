#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
: "${KUJO_BIN:?set a compatible runtime}"
cd "$ROOT"
work="${COLLECTION_BENCH_ROOT:-$ROOT/.loop-engineering/collection-benchmark}"
mkdir -p "$work"
if [[ -e "$work/build.json" ]]; then
  echo 'This fixture already has snapshot evidence; use a fresh COLLECTION_BENCH_ROOT.' >&2; exit 1
fi
if command -v sha256sum >/dev/null 2>&1; then runtime_hash="$(sha256sum "$KUJO_BIN")"
else runtime_hash="$(shasum -a 256 "$KUJO_BIN")"; fi
if [[ -f "$work/runtime.sha256" && "$(cut -d ' ' -f 1 "$work/runtime.sha256")" != "${runtime_hash%% *}" ]]; then
  echo 'Refusing to mix benchmark runtime binaries; use a fresh fixture directory.' >&2; exit 1
fi
printf '%s\n' "$runtime_hash" > "$work/runtime.sha256"
printf '%s\n' "${COLLECTION_RUNTIME_SOURCE:-unverified source revision}" > "$work/runtime-source.txt"
if [[ ! -f "$work/generate.json" || ! -s "$work/generate.json" ]]; then
  "$KUJO_BIN" run benchmarks/collections.kujo -- generate "$work/state" "$work/index" 95000 > "$work/generate.json"
fi
"$KUJO_BIN" run benchmarks/collections.kujo -- build "$work/state" "$work/index" > "$work/build.json"
du -sk "$work/state" "$work/index" > "$work/disk-kib.txt"
for sample in 1 2 3; do
  for method in flat segments; do
    for filter in all sparse; do
      kind=""; if [[ "$filter" == sparse ]]; then kind=review; fi
      "$KUJO_BIN" run benchmarks/collections.kujo -- "$method" "$work/state" "$work/index" "$kind" "$work/$method-$filter-$sample.json" > /dev/null
    done
  done
done
printf 'Collection receipts: %s\n' "$work"
