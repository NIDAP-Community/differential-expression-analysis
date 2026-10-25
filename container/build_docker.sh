#!/usr/bin/env bash
set -euo pipefail
script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(CDPATH= cd -- "${script_dir}/.." && pwd)"
docker buildx build --file "${script_dir}/Dockerfile" --load --platform linux/amd64 --tag "${1:-differential-expression-analysis:local}" "${project_dir}"
