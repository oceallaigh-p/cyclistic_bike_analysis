# Required libraries
library(dplyr)

#' Remove Anomalies
#'
#' Filter out anomalies in a specified column based on given minimum and maximum
#' thresholds.
#'
#' @param data A data frame, tibble, or `dtplyr::lazy_dt` containing the data.
#' @param col_name The column within the data to filter for anomalies. This
#'   should be an unquoted column name.
#' @param min The minimum threshold for filtering anomalies.
#' @param max The maximum threshold for filtering anomalies.
#'
#' @return A filtered data frame, tibble, or `dtplyr::lazy_dt` with anomalies removed.
#'
#' @details This function filters out rows where the specified column's values
#'   are below the minimum threshold (`min`) or above the maximum threshold (`max`).
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#'
#' data <- data.frame(
#'   ride_length = c(5, 10, 15, 20, 25, 30, 35, 40, 45, 50)
#' )
#' cleaned_data <- remove_anomalies(data, ride_length, min = 10, max = 40)
#' print(cleaned_data)
#' }
#'
#' @importFrom dplyr filter

remove_anomalies <- function(data, col_name, min, max) {
  data %>%
    filter(
      {{ col_name }} >= min,
      {{ col_name }} <= max
    )
}
