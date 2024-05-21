# Required libraries
library(here)

# Required scripts
source(here("R", "csv_to_lazy_dt.R"))

# ==============================================================================
# Load raw data
# ==============================================================================
data_raw <- csv_to_lazy_dt()
