#' Setup Script for Project Directories
#'
#' This script initializes the directory structure for a data analysis project
#' using the `here` package to ensure paths are relative to the project root.
#' It also checks for the existence of these directories and creates them if
#' they do not exist.

# Load the necessary library
library(here)

# -----------------------------------------------------------------------------

#' Reports directory
#'
#' @details Stores reports and other documents generated during the analysis
#'          process
reports_dir <- here("reports")

# -----------------------------------------------------------------------------

#' Data directories
#'
#' @details Directories for storing raw and processed data.
#'          - `raw_data_dir` for raw data.
#'          - `processed_data_dir` for data that has been cleaned and processed.
raw_data_dir <- here("data", "raw_data")
processed_data_dir <- here("data", "processed_data")

# -----------------------------------------------------------------------------

#' Output directories
#'
#' @details Directories for storing outputs like plots, tables, and HTML files.
#'          - `plot_dir` for graphical outputs.
#'          - `table_dir` for tabular data outputs.
#'          - `html_dir` for HTML outputs.
plot_dir <- here("output", "plots")
table_dir <- here("output", "tables")
html_dir <- here("output", "html")

# -----------------------------------------------------------------------------

#' Resources directories
#'
#' @details Directories for storing static resources such as images and CSS files.
#'          - `resources_images_dir` for image files.
#'          - `resources_css_dir` for CSS styling files.
resources_images_dir <- here("resources", "images")
resources_css_dir <- here("resources", "css")

# -----------------------------------------------------------------------------

#' R scripts directory
#'
#' @details Directories for storing script files and utilities functions.
scripts_dir <- here("R")

# -----------------------------------------------------------------------------

#' Directory Existence Check and Creation
#'
#' @details Checks if the directories exist and creates them if they do not.
#'          This ensures that all necessary directories are available for the
#'          project without manual setup.
dirs_to_check <- c(
  reports_dir, raw_data_dir, processed_data_dir,
  plot_dir, table_dir, html_dir, resources_images_dir,
  resources_css_dir, scripts_dir
)

lapply(dirs_to_check, function(x) if (!dir.exists(x)) dir.create(x, recursive = TRUE))
