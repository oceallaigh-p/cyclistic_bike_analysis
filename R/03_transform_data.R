# Required libraries
library(tidyverse)
library(geosphere)

# Required scripts
source(here("R", "count_anomalies.R"))
source(here("R", "remove_anomalies.R"))
source(here("R", "calculate_summary_stats.R"))

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

data_processed <- data_processed %>%
  filter(!rideable_type %in% "docked_bike")

## Convert data types ----------------------------------------------------------
data_processed <- data_processed %>%
  mutate(
    rideable_type = as.factor(rideable_type),
    member_casual = as.factor(member_casual)
  )

## Rename variables ------------------------------------------------------------
data_processed <- data_processed %>%
  rename(
    bike_type = rideable_type,
    rider_type = member_casual,
    start_timestamp = started_at,
    end_timestamp = ended_at,
    start_latitude = start_lat,
    start_longitude = start_lng,
    end_latitude = end_lat,
    end_longitude = end_lng
  )

## Create new variables --------------------------------------------------------
data_processed <- data_processed %>%
  mutate(
    ride_duration = as.numeric(difftime(end_timestamp, start_timestamp, units = "mins")),
    ride_month = factor(floor_date(start_timestamp, "month")),
    ride_week = factor(floor_date(start_timestamp, "week")),
    ride_day_of_week = factor(wday(start_timestamp, label = TRUE)),
    ride_start_hour = factor(hour(start_timestamp))
  ) %>%
  mutate(
    ride_distance = distHaversine(
      cbind(start_longitude, start_latitude),
      cbind(end_longitude, end_latitude)
    )
  )

## Remove outliers -------------------------------------------------------------

### Check for anomalous ride duration
min_duration <- 1
max_duration <- 180

anomalous_duration <- data_processed %>%
  count_anomalies(ride_duration, min_duration, max_duration)

### Remove rides with anomalous duration
data_processed <- data_processed %>%
  remove_anomalies(ride_duration, min_duration, max_duration)

### Check for anomalous ride distance

ride_distance_stats <- data_processed %>%
  summarise(
    min_distance = min(ride_distance),
    max_distance = max(ride_distance)
  )
