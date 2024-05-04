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




# Examine weekly ridership data -------------------------------------------------



# Examine daily ridership data --------------------------------------------------

## Find the day of the week with the most rides
day_mode <- data_processed %>%
  find_mode(ride_day_of_week)




# Examine hourly ridership data -------------------------------------------------

# Examine bike type data --------------------------------------------------------
