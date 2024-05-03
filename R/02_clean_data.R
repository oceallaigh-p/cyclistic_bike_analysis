# Load required libraries
library(tidyverse)
library(here)

# Load required scripts
source(here("R", "nrow_lazy_dt.R"))

# Data Inspection --------------------------------------------------------------

## Check structure and type of data --------------------------------------------

data_raw %>%
  glimpse()

## Check duplicate observations ------------------------------------------------

duplicate_obs <- data_raw %>%
  group_by_all() %>%
  filter(n() > 1) %>%
  ungroup() %>%
  nrow_lazy_dt()
  
## Check missing values ---------------------------------------------------------

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

