# Required libraries
library(kableExtra)

#' Custom Table Theme
#'
#' This function applies styling to a kable input based on the output format.
#'
#' @param kable_input A kable object to be styled.
#' @return A styled kable object.
#'
#' @details
#' This function checks the output format (HTML or LaTeX) and applies
#' appropriate styling using the `kable_styling` function from the
#' `kableExtra` package.
#'
#' @examples
#' # Example usage:
#' library(knitr)
#' library(kableExtra)
#' library(dplyr)
#' kable_input <- knitr::kable(head(mtcars), "html")
#' custom_table_theme(kable_input)
#'
#' @import knitr
#' @import dplyr
#' @import kableExtra
custom_table_theme <- function(kable_input) {
  if (format == "html") {
    kable_input %>%
      kable_styling(
        bootstrap_options = c("hover", "condensed", "responsive"),
        full_width = FALSE,
        position = "center"
      )
  } else {
    kable_input %>%
      kable_styling(
        latex_options = "striped",
        full_width = FALSE,
        position = "center"
      )
  }
}
