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
