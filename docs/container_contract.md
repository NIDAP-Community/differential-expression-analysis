# Container Contract

The Differential Expression application is a Container-as-a-Function. Its
root command is the noninteractive `entrypoint.R` supplied by the OCI image.
It accepts only declared DEG arguments and never receives a database
credential, host path, or arbitrary shell fragment from an application caller.

## Validated release

```text
ghcr.io/nidap-community/differential-expression-analysis@sha256:0d4e7ba82a8b44c339e9fc2292650a8a5968683bc8c262da7dd70ce15f3e63af
```

This approved `v0.1.0` image was built from source commit
`10f463baebc5bd58429973e6ef4bb0f7ffdab969` for `linux/amd64`. It uses the
pinned OMIX R-statistics base image recorded in `OMIX_MODULE_SOURCE.md`. Use
the digest for reproducible execution; `v0.1.0` is a readable release tag, and
`latest` is not a deployment identity.

## Filesystem and process boundary

| Location or setting | Contract |
| --- | --- |
| `/data` | Caller-supplied raw-count table and aligned metadata, mounted read-only. |
| `/output` | Caller-supplied writable directory for one complete result bundle. |
| User | The OCI image defaults to unprivileged user `deg`; helpers retain the invoking user's output ownership. |
| Network | No runtime package installation or network access is required. |
| Architecture | `linux/amd64`; Apple Silicon hosts may use emulation for local development. |

The result bundle contains canonical compatibility files plus adapter-owned
`tables/`, `figures/`, `logs/`, `run_manifest.json`, and `RUN_METADATA.md`.

## Supported launch helpers

`container/run_docker.sh` mounts a local input directory at `/data` and an
output directory at `/output`. `container/run_apptainer.sh` provides the
equivalent Apptainer/Singularity binding after OCI-to-SIF conversion. Neither
wrapper changes scientific arguments or stages data itself.

Validate a local image before publication or use:

```bash
tests/run_container_checks.sh differential-expression-analysis:local
```

This runs the public-interface smoke test (including fractional RSEM
`expected_count` acceptance and rejection of unsupported continuous-expression
mode) and the canonical-output parity test.
