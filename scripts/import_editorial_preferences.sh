#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
: "${KUJO_BIN:?set the pinned runtime}"
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT
revision=990b2711a36180dd19d9c94b8627844866f8982a
expected=a5cd48600fb7a330cf0ccc8f59051e24e8f236907c379f42eff1ba18da55204b
curl -fL --retry 2 "https://huggingface.co/datasets/nvidia/HelpSteer2/resolve/$revision/preference/preference.jsonl.gz" -o "$scratch/source.gz"
if command -v sha256sum >/dev/null 2>&1; then actual="$(sha256sum "$scratch/source.gz")"
else actual="$(shasum -a 256 "$scratch/source.gz")"; fi
[[ "${actual%% *}" == "$expected" ]] || { echo 'Source checksum mismatch' >&2; exit 1; }
mkdir "$scratch/chunks"
gzip -dc "$scratch/source.gz" | split -l 25 - "$scratch/chunks/part-"
cd "$ROOT"
"$KUJO_BIN" run scripts/import_editorial_preferences.kujo -- "$scratch/chunks" "${1:-$scratch/corpus.json}"

if [[ $# == 0 ]]; then
  cmp "$scratch/corpus.json" fixtures/helpsteer2/corpus.json
  echo "Pinned corpus reproduction matched byte for byte."
fi
