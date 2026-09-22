#!/usr/bin/env bash
set -euo pipefail
bundle_directory="${1:?provide the absolute bundle directory}"
bundle_platform="${2:-linux-x64}"
container_platform="linux/amd64"; baselines=(22.04 24.04)
if [[ "$bundle_platform" == linux-arm64 ]]; then container_platform="linux/arm64"; baselines=(24.04); fi
# Minimal OS image: no source checkout, SDK, installed Kujo, or network.
for baseline in "${baselines[@]}"; do
docker run --rm --platform "$container_platform" --network none -v "$bundle_directory:/bundles:ro" "ubuntu:$baseline" bash -euc '
  cd /bundles
  sha256sum -c ./*.sha256
  archives=(./*.tar.gz)
  [[ ${#archives[@]} == 1 ]]
  mkdir "/application with spaces"
  tar -xzf "${archives[0]}" -C "/application with spaces"
  installations=("/application with spaces"/bluepencil-*)
  [[ ${#installations[@]} == 1 ]]
  launcher="${installations[0]}/bin/bluepencil"
  ! command -v cargo
  ! command -v rustc
  ! command -v kujo
  cd /tmp
  "${installations[0]}/runtime/kujo" run "${installations[0]}/tests/release_install.kujo" --isolated-imports -- "${installations[0]}"
  "$launcher" --version --json
  "$launcher" doctor --state /tmp/state --json
  "$launcher" review --state /tmp/state --input "${installations[0]}/fixtures/core.json" --actor installation-smoke --id review-clean-install --json
  "$launcher" validate --state /tmp/state --id review-clean-install --json
  "$launcher" audit --state /tmp/state --json
  mkdir /tmp/custody
  "$launcher" checkpoint-create --state /tmp/state --custodian clean-container --output /tmp/custody/checkpoint.json --json
  "$launcher" checkpoint-verify --state /tmp/state --checkpoint /tmp/custody/checkpoint.json --json
'
done
