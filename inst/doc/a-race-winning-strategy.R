## -----------------------------------------------------------------------------
# Guard against offline builds (CRAN)
knitr::opts_chunk$set(eval = curl::has_internet())

## -----------------------------------------------------------------------------
suppressPackageStartupMessages({
  library(conflicted)
  library(ggtext)
  library(glue)
  library(nascaR.data)
  library(tidyverse)
})

conflicted::conflict_prefer("filter", "dplyr")
# suppress "`summarise()` has grouped output by " messages
options(dplyr.summarise.inform = FALSE)

# Load Cup Series data for use throughout the vignette
cup_series <- load_series("cup")

## -----------------------------------------------------------------------------
library(nascaR.data)

# Load data from cloud storage
cup_series <- load_series("cup")

## -----------------------------------------------------------------------------
# cup_series |>
#   group_by(Driver) |>
#   summarize(career_wins = sum(Win, na.rm = TRUE)) |>
#   arrange(desc(career_wins)) |>
#   slice_head(n = 5) |>
#   ggplot(aes(Driver, career_wins)) +
#   geom_bar(stat = "identity") +
#   coord_flip()

## -----------------------------------------------------------------------------
driver_colors <- c(
  "Richard Petty" = "#04aeec",
  "David Pearson" = "#630727",
  "Jeff Gordon" = "#fc3812",
  "Bobby Allison" = "#e4be8f",
  "Darrell Waltrip" = "#24987a"
)

cup_series |>
  group_by(Driver) |>
  summarize(career_wins = sum(Win, na.rm = TRUE)) |>
  arrange(desc(career_wins)) |>
  slice_head(n = 5) |>
  ggplot(aes(fct_reorder(Driver, career_wins), career_wins, fill = Driver)) +
  geom_bar(stat = "identity", color = "black", alpha = 0.8) +
  geom_text(
    aes(label = career_wins),
    vjust = 0.65, color = "black",
    size = 3.5, hjust = 1.4
  ) +
  coord_flip() +
  theme_minimal() +
  scale_fill_manual(values = driver_colors) +
  labs(
    title = "NASCAR Cup Series Top 5 winning drivers",
    subtitle = "Career wins",
    caption = "Source: nascaR.data package",
    x = NULL,
    y = "Career Wins"
  ) +
  theme(
    legend.position = "none",
    plot.title = element_text(
      color = "black", face = "bold", size = rel(1.5)
    ),
    plot.subtitle = element_text(
      color = "black", size = rel(1.1)
    ),
    axis.text = element_text(color = "black"),
    axis.text.x = element_blank()
  )

## -----------------------------------------------------------------------------
# cup_series |>
#   group_by(Driver) |>
#   summarize(
#     career_wins = sum(Win, na.rm = TRUE),
#     total_races = n(),
#     win_pct = career_wins / total_races
#   ) |>
#   arrange(desc(career_wins)) |>
#   slice_head(n = 5) |>
#   ggplot(aes(Driver, win_pct)) +
#   geom_bar(stat = "identity") +
#   coord_flip()

## -----------------------------------------------------------------------------
cup_series |>
  group_by(Driver) |>
  summarize(
    career_wins = sum(Win, na.rm = TRUE),
    total_races = n(),
    win_pct = career_wins / total_races
  ) |>
  arrange(desc(career_wins)) |>
  slice_head(n = 5) |>
  ggplot(aes(fct_reorder(Driver, win_pct), win_pct, fill = Driver)) +
  geom_bar(stat = "identity", color = "black", alpha = 0.8) +
  geom_text(
    aes(label = scales::percent(win_pct, accuracy = 0.1)),
    vjust = 0.65, color = "black",
    size = 3.5, hjust = 1.1
  ) +
  coord_flip() +
  theme_minimal() +
  scale_fill_manual(values = driver_colors) +
  labs(
    title = "NASCAR Cup Series Top 5 winning drivers",
    subtitle = "Career win percentage",
    caption = "Source: nascaR.data package",
    x = NULL,
    y = "Career Win Percentage"
  ) +
  theme(
    legend.position = "none",
    plot.title = element_text(
      color = "black", face = "bold", size = rel(1.5)
    ),
    plot.subtitle = element_text(
      color = "black", size = rel(1.1)
    ),
    axis.text = element_text(color = "black"),
    axis.text.x = element_blank()
  )

## -----------------------------------------------------------------------------
# Get all wins for a specific driver
bell_wins <- cup_series |>
  filter(Driver == "Christopher Bell", Win == 1) |>
  arrange(desc(Season))

# How many Cup Series wins?
nrow(bell_wins)

## -----------------------------------------------------------------------------
bell_total <- nrow(bell_wins)

## -----------------------------------------------------------------------------
# Average finish by track surface
cup_series |>
  filter(Driver == "Christopher Bell", Season >= 2020) |>
  group_by(Surface) |>
  summarize(
    races = n(),
    avg_finish = round(mean(Finish, na.rm = TRUE), 1),
    wins = sum(Win, na.rm = TRUE),
    laps_led = sum(Led, na.rm = TRUE)
  ) |>
  arrange(avg_finish)

