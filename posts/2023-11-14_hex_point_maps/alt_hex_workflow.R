# Alternate possible workflow, where we set up the 3 layers needed for 
# making this map one by one. The first layer is a basemap that we get from 
# {ozmaps}. The second is the layer of hexes with occurrence records. The third 
# is a layer with points for every species within each hex.

library(tidyverse)
library(galah)
library(ozmaps)
library(sf)

galah_config(email = Sys.getenv("email"))

# get names of honeyeaters
melithreptus <- galah_call() |>
  galah_identify("Melithreptus") |>
  atlas_species()

# download occurrence records 
species_occ <- readRDS("posts/2023-11-14_hex_point_maps/species_occ.RDS")

# species_occ <- galah_call() |>
#   galah_apply_profile(ALA) |>
#   galah_identify(melithreptus$species) |>
#   galah_filter(year == 2022,
#                !is.na(cl1048),
#                !is.na(decimalLatitude),
#                !is.na(decimalLongitude)) |>
#   galah_select(decimalLatitude,
#                decimalLongitude,
#                species,
#                vernacularName,
#                scientificName) |>
#   atlas_occurrences()
# saveRDS(species_occ, "posts/2023-11-14_hex_point_maps/species_occ.RDS")

species_occ_sf <- species_occ |>
  st_as_sf(coords = c("decimalLongitude", "decimalLatitude"), 
           crs = 4326) |>   
  st_set_geometry("occ_geometry")

# create hex grid across Australia
hex_grid <- st_make_grid(ozmap_country,
                         cellsize = 2,
                         what = "polygons",
                         square = FALSE,
                         flat_topped = TRUE) |>  
  st_as_sf() |>   
  st_filter(ozmap_country) |> 
  st_set_geometry("hex_geometry") |> 
  st_transform(4326) |> 
  rowid_to_column(var = "hex_id") 

# remove hexes without records  
hex_with_species <- st_join(x = hex_grid, 
                            y = species_occ_sf,
                            join = st_intersects,
                            left = FALSE)

# no duplicates in hexes with records
# unique_hex <- hex_with_species |> 
#   select(hex_id, hex_geometry) |> 
#   distinct()
# using count() here because it's much much faster than distinct()
unique_hex <- hex_with_species |> 
  count(hex_id, hex_geometry) |> 
  select(-`n`)

#### fiddly bits to get points #### 
#### to visualise what's actually going on in the next few steps,
#### run this section of code 
#### this is to explain to users what we're trying to do before we actually 
#### get into the code
#### could just have a set of images in sequence, or could animate it
#### to show changes
library(patchwork)

big_hex <- st_polygon(list(rbind(
  c(-1, 0),
  c(-0.5, sqrt(0.75)),
  c(0.5, sqrt(0.75)),
  c(1, 0),
  c(0.5,-sqrt(0.75)),
  c(-0.5,-sqrt(0.75)),
  c(-1, 0))))

small_hex <- st_buffer(big_hex, -0.3)

small_hex_vertices <- small_hex |>
  st_coordinates() |>
  as_tibble() |>
  st_as_sf(coords = c("X", "Y"), remove = FALSE) |> 
  rowid_to_column() |> 
  mutate(vertex_id = if_else(rowid %in% c(2:6), as.character(rowid), "1, 7"))

# 1. original hex
p1 <- ggplot() +
  geom_sf(data = big_hex, fill = NA, linewidth = 1.5, colour = "deepskyblue4") +
  labs(subtitle = "Original hex") +
  theme_void() +
  theme(plot.subtitle = element_text(hjust = 0.5))

# 2. smaller hex
p2 <- ggplot() +
  geom_sf(data = big_hex, fill = NA, linewidth = 1.5, colour = "deepskyblue4") +
  geom_sf(data = small_hex, fill = NA, linewidth = 1, colour = "deepskyblue3") +
  labs(subtitle = "Smaller hex") +
  theme_void() +
  theme(plot.subtitle = element_text(hjust = 0.5))

