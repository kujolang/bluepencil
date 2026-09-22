#!/usr/bin/env bash
set -euo pipefail
bundle_directory="${1:?provide the absolute bundle directory}"
# Minimal OS image: no source checkout, SDK, installed Kujo, or network.
docker run --rm --platform linux/amd64 --network none -v "$bundle_directory:/bundles:ro" ubuntu:24.04 bash -euc '
  cd /bundles
  sha256sum -c ./*.sha256
  archives=(./*.tar.gz)
  [[ ${#archives[@]} == 1 ]]
  mkdir /application
  tar -xzf "${archives[0]}" -C /application
  installations=(/application/bluepencil-*)
  [[ ${#installations[@]} == 1 ]]
  launcher="${installations[0]}/bin/bluepencil"
  ! command -v cargo
  ! command -v rustc
  ! command -v kujo
  cd /tmp
  "$launcher" --version --json
  "$launcher" doctor --state /tmp/state --json
  "$launcher" review --state /tmp/state --input "${installations[0]}/fixtures/core.json" --actor installation-smoke --id review-clean-install --json
  "$launcher" validate --state /tmp/state --id review-clean-install --json
  "$launcher" audit --state /tmp/state --json
  mkdir /tmp/custody
  "$launcher" checkpoint-create --state /tmp/state --custodian clean-container --output /tmp/custody/checkpoint.json --json
  "$launcher" checkpoint-verify --state /tmp/state --checkpoint /tmp/custody/checkpoint.json --json
'
