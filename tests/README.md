# Validation Layout

`run_container_checks.sh` is the maintained public validation entry point. It
delegates to the container smoke and canonical-output parity checks, so the
same interface and regression evidence can be used locally and in CI.

GitHub Actions additionally compares the vendored scientific export with the
immutable canonical OMIX commit before building the image.
