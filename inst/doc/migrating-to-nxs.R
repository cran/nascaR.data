## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE
)

## ----eval = FALSE-------------------------------------------------------------
# data("cup_series")
# data("xfinity_series")
# data("truck_series")

## ----eval = FALSE-------------------------------------------------------------
# cup <- load_series("cup")
# nxs <- load_series("nxs")
# truck <- load_series("truck")

## ----eval = FALSE-------------------------------------------------------------
# xfinity <- load_series("xfinity")
# get_driver_info("bell", series = "xfinity")

## ----eval = FALSE-------------------------------------------------------------
# nxs <- load_series("nxs")
# get_driver_info("bell", series = "nxs")

## ----eval = FALSE-------------------------------------------------------------
# # Force fresh download within a session
# cup <- load_series("cup", refresh = TRUE)
# 
# # Reset the in-memory cache
# clear_cache()

## ----eval = FALSE-------------------------------------------------------------
# find_driver("bell")
# get_driver_info("Christopher Bell")

## ----eval = FALSE-------------------------------------------------------------
# # Just use get_*_info() directly
# get_driver_info("bell")

