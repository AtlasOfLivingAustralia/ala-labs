# ----------------------------------------------------------------------#
# Title: Update sampbias layers
# Date: 2026-09-30
# ----------------------------------------------------------------------#
# Context:
# As of 2026, {sampbias} updated itself to use terra instead of
# raster, saving and loading model output has become nightmarish.
# Use this code to correctly save and wrap output so that it can be loaded
# again and used in the post.


library(sampbias)
library(galah)
library(viridis)
library(tidyverse)
library(ozmaps)
library(sf)
library(terra)
galah_config(email = "dax.kellie@csiro.au", verbose = FALSE)


# custom functions for saving
wrap_sampbias <- function(x) {
  if (inherits(x, "SpatRaster") || inherits(x, "SpatVector")) {
    terra::wrap(x)
  } else if (inherits(x, "SpatExtent")) {
    # tag it so we can rebuild it on load
    structure(list(vec = as.vector(x)), class = "wrapped_extent")
  } else if (is.data.frame(x)) {
    x
  } else if (is.list(x)) {
    out <- lapply(x, wrap_sampbias)
    attributes(out) <- attributes(x)   # keep names, class, etc.
    out
  } else {
    x
  }
}



# --- quoll

delma_records <- galah_call() |>
  galah_identify("Dasyuridae") |>
  galah_filter(stateProvince == "Northern Territory") |>
  atlas_occurrences()

delma_records_filtered <- delma_records |>
  dplyr::select(scientificName, decimalLatitude, decimalLongitude) |>
  drop_na() |>
  filter(decimalLatitude < -10,
         decimalLatitude >= -26,
         decimalLongitude >= 129,
         decimalLongitude <= 138)

nt_wgs84 <- ozmap_data(data = "states") |>
  filter(NAME == "Northern Territory") |>
  sf::st_transform(crs = sf::st_crs("WGS84"))

model_bias_delma <- sampbias::calculate_bias(
  x = delma_records_filtered,
  res = 0.05,   # scale of spatial resolution
  buffer = 0.5, # account for neighbouring features
  restrict_sample = nt_wgs84
)

beepr::beep(sound = 2)

wrapped <- model_bias_delma |>
  wrap_sampbias() |>
  readr::write_rds(file = here::here("posts", "data", "nt_out_quoll.rds"))



# --- Kingfisher

delma_records <- galah_call() |>
  galah_identify("Ceyx pusillus") |>
  galah_filter(stateProvince == "Northern Territory") |>
  atlas_occurrences()

delma_records_filtered <- delma_records |>
  dplyr::select(scientificName, decimalLatitude, decimalLongitude) |>
  drop_na() |>
  filter(decimalLatitude < -10,
         decimalLatitude >= -26,
         decimalLongitude >= 129,
         decimalLongitude <= 138)

nt_wgs84 <- ozmap_data(data = "states") |>
  filter(NAME == "Northern Territory") |>
  sf::st_transform(crs = sf::st_crs("WGS84"))

model_bias_delma <- sampbias::calculate_bias(
  x = delma_records_filtered,
  res = 0.05,   # scale of spatial resolution
  buffer = 0.5, # account for neighbouring features
  restrict_sample = nt_wgs84
)
beepr::beep(sound = 2)

wrapped <- model_bias_delma |>
  wrap_sampbias() |>
  readr::write_rds(file = here::here("posts", "data", "nt_out_kingfisher.rds"))




# --- Mantids

delma_records <- galah_call() |>
  galah_identify("Mantidae") |>
  galah_filter(stateProvince == "Northern Territory") |>
  atlas_occurrences()

delma_records_filtered <- delma_records |>
  dplyr::select(scientificName, decimalLatitude, decimalLongitude) |>
  drop_na() |>
  filter(decimalLatitude < -10,
         decimalLatitude >= -26,
         decimalLongitude >= 129,
         decimalLongitude <= 138)

nt_wgs84 <- ozmap_data(data = "states") |>
  filter(NAME == "Northern Territory") |>
  sf::st_transform(crs = sf::st_crs("WGS84"))

model_bias_delma <- sampbias::calculate_bias(
  x = delma_records_filtered,
  res = 0.05,   # scale of spatial resolution
  buffer = 0.5, # account for neighbouring features
  restrict_sample = nt_wgs84
)
beepr::beep(sound = 2)

wrapped <- model_bias_delma |>
  wrap_sampbias() |>
  readr::write_rds(file = here::here("posts", "data", "nt_out_mantid.rds"))




# --- Birdflower

delma_records <- galah_call() |>
  galah_identify("Crotalaria cunninghamii") |>
  galah_filter(stateProvince == "Northern Territory") |>
  atlas_occurrences()

delma_records_filtered <- delma_records |>
  dplyr::select(scientificName, decimalLatitude, decimalLongitude) |>
  drop_na() |>
  filter(decimalLatitude < -10,
         decimalLatitude >= -26,
         decimalLongitude >= 129,
         decimalLongitude <= 138)

nt_wgs84 <- ozmap_data(data = "states") |>
  filter(NAME == "Northern Territory") |>
  sf::st_transform(crs = sf::st_crs("WGS84"))

model_bias_delma <- sampbias::calculate_bias(
    x = delma_records_filtered,
  res = 0.05,   # scale of spatial resolution
  buffer = 0.5, # account for neighbouring features
  restrict_sample = nt_wgs84
)
beepr::beep(sound = 2)

wrapped <- model_bias_delma |>
  wrap_sampbias() |>
  readr::write_rds(file = here::here("posts", "data", "nt_out_birdflower.rds"))

