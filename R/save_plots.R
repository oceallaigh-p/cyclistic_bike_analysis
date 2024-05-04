save_plots <- function(file_name, plot_name) {
  ggsave(
    filename = file_name,
    plot = plot_name,
    path = here("output", "plots"),
    width = 10,
    height = 8,
    units = "in",
    dpi = 300
  )
}
