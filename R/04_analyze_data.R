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
  summarise(count = n()) %>%
  ungroup() %>%
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


p <- data_processed %>%
  group_by(ride_day_of_week,
           rider_type) %>%
  summarise(avg_rides = n()) %>%
  mutate(avg_rides = avg_rides / n_distinct(data_processed$ride_week)) %>%
  ggplot(aes(x = ride_day_of_week, y = avg_rides, fill = rider_type)) +
  geom_col(position = "dodge") +
  labs(title = "Average Number of Rides Per Day of the Week by Rider Type",
       x = "Day of the Week",
       y = "Average Number of Rides",
       fill = "Rider Type") +
  theme_minimal_grid()

# Save the plot
file_name <- "day_ridership_bar.png"
save_plots(file_name, p)

# Examine hourly ridership data -------------------------------------------------

# Examine bike type data --------------------------------------------------------
