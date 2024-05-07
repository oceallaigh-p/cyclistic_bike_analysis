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
    weekday_weekend
  ) %>%
  summarise(total_rides = n(), .groups = "drop") %>%
  group_by(ride_start_hour, rider_type, weekday_weekend) %>%
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
  facet_wrap(~weekday_weekend, ncol = 1) +
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
# Examine ride distance data
# ==============================================================================

# Examine ride distance by rider type on weekends versus weekdays --------------
p <- data_processed %>%
  group_by(rider_type, weekday_weekend) %>%
  summarise(mean_distance = mean(ride_distance), .groups = "drop") %>%
  ggplot(aes(x = weekday_weekend, y = mean_distance, fill = rider_type)) +
  geom_col(position = "dodge") +
  geom_text(
    aes(label = paste0(round(mean_distance, 0), " m")),
    color = "white",
    vjust = 1.6,
    position = position_dodge(0.9),
    size = 3.5
  ) +
  scale_x_discrete(
    name = "",
    labels = c("Weekday", "Weekend")
  ) +
  scale_y_continuous(
    name = "Average distance (meters)",
    expand = expansion(mult = c(0, 0.05))
  ) +
  scale_fill_viridis_d(
    name = "Rider type",
    labels = c("Casual", "Member"),
    begin = 0.2,
    end = 0.8,
    option = "mako"
  ) +
  labs(
    title = "Average ride distance by rider rype",
    subtitle = "Weekday vs. weekend (April 2023 - March 2024)",
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

## Save the plot
file_name <- "ride_distance_mean"
save_plots(filename = file_name, plot = p)

# ==============================================================================
# Examine ride duration data
# ==============================================================================
# Calculate average ride duration and distance by rider type -------------------
rider_stats <- data_processed %>%
  group_by(weekday_weekend, rider_type) %>%
  summarise(
    avg_ride_duration = mean(ride_duration),
    avg_ride_distance = mean(ride_distance),
    .groups = "drop"
  )

# Plot average ride duration by rider type weekends versus weekdays ------------
p <- data_processed %>%
  group_by(rider_type, weekday_weekend) %>%
  summarise(mean_duration = mean(ride_duration), .groups = "drop") %>%
  ggplot(aes(x = weekday_weekend, y = mean_duration, fill = rider_type)) +
  geom_col(position = "dodge") +
  geom_text(
    aes(label = paste0(round(mean_duration, 1), " min")),
    color = "white",
    vjust = 1.6,
    position = position_dodge(0.9),
    size = 3
  ) +
  scale_x_discrete(
    name = "",
    labels = c("Weekday", "Weekend")
  ) +
  scale_y_continuous(
    name = "Average duration (minutes)",
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
    title = "Average ride duration by rider type",
    subtitle = "Weekday vs weekend (April 2023 - March 2024)"
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
file_name <- "ride_duration_mean"
save_plots(filename = file_name, plot = p)
