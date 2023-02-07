#-----------------------------------------------------#
# Other animals
#-----------------------------------------------------#

library(sampbias)
library(galah)
library(viridis)
library(tidyverse)
library(ozmaps)
library(sf)

# Add registered email (register at ala.org.au)
galah_config(email = "dax.kellie@csiro.au", verbose = FALSE)

# Download Delma occurrence records in NT
records <- galah_call() |>
  galah_identify("Mantodea") |>
  galah_filter(stateProvince == "Northern Territory") |>
  atlas_occurrences()

records_filtered <- records |>
  dplyr::select(scientificName, decimalLatitude, decimalLongitude) |>
  drop_na() |>
  filter(decimalLatitude < -10,
         decimalLatitude >= -26,
         decimalLongitude >= 129,
         decimalLongitude <= 138)

# Get map
nt_wgs84 <- ozmap_data(data = "states") |>
  filter(NAME == "Northern Territory") |>
  sf::st_transform(crs = sf::st_crs("WGS84"))


ggplot() +
  # NT map
  geom_sf(data = nt_wgs84,
          fill = "grey98", color = "grey40") +
  geom_point(data = records_filtered,
             mapping = aes(x = decimalLongitude, y = decimalLatitude),
             color = "#E06E53",
             size = 1.1,
             alpha = 0.3) +
  theme_minimal()


# Model
model_bias <- sampbias::calculate_bias(
  x = records_filtered,
  res = 0.05,   # scale of spatial resolution
  buffer = 0.5, # account for neighbouring features
  restrict_sample = sf:::as_Spatial(nt_wgs84)
)


# Check all the stuffs
plot(model_bias)
mappy <- sampbias::project_bias(model_bias)
sampbias::map_bias(mappy, type="log_sampling_rate")



# Save model output
# saveRDS(model_bias, file = here::here("_posts", "data", "nt_out_mantid.rds"))




# Investigate stuff ----------------#

galah_call() |>
  # galah_identify("Dasyurus") |>
  # galah_identify("Macroderma gigas") |>
  # galah_identify("Ceyx pusillus") |>
  galah_identify("Mantodea") |>
  # galah_identify("Crotalaria cunninghamii") |>
  galah_filter(stateProvince == "Northern Territory") |>
  atlas_species()

# galah_call() |>
#   galah_identify("perameles") |>
#   galah_filter(year == 2001) |>
#   atlas_occurrences()
