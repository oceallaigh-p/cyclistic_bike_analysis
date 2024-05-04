# Required libraries
library(dplyr)

#' Find the Mode of a Column in a Tibble
#'
#' This function calculates the mode(s) of a specified column in a tibble. The mode is defined
#' as the value(s) that appear most frequently in the column. If there are multiple modes,
#' all of them will be returned.
#'
#' @param data A tibble containing the data to analyze.
#' @param variable The name of the column (unquoted) whose mode is to be calculated.
#'
#' @return A vector containing the mode(s) of the specified column.
#'
#' @details The function uses `dplyr` for data manipulation, counting each unique value in the specified
#' column and then determining which value(s) appear most frequently. The use of `{{ variable }}` ensures
#' tidy evaluation of the column name.
#'
#' @examples
#' # Assuming a tibble `df` with a column `age`
#' df <- tibble(age = c(25, 30, 25, 40, 45, 30, 30, 25, 45))
#' find_mode(df, age)
#'
#' @importFrom dplyr count
#' @importFrom dplyr filter
#' @importFrom dplyr pull

find_mode <- function(data, variable){
  count({{ variable }}) %>%
    filter(n == max(n)) %>%
    pull({{ variable }})
}

