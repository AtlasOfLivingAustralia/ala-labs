library(galah)
library(sf)
library(terra)
library(spatstat)
library(ggplot2)
library(dplyr)
library(tibble)
library(tidyr)
library(tidyterra)

galah_config(email = "dax.kellie@csiro.au")

## Bounding box

se_nsw_bbox <- tibble::tibble(
  xmin = 148.5,
  xmax = 151,
  ymin = -37.5,
  ymax = -35
)

# bounding box
bbox_ext <- terra::ext(
  c(se_nsw_bbox$xmin,
    se_nsw_bbox$xmax,
    se_nsw_bbox$ymin,
    se_nsw_bbox$ymax
  ))

# convert to sf for plotting
bbox_sf <- bbox_ext |>
  as.polygons(crs = "EPSG:4326") |>
  st_as_sf()


# Download data

bandicoots <- galah_call() |>
  # filter(year == 2016) |>
  identify("perameles") |>
  # geolocate(se_nsw_bbox, type = "bbox") |>
  apply_profile(ALA) |>
  atlas_occurrences() |>
  drop_na(decimalLongitude, decimalLatitude)

bandicoots_sf <- bandicoots |>
  sf::st_as_sf(coords = c("decimalLatitude", "decimalLongitude"),
               crs = 4326)

bandicoots_sf |>
  sf::st_coordinates()

ggplot() +
  geom_sf(data = bbox_sf) +
  geom_point(data = bandicoots,
             aes(x = decimalLongitude,
                 y = decimalLatitude))

# raster of bounding box area
area_rast <- terra::rast(bbox_ext, crs = "EPSG:4326")

# window must be defined in a specifically ordered vector
# using any other bbox function (eg st_bbox) is interpreted incorrectly by `as.owin()`
window <-
  c(
    xmin = se_nsw_bbox$xmin,
    xmax = se_nsw_bbox$xmax,
    ymin = se_nsw_bbox$ymin,
    ymax = se_nsw_bbox$ymax
  ) |>
  as.owin()

plot(window)

# what about a shape?
aus <- ozmaps::ozmap_country |>
  st_transform(st_crs("EPSG:7841"))

window_aus <- aus |>
  as.owin(eps = 0.0001)



# bandicoots_sf |>
#   st_transform(crs = st_crs("EPSG:7841"))

# convert to ppp object
# NOTE: EPSG:7841 is a height projection for Papua New Guinea
#       For some unknown reason, this is one of very few projections that works in `as.ppp()`
#       EPSG:4326 doesn't work (nor any other common/projected Australian epsg)
#       I imagine this is bad practice, but there are no other solutions
#
#       The inability for EPSG:4326 to be converted to a ppp object is documented here:
#       https://github.com/r-spatial/sf/issues/1233
#
bandicoots_ppp <- as.ppp(
  bandicoots_sf |>
    st_transform(crs = st_crs("EPSG:7841")) |>
    st_coordinates() |>
    as_tibble() |>
    select(2, 1),
  W = window_aus
  )
## Maybe something about a planar coordinate system?
## I've tried many types of EPSG and this doesn't seem to solve anything consistently
# https://gis.stackexchange.com/questions/454711/how-to-create-a-ppp-spatstat-object-from-a-sf-object

# kde
kd <- density(bandicoots_ppp, sigma = 1)

# convert to raster layer for plotting
kd_terra <- kd |> terra::rast()
crs(kd_terra) <- "+init=EPSG:7841" # must assign crs which is lost during conversion

kd_terra <- kd_terra |>
  terra::project("EPSG:4326")

ggplot() +
  geom_sf(data = ozmaps::ozmap_country |> st_transform(st_crs("EPSG:4326"))) +
  tidyterra::geom_spatraster(data = kd_terra) +
  tidyterra::scale_fill_grass_c()
