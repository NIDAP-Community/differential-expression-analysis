#!/usr/bin/env bash
set -euo pipefail
root="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
canonical_out="$(mktemp -d "${TMPDIR:-/tmp}/deg-canonical.XXXXXX")"
adapter_out="$(mktemp -d "${TMPDIR:-/tmp}/deg-adapter.XXXXXX")"
image="${1:-differential-expression-analysis:local}"
args=(--counts /data/counts.tsv --metadata /data/metadata.tsv --gene_names_column GeneName --sample_names_column Sample --contrast_variable_columns Group --contrasts B-A --write_normalization_diagnostics false)
docker run --rm --platform linux/amd64 --user "$(id -u):$(id -g)" --entrypoint Rscript \
  --mount "type=bind,src=${root}/test_data,dst=/data,readonly" --mount "type=bind,src=${canonical_out},dst=/output" \
  "${image}" --vanilla /app/scripts/run_deg_analysis.R "${args[@]}" --output_dir /output
docker run --rm --platform linux/amd64 --user "$(id -u):$(id -g)" \
  --mount "type=bind,src=${root}/test_data,dst=/data,readonly" --mount "type=bind,src=${adapter_out},dst=/output" \
  "${image}" "${args[@]}" --output_dir /output
cmp "${canonical_out}/DEG_Analysis.csv" "${adapter_out}/DEG_Analysis.csv"
cmp "${canonical_out}/Sample_Metadata.csv" "${adapter_out}/Sample_Metadata.csv"
printf 'DEG canonical-output parity passed.\n'
