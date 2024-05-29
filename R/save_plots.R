# Required libraries
library(ggplot2)
library(here)

#' Save Plots
#'
#' Save a ggplot object as a PNG file with specified dimensions and resolution.
#'
#' @param filename A character string representing the name of the file (without
#'   extension) to save the plot as.
#' @param plot A ggplot object to be saved.
#'
#' @return None. This function saves the plot to a file and does not return a value.
#'
#' @details This function saves a ggplot object as a PNG file in the "output/plots"
#'   directory with a specified width, height, and resolution. The file name is
#'   constructed by appending ".png" to the provided filename.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library(here)
#'
#' plot <- ggplot(mtcars, aes(x = mpg, y = hp)) +
#'   geom_point()
#' save_plots("mtcars_plot", plot)
#' }
#'
#' @importFrom ggplot2 ggsave
#' @importFrom here here

save_plots <- function(filename, plot) {
  ggsave(
    filename = paste0(filename, ".png"),
    plot = plot,
    path = here("output", "plots"),
    width = 10,
    height = 8,
    units = "in",
    dpi = 300
  )
}
