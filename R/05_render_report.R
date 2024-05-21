# Required libraries
library(here)

# ==============================================================================
# Render the Rmd file to the specified directory
# ==============================================================================

# Path variables for knitted html and pdf
input_file <- here("Rmd", "cyclistic_bikeshare_report.Rmd")
output_file_html <- here("output", "html", "cyclistic_bikeshare_report.html")
output_file_pdf <- here("reports", "cyclistic_bikeshare_report.pdf")

render_reports_both <- function(input_rmd, output_html, output_pdf) {
  # Render HTML report
  rmarkdown::render(
    input = input_rmd,
    output_format = "html_document",
    output_file = output_html
  )

  # Render PDF report
  rmarkdown::render(
    input = input_rmd,
    output_format = "pdf_document",
    output_file = output_pdf
  )
}

# Render the report
render_reports_both(
  input_rmd = input_file,
  output_html = output_file_html,
  output_pdf = output_file_pdf
)
