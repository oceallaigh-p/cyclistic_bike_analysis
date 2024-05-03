library(dplyr)
library(here)

source(here("R", "csv_to_lazy_dt.R"))

# Load raw data ----------------------------------------------------------------
data_raw <- csv_to_lazy_dt()

# Display structure of raw data ------------------------------------------------

data_raw %>%
  glimpse()

