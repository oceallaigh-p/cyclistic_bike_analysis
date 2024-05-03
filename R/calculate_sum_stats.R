# Required libraries
library(dplyr)
library(tibble)
library(dtplyr)

#' Calculate Summary Statistics for a Specified Variable
#'
#' Computes summary statistics for a specified variable within a data frame,
#' tibble, or a `dtplyr::lazy_dt` object. This function is designed to
#' handle both regular data frames and tibbles, as well as dtplyr lazy 
#' evaluation data tables.
#'
#' @param data A data frame, tibble, or a dtplyr_step lazy data table
#'        representing the dataset.
#' @param variable The unquoted name of the column for which summary statistics
#'        are calculated. This variable should be passed using the curly-curly
#'        syntax to enable tidy evaluation.
#'
#' @return Returns a tibble containing the following summary statistics of the
#'         specified variable: count of non-NA values, minimum, maximum, mean,
#'         standard deviation, median, 25th percentile, and 75th percentile.
#'
#' @details The function first calculates various summary statistics using
#'          dplyr's summarise function. It checks if the data input is a
#'          dtplyr_step (lazy data table) and collects the result to a standard
#'          tibble if true. This check ensures compatibility with both in-memory
#'          data frames and larger, on-disk datasets handled via dtplyr. The
#'          result is always returned as a tibble, ensuring consistent data
#'          format output.
#'
#' @examples
#' data <- data.frame(value = rnorm(100))
#' stats <- calculate_summary_stats(data, value)
#' print(stats)
#'
#' @importFrom dplyr summarise
#' @importFrom dplyr n
#' @importFrom dplyr collect
#' @importFrom tibble as_tibble

calculate_summary_stats <- function(data, variable) {
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