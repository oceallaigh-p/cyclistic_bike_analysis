# Required libraries
library(dplyr)
library(tibble)
library(dtplyr)

#' Calculate Summary Statistics
#'
#' Compute various summary statistics for a specified variable in a data frame,
#' tibble, or `dtplyr::lazy_dt`.
#'
#' @param data A data frame, tibble, or `dtplyr::lazy_dt` containing the data.
#' @param variable The variable within the data for which to calculate
#'   summary statistics. This should be an unquoted variable name.
#'
#' @return A tibble containing the summary statistics: count, min, max, mean,
#'   standard deviation, median, 25th percentile (q25), and 75th percentile (q75).
#'
#' @details This function calculates summary statistics for a given variable,
#'   including count, minimum, maximum, mean, standard deviation, median, 25th
#'   percentile, and 75th percentile. If the input data is a `dtplyr::lazy_dt`
#'   object, the results are collected before returning.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(tibble)
#' library(dtplyr)
#'
#' data <- mtcars
#' result <- calculate_sum_stats(data, mpg)
#' print(result)
#'
#' lazy_data <- lazy_dt(mtcars)
#' result_lazy <- calculate_sum_stats(lazy_data, mpg)
#' print(result_lazy)
#' }
#'
#' @importFrom dplyr summarise
#' @importFrom dplyr n
#' @importFrom dplyr collect
#' @importFrom tibble as_tibble
#' @importFrom dtplyr lazy_dt

calculate_sum_stats <- function(data, variable) {
  summary <- data %>%
    summarise(
      count = n(),
      min = min({{ variable }}),
      max = max({{ variable }}),
      mean = mean({{ variable }}),
      stdev = sd({{ variable }}),
      median = median({{ variable }}),
      q25 = quantile({{ variable }}, 0.25),
      q75 = quantile({{ variable }}, 0.75)
    )

  if (any(grepl("dtplyr_step", class(data)))) {
    summary <- collect(summary)
  }

  as_tibble(summary)
}
