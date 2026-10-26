# Container contract

Build a local AMD64 image from the pinned OMIX R-statistics runtime:

```bash
container/build_docker.sh differential-expression-analysis:local
```

The container runs as an unprivileged `deg` user. Mount `/data` read-only and
`/output` writable. It accepts only a raw count-scale table and aligned
metadata: observed integer counts and fractional RSEM `expected_count` values
are supported, while TPM, FPKM, CPM, and transformed values are not. See the
repository README for the public parameters.

Validate a built image before publication:

```bash
container/smoke_test.sh differential-expression-analysis:local
container/parity_test.sh differential-expression-analysis:local
```

The smoke test checks the public entrypoint and stable result bundle. The
parity test confirms that the adapter preserves the canonical differential-
expression table and modeled metadata.

The approved `v0.1.0` application image is:

```text
ghcr.io/nidap-community/differential-expression-analysis@sha256:0d4e7ba82a8b44c339e9fc2292650a8a5968683bc8c262da7dd70ce15f3e63af
```

Use the digest for deployment. `run_docker.sh` and `run_apptainer.sh` provide
equivalent `/data` read-only and `/output` writable mounts for Docker and HPC
execution. The full contract is in [../docs/container_contract.md](../docs/container_contract.md).
