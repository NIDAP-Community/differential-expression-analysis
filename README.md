# Differential Expression Analysis

A containerized R application for differential expression from a tabular
raw-count matrix and matching sample metadata. It runs from the command line,
in Docker, or on HPC with explicit input tables and a writable output
directory.

The application intentionally supports only raw count-scale values: observed integer counts and fractional RSEM `expected_count` values are accepted. The canonical OMIX module also has MOO and continuous-expression modes, but those are not part of this portable application contract.

## Validated release

```text
ghcr.io/nidap-community/differential-expression-analysis@sha256:b78e452318131927b5a140e399d59350e1834d1f63239376f18637ebb0568854
```

This approved `v0.1.1` image was built for `linux/amd64` from validated source
commit `78190ad26bf2a6be4f0e4074bd4f275f97ee3575`. Use the digest for
reproducible deployment; `v0.1.1` is a readable release tag and `latest` is
not a deployment identity.

## Quick start

Build a local AMD64 image:

```bash
container/build_docker.sh differential-expression-analysis:local
```

Run it with read-only input and a writable output directory:

```bash
docker run --rm --platform linux/amd64 \
  -v /path/to/input:/data:ro \
  -v /path/to/output:/output \
  differential-expression-analysis:local \
  --counts /data/counts.tsv \
  --metadata /data/metadata.tsv \
  --gene_names_column GeneName \
  --sample_names_column Sample \
  --contrast_variable_columns Group \
  --contrasts B-A \
  --output_dir /output
```

`B-A` means the reported log fold change is the group `B` estimate minus group `A`.

The same command can use the approved image digest in place of the local tag.
For convenience, `container/run_docker.sh <image> <data_dir> <output_dir> ...`
creates the same `/data` and `/output` mounts.

## Input contract

`--counts` is a CSV, TSV, or TXT table with genes in rows, a gene-identifier column, and one column per sample. Values must be finite, non-negative count-scale values: observed integer counts and fractional RSEM `expected_count` values are accepted. Do not supply TPM, FPKM, CPM, normalized, log-transformed, Harmony-corrected, or SCTransform values.

```text
GeneName  A1  A2  B1  B2
Gene1     80  82 160 158
Gene2     90  88 170 168
```

`--metadata` is a CSV, TSV, or TXT table with one row per sample. Values in `--sample_names_column` must match count-table sample columns.

```text
Sample  Group  Batch
A1      A      1
A2      A      1
B1      B      2
B2      B      2
```

## Parameters

| Parameter | Default | Purpose |
| --- | --- | --- |
| `--counts` | required | Tabular gene-by-sample raw count-scale values, including RSEM `expected_count`. |
| `--metadata` | required | Matching sample metadata. |
| `--gene_names_column` | `GeneName` | Gene-identifier column in counts. |
| `--sample_names_column` | `Sample` | Sample-ID column in metadata. |
| `--contrast_variable_columns` | `Group` | Metadata column defining comparison groups. |
| `--contrasts` | `B-A` | Comma-separated numerator-minus-denominator contrasts. |
| `--covariate_columns` | empty | Optional fixed-effect metadata columns. |
| `--batch_effect_columns` | `auto` | Uses `Batch` when present; otherwise no batch term. |
| `--donor_variable_column` | empty | Optional donor column for true repeated measures. |
| `--write_normalization_diagnostics` | `auto` | Write raw-count normalization and voom diagnostic plots. |
| `--output_dir` | `results` | Writable result directory. |

`--input_type` is fixed to `table` and `--analysis_mode` is fixed to
`raw_counts`. The application rejects MOO, pseudobulk-manifest, and
continuous-expression inputs so its behavior is reproducible across supported
execution environments.

## Outputs

The canonical OMIX files remain at the output root for command-line
compatibility. The tool also creates stable result paths for downstream review.

| Stable path | Contents |
| --- | --- |
| `tables/DEG_Analysis.csv` | Differential-expression statistics and modeled expression values. |
| `tables/Sample_Metadata.csv` | Metadata for modeled samples. |
| `logs/run_summary.txt` | Model, normalization, and variance-model provenance. |
| `logs/sessionInfo.txt` | R session information for the completed container run. |
| `figures/` | Normalization and voom diagnostics, when requested. |
| `run_manifest.json` | Machine-readable status, arguments, and artifact paths. |
| `RUN_METADATA.md` | Human-readable run handoff. |

Raw p-values and multiple-testing-adjusted values are retained in the differential-expression table. This application is for exploratory research, not clinical decision support.

## Validation

```bash
container/build_docker.sh differential-expression-analysis:local
container/smoke_test.sh differential-expression-analysis:local
container/parity_test.sh differential-expression-analysis:local
```

The parity test confirms that the application adapter does not change canonical differential-expression tables or modeled metadata.

## Container and HPC use

The published image targets `linux/amd64` and can be pulled into Apptainer or Singularity:

```bash
apptainer pull differential-expression-analysis.sif \
  docker://ghcr.io/nidap-community/differential-expression-analysis:VERSION
```

Bind input to `/data` and results to `/output` exactly as in the Docker example.
`container/run_apptainer.sh` supplies the equivalent launch contract once the
OCI image has been converted to `.sif`. See
[docs/container_contract.md](docs/container_contract.md) for the complete
filesystem, process, and provenance contract.

## Provenance

Canonical OMIX science is intentionally preserved byte-for-byte in `R/OMIX_DEG_Analysis.R` and `scripts/run_deg_analysis.R`. The standalone adapter is limited to input validation, execution, and stable artifact handoff; it does not alter model settings or calculated values. See [docs/architecture.md](docs/architecture.md).
