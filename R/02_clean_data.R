# Load required libraries
library(dplyr)
library(tidyr)
library(here)

# Load required scripts
source(here("R", "nrow_lazy_dt.R"))

# Remove irrelevant variables---------------------------------------------------

irrelevant_vars <- c("start_station_name", "start_station_id",
                     "end_station_name", "end_station_id")

data_raw <- data_raw %>%
  select(-all_of(irrelevant_vars))

# Check duplicate observations -------------------------------------------------

duplicate_obs <- data_raw %>%
  group_by_all() %>%
  filter(n() > 1) %>%
  ungroup() %>%
  nrow_lazy_dt()
  
# Check missing values ---------------------------------------------------------

missing_obs <- data_raw %>%
    summarise(
      across(everything(), ~ sum(is.na(.), na.rm = TRUE))
    ) %>%
    pivot_longer(
      everything(),
      names_to = "variable",
      values_to = "missing_count"
    ) %>%
    filter(missing_count > 0) %>%
    as_tibble()

