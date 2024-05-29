# Required libraries
library(dtplyr)
library(dplyr)
library(vroom)
library(here)

#' Import and Combine CSV Files into a Lazy Data Table
#'
#' Read CSV files from the specified directory and convert them into a
#' `dtplyr::lazy_dt` object.
#'
#' @return A `dtplyr::lazy_dt` object containing the combined data from all
#'   CSV files in the specified directory.
#'
#' @details This function reads all CSV files from the "data/raw_data" directory,
#'   combines them into a single data frame, and then converts it into a
#'   `dtplyr::lazy_dt` object.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(dtplyr)
#' library(vroom)
#' library(here)
#'
#' lazy_data <- csv_to_lazy_dt()
#' print(lazy_data)
#' }
#'
#' @importFrom vroom vroom
#' @importFrom dtplyr lazy_dt
#' @importFrom here here

csv_to_lazy_dt <- function() {
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
