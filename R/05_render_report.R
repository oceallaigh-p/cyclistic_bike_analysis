# Required libraries
library(here)

# ==============================================================================
# Render the Rmd file to the specified directory
# ==============================================================================

# Path variables for knitted html
input_file <- here("reports", "cyclistic_bikeshare_report.Rmd")
output_dir <- here("output", "html")
output_file <- "index.html"

# Render the Rmd file to the specified directory
rmarkdown::render(input_file,
                  output_dir = output_dir,
                  output_file = output_file)