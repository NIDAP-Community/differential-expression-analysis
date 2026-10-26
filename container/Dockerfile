# syntax=docker/dockerfile:1
ARG BASE_IMAGE=ghcr.io/nidap-community/omix-r-statistics@sha256:1325722877fec5167d171aa766ddf7bbfd056e4999bf40fd8c1eabee495da667
FROM ${BASE_IMAGE}
WORKDIR /app
COPY R/ R/
COPY scripts/ scripts/
COPY entrypoint.R ./
COPY schemas/ schemas/
COPY test_data/ test_data/
COPY container/ container/
COPY docs/ docs/
COPY README.md LICENSE CHANGELOG.md OMIX_MODULE_SOURCE.md module.yml renv.lock ./
RUN mkdir -p /data /output && useradd --create-home --uid 10001 --shell /usr/sbin/nologin deg && chown --recursive deg:deg /app /data /output
ARG VCS_REF=unknown
ARG BUILD_DATE=unknown
LABEL org.opencontainers.image.title="differential-expression-analysis" \
      org.opencontainers.image.description="Portable differential-expression analysis component derived from OMIX" \
      org.opencontainers.image.source="https://github.com/NIDAP-Community/differential-expression-analysis" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.base.name="ghcr.io/nidap-community/omix-r-statistics@sha256:1325722877fec5167d171aa766ddf7bbfd056e4999bf40fd8c1eabee495da667" \
      org.opencontainers.image.created="${BUILD_DATE}"
USER deg
ENTRYPOINT ["Rscript", "--vanilla", "/app/entrypoint.R"]
CMD ["--help"]
