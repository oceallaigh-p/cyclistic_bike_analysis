# Required libraries
library(knitr)
library(kableExtra)

#' Style Tables
#'
#' Apply styling to kable tables based on the specified format.
#'
#' @param kable_input A kable object to be styled.
#' @param tbl_format A character string specifying the format of the table.
#'   Accepted values are "html" and "latex".
#'
#' @return A styled kable object.
#'
#' @details This function applies different styles to kable tables based on the
#'   specified format. For HTML tables, it adds bootstrap options such as "hover",
#'   "condensed", and "responsive". For LaTeX tables, it adds options like
#'   "striped" and "hold_position".
#'
#' @examples
#' \dontrun{
#' library(knitr)
#' library(kableExtra)
#'
#' # Example for HTML table
#' kable_input <- knitr::kable(head(mtcars), format = "html")
#' styled_table <- style_tables(kable_input, "html")
#'
#' # Example for LaTeX table
#' kable_input <- knitr::kable(head(mtcars), format = "latex")
#' styled_table <- style_tables(kable_input, "latex")
#' }
#'
#' @importFrom knitr kable
#' @importFrom kableExtra kable_styling

style_tables <- function(kable_input, tbl_format) {
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
