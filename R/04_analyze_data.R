# Required libraries
library(tidyverse)
library(here)
library(cowplot)

# Required scripts
source(here("R", "find_mode.R"))
source(here("R", "save_plots.R"))

# Collect the lazy data table to a tibble ---------------------------------------
data_processed <- data_processed %>%
  collect()

# Examine monthly ridership data ------------------------------------------------

## Plot monthly ridership by rider type
p <- data_processed %>%
  group_by(
    ride_month,
    rider_type
  ) %>%
  summarise(
    count = n(),
    .groups = "drop"
  ) %>%
  ggplot(aes(
    x = ride_month,
    y = count,
    fill = rider_type
  )) +
  geom_col(position = "dodge") +
  theme_minimal_grid() +
  labs(
    title = "Monthly Ridership by Rider Type",
    x = "Month",
    y = "Ride Count",
    fill = "Rider Type"
  )

# Save the plot
file_name <- "monthly_ridership"
save_plots(
  filename = file_name,
  plot = p
)


# Examine daily ridership data -------------------------------------------------

## Find the day of the week with the most rides
day_mode <- data_processed %>%
  find_mode(ride_day_of_week)


## Plot average daily ridership by rider type
## Note: The 'ride_week' column includes data for incomplete weeks at the beginning
##       and end of the period covered. To accurately reflect the average number of
##       rides per day of the week across all weeks, including these incomplete ones,
##       we first group by 'ride_week', 'ride_day_of_week', and 'rider_type' to count
##       the total rides for each specific combination per week. This approach ensures
##       that each week, whether complete or not, contributes proportionally to the
##       final averages. We then regroup by 'ride_day_of_week' and 'rider_type' and
##       calculate the mean of these total rides. This second grouping and calculation
##       provide an accurate average by normalizing the weekly ride counts across
##       the dataset, ensuring that partial weeks do not skew the overall average.
p <- data_processed %>%
  group_by(
    ride_week,
    ride_day_of_week,
    rider_type
  ) %>%
  summarise(
    total_rides = n(), # Total rides per day of week by rider type
    .groups = "drop"
  ) %>%
  group_by(
    ride_day_of_week,
    rider_type
  ) %>%
  summarise(
    mean_rides = mean(total_rides), # Avg number of rides per day of week by rider type
    .groups = "drop"
  ) %>%
  ggplot(
    aes(
      x = ride_day_of_week,
      y = mean_rides,
      fill = rider_type
    )
  ) +
  geom_col(
    position = "dodge"
  ) +
  geom_text(
    aes(label = round(mean_rides, 0)),
    vjust = 1.6,
    position = position_dodge(0.9),
    size = 2.3
  ) +
  theme_minimal_grid() +
  labs(
    x = "Day of week",
    y = "Average daily rides",
    title = "Average number of rides by day of week and rider type"
  )

# Save the plot
file_name <- "day_ridership"
save_plots(
  filename = file_name,
  plot = p
)

# Examine hourly ridership data -------------------------------------------------

## Plot average hourly ridership by rider type
p <- data_processed %>%
  group_by(
    ride_week,
    ride_day_of_week,
    ride_start_hour,
    rider_type
  ) %>%
  summarise(
    total_rides = n(),
    .groups = "drop"
  ) %>%
  group_by(
    ride_start_hour,
    rider_type
  ) %>%
  summarise(
    mean_per_hour = mean(total_rides),
    .groups = "drop"
  ) %>%
  ggplot(aes(
    x = ride_start_hour,
    y = mean_per_hour,
    fill = rider_type
  )) +
  geom_col(position = "dodge") +
  theme_minimal_grid() +
  labs(
    title = "Average Hourly Ridership by Rider Type",
    x = "Hour",
    y = "Ride Count",
    fill = "Rider Type"
  )

## Save the plot
file_name <- "hourly_ridership"
save_plots(
  filename = file_name,
  plot = p
)

----------------------------------------------------------------------------------------------------------------

  ## Plot average hourly ridership by rider type and day of week
  processed_df <- data_processed %>%
  group_by(
    ride_week,
    ride_day_of_week,
    ride_start_hour,
    rider_type
  ) %>%
  summarise(
    total_rides = n(),
    .groups = "drop"
  ) %>%
  group_by(
    ride_day_of_week,
    ride_start_hour,
    rider_type
  ) %>%
  summarise(
    mean_per_hour = mean(total_rides),
    .groups = "drop"
  )

## Get unique days of the week from the data
days_of_week <- unique(processed_df$ride_day_of_week)

## Create a list to store plots
plots_list <- list()

