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
file_name <- "monthly_ridership_bar.png"
save_plots(file_name, p)


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
file_name <- "day_ridership_bar.png"
save_plots(file_name, p)

# Examine hourly ridership data -------------------------------------------------

# Examine bike type data --------------------------------------------------------
