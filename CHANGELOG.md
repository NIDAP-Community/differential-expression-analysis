# Changelog

All notable changes to this project are documented here.

## Unreleased

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

No versioned application image, Git tag, or GitHub Release has been published
yet. A release requires an explicit version decision, a clean source commit,
successful CI, a linux/amd64 image validation, and publication of an immutable
image digest.
