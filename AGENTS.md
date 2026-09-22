# Agent instructions

Keep CLI, domain behavior, validation, storage, fixtures, release checks, and tests in Kujo. Preserve immutable records, append-only history, atomic writes, bounded I/O, path/symlink protection, offline behavior, and authority boundaries. Build the source-pinned Kujo revision in `runtime-requirements.json`; a version label alone does not establish API support. Run `KUJO_BIN=/absolute/path/to/pinned/kujo bash scripts/validate.sh` and `git diff --check`. Never force-push or use live credentials in tests.
