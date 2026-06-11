## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE
)

## ----eval = FALSE-------------------------------------------------------------
# # Base R
# cup <- read.csv(
#   "cup_series.csv",
#   colClasses = c(Car = "character"),
#   stringsAsFactors = FALSE
# )
# 
# # tidyverse / readr
# cup <- readr::read_csv(
#   "cup_series.csv",
#   col_types = readr::cols(Car = readr::col_character())
# )

