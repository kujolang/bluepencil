#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
: "${KUJO_BIN:?set KUJO_BIN to the tested candidate runtime}"
: "${KUJO_SOURCE_ROOT:?set KUJO_SOURCE_ROOT to the pinned runtime source checkout}"
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
cp "$KUJO_SOURCE_ROOT/LICENSE" "$stage/$name/runtime/LICENSE"
printf '%s\n' "$revision" > "$stage/$name/APPLICATION_COMMIT"
tar -czf "$ROOT/dist/$name.tar.gz" -C "$stage" "$name"
(
  cd dist
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$name.tar.gz" > "$name.sha256"
  else shasum -a 256 "$name.tar.gz" > "$name.sha256"; fi
)
# Verify the actual archive in a fresh installation directory without KUJO_BIN.
mkdir -p "$stage/installed"
tar -xzf "$ROOT/dist/$name.tar.gz" -C "$stage/installed"
(
  cd "$stage"
  unset KUJO_BIN KUJO_MODULE_PATH KUJO_ISOLATED_IMPORTS
  "$stage/installed/$name/bin/bluepencil" --version --json > version.json
  "$stage/installed/$name/bin/bluepencil" doctor --state "$stage/install-state" --json > doctor.json
  "$stage/installed/$name/runtime/kujo$extension" run "$stage/installed/$name/scripts/runtime_probe.kujo"
)
printf 'Packaged and smoke-tested %s\n' "$name"
