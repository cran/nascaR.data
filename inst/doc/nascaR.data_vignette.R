## -----------------------------------------------------------------------------
#| label: load_packages
#| echo: false
library(conflicted)
library(ggtext)
library(glue)
library(gtsummary)
library(rUM)
library(tidyverse)

conflicted::conflict_prefer('filter', 'dplyr')
# suppress "`summarise()` has grouped output by " messages
options(dplyr.summarise.inform = FALSE)


## -----------------------------------------------------------------------------
#| echo: true
library(nascaR.data)


## -----------------------------------------------------------------------------
#| echo: true
#| eval: false
## cup_driver_career |>
##   arrange(desc(career_wins)) |>
##   slice_head(n = 5) |>
##   ggplot(aes(driver, career_wins)) +
##   geom_bar(stat = 'identity') +
##   coord_flip()


## -----------------------------------------------------------------------------
#| echo: false
#| warning: false

driver_colors = c(
  'Richard Petty' = '#04aeec',
  'David Pearson' = '#630727',
  'Jeff Gordon' = '#fc3812',
  'Bobby Allison' = '#e4be8f',
  'Darrell Waltrip' = '#24987a'
)

cup_driver_career |>
  arrange(desc(career_wins)) |>
  slice_head(n = 5) |>
  ggplot(aes(fct_reorder(driver, career_wins), career_wins, fill = driver)) +
  geom_bar(stat = 'identity', color = 'black', alpha = 0.8) +
  geom_text(
    aes(label = career_wins), vjust = 0.65, color = 'black',
    size = 3.5, hjust = 1.4
  ) +
  coord_flip() +
  theme_minimal() +
  scale_fill_manual(values = driver_colors) +
  labs(
    title = 'NASCAR Cup Series Top 5 winning drivers',
    subtitle = 'Career wins',
    caption = 'Source: NASCAR.com',
    x = NULL,
    y = 'Career Wins'
  ) +
  theme(
    legend.position = 'none',
    plot.title = element_text(
      color = 'black', face = 'bold', size = rel(1.5), 
      # hjust = -0.45
    ),
    plot.subtitle = element_text(
      color = 'black', size = rel(1.1), 
      # hjust = -0.195
    ),
    axis.text = element_text(color = 'black'),
    axis.text.x = element_blank()
  )


## -----------------------------------------------------------------------------
#| echo: true
#| eval: false
## cup_driver_career |>
##   arrange(desc(career_wins)) |>
##   slice_head(n = 5) |>
##   ggplot(aes(driver, career_win_pct)) +
##   geom_bar(stat = 'identity') +
##   coord_flip()


## -----------------------------------------------------------------------------
#| echo: false
cup_driver_career |>
  arrange(desc(career_wins)) |>
  slice_head(n = 5) |>
  mutate(career_win_pct = round(career_win_pct, 3)) |>
  ggplot(aes(fct_reorder(driver, career_win_pct), career_win_pct, fill = driver)) +
  geom_bar(stat = 'identity', color = 'black', alpha = 0.8) +
  geom_text(
    aes(label = scales::percent(career_win_pct)), vjust = 0.65, color = 'black',
    size = 3.5, hjust = 1.1
  ) +
  coord_flip() +
  theme_minimal() +
  scale_fill_manual(values = driver_colors) +
  labs(
    title = 'NASCAR Cup Series Top 5 winning drivers',
    subtitle = 'Career win percentage',
    caption = 'Source: NASCAR.com',
    x = NULL,
    y = 'Career Win Percentage'
  ) +
  theme(
    legend.position = 'none',
    plot.title = element_text(
      color = 'black', face = 'bold', size = rel(1.5), 
      # hjust = -0.45
    ),
    plot.subtitle = element_text(
      color = 'black', size = rel(1.1), 
      # hjust = -0.23
    ),
    axis.text = element_text(color = 'black'),
    axis.text.x = element_blank()
  )


## -----------------------------------------------------------------------------
#| echo: false
petty <- cup_driver_career |>
  filter(driver == 'Richard Petty') |>
  pull(career_races)

