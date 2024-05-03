# Required libraries

#' Remove Anomalies from Ride Data
#'
#' This function filters out anomalous ride data that falls outside specified
#' minimum and maximum thresholds. It is compatible with data frames, tibbles,
#' or `dtplyr::lazy_dt` objects. Only rides with durations within the inclusive
#' range defined by `min` and `max` are retained.
#'
#' @param data A data frame, tibble, or `dtplyr::lazy_dt` object containing the
#'        ride data.
#' @param col_name Unquoted name of the column containing ride durations.
#' @param min The minimum acceptable value for ride duration.
#' @param max The maximum acceptable value for ride duration.
#'
#' @return A data frame, tibble, or `dtplyr::lazy_dt` object that contains only
#'         rides with durations within the specified range.
#'
#' @details The function uses the `filter` function from `dplyr` to retain only
#'          those rides where the duration falls within the specified minimum and
#'          maximum thresholds.
#'
#' @examples
#' # Assuming df is your dataset with a column 'duration' for ride times
#' filtered_data <- remove_anomalies(df, duration, 5, 120)
#'
#' @importFrom dplyr filter
remove_anomalies <- function(data, col_name, min, max) {
  data %>%
    filter(
      {{ col_name }} >= min,
      {{ col_name }} <= max
    )
}
