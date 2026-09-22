#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
: "${KUJO_BIN:?set the pinned Kujo runtime}"
: "${OPERATOR_ROOT:?set the Publishing House operator directory}"
: "${REPOS_ROOT:?set the Kujo repositories directory}"
# This external consumer is Python; all BluePencil behavior remains Kujo.
# -I prevents its operator.py filename from shadowing Python's stdlib operator.
consumer_python="${CONSUMER_PYTHON:-$(command -v python3)}"
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT
cat > "$scratch/operator" <<'SH'
#!/usr/bin/env bash
exec "$CONSUMER_PYTHON" -I "$OPERATOR_ROOT/operator.py" "$@"
SH
chmod 700 "$scratch/operator"
export CONSUMER_PYTHON="$consumer_python" OPERATOR_ROOT
cd "$ROOT"
"$KUJO_BIN" run tests/operator_sandbox.kujo -- "$KUJO_BIN" "$scratch/operator" "$REPOS_ROOT" "$consumer_python" "$OPERATOR_ROOT"
