# Required libraries
library(dplyr)
library(dtplyr)

#' Count the Number of Observations in a Lazy Data Table
#'
#' This function counts the number of observations in a lazy data table,
#' specifically designed to handle data tables managed by `dtplyr` in a lazy
#' evaluation mode. This is particularly useful for large datasets that are not
#' entirely loaded into memory.
#'
#' @param data A `dtplyr_step` object representing a lazy evaluation data table.
#'
#' @return A single integer value representing the count of rows in the provided
#'         data table.
#'
#' @details The function uses `dplyr`'s `summarize()` to compute the count of
#'          rows, which is then explicitly collected and extracted using
#'          `collect()` and `pull()`. This method ensures that the counting
#'          operation is deferred until explicitly demanded, which optimizes
#'          memory usage and computational efficiency for large datasets.
#'
#' @examples
#' # Assume `lazy_dt` is a dtplyr_step created from a large data.table
#' total_rows <- count_rows_lazy_dt(lazy_dt)
#' print(total_rows)
#'
#' @importFrom dplyr summarize
#' @importFrom dplyr n
#' @importFrom dplyr pull
#' @importFrom dplyr collect

# Count the number of observations in the data of a lazy data table
nrow_lazy_dt <- function(data) {
  data %>%
    summarize(n = n()) %>%
    collect() %>%
    pull(n)
}