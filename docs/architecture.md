# Architecture

`scripts/run_deg_analysis.R` and `R/OMIX_DEG_Analysis.R` are byte-preserved
canonical OMIX science. `entrypoint.R` is the application boundary: it invokes
that CLI unchanged and copies its completed outputs into a stable result
bundle. It does not alter counts, model settings, or calculated results.

The immutable base image is recorded in `OMIX_MODULE_SOURCE.md`. Database
adapters must materialize bounded raw-count and metadata tables under `/data`;
the container writes only to `/output`.
