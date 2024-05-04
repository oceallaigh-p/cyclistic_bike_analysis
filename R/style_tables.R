library(kableExtra)

#' Apply Custom Style to Tables
#'
#' This function applies a custom style to tables created with `knitr::kable`.
#' It uses the `kable_minimal` style from `kableExtra` with additional bootstrap
#' options to enhance the appearance of the table. The function is designed to
#' make tables more visually appealing with options like hover, condensed view,
#' and responsiveness.
#'
#' @param kable_input A kable object created by `knitr::kable` that you want
#'        to style.
#'
#' @return A kable object styled with minimal theme options and additional
#'         bootstrap features. The table is not set to full width and is centered.
#'
#' @details The function utilizes `kableExtra::kable_minimal` to apply a
#'          minimalist theme to the kable output. Bootstrap options such as
#'          'hover', 'condensed', and 'responsive' are used to enhance table
#'          interactivity and fit. The table is configured to not use the full
#'          width of the page and is centered for better visual alignment in
#'          reports or web pages.
#'
#' @examples
#' library(knitr)
#' library(kableExtra)
#' data(mtcars)
#' kable_output <- kable(mtcars, format = "html")
#' styled_table <- custom_table_theme(kable_output)
#' print(styled_table)
#'
#' @importFrom kableExtra kable_minimal

custom_table_theme <- function(kable_input) {
  kable_minimal(
    kable_input,
    bootstrap_options = c("hover", "condensed", "responsive"),
    full_width = FALSE,
    position = "center"
  )
}
