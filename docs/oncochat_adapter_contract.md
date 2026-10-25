# OncoChat Adapter Contract

Validate request fields against `schemas/interface.yml`, materialize only the
selected raw-count and metadata artifacts under `/data`, and invoke a released
image by digest. Do not pass database credentials, host paths, or arbitrary
shell arguments into the container.

Consume `run_manifest.json` only after a zero exit status. The flat canonical
files are retained for interoperability; downstream application code should
use the adapter-owned `tables/`, `figures/`, and `logs/` paths. Publication,
database mapping, and clinical-use decisions remain separate release gates.
