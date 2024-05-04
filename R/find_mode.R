library(dplyr)

#' Calculate the Mode of a Specified Variable in a Dataset
#'
#' This function calculates the mode, which is the most frequently occurring
#' value, of a specified variable in a dataset. It is particularly useful for
#' statistical analysis and data exploration. If multiple values have the
#' highest frequency, all such values are returned.
#'
#' @param data A data frame, tibble, or dtplyr lazy data table containing the
#'        dataset.
#' @param variable The unquoted name of the column for which the mode is to be
#'        calculated. The variable should be passed without quotes thanks to
#'        tidy evaluation.
#'
#' @return Returns a vector containing the mode(s) of the specified column.
#'          If multiple modes exist (i.e., multiple values appear with the
#'          highest frequency), all are returned.
#'
#' @details The function first extracts the specified column from the data using
#'          the `pull` function along with the curly-curly `{{ variable }}`
#'          syntax for tidy evaluation. It then computes the frequency of each
#'          unique value in the column. The mode is determined by identifying
#'          the value(s) that occur most frequently.
#'
#' @examples
#' data <- data.frame(age = c(25, 30, 35, 25, 25, 30))
#' mode_age <- find_mode(data, age)
#' print(mode_age) # Outputs: 25
#'
#' @importFrom dplyr pull

find_mode <- function(data, variable) {
  # Use the curly-curly operator to allow unquoted column names
  column_data <- data %>%
    pull({{ variable }})

  # Calculate the mode
  unique_values <- unique(column_data)
  count_unique <- tabulate(match(column_data, unique_values))
  unique_values[count_unique == max(count_unique)]
}
