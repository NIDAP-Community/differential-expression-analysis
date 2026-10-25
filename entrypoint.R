#!/usr/bin/env Rscript

# Application adapter: restrict the public application interface to tabular
# raw counts, invoke the byte-preserved OMIX CLI, then copy (never rewrite)
# its artifacts into a stable result bundle for orchestrators.
args <- commandArgs(trailingOnly = TRUE)
canonical_script <- file.path("scripts", "run_deg_analysis.R")

if (length(args) == 0L || any(args %in% c("--help", "-h"))) {
  cat(
    "Differential Expression Analysis\n\n",
    "Portable raw-count differential-expression analysis.\n\n",
    "Required: --counts FILE --metadata FILE --gene_names_column NAME\n",
    "          --sample_names_column NAME --contrast_variable_columns NAME\n",
    "          --contrasts NUMERATOR-DENOMINATOR\n\n",
    "Optional: --covariate_columns NAME[,NAME] --batch_effect_columns auto|NAME\n",
    "          --donor_variable_column NAME --normalization_method auto|TMM|...\n",
    "          --write_normalization_diagnostics true|false --output_dir DIRECTORY\n\n",
    "Only a tabular raw count-scale matrix (integer or RSEM expected_count) and aligned metadata are supported\n",
    "by this standalone application. See README.md for input requirements.\n",
    sep = ""
  )
  quit(save = "no", status = 0L)
}

option_value <- function(name, values) {
  index <- which(values == name)
  if (length(index) == 1L && index < length(values)) return(values[[index + 1L]])
  prefix <- paste0(name, "=")
  inline <- values[startsWith(values, prefix)]
  if (length(inline) == 1L) substring(inline, nchar(prefix) + 1L) else NULL
}

option_values <- function(name, values) {
  indexes <- which(values == name)
  separated <- vapply(indexes[indexes < length(values)], function(index) values[[index + 1L]], character(1))
  prefix <- paste0(name, "=")
  inline <- substring(values[startsWith(values, prefix)], nchar(prefix) + 1L)
  c(separated, inline)
}

has_option <- function(name, values) {
  any(values == name | startsWith(values, paste0(name, "=")))
}

require_option <- function(name, values) {
  values_found <- option_values(name, values)
  if (!length(values_found) || any(!nzchar(values_found))) {
    stop(name, " is required by the raw-count application interface.")
  }
}

allow_only <- function(name, expected, values) {
  values_found <- option_values(name, values)
  if (length(values_found) && any(tolower(trimws(values_found)) != expected)) {
    stop(name, " must be ", expected, " for this raw-count application.")
  }
}

# The canonical module retains additional OMIX modes. They remain available in
# OMIX itself, but accepting them here would make this standalone container
# incompatible with its documented database-to-tabular input contract.
require_option("--counts", args)
require_option("--metadata", args)
allow_only("--input_type", "table", args)
allow_only("--analysis_mode", "raw_counts", args)
forbidden <- c("--moo", "--pseudobulk_manifest")
present_forbidden <- forbidden[vapply(forbidden, has_option, logical(1), values = args)]
if (length(present_forbidden)) {
  stop("Unsupported application input option(s): ", paste(present_forbidden, collapse = ", "),
       ". Supply only --counts and --metadata for raw-count analysis.")
}

write_bundle <- function(output_dir, arguments) {
  artifacts <- data.frame(
    role = c("Differential-expression table", "Modeled sample metadata", "Canonical run summary"),
    source = c("DEG_Analysis.csv", "Sample_Metadata.csv", "run_summary.txt"),
    destination = c("tables/DEG_Analysis.csv", "tables/Sample_Metadata.csv", "logs/run_summary.txt"),
    stringsAsFactors = FALSE
  )
  diagnostic_sources <- c(
    "normalization_boxplots.png", "normalization_densities.png", "voom_mean_variance.png"
  )
  present_diagnostics <- diagnostic_sources[file.exists(file.path(output_dir, diagnostic_sources))]
  if (length(present_diagnostics)) {
    artifacts <- rbind(
      artifacts,
      data.frame(
        role = paste("Normalization diagnostic", present_diagnostics),
        source = present_diagnostics,
        destination = file.path("figures", present_diagnostics),
        stringsAsFactors = FALSE
      )
    )
  }
  if (!all(file.exists(file.path(output_dir, artifacts$source)))) stop("Canonical DEG run did not create all required artifacts.")
  for (directory in unique(dirname(artifacts$destination))) dir.create(file.path(output_dir, directory), recursive = TRUE, showWarnings = FALSE)
  for (i in seq_len(nrow(artifacts))) file.copy(file.path(output_dir, artifacts$source[[i]]), file.path(output_dir, artifacts$destination[[i]]), overwrite = TRUE)
  capture.output(sessionInfo(), file = file.path(output_dir, "logs", "sessionInfo.txt"))
  timestamp <- format(Sys.time(), tz = "UTC", usetz = TRUE)
  manifest <- list(status = "completed", completed_utc = timestamp,
    application_interface = "raw-count-table-v1", analysis_mode = "raw_counts",
    canonical_omix_module = "OMIX-DEG-Analysis", artifacts = lapply(seq_len(nrow(artifacts)), function(i) list(role = artifacts$role[[i]], path = artifacts$destination[[i]])),
    arguments = arguments)
  jsonlite::write_json(manifest, file.path(output_dir, "run_manifest.json"), auto_unbox = TRUE, pretty = TRUE)
  writeLines(c("# DEG Run Metadata", "", "Completed successfully.", "", "## Canonical module", "", "OMIX-DEG-Analysis", "", "## Parameters", "", paste0("`", paste(arguments, collapse = " ` `"), "`"), "", "Exploratory research use only; not clinical decision support."), file.path(output_dir, "RUN_METADATA.md"))
}

status <- system2(file.path(R.home("bin"), "Rscript"), c("--vanilla", shQuote(canonical_script), shQuote(args)))
output_dir <- option_value("--output_dir", args)
if (identical(as.integer(status), 0L) && !is.null(output_dir)) write_bundle(output_dir, args)
quit(save = "no", status = as.integer(status))
