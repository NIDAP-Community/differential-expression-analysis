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
