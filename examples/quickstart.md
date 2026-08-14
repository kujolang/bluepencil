# Quickstart

`./bin/bluepencil init --state /tmp/bluepencil-demo --json`

`./bin/bluepencil review --state /tmp/bluepencil-demo --input fixtures/core.json --actor operator --timestamp 2026-08-14T00:00:00Z --json`

The fixed timestamp makes fixture IDs deterministic; repeating the command is rejected.
