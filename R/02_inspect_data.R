# Required libraries
library(dplyr)
library(tidyr)
library(here)

# Required scripts
source(here("R", "nrow_lazy_dt.R"))
source(here("R", "count_categorical.R"))

# ==============================================================================
# Check structure and type of data
# ==============================================================================

data_raw %>%
  glimpse()

obs_raw <- data_raw %>%
  nrow_lazy_dt()

# ==============================================================================
# Check duplicate observations
# ==============================================================================
duplicate_obs <- data_raw %>%
  group_by_all() %>%
  filter(n() > 1) %>%
  ungroup() %>%
  nrow_lazy_dt()

# ==============================================================================
# Check missing values
# ==============================================================================

missing_obs <- data_raw %>%
  summarise(across(everything(), ~ sum(is.na(.), na.rm = TRUE))) %>%
  pivot_longer(
    everything(),
    names_to = "variable",
    values_to = "missing_count"
  ) %>%
  filter(missing_count > 0) %>%
  as_tibble()

# ==============================================================================
# Check categorical variables
# ==============================================================================

# Check for valid values in the rideable_type variable -------------------------
count_rideable_type <- data_raw %>%
  count_categorical(rideable_type)

# Check for valid values in the member_casual variable -------------------------
count_member_casual <- data_raw %>%
  count_categorical(member_casual)
