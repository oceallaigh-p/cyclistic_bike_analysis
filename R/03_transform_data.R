# Required libraries
library(tidyverse)
library(geosphere)

# Required scripts
source(here("R", "count_anomalies.R"))
source(here("R", "remove_anomalies.R"))
source(here("R", "calculate_sum_stats.R"))

# ==============================================================================
# Remove irrelevant variables
# ==============================================================================
irrelevant_vars <- c(
  "start_station_name",
  "start_station_id",
  "end_station_name",
  "end_station_id"
)

data_processed <- data_raw %>%
  select(-all_of(irrelevant_vars))

# ==============================================================================
# Remove missing values
# ==============================================================================
missing_vars <- c("end_lat", "end_lng")

data_processed <- data_processed %>%
  filter(
    !is.na(end_lat),
    !is.na(end_lng)
  )

obs_nonmissing <- data_processed %>%
  nrow_lazy_dt()

# ==============================================================================
# Remove invalid categorical values
# ==============================================================================

data_processed <- data_processed %>%
  filter(!rideable_type %in% "docked_bike")

# ==============================================================================
# Convert data types
# ==============================================================================
data_processed <- data_processed %>%
  mutate(
    rideable_type = as.factor(rideable_type),
    member_casual = as.factor(member_casual)
  )

# ==============================================================================
# Rename variables
# ==============================================================================
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

# ==============================================================================
# Create new variables
# ==============================================================================
data_processed <- data_processed %>%
  mutate(
    ride_duration = as.numeric(difftime(
      end_timestamp,
      start_timestamp,
      units = "mins"
    )),
    ride_month = factor(floor_date(start_timestamp, "month")),
    ride_week = factor(floor_date(start_timestamp, "week")),
    ride_day_of_week = factor(wday(start_timestamp, label = TRUE)),
    ride_start_hour = factor(hour(start_timestamp)),
    weekday_weekend = factor(ifelse(
      ride_day_of_week %in% c("Sat", "Sun"),
      "Weekend",
      "Weekday"
    )),
    ride_distance = distHaversine(
      cbind(start_longitude, start_latitude),
      cbind(end_longitude, end_latitude)
    )
  )

# ==============================================================================
# Remove outliers
# ==============================================================================
# Check for anomalous ride duration ------------------------------------------
min_duration <- 1
max_duration <- 180

# Count anomalous durations
anomalous_duration <- data_processed %>%
  count_anomalies(ride_duration, min_duration, max_duration)

# Remove rides with anomalous duration
data_processed <- data_processed %>%
  remove_anomalies(ride_duration, min_duration, max_duration)

# Check for anomalous ride distance ------------------------------------------

ride_distance_stats <- data_processed %>%
  calculate_summary_stats(ride_distance)

# Calulate IQR
iqr_distance <- ride_distance_stats$q75 - ride_distance_stats$q25

# Calculate maximum threshold
max_distance <- ride_distance_stats$q75 + 3 * iqr_distance

# Calculate 99th percentile for the minimum threshold
min_distance <- data_processed %>%
  filter(ride_distance > 0) %>%
  summarise(min_dist = quantile(ride_distance, 0.01)) %>%
  pull()

# Count anomalous distances
anomalous_distance <- data_processed %>%
  count_anomalies(ride_distance, min_distance, max_distance)

# Remove rides with anomalous distance
data_processed <- data_processed %>%
  remove_anomalies(ride_distance, min_distance, max_distance)

obs_nonanomalous <- data_processed %>%
  nrow_lazy_dt()

# ==============================================================================
# Calculate summary statistics
# ==============================================================================
ride_distance_stats_clean <- data_processed %>%
  calculate_summary_stats(ride_distance)

# ==============================================================================
# Calculate percentage of removed observations
# ==============================================================================
percent_removed <- ((obs_raw - obs_nonanomalous) / obs_raw) * 100
