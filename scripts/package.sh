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
cargo metadata --locked --no-default-features --format-version 1 --manifest-path "$KUJO_SOURCE_ROOT/Cargo.toml" > "$stage/runtime-metadata.json"
"$KUJO_BIN" run scripts/runtime_notices.kujo -- "$stage/runtime-metadata.json" "$stage/$name/runtime"
cp -R "$(cat "$stage/$name/runtime/colored-source-path.txt")" "$stage/$name/runtime/colored-source"
rm "$stage/$name/runtime/colored-source-path.txt"
printf '%s\n' "$revision" > "$stage/$name/APPLICATION_COMMIT"
tar -czf "$ROOT/dist/$name.tar.gz" -C "$stage" "$name"
(
  cd dist
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$name.tar.gz" > "$name.sha256"
  else shasum -a 256 "$name.tar.gz" > "$name.sha256"; fi
)
# Verify the actual archive in a fresh installation directory without KUJO_BIN.
mkdir -p "$stage/clean installation"
tar -xzf "$ROOT/dist/$name.tar.gz" -C "$stage/clean installation"
(
  cd "$stage"
  unset KUJO_BIN KUJO_MODULE_PATH KUJO_ISOLATED_IMPORTS
  "$stage/clean installation/$name/bin/bluepencil" --version --json > version.json
  "$stage/clean installation/$name/bin/bluepencil" doctor --state "$stage/install-state" --json > doctor.json
  "$stage/clean installation/$name/bin/bluepencil" review --state "$stage/install-state" --input "$stage/clean installation/$name/fixtures/core.json" --actor installation-smoke --id review-installation --json > review.json
  "$stage/clean installation/$name/bin/bluepencil" validate --state "$stage/install-state" --id review-installation --json > validated.json
  # The standalone development probe imports tests.support from its project.
  cd "$stage/clean installation/$name"
  ./runtime/kujo"$extension" run scripts/runtime_probe.kujo
  ./runtime/kujo"$extension" run tests/release_install.kujo -- "$stage/clean installation/$name"
  ./runtime/kujo"$extension" run tests/upgrade_test.kujo
)
printf 'Packaged and smoke-tested %s\n' "$name"
