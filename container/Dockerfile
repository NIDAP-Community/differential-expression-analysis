# syntax=docker/dockerfile:1
ARG BASE_IMAGE=ghcr.io/nidap-community/omix-r-statistics@sha256:1325722877fec5167d171aa766ddf7bbfd056e4999bf40fd8c1eabee495da667
FROM ${BASE_IMAGE}
WORKDIR /app
COPY R/ R/
COPY scripts/ scripts/
COPY entrypoint.R ./
COPY schemas/ schemas/
COPY test_data/ test_data/
COPY module.yml renv.lock ./
RUN mkdir -p /data /output && useradd --create-home --uid 10001 --shell /usr/sbin/nologin deg && chown --recursive deg:deg /app /data /output
USER deg
ENTRYPOINT ["Rscript", "--vanilla", "/app/entrypoint.R"]
CMD ["--help"]
