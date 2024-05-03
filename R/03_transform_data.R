# Required libraries
library(tidyverse)

# Required scripts

# Data transformation ----------------------------------------------------------

## Remove irrelevant variables -------------------------------------------------
irrelevant_vars <- c("start_station_name", "start_station_id",
                     "end_station_name", "end_station_id")

data_processed <- data_raw %>%
  select(-all_of(irrelevant_vars))

## Remove missing values -------------------------------------------------------
missing_vars <- c("end_lat", "end_lng")

data_processed <- data_processed %>%
  filter(!is.na(end_lat),
         !is.na(end_lng))

obs_nonmissing <- data_processed %>%
  nrow_lazy_dt()

## Remove invalid categorical values -------------------------------------------

