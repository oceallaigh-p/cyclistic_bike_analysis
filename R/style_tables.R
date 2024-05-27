# Required libraries
library(kableExtra)

#' Apply custom styling to kable tables
#'
#' This function applies custom styling to Kable tables based on the specified
#' format. For HTML tables, it adds bootstrap options for hover, condensed, and
#' responsive styles. For LaTeX tables, it applies a striped style.
#'
#' @param kable_input A kable object that you want to style.
#' @param tbl_format A character string specifying the format of the table.
#'                   It should be either "html" or "latex".
#'
#' @return A styled kable object.
#'
#' @details This function uses the `kable_styling` function from the `kableExtra`
#'          package to apply different styles depending on the table format.
#'
#' @examples
#' \dontrun{
#' library(kableExtra)
#' kable_input <- knitr::kable(head(mtcars), format = "html")
#' styled_table <- custom_table_theme(kable_input, "html")
#' }
#'
#' @importFrom kableExtra kable_styling
custom_table_theme <- function(kable_input, tbl_format) {
  if (tbl_format == "html") {
    kable_input %>%
      kable_styling(
        bootstrap_options = c("hover", "condensed", "responsive"),
        full_width = FALSE,
        position = "center"
      )
  } else {
    kable_input %>%
      kable_styling(
        latex_options = c("striped", "hold_position"),
        full_width = FALSE,
        position = "center"
      )
  }
}
