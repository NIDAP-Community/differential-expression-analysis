#!/usr/bin/env bash
set -euo pipefail
script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(CDPATH= cd -- "${script_dir}/.." && pwd)"
output_dir="$(mktemp -d "${TMPDIR:-/tmp}/deg-analysis-smoke.XXXXXX")"
docker run --rm --platform linux/amd64 --user "$(id -u):$(id -g)" --mount "type=bind,src=${project_dir}/test_data,dst=/data,readonly" --mount "type=bind,src=${output_dir},dst=/output" "${1:-differential-expression-analysis:local}" --counts /data/counts.tsv --metadata /data/metadata.tsv --gene_names_column GeneName --sample_names_column Sample --contrast_variable_columns Group --contrasts B-A --write_normalization_diagnostics false --output_dir /output
for file in DEG_Analysis.csv Sample_Metadata.csv run_summary.txt; do test -s "${output_dir}/${file}" || exit 1; done
for file in tables/DEG_Analysis.csv tables/Sample_Metadata.csv logs/run_summary.txt logs/sessionInfo.txt RUN_METADATA.md run_manifest.json; do test -s "${output_dir}/${file}" || exit 1; done
# Fractional RSEM expected_count values are supported raw count-scale input.
rsem_output_dir="$(mktemp -d "${TMPDIR:-/tmp}/deg-analysis-rsem-smoke.XXXXXX")"
docker run --rm --platform linux/amd64 --user "$(id -u):$(id -g)" --mount "type=bind,src=${project_dir}/test_data,dst=/data,readonly" --mount "type=bind,src=${rsem_output_dir},dst=/output" "${1:-differential-expression-analysis:local}" --counts /data/rsem_expected_counts.tsv --metadata /data/metadata.tsv --gene_names_column GeneName --sample_names_column Sample --contrast_variable_columns Group --contrasts B-A --write_normalization_diagnostics false --output_dir /output
test -s "${rsem_output_dir}/tables/DEG_Analysis.csv" || exit 1
# The standalone contract deliberately excludes continuous-expression modes.
if docker run --rm --platform linux/amd64 --user "$(id -u):$(id -g)" --mount "type=bind,src=${project_dir}/test_data,dst=/data,readonly" "${1:-differential-expression-analysis:local}" --counts /data/counts.tsv --metadata /data/metadata.tsv --analysis_mode harmony_mean_expression; then
  printf '%s\n' 'Continuous-expression mode unexpectedly passed the raw-count application preflight.' >&2
  exit 1
fi
printf 'DEG container smoke test passed: %s\n' "${output_dir}"
