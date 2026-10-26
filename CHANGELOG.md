# Changelog

All notable changes to this project are documented here.

## 2026-10-25 — v0.1.1

- Published an AMD64 application image with immutable digest
  `sha256:b78e452318131927b5a140e399d59350e1834d1f63239376f18637ebb0568854`.
- Added documented Docker and Apptainer/Singularity launch paths, a public
  smoke/parity validation entry point, container-contract documentation, and
  an MIT license.
- Included applicable documentation and launch helpers in the OCI image.
- Kept the byte-preserved canonical OMIX science, raw-count/RSEM contract, and
  user-visible model defaults unchanged.

## 2026-10-25 — v0.1.0

- Established the standalone Container-as-a-Function application boundary for
  tabular raw-count differential-expression analysis, with explicit `/data`
  and `/output` mounts and a stable result bundle for orchestration.
- Added the application interface schema, OncoChat adapter contract,
  architecture documentation, container usage guide, ignore rules, and
  GitHub validation workflow.
- Pinned the byte-preserved canonical OMIX DEG source and its SHA-256 record;
  CI verifies the export before running the container smoke and parity tests.
- Added support for fractional RSEM `expected_count` count-scale input through
  canonical OMIX v0.4.4, with direct CLI and container smoke-test coverage.
- Kept MOO and continuous-expression modes outside this standalone application
  contract. They remain canonical OMIX capabilities rather than application
  inputs.

## Release policy

Each release requires an explicit version decision, a clean source commit,
successful CI, a linux/amd64 image validation, and publication of an immutable
image digest. The versioned GitHub Release is the authoritative record of the
published image digest.
