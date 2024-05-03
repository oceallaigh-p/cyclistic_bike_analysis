#' Import and Combine CSV Files into a Lazy Data Table
#'
#' This function searches for all CSV files in a specified directory, reads them
#' into R using the vroom package, and combines them into a single lazy data
#' table for efficient processing. The data is read from the 'raw_data'
#' subdirectory within the 'data' directory located at the project root, as
#' specified by the here() function.
#'
#' @return A `dtplyr::lazy_dt` object containing the data from all CSV files
#' in the specified directory.
#'
#' @details This function utilizes the `list.files` function to retrieve all CSV
#'          files within the specified subdirectory. It then employs `vroom` to
#'          read these files efficiently. `vroom` is particularly well-suited
#'          for large datasets as it only reads the data on-demand rather than
#'          loading it all into memory at once. After reading, the function
#'          converts the imported data into a `lazy_dt` format, which is a
#'          dtplyr step to handle data lazily, optimizing for both performance
#'          and memory usage. This makes it ideal for dealing with large
#'          datasets or for scenarios where data manipulation needs to be
#'          efficient and minimized in memory usage. The use of the `here()`
#'          function ensures that file paths are constructed reliably, regardless
#'          of where the project directory is currently set in the R environment.
#'
#' @examples
#' # Load data assuming your CSV files are stored in the data/raw_data directory
#' data_lazy <- load_data()
#'
#' @importFrom vroom vroom
#' @importFrom dtplyr lazy_dt
#' @importFrom here here
#'
load_data <- function() {
  return(
    list.files(
      path = here("data", "raw_data"),
      pattern = "*.csv",
      full.names = TRUE
    ) %>%
      vroom() %>%
      lazy_dt()
  )
}
