# Required libraries
library(ggplot2)

#' Save a ggplot to a Specified Directory
#'
#' This function simplifies the process of saving ggplot2 plots by wrapping around
#' `ggsave`. It saves plots to a specific directory with pre-defined settings.
#'
#' @param file_name The name of the file to save the plot as.
#' @param plot_name The ggplot object to be saved.
#'
#' @return Saves the plot to the specified directory. The function itself
#' returns nothing.
#'
#' @details The function sets the directory path to 'output/plots' within the
#' project directory, and uses predefined dimensions and resolution.
#' Modify these parameters within the function as needed.
#'
#' @examples
#' p <- ggplot(mtcars, aes(x = mpg, y = wt)) +
#'   geom_point()
#' save_plots("my_custom_plot.png", p)
#'
#' @importFrom ggplot2 ggsave

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
