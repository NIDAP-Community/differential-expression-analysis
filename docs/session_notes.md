# Session Notes (append-only)

## 2026-10-25

- Established the standalone tabular raw-count application boundary while
  preserving canonical OMIX DEG source files byte-for-byte.
- Added the application schema, OncoChat contract, stable result-bundle
  adapter, container smoke test, and canonical-output parity test.
- Synced canonical OMIX v0.4.4 (`e95a2bb737fa527294aa515a8978702fcdb7b295`),
  which accepts fractional RSEM `expected_count` values without rounding.
- Added direct OMIX function/CLI coverage and standalone container smoke
  coverage for a fractional RSEM-style fixture.
- Pushed standalone application commit `625a80d`; GitHub validation and
  CodeQL completed successfully.
- Opened OMIX issue #125 to synchronize the separate Code Ocean DEG adapter
  with the updated RSEM contract.
- No application image, Git tag, or GitHub Release has been published.

## 2026-10-25 — v0.1.1 release

- Tagged the validated application commit
  `78190ad26bf2a6be4f0e4074bd4f275f97ee3575` as `v0.1.1`.
- Published the repository-owned `linux/amd64` OCI image at
  `ghcr.io/nidap-community/differential-expression-analysis@sha256:b78e452318131927b5a140e399d59350e1834d1f63239376f18637ebb0568854`.
- Created the matching GitHub Release after testing the published digest with
  the public smoke and canonical-output parity checks.
- `v0.1.1` standardizes runtime documentation and launch/validation helpers;
  it does not change canonical scientific code, defaults, or the raw-count
  input contract.
