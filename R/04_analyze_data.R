# Required libraries
library(tidyverse)
library(here)
library(scales)
library(cowplot)

# Required scripts
source(here("R", "find_mode.R"))
source(here("R", "save_plots.R"))

# ==============================================================================
# Collect the lazy data table to a tibble
# ==============================================================================
data_processed <- collect(data_processed)

# ==============================================================================
# Export the processed data to a CSV file
# ==============================================================================
write_csv(data_processed, here("data", "processed_data", "processed_data.csv"))

# ==============================================================================
# Examine monthly ridership data
# ==============================================================================

# Plot monthly ridership by rider type -----------------------------------------
p <- data_processed %>%
  count(ride_month, rider_type) %>%
  group_by(ride_month) %>%
  mutate(proportion = n / sum(n)) %>%
  ungroup() %>%
  ggplot(aes(x = ride_month, y = proportion, fill = rider_type)) +
  geom_col() +
  geom_text(
    aes(label = percent(proportion, accuracy = 1)),
    position = position_stack(vjust = 0.5),
    color = "white",
    size = 3.5
  ) +
  scale_x_date(
    name = "",
    date_labels = "%b %y",
    date_breaks = "1 month",
    expand = expansion(mult = c(0.02, 0.02))
  ) +
  scale_y_continuous(
    name = "",
    labels = percent_format(),
    expand = expansion(mult = c(0, 0.04))
  ) +
  scale_fill_viridis_d(
    name = "Rider type",
    begin = 0.2,
    end = 0.8,
    option = "mako"
  ) +
  labs(
    title = "Monthly ridership by rider type",
    subtitle = "April 2023 - March 2024"
  ) +
  theme_minimal_grid() +
  theme(
    axis.title = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 10, vjust = 1),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

# Save the plot
file_name <- "monthly_ridership"
save_plots(filename = file_name, plot = p)

# ==============================================================================
# Examine daily ridership data
# ==============================================================================

# Find the day of the week with the most rides ---------------------------------
day_mode_member <- data_processed %>%
  filter(rider_type == "member") %>%
  find_mode(ride_day_of_week)
day_mode_casual <- data_processed %>%
  filter(rider_type == "casual") %>%
  find_mode(ride_day_of_week)


# Plot average daily ridership by rider type -----------------------------------
# Note: The 'ride_week' column includes data for incomplete weeks at the
#       beginning and end of the period covered. To accurately reflect the
#       average number of rides per day of the week across all weeks, including
#       these incomplete ones, we first group by 'ride_week', 'ride_day_of_week',
#       and 'rider_type' to count the total rides for each specific combination
#       per week. This approach ensures that each week, whether complete or not,
#       contributes proportionally to the final averages. We then regroup by
#       'ride_day_of_week' and 'rider_type' and calculate the mean of these
#       total rides. This second grouping and calculation provide an accurate
#       average by normalizing the weekly ride counts across the dataset,
#       ensuring that partial weeks do not skew the overall average.

p <- data_processed %>%
  group_by(ride_week, ride_day_of_week, rider_type) %>%
  summarise(total_rides = n(), .groups = "drop") %>%
  group_by(ride_day_of_week, rider_type) %>%
  summarise(mean_rides = mean(total_rides), .groups = "drop") %>%
  ggplot(aes(x = ride_day_of_week, y = mean_rides, fill = rider_type)) +
  geom_col(position = "dodge") +
  geom_text(
    aes(label = round(mean_rides, 0)),
    color = "white",
    vjust = 1.6,
    position = position_dodge(0.9),
    size = 3.5
  ) +
  scale_x_discrete(
    name = "",
    expand = expansion(mult = c(0.02, 0.04))
  ) +
  scale_y_continuous(
    name = "Average daily rides",
    expand = expansion(mult = c(0, 0.04))
  ) +
  scale_fill_viridis_d(
    name = "Rider type",
    labels = c("Casual", "Member"),
    begin = 0.2,
    end = 0.8,
    option = "mako"
  ) +
  labs(
    title = "Daily ride averages by rider type",
    subtitle = "April 2023 - March 2024"
  ) +
  theme_minimal_grid() +
  theme(
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 10, vjust = 1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  )


# Save the plot
file_name <- "daily_ridership"
save_plots(filename = file_name, plot = p)

# ==============================================================================
# Examine hourly ridership data
# ==============================================================================

# Create a heatmap of average hourly ridership by rider type and weekday vs weekend

p <- data_processed %>%
  group_by(
    ride_week,
    ride_day_of_week,
    ride_start_hour,
    rider_type,
    day_type
  ) %>%
  summarise(total_rides = n(), .groups = "drop") %>%
  group_by(ride_start_hour, rider_type, day_type) %>%
  summarise(mean_per_hour = mean(total_rides), .groups = "drop") %>%
  ggplot(aes(x = ride_start_hour, y = rider_type, fill = mean_per_hour)) +
  geom_tile(color = "white") +
  scale_x_discrete(
    name = "Hour",
    expand = expansion(mult = c(0.01, 0.04))
  ) +
  scale_y_discrete(
    name = "Rider type"
  ) +
  scale_fill_viridis_c(
    name = "Average hourly rides",
    option = "mako",
    breaks = c(300, 600, 900)
  ) +
  facet_wrap(~day_type, ncol = 1) +
  labs(
    title = "Average hourly ridership by rider type",
    subtitle = "Weekday vs. weekend (April 2023 - March 2024)"
  ) +
  theme_minimal_grid() +
  theme(
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 10, vjust = 1),
    panel.grid = element_blank()
  )

