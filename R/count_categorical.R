# Required libraries
library(dplyr)
library(tibble)

#' Count Categorical Variables
#'
#' Calculate the count of each level for specified categorical variables.
#'
#' @param data A data frame, tibble, or `dtplyr::lazy_dt` containing the data.
#' @param categorical_vars The categorical variable to group by. This should
#'   be unquoted variable names.
#'
#' @return A tibble containing the counts of each level of the specified
#'   categorical variable.
#'
#' @details This function groups the data by the specified categorical variable
#'   and calculates the count of each level. It returns a tibble with these
#'   counts.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(tibble)
#'
#' data <- data.frame(
#'   category1 = c("A", "B", "A", "B", "C"),
#'   category2 = c("X", "X", "Y", "Y", "Z")
#' )
#' result <- count_categorical(data, c(category1, category2))
#' print(result)
#' }
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
