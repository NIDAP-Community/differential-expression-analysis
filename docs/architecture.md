# Architecture

`scripts/run_deg_analysis.R`, `R/OMIX_DEG_Analysis.R`, `schemas/interface.yml`,
and `module.yml` are byte-preserved canonical OMIX science and module records.
The GitHub workflow verifies them against the pinned OMIX commit.

`entrypoint.R` is the standalone application boundary. It accepts only a
tabular raw count-scale matrix plus matching metadata, rejects MOO and
continuous-expression modes before invoking the canonical CLI, and copies
completed canonical outputs into a stable result bundle. It does not alter
counts, model settings, or calculated results. The application-specific
contract is `schemas/application_interface.yml`; it is intentionally separate
from the canonical OMIX schema.

Raw count-scale input includes observed integer counts and fractional RSEM
`expected_count` estimates. TPM, FPKM, CPM, log-transformed, and other
normalized-expression matrices are outside this contract.

The immutable base image is recorded in `OMIX_MODULE_SOURCE.md`. Database
adapters must materialize bounded raw-count and metadata tables under `/data`;
the container writes only to `/output`. Stable adapter artifacts are copied to
`tables/`, `figures/` when diagnostics exist, and `logs/`; the canonical flat
files remain at the result root.
