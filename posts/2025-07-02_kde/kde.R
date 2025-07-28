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
  sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"), # order is important
               crs = 4326)

bandicoots_sf |>
  sf::st_coordinates()

ggplot() +
  # geom_sf(data = bbox_sf) +
  geom_sf(data = ozmaps::ozmap_country) +
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
  st_transform(st_crs("EPSG:3577"))

window_aus <- aus |>
  as.owin(
    # eps = 0.0001
    )

plot(window_aus)

# bandicoots_sf |>
#   st_transform(crs = st_crs("EPSG:7841"))

# convert to ppp object
# NOTE: The inability for EPSG:4326 to be converted to a ppp object is documented here:
#       https://github.com/r-spatial/sf/issues/1233
#
#       We use GDA94/Australian Albers. This is a Cartesian 2D coordinate system that can be used to measure distances in metres
bandicoots_ppp <- as.ppp(
  bandicoots_sf |>
    st_transform(crs = 3577) |>
    st_coordinates() |>
    as_tibble() |>
    select(1, 2),
  W = window_aus
  )

plot(bandicoots_ppp)

## Maybe something about a planar coordinate system?
## I've tried many types of EPSG and this doesn't seem to solve anything consistently
# https://gis.stackexchange.com/questions/454711/how-to-create-a-ppp-spatstat-object-from-a-sf-object

# what works, however, is kinda hilarious
plot(bandicoots_ppp)


# kde
kd <- density(bandicoots_ppp,
              sigma = 4, # amount of smoothing. Higher numbers mean greater distance
              eps = 0.1  # size of pixels
              )

# convert to raster layer for plotting
kd_terra <- kd |> terra::rast()
crs(kd_terra) <- "+init=EPSG:7841" # must assign crs which is lost during conversion

kd_terra <- kd_terra |>
  terra::project("EPSG:4326") # then add the correct one

## PLOT THAT MAP
ggplot() +
  geom_sf(data = ozmaps::ozmap_country |> st_transform(st_crs("EPSG:4326"))) +
  tidyterra::geom_spatraster(data = kd_terra) +
  tidyterra::scale_fill_grass_c()




# ---- Australian cities ----

library(maps)
cities <- world.cities |>
  filter(country.etc == "Australia",
         pop > 100000) # major cities only

# convert to sf object
cities_sf <- cities |>
  sf::st_as_sf(coords = c("long", "lat"), crs = 4326)

ggplot() +
  geom_sf(data = ozmaps::ozmap_country) +
  geom_sf(data = cities_sf,
          colour = "#4a0ff0") +
  ggrepel::geom_text_repel(data = cities,
                           aes(x = long,
                               y = lat,
                               label = name))

# all of austrlaia as a window
aus <- ozmaps::ozmap_country |>
  st_transform(st_crs(3577))

window_aus <- aus |>
  as.owin(
    # eps = 0.0001
  )

plot(window_aus)


# convert city locations to ppp object
cities_ppp <- cities_sf |>
  st_transform(crs = 3577) |> # convert to weird projection
  st_coordinates() |>
  as_tibble() |>
  select(1, 2) |>
  as.ppp(W = window_aus)

plot(cities_ppp)


# kde
kd <- density(cities_ppp,
              sigma = 50000, # amount of smoothing. Higher numbers mean greater distance
              # eps = 10000    # size of pixels
              dimyx = 400
)

plot(kd)

# convert to raster layer for plotting
kd_terra <- kd |> terra::rast()
crs(kd_terra) <- "+init=EPSG:3577" # must assign crs which is lost during conversion

kd_terra <- kd_terra |>
  terra::project("EPSG:4326") # then add the correct one

## PLOT THAT MAP
ggplot() +
  geom_sf(data = ozmaps::ozmap_country |> st_transform(st_crs("EPSG:4326"))) +
  tidyterra::geom_spatraster(data = kd_terra) +
  tidyterra::scale_fill_grass_c() +
  coord_sf(xlim = c(148, 151),
           ylim = c(-38, -34))


# density plot of values to figure out grouping
ggplot() +
  geom_histogram(data = kd_terra |> filter(lyr.1 > 1e-10),
                 aes(x = lyr.1),
                 fill = "darkgreen")

# TODO: group values into weights
# TODO: Use this new weighted raster in a statistical model
