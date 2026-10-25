# Differential Expression Analysis

Portable raw-count differential-expression component derived from canonical
OMIX DEG Analysis. It accepts declared integer counts and aligned metadata;
see the canonical source record and preflight before integrating it with an
orchestrator.

## Status

Local candidate only. It has passed a synthetic raw-count container smoke test
but is not published or OncoChat-enabled.

## Input and output

Stage `counts` and `metadata` under read-only `/data`, then invoke the image
with explicit paths and a declared design. Raw counts are valid only for
`analysis_mode=raw_counts`; continuous modes require their declared artifacts.

```bash
docker run --rm --platform linux/amd64 \
  -v "$PWD/input:/data:ro" -v "$PWD/results:/output" \
  differential-expression-analysis:local \
  --counts /data/counts.tsv --metadata /data/metadata.tsv \
  --gene_names_column GeneName --sample_names_column Sample \
  --contrast_variable_columns Group --contrasts B-A --output_dir /output
```

The canonical flat files remain at the result root for command-line
compatibility. The application adapter also copies stable handoff artifacts to
`tables/`, `figures/` when diagnostics are produced, and `logs/`, and writes
`RUN_METADATA.md` plus `run_manifest.json`. See `docs/` for the integration
boundary.
