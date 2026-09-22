#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
: "${KUJO_BIN:?set KUJO_BIN to the tested candidate runtime}"
: "${BUNDLE_PLATFORM:?set BUNDLE_PLATFORM to the native platform name}"
case "$BUNDLE_PLATFORM" in linux-x64|linux-arm64|macos-x64|macos-arm64|windows-x64) ;; *) exit 2 ;; esac
cd "$ROOT"
revision="$(git rev-parse HEAD)"
name="bluepencil-${revision:0:12}-$BUNDLE_PLATFORM"
mkdir -p dist
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT
mkdir -p "$stage/$name/runtime"
git archive HEAD | tar -xf - -C "$stage/$name"
extension=""; if [[ "$BUNDLE_PLATFORM" == windows-* ]]; then extension=".exe"; fi
cp "$KUJO_BIN" "$stage/$name/runtime/kujo$extension"
chmod +x "$stage/$name/runtime/kujo$extension"
if [[ -n "${KUJO_SOURCE_ROOT:-}" ]]; then cp "$KUJO_SOURCE_ROOT/LICENSE" "$stage/$name/runtime/LICENSE"; fi
printf '%s\n' "$revision" > "$stage/$name/APPLICATION_COMMIT"
# Verify bundled-runtime selection outside the source checkout and without KUJO_BIN.
(
  cd "$stage"
  unset KUJO_BIN KUJO_MODULE_PATH KUJO_ISOLATED_IMPORTS
  "$stage/$name/bin/bluepencil" --version --json > version.json
  "$stage/$name/bin/bluepencil" doctor --state "$stage/install-state" --json > doctor.json
  "$stage/$name/runtime/kujo$extension" run "$stage/$name/scripts/runtime_probe.kujo"
)
tar -czf "$ROOT/dist/$name.tar.gz" -C "$stage" "$name"
(
  cd dist
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$name.tar.gz" > "$name.sha256"
  else shasum -a 256 "$name.tar.gz" > "$name.sha256"; fi
)
printf 'Packaged and smoke-tested %s\n' "$name"
