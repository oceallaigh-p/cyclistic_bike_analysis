library(here)

# ==============================================================================
# Process files
# ==============================================================================
# List of files in the order they should be processed
files_to_process <- c(
  "01_load_data.R",
  "02_inspect_data.R",
  "03_transform_data.R",
  "04_analyze_data.R",
  "05_render_report.R"
)

# Process each file
for (file in files_to_process) {
  # Check existence of the file
  if (!file.exists(here("R", file))) {
    stop(paste0("The file ", file, " does not exist."))
  }

  # Catch any errors that occur during processing
  tryCatch(
    {
      if (grepl("\\.R$", here("R", file))) {
        message("Processing R script: ", file)
        source(here("R", file))
      } else if (grepl("\\.Rmd$", file)) {
        message("Rendering Rmd file: ", file)
        render(here("R", file))
      }
    },
    error = function(e) {
      # Custom error handling
      message("Error processing file ", file, ": ", e$message)
      stop("Stopping due to error.")
    }
  )
}

message("All files processed successfully.")
