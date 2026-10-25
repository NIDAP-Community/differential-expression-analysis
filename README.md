# Differential Expression Analysis

Portable raw-count differential-expression component derived from canonical
OMIX DEG Analysis. It accepts declared integer counts and aligned metadata;
see the canonical source record and preflight before integrating it with an
orchestrator.

## Status

Local candidate only. It has passed a synthetic raw-count container smoke test
but is not published or OncoChat-enabled.

## Input and output

Stage `counts` and `metadata` under read-only `/data`, invoke the bounded
canonical CLI, and collect `DEG_Analysis.csv`, `Sample_Metadata.csv`, optional
normalization diagnostics, and `run_summary.txt` from `/output`. Raw counts
are valid only for `analysis_mode=raw_counts`; continuous modes require their
declared artifacts.
