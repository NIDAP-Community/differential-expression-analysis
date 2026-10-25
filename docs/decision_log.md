# Decision Log (append-only)

## 2026-10-25 — Execution model: Container-as-a-Function

**Decision:** The standalone application is non-interactive, accepts explicit
tabular inputs under `/data`, and writes results only under `/output`.

**Rationale:** This makes command-line, HPC, and OncoChat execution
reproducible without placing database credentials or host-specific state in the
container.

**Consequences:** `entrypoint.R` is the application boundary; callers consume
the stable `tables/`, `figures/`, and `logs/` bundle only after a successful
exit status.

## 2026-10-25 — Canonical OMIX science is vendored and verified

**Decision:** The OMIX DEG R source, CLI, schema, and module record remain
byte-preserved in this repository and are pinned to a specific OMIX commit.

**Rationale:** The adapter must not independently alter differential-expression
modeling behavior.

**Consequences:** Any canonical scientific change is made and tested in OMIX
first, then imported here with refreshed SHA-256 provenance and CI parity
validation.

## 2026-10-25 — RSEM expected counts are valid raw count-scale input

**Decision:** Accept finite, non-negative fractional RSEM `expected_count`
values in `raw_counts` mode without rounding or truncation.

**Rationale:** RSEM expected counts are count-scale estimates. Rounding would
silently change submitted data, while integer-only validation would reject a
legitimate input class.

**Consequences:** TPM, FPKM, CPM, log-transformed, and other
normalized-expression values remain invalid for this raw-count workflow.

## 2026-10-25 — Release target

**Decision:** The canonical deployment target is `linux/amd64`; publication is
a separate release gate.

**Rationale:** This matches Biowulf and the intended AWS/Fargate runtime while
keeping the published container tied to a validated source commit.

**Consequences:** Do not use mutable tags as deployment provenance. Record the
immutable GHCR digest in versioned release notes after explicit publication.
