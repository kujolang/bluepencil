#!/usr/bin/env bash
set -euo pipefail
KUJO_RUNTIME="${KUJO_BIN:?set KUJO_BIN}"
fixture_root="$(mktemp -d)"
worker_pid=""
cleanup() {
  if [[ -n "$worker_pid" ]]; then kill -9 "$worker_pid" 2>/dev/null || true; fi
  find "$fixture_root" -depth -delete
}
trap cleanup EXIT
for round in 1 2 3 4; do
  receipt_dir="$fixture_root/round-$round"
  mkdir "$receipt_dir"
  pids=()
  for writer in 1 2 3 4; do
    "$KUJO_RUNTIME" run bluepencil.kujo -- review --state "$receipt_dir/state" \
      --input fixtures/core.json --actor race-fixture --id review-concurrent \
      --timestamp 2026-09-22T00:00:00Z --json > "$receipt_dir/writer-$writer.json" 2> "$receipt_dir/writer-$writer.err" &
    pids+=("$!")
  done
  for pid in "${pids[@]}"; do wait "$pid" || true; done
  "$KUJO_RUNTIME" run tests/concurrency_receipt.kujo -- "$receipt_dir"
done
for stage in intent record event; do
  ready="$fixture_root/$stage-ready"
  "$KUJO_RUNTIME" run tests/crash_worker.kujo -- "$fixture_root/$stage" "$stage" "$ready" > "$fixture_root/$stage.log" 2>&1 &
  worker_pid="$!"
  attempts=0
  until [[ -f "$ready" ]]; do
    if ! kill -0 "$worker_pid" 2>/dev/null || (( attempts >= 200 )); then
      cat "$fixture_root/$stage.log" >&2
      exit 1
    fi
    attempts=$((attempts + 1))
    sleep 0.05
  done
  kill -9 "$worker_pid"
  wait "$worker_pid" 2>/dev/null || true
  worker_pid=""
  "$KUJO_RUNTIME" run tests/recovery_receipt.kujo -- "$fixture_root/$stage"
done
