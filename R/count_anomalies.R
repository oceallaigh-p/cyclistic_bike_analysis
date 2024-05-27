# Required libraries
library(dplyr)
library(tibble)

#' Count Anomalies
#'
#' Calculate the number and percentage of anomalies in a specified column based
#' on given minimum and maximum thresholds.
#'
#' @param data A data frame, tibble, or `dtplyr::lazy_dt` containing the data.
#' @param col_name The column within the data to check for anomalies. This should
#'   be an unquoted column name.
#' @param min The minimum threshold for determining anomalies.
#' @param max The maximum threshold for determining anomalies.
#'
#' @return A tibble containing the number and percentage of short and long rides.
#'
#' @details This function calculates the number and percentage of values in a
#'   specified column that fall below the minimum threshold (`min`) or exceed the
#'   maximum threshold (`max`). It returns a tibble with these counts and
#'   percentages.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(tibble)
#'
#' data <- data.frame(ride_length = c(5, 10, 15, 20, 25, 30, 35, 40, 45, 50))
#' result <- count_anomalies(data, ride_length, min = 10, max = 40)
#' print(result)
#' }
#'
#' @importFrom dplyr summarise
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom tibble as_tibble
count_anomalies <- function(data, col_name, min, max) {
  data %>%
    summarise(
      total_rides = n(),
      short_rides = sum({{ col_name }} < min, na.rm = TRUE),
      long_rides = sum({{ col_name }} > max, na.rm = TRUE)
    ) %>%
    mutate(
      short_ride_percent = (short_rides / total_rides) * 100,
      long_ride_percent = (long_rides / total_rides) * 100
    ) %>%
    select(short_rides, short_ride_percent, long_rides, long_ride_percent) %>%
    as_tibble()
}
