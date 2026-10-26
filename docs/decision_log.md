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

## 2026-10-25 — Application runtime helpers and validation layout

**Decision:** Keep the stable adapter entrypoint at the repository root and
provide Docker/Apptainer launch helpers in `container/`; retain test logic in
`container/` and expose it through `tests/run_container_checks.sh`.

**Rationale:** The root entrypoint is the only application-owned R
orchestration code. The scientific implementation stays byte-preserved under
`R/` and `scripts/`, while the helpers make the same `/data` and `/output`
contract usable in Docker, Apptainer, and CI without duplicating test logic.

**Consequences:** No `src/` directory is needed unless a future adapter-owned
helper has a stable implementation role. The named validation entry point and
`docs/container_contract.md` are the repository-shape evidence for this
single-entrypoint application.
