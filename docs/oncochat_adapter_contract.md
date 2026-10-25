# OncoChat Adapter Contract

Validate request fields against `schemas/application_interface.yml`, materialize
only the selected raw-count and metadata artifacts under `/data`, and invoke a
released image by digest. Do not pass database credentials, host paths, MOO
objects, continuous-expression matrices, or arbitrary shell arguments into the
container.

Require `input_type=table` and `analysis_mode=raw_counts` (the application
defaults already resolve to those values). Consume `run_manifest.json` only
after a zero exit status and verify its `application_interface` value is
`raw-count-table-v1`. The flat canonical files are retained for
interoperability; downstream application code should use the adapter-owned
`tables/`, `figures/`, and `logs/` paths. Publication, database mapping, and
clinical-use decisions remain separate release gates.
