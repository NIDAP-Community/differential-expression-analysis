#!/usr/bin/env bash
set -euo pipefail

# The smoke test exercises supported raw-count and fractional-RSEM input plus a
# rejected invalid mode. The parity test compares adapter output with the
# vendored canonical OMIX implementation using identical input and arguments.
project_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
image="${1:-differential-expression-analysis:local}"

"${project_dir}/container/smoke_test.sh" "${image}"
"${project_dir}/container/parity_test.sh" "${image}"
