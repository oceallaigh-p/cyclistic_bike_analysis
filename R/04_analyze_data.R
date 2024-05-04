# Required libraries
library(tidyverse)
library(cowplot) 

# Collect the lazy data table to a tibble ---------------------------------------
data_processed <- data_processed %>%
  collect()

# Examine monthly ridership data ------------------------------------------------
data_processed %>%
  group_by(ride_month,
           rider_type) %>%
  summarise(count = n()) %>%
  ungroup() %>%
  ggplot(aes(x = ride_month, 
             y = count, 
             fill = rider_type)) +
  geom_col(position = "dodge") +
  theme_minimal_grid() +
  labs(title = "Monthly Ridership by Rider Type",
       x = "Month",
       y = "Ride Count",
       fill = "Rider Type")
  

# Examine weekly ridership data -------------------------------------------------

# Examine daily ridership data --------------------------------------------------

# Examine hourly ridership data -------------------------------------------------

# Examine bike type data --------------------------------------------------------