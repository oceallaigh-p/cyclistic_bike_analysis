# Required libraries
library(dplyr)

#' Find Mode
#'
#' Identify the mode(s) of a specified variable in a data frame.
#'
#' @param data A data frame, tibble, or `dtplyr::lazy_dt` containing the data.
#' @param variable The variable within the data for which to find the mode.
#'   This should be an unquoted variable name.
#'
#' @return The mode(s) of the specified variable.
#'
#' @details This function calculates the mode(s) of a given variable by counting
#'   the frequency of each value and identifying the value(s) with the highest
#'   frequency.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#'
#' data <- data.frame(
#'   values = c(1, 2, 2, 3, 3, 3, 4, 4, 4, 4)
#' )
#' mode_value <- find_mode(data, values)
#' print(mode_value)
#' }
#'
#' @importFrom dplyr count
#' @importFrom dplyr filter
#' @importFrom dplyr pull

find_mode <- function(data, variable) {
  data %>%
    count({{ variable }}) %>%
    filter(n == max(n)) %>%
    pull({{ variable }})
}