# 3. vertices
p3 <- ggplot() +
  geom_sf(data = big_hex, fill = NA, linewidth = 1.5, colour = "deepskyblue4") +
  geom_sf(data = small_hex_vertices, size = 3, colour = "deepskyblue3") +
  labs(subtitle = "Smaller hex vertices") +
  theme_void() +
  theme(plot.subtitle = element_text(hjust = 0.5))

# 4. vertex numbers
p4 <- ggplot() +
  geom_sf(data = big_hex, fill = NA, linewidth = 1.5, colour = "deepskyblue4") +
  geom_sf(data = small_hex_vertices, size = 3, colour = "deepskyblue3") +
  geom_text(data = small_hex_vertices, aes(X, Y, label = vertex_id), nudge_y = 0.12) +
  labs(subtitle = "Numbered vertices") +
  theme_void() +
  theme(plot.subtitle = element_text(hjust = 0.5))

# 5. with centroid
p5 <- ggplot() +
  geom_sf(data = big_hex, fill = NA, linewidth = 1.5, colour = "deepskyblue4") +
  geom_sf(data = small_hex_vertices, size = 3, colour = "deepskyblue3") +
  geom_sf(data = st_centroid(small_hex), size = 3, colour = "deepskyblue3") +
  geom_text(data = small_hex_vertices[c(1:6),], aes(X, Y, label = rowid), nudge_y = 0.12) +
  geom_sf_text(data = st_centroid(small_hex), aes(label = "7"), nudge_y = 0.12) +
  labs(subtitle = "Numbered vertices and centroid") +
  theme_void() +
  theme(plot.subtitle = element_text(hjust = 0.5))

p1 + p2 + p3 + p4 + p5 + plot_layout(ncol = 5)

#### explainy visuals end here 

# get 7 points
vertex_coords <- unique_hex |> 
  mutate(vertices = pmap(
    .l = list(x = hex_geometry),
    .f = function(x) {
      x |>
        st_buffer(dist = -0.3) |>
        st_coordinates() |>
        as_tibble() |>
        st_as_sf(coords = c("X", "Y")) |>
        select(-L1,-L2) |>
        mutate(vertex_position = 1:7)
    })) |> 
  tidyr::unnest(cols = vertices)

# convert 7th point to centroid
vertex_centroid_coords <- vertex_coords |> 
  mutate(geometry = ifelse(vertex_position == 7,
                           st_centroid(hex_geometry),
                           geometry)) |> 
  st_drop_geometry() |> 
  st_as_sf(crs = 4326)

# species list to join to hexes  
# more colour options here (uncomment to see colours) 
# from {viridis}
# "#440154", "#443A83", "#31688E", "#21908C",  "#35B779", "#8FD744", "#FDE725"
# from {pilot}    
# "#204466", "#249db5", "#b84818", "#30c788", "#ffc517", "#9956db", "#f28100"

# this regex is disgusting so we could also go with the option of typing 
# everything out - I just liked the idea of keeping as much of the galah output
# as possible 
species_data <- melithreptus |>
  select(species, vernacular_name) |>
  mutate(species = str_replace_all(species, "\\s*\\(.*?\\)\\s*", " "),
         vernacular_name = case_when(
           species == "Melithreptus chloropsis" ~ "Gilbert's Honeyeater",
           TRUE ~ as.character(vernacular_name)),
         label = paste(vernacular_name, " (*", species, "*)", sep = ""),
         position = c(1:7),
         colour = c("#F7618F",
                    "#842192",
                    "#F7C328",
                    "#33C8E1",
                    "#E4C9C9",
                    "#D7271C",
                    "#7CC545"))

# join everything for plotting  
species_points <- hex_with_species |>
  st_drop_geometry() |>
  select(hex_id, species) |>
  distinct() |>
  left_join(species_data,
            by = join_by(species)) |>
  left_join(vertex_centroid_coords,
            by = join_by(position == vertex_position, hex_id == hex_id)) |> 
  st_as_sf(crs = 4326)
  
ggplot() +
  geom_sf(data = ozmap_states, fill = NA, colour = "#ababab", linewidth = 0.5) +
  geom_sf(data = unique_hex, fill = NA, colour = "#777777", linewidth = 0.5) +
  geom_sf(data = species_points, aes(colour = species)) +
  theme_void()

  
