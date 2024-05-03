# Required libraries
library(dplyr)
library(tibble)

#' Count Observations for Each Categorical Variable
#'
#' This function takes a data frame, tibble, or dtplyr lazy_dt and returns the
#' count of observations for each specified categorical variable.
#'
#' @param data A data frame, tibble, or `dtplyr::lazy_dt` object containing
#'        the data.
#' @param categorical_vars A variable or set of variables to group by. These should
#'        be specified as unquoted variable names or expressions.
#'
#' @return A tibble where each row represents a category of the input categorical
#'         variables and includes a count of observations in that category.
#'
#' @details This function is useful for quickly summarizing the distribution of
#'          categories within a dataset. It leverages `dplyr`'s `group_by` and
#'          `summarise` functions to perform the aggregation and returns the result
#'          as a tibble, regardless of the input type.
#'
#' @examples
#' # Sample data frame
#' df <- data.frame(category = c("apple", "banana", "carrot", "apple", "banana", "banana"))
#'
#' # Count occurrences of each category
#' counts <- count_categorical(df, category)
#' print(counts)
#'
#' @importFrom dplyr group_by
#' @importFrom dplyr summarise
#' @importFrom tibble as_tibble

count_categorical <- function(data, categorical_vars) {
  data %>%
    group_by({{ categorical_vars }}) %>%
    summarise(
      count = n(),
      .groups = "drop"
    ) %>%
    as_tibble()
}