# Save the plot
file_name <- "hourly_ridership_heatmap"
save_plots(filename = file_name, plot = p)


# ==============================================================================
# Examine bike type data
# ==============================================================================
# Plot bike preferences by rider type ------------------------------------------
p <- data_processed %>%
  group_by(bike_type, rider_type) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(rider_type) %>%
  mutate(proportion = count / sum(count)) %>%
  ungroup() %>%
  ggplot(aes(x = bike_type, y = proportion, fill = rider_type)) +
  geom_col(position = "dodge") +
  geom_text(
    aes(label = percent(proportion, accuracy = 1)),
    color = "white",
    vjust = 1.6,
    position = position_dodge(0.9),
    size = 3.5
  ) +
  scale_x_discrete(
    name = "Bicycle type",
    labels = c("Classic", "Electric")
  ) +
  scale_y_continuous(
    name = "Percentage of riders",
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.07))
  ) +
  scale_fill_viridis_d(
    name = "Rider type",
    labels = c("Casual", "Member"),
    begin = 0.2,
    end = 0.8,
    option = "mako"
  ) +
  labs(
    title = "Bicycle preference by rider type",
    subtitle = "April 2023 - March 2024"
  ) +
  theme_minimal_grid() +
  theme(
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 10, vjust = 1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  )

# Save the plot
file_name <- "bike_preference"
save_plots(filename = file_name, plot = p)

# ==============================================================================
# Examine ride distance and duration data
# ==============================================================================
# Calculate average ride duration and distance by rider type -------------------
rider_stats <- data_processed %>%
  group_by(day_type, rider_type) %>%
  summarise(
    avg_ride_duration = mean(ride_duration),
    avg_ride_distance = mean(ride_distance),
    .groups = "drop"
  )

# Plot average ride distance and duration by rider type ------------------------

# Define custom labels for the facets
custom_labels <- c(avg_ride_duration = "Average Duration (minutes)",
                   avg_ride_distance = "Average Distance (meters)")

p <- rider_stats %>%
  pivot_longer(
    cols = c(avg_ride_duration, avg_ride_distance),
    names_to = "metric",
    values_to = "value"
  ) %>%
  mutate(
    label = case_when(
      metric == "avg_ride_duration" ~ paste0(round(value, 1), " min"),
      metric == "avg_ride_distance" ~ paste0(round(value, 0), " m")
    )
  ) %>%
ggplot(aes(x = day_type, y = value, fill = rider_type)) +
  geom_col(position = position_dodge(width = 0.8)) +
  facet_wrap(~metric, scales = "free_y", labeller = labeller(metric = custom_labels)) +
  geom_text(
    aes(label = label),
    color = "white",
    position = position_dodge(0.9),
    vjust = 1.6,
    size = 3.5
  ) +
  scale_x_discrete(name = "") +
  scale_y_continuous(
    name = "Value",
    labels = scales::comma
  ) +
  scale_fill_viridis_d(
    name = "Rider Type",
    begin = 0.2,
    end = 0.8,
    option = "mako"
  ) +
  labs(
    title = "Average Ride Duration and Distance by Rider Type",
    subtitle = "Comparison across Weekday and Weekend"
  ) +
  theme_minimal_grid() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 12, vjust = 1),
    axis.text.x = element_text(angle = 0, hjust = 0.5)
  )

# Save the plot
file_name <- "mean_distance_duration"
save_plots(filename = file_name, plot = p)

# Plot the density of ride durations by rider type -----------------------------
custom_breaks <- c(seq(0, 20, by = 2), seq(20, 60, by = 5))

p <- data_processed %>%
  ggplot(aes(x = ride_duration, y = after_stat(scaled), fill = rider_type)) +
  geom_density(alpha = 0.95, position = "stack") +
  coord_cartesian(xlim = c(0, 60)) +
  scale_x_continuous(
    name = "Ride duration (minutes)",
    expand = expansion(mult = c(0.02, 0.02)),
    breaks = c(seq(0, 20, by = 2), seq(20, 60, by = 5))
  ) +
  scale_fill_viridis_d(
    name = "Rider type",
    labels = c("Casual", "Member"),
    begin = 0.2,
    end = 0.8,
    option = "mako"
  ) +
  labs(
    title = "Density of ride durations by rider type",
    subtitle = "April 2023 - March 2024"
  ) +
  theme_minimal_grid() +
  theme(
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 10, vjust = 1),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

# Save the plot
file_name <- "ride_duration_density"
save_plots(filename = file_name, plot = p)