## -----------------------------------------------------------------------------
# # Visualize season-by-season performance
# cup_series |>
#   filter(Driver == "Christopher Bell", Season >= 2020) |>
#   group_by(Season) |>
#   summarize(
#     avg_finish = mean(Finish, na.rm = TRUE),
#     wins = sum(Win, na.rm = TRUE)
#   ) |>
#   ggplot(aes(Season, avg_finish)) +
#   geom_line(color = "#fb9f00", linewidth = 1.2) +
#   geom_point(aes(size = wins), color = "#fb9f00") +
#   scale_y_reverse() +
#   theme_minimal()

## -----------------------------------------------------------------------------
cup_series |>
  filter(Driver == "Christopher Bell", Season >= 2020) |>
  group_by(Season) |>
  summarize(
    avg_finish = mean(Finish, na.rm = TRUE),
    wins = sum(Win, na.rm = TRUE)
  ) |>
  ggplot(aes(Season, avg_finish)) +
  geom_line(color = "#fb9f00", linewidth = 1.2) +
  geom_point(aes(size = wins), color = "#fb9f00", alpha = 0.7) +
  scale_y_reverse(limits = c(20, 5)) +
  scale_size_continuous(range = c(3, 8)) +
  theme_minimal() +
  labs(
    title = "Christopher Bell Cup Series Performance",
    subtitle = "Average finish position by season (2020-present)",
    caption = "Source: nascaR.data package\nPoint size = wins",
    x = NULL,
    y = "Average Finish Position"
  ) +
  theme(
    legend.position = "none",
    plot.title = element_text(color = "black", face = "bold", size = rel(1.3)),
    plot.subtitle = element_text(color = "black", size = rel(1.0)),
    axis.text = element_text(color = "black"),
    panel.grid.minor = element_blank()
  )

## -----------------------------------------------------------------------------
# cup_series |>
#   filter(Season >= 2010) |>
#   group_by(Season, Make) |>
#   summarize(avg_finish = mean(Finish, na.rm = TRUE)) |>
#   ggplot(aes(Season, avg_finish, group = Make, color = Make)) +
#   geom_line() +
#   geom_point() +
#   scale_y_reverse()

## -----------------------------------------------------------------------------
mfg_colors <- c(
  "Chevrolet" = "#c5b358",
  "Dodge" = "darkcyan",
  "Ford" = "#003478",
  "Toyota" = "#eb0a1e"
)

cup_series |>
  filter(Season >= 2010) |>
  group_by(Season, Make) |>
  summarize(avg_finish = mean(Finish, na.rm = TRUE), .groups = "drop") |>
  ggplot(aes(Season, avg_finish, group = Make, color = Make)) +
  geom_line(alpha = 0.8, linewidth = 1) +
  geom_point(size = 2) +
  scale_y_reverse() +
  theme_minimal() +
  scale_color_manual(values = mfg_colors) +
  labs(
    title = "NASCAR Cup Series Manufacturer Performance",
    subtitle = "Average finish position by season (2010-present)",
    caption = "Source: nascaR.data package",
    x = NULL, y = "Average Finish Position"
  ) +
  theme(
    legend.position = "top",
    legend.title = element_blank(),
    plot.title = element_text(
      color = "black", face = "bold", size = rel(1.35)
    ),
    plot.subtitle = element_text(
      color = "black", size = rel(1.0)
    ),
    axis.text = element_text(color = "black"),
    panel.grid.minor = element_blank()
  )

## -----------------------------------------------------------------------------
cup_series |>
  filter(Team == "Joe Gibbs Racing", Season >= 2000) |>
  group_by(Season, Make) |>
  summarize(
    races = n(),
    wins = sum(Win, na.rm = TRUE),
    avg_finish = round(mean(Finish, na.rm = TRUE), 1),
    .groups = "drop"
  ) |>
  select(Season, Make, races, wins, avg_finish)

## -----------------------------------------------------------------------------
# # Get comprehensive driver statistics (handles fuzzy matching)
# get_driver_info("bell", series = "cup", type = "summary")

## -----------------------------------------------------------------------------
# # Season-by-season performance
# get_driver_info("Christopher Bell", series = "cup", type = "season")

## -----------------------------------------------------------------------------
# # Get team statistics (fuzzy matching built in)
# get_team_info("gibbs", series = "cup", type = "summary")
# 
# # Get manufacturer performance across all series
# get_manufacturer_info("Toyota", series = "all", type = "season")

## -----------------------------------------------------------------------------
# Compare drivers at Martinsville (short track)
drivers_to_compare <- c("Christopher Bell", "Kyle Larson", "William Byron")

martinsville_comparison <- cup_series |>
  filter(
    Driver %in% drivers_to_compare,
    Track == "Martinsville Speedway",
    Season >= 2020
  ) |>
  group_by(Driver) |>
  summarize(
    races = n(),
    wins = sum(Win, na.rm = TRUE),
    avg_finish = round(mean(Finish, na.rm = TRUE), 1),
    avg_start = round(mean(Start, na.rm = TRUE), 1),
    laps_led = sum(Led, na.rm = TRUE)
  ) |>
  arrange(avg_finish)

martinsville_comparison