## Loop over each day and create a plot
for (day in days_of_week) {
  day_data <- filter(
    processed_df,
    ride_day_of_week == day
  )

  p <- day_data %>% ggplot(aes(
    x = ride_start_hour,
    y = mean_per_hour,
    fill = rider_type
  )) +
    geom_col(position = "dodge") +
    theme_minimal_grid() +
    labs(
      title = paste("Average hourly ridership by rider type: ", day),
      x = "Hour of Day",
      y = "Average Ride Count",
      fill = "Rider Type"
    )
  plots_list[[day]] <- p
}

## Save the plot
file_name <- "hourly_ridership_"

for (day in days_of_week) {
  save_plots(
    filename = paste0(file_name, day),
    plot = plots_list[[day]]
  )
}


# Examine bike type data -------------------------------------------------------

p <- data_processed %>%
  group_by(
    bike_type,
    rider_type
  ) %>%
  summarise(
    count = n(),
    .groups = "drop"
  ) %>%
  ggplot(aes(
    x = rider_type,
    y = count,
    fill = bike_type
  )) +
  geom_col(position = "dodge") +
  theme_minimal_grid() +
  labs(
    title = "Bike Type Distribution",
    x = "Rider Type",
    y = "Count",
    fill = "Bike Type"
  )

## Save the plot
file_name <- "bike_type_distribution"
save_plots(
  filename = file_name,
  plot = p
)

# Examine ride distance data ---------------------------------------------------

p <- data_processed %>%
  group_by(
    rider_type
  ) %>%
  summarise(
    mean_distance = mean(ride_distance),
    .groups = "drop"
  ) %>%
  ggplot(aes(
    x = rider_type,
    y = mean_distance,
    fill = rider_type
  )) +
  geom_col() +
  theme_minimal_grid() +
  labs(
    title = "Average Ride Distance by Rider Type",
    x = "Rider Type",
    y = "Average Distance (meters)",
    fill = "Rider Type"
  )


## Save the plot
file_name <- "mean_ride_distance"
save_plots(
  filename = file_name,
  plot = p
)

## Examine ride distance by rider type on weekends

p <- data_processed %>%
  group_by(
    ride_day_of_week,
    rider_type
  ) %>%
  summarise(
    mean_distance = mean(ride_distance),
    .groups = "drop"
  ) %>%
  filter(
    ride_day_of_week %in% c("Sat", "Sun")
  ) %>%
  ggplot(aes(
    x = rider_type,
    y = mean_distance,
    fill = rider_type
  )) +
  geom_col(position = "dodge") +
  theme_minimal_grid() +
  labs(
    title = "Average Ride Distance by Rider Type on Weekends",
    x = "Day of Week",
    y = "Average Distance (meters)",
    fill = "Rider Type"
  )

## Save the plot
file_name <- "mean_ride_distance_weekends"
save_plots(
  filename = file_name,
  plot = p
)


## Examine ride distance by rider type on weekdays

p <- data_processed %>%
  group_by(
    ride_day_of_week,
    rider_type
  ) %>%
  summarise(
    mean_distance = mean(ride_distance),
    .groups = "drop"
  ) %>%
  filter(
    !(ride_day_of_week %in% c("Sat", "Sun"))
  ) %>%
  ggplot(aes(
    x = rider_type,
    y = mean_distance,
    fill = rider_type
  )) +
  geom_col(position = "dodge") +
  theme_minimal_grid() +
  labs(
    title = "Average Ride Distance by Rider Type on Weekdays",
    x = "Day of Week",
    y = "Average Distance (meters)",
    fill = "Rider Type"
  )

## Save the plot
file_name <- "mean_ride_distance_weekdays"
save_plots(
  filename = file_name,
  plot = p
)

# Examine ride duration data ---------------------------------------------------

rider_stats <- data_processed%>%
  group_by(
    rider_type
  ) %>%
  summarise(
    avg_ride_duration = mean(ride_duration),
    avg_ride_distance = mean(ride_distance),
    .groups = "drop"
  )

## Plot average ride duration by rider type
p <- data_processed %>%
  group_by(
    rider_type
  ) %>%
  summarise(
    mean_duration = mean(ride_duration),
    .groups = "drop"
  ) %>%
  ggplot(aes(
    x = rider_type,
    y = mean_duration,
    fill = rider_type
  )) +
  geom_col() +
  theme_minimal_grid() +
  labs(
    title = "Average Ride Duration by Rider Type",
    x = "Rider Type",
    y = "Average Duration (seconds)",
    fill = "Rider Type"
  )