pearson <- cup_driver_career |>
  filter(driver == 'David Pearson') |>
  pull(career_races)


## -----------------------------------------------------------------------------
#| eval: false
## truck_mfg_season |>
##   ggplot(aes(season, mfg_season_win_pct, group = manufacturer, color = manufacturer)) +
##   geom_line() +
##   geom_point()


## -----------------------------------------------------------------------------
#| echo: false
mfg_colors = c(
  'Chevrolet' = '#c5b358',
  'Dodge' = 'darkcyan',
  'Ford' = '#003478',
  'RAM' = '#94979c',
  'Toyota' = '#eb0a1e'
)

truck_mfg_season |>
  ggplot(aes(season, mfg_season_win_pct, group = manufacturer, color = manufacturer)) +
  geom_line(alpha = 0.8) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = mfg_colors) +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = 'NASCAR Truck Series Manufacturer Win Percentage',
    caption = 'Source: NASCAR.com',
    x = NULL, y = NULL
  ) +
  theme(
    legend.position = 'top',
    legend.title = element_blank(),
    plot.title = element_text(
      color = 'black', face = 'bold', size = rel(1.35)
    ),
    plot.subtitle = element_text(
      color = 'black', size = rel(1.1)
    ),
    axis.text = element_text(color = 'black')
  )


## -----------------------------------------------------------------------------
#| eval: false
## cup <- cup_race_data |>
##   mutate(series = 'Cup') |>
##   filter(finish == 1) |>
##   select(season, race, finish, money, series)
## 
## xfinity <- xfinity_race_data |>
##   mutate(series = 'Xfinity') |>
##   filter(finish == 1) |>
##   select(season, race, driver, money, series)
## 
## truck <- truck_race_data |>
##   mutate(series = 'Truck') |>
##   filter(finish == 1) |>
##   select(season, race, driver, money, series)
## 
## bind_rows(cup, xfinity, truck) |>
##   group_by(series, season) |>
##   summarize(mean_money = mean(money, na.rm = TRUE)) |>
##   ggplot(aes(season, mean_money, group = series, color = series)) +
##   geom_point() +
##   geom_line()


## -----------------------------------------------------------------------------
#| echo: false
flags = c(
  'Cup' = 'darkgreen',
  'Xfinity' = 'gold',
  'Truck' = 'black'
)

cup <- cup_race_data |>
  mutate(series = 'Cup') |>
  filter(finish == 1) |>
  select(season, race, finish, money, series)

xfinity <- xfinity_race_data |>
  mutate(series = 'Xfinity') |>
  filter(finish == 1) |>
  select(season, race, driver, money, series)

truck <- truck_race_data |>
  mutate(series = 'Truck') |>
  filter(finish == 1) |>
  select(season, race, driver, money, series)

bind_rows(cup, xfinity, truck) |>
  group_by(series, season) |>
  summarize(mean_money = mean(money, na.rm = TRUE)) |>
  ggplot(aes(season, mean_money, group = series, color = series)) +
  geom_point() +
  geom_line() +
  theme_minimal() +
  scale_color_manual(values = flags) +
  scale_y_continuous(labels = scales::label_dollar(scale = 1, prefix = '$')) +
  labs(
    title = 'NASCAR Race Money by Season',
    subtitle = 'Race winnings were not reported since 2016',
    caption = 'Source: NASCAR.com',
    x = NULL, y = NULL
  ) +
  theme(
    legend.position = 'top',
    legend.title = element_blank(),
    plot.title = element_text(
      color = 'black', face = 'bold', size = rel(1.35)
    ),
    plot.subtitle = element_text(
      color = 'black', size = rel(0.8)
    ),
    axis.text = element_text(color = 'black')
  )


## -----------------------------------------------------------------------------
#| include: false

# automatically create a bib database for loaded R packages & rUM
knitr::write_bib(
  c(
    .packages(),
    "rUM"
  ),
  "packages.bib"
)

