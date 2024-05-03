# Required libraries
library(dplyr)
library(tibble)

#' Count Anomalies in Ride Data
#'
#' This function processes ride data to identify and count rides that are 
#' anomalously short or long. It works with data frames, tibbles, or 
#' `dtplyr::lazy_dt` objects. The results, including the counts and 
#' percentages of anomalies, are returned as a tibble.
#'
#' @param data A data frame, tibble, or `dtplyr::lazy_dt` object containing 
#'   the ride data.
#' @param col_name Unquoted name of the column containing ride durations.
#' @param min The minimum threshold for ride duration to be considered normal.
#' @param max The maximum threshold for ride duration to be considered normal.
#'
#' @return A tibble containing the number and percentage of rides that are
#'   considered short and long according to the provided thresholds.
#'
#' @details The function calculates the total number of rides, the number of 
#'   rides shorter than `min`, and the number of rides longer than `max`. 
#'   It also calculates the percentage of rides that fall into these 
#'   categories. The result is a tibble with columns for short and long ride 
#'   counts and percentages.
#'
#' @examples
#' # Assuming df is your dataset with a column 'duration' for ride times
#' anomaly_counts <- count_anomalies(df, duration, 5, 120)
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