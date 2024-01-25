
##### Libraries #####
library(galah)
library(hexbin)
library(monochromeR)
library(ozmaps)
library(sf)
library(tidyverse)

##### galah_config() #####
galah_config(email = "callumwaite2000@gmail.com")

##### Simple Aus Map #####
aus <- ozmap_data(data = "states")

##### IBRA Map #####
ibra <- st_read("C://Users/WAI045/OneDrive - CSIRO/ALA/Labs/Shapefiles/IBRA7_regions/ibra7_regions.shp") |>
  st_make_valid() |>
  st_union()

# EEZ Map (from IBRA  + IMCRA) #####

library(sfheaders)
# Create an outline of Australia from IBRA/IMCRA regions
IBRA_regions <- st_read("C://Users/WAI045/OneDrive - CSIRO/ALA/Labs/Shapefiles/IBRA7_regions/ibra7_regions.shp") |>
  st_make_valid() |>
  st_simplify(preserveTopology = TRUE, dTolerance = 1000) |>
  select(REG_NAME_7) |>
  rename(region_name = REG_NAME_7)
IMCRA_mesoscale <- st_read("C://Users/WAI045/OneDrive - CSIRO/ALA/Labs/Shapefiles/IMCRA4_provincial/imcra4_pb.shp") |>
  st_make_valid() |>
  st_simplify(preserveTopology = TRUE, dTolerance = 1000) |>
  select(PB_NAME) |>
  rename(region_name = PB_NAME)

aus_EEZ <- rbind(IBRA_regions, IMCRA_mesoscale) |>
  st_union() |>
  st_as_sf() |> 
  st_transform(4326)

##### Data Download + Setup #####
species_data <- data.frame(
  species = c("Melithreptus albogularis", # White-throated Honeyeater
              "Melithreptus lunatus", # White-naped Honeyeater
              "Melithreptus brevirostris", # Brown-headed Honeyeater
              "Melithreptus gularis", # Black-chinned Honeyeater
              "Melithreptus affinis", # Black-headed Honeyeater
              "Melithreptus chloropsis", # Gilbert's Honeyeater
              "Melithreptus validirostris"), # Strong-billed Honeyeater
  common_name = c("", "", "", "", "", "", ""),
  colour = c("#F7618F",
             "#842192",
             "#F7C328",
             "#33C8E1",
             "#E4C9C9",
             "#D7271C",
             "#7CC545"),
  species_id = c(1, 2, 3, 4, 5, 6, 7)
) |>
  mutate(label = paste0(species, " (", common_name, ")"))

#   6 5
#  1 7 4
#   2 3

species_occ <- galah_call() |>
  galah_apply_profile(ALA) |>
  galah_filter(year == 2022) |>
  galah_filter(occurrenceStatus == "PRESENT") |>
  galah_identify(species_data$species) |>
  galah_select(group = c("basic"), species, vernacularName, cl1048, cl21) |>
  atlas_occurrences()

species_occ_filt <- species_occ |>
  # Clean out incomplete data
  filter(!is.na(decimalLatitude) & !is.na(decimalLongitude) & !is.na(eventDate)) |>
  # only keep those records that overlap with Australian IBRA or IMCRA regions
  # Create geometry of coordinates and filter values inside Aus EEZ
  st_as_sf(coords = c("decimalLongitude", "decimalLatitude"), crs = st_crs(4283), remove = FALSE) |>
  mutate(intersection = st_intersects(geometry, ibra) |> as.integer()) |>
  filter(!is.na(intersection)) |>
  select(-intersection)

##### Create Base Hexagon #####
# Cover all of Australia's EEZ with hexagons
all_hex_grid <- st_make_grid(ibra, cellsize = 2, what = "polygons", 
                             square = FALSE, flat_topped = TRUE) |>
  st_as_sf(crs = st_crs(4283)) |>
  rename(geometry = x) |>
  # Assign each hexagon an ID
  mutate(hex_id = 1:n())

# Only keep those records that are actually over the EEZ
aus_hex_grid <- all_hex_grid |>
  filter(hex_id %in% (st_intersects(all_hex_grid, ibra) |> 
                        as.data.frame() |>
                        pull(row.id))) |>
  # Calculate the centre of each remaining hex
  mutate(hex_centre = st_centroid(geometry))

##### Produce hexagon vertices #####
# Create a function that will do this
extract_vertices <- function(r, aus_hex_grid) {
  aus_hex_grid[r,] |>
    pull(geometry) |>
    st_coordinates() |>
    # convert matrix to tibble
    as_tibble() |>
    select(-L1, -L2) |>
    # create a geometry object of each vertex
    st_as_sf(coords = c("X", "Y"), crs = st_crs(4283), remove = FALSE) |>
    # assign the hex id and vertex numbers to the data-frame 
    mutate(hex_id = aus_hex_grid$hex_id[r],
           hex_vertex = row_number()) |>
    # remove x,y columns and rename geometry column
    select(-X, -Y) |>
    rename(vertex = geometry)
}

aus_hex_vertices <- map(
  # Loop over each row 
  .x = 1:nrow(aus_hex_grid), 
  # For each row, extract the matrix of 7 coordinates (6 vertices + back to start)
  .f = ~extract_vertices(., aus_hex_grid)) |>
  list_rbind()

##### Match Species to Hexagons #####
species_hex <- species_occ_filt |>
  # Match each occurrence to it's corresponding hexagon
  mutate(intersection = st_intersects(geometry, aus_hex_grid) |> as.integer(),
         hex_id = aus_hex_grid$hex_id[intersection]) |>
  st_drop_geometry() |>
  # Only keep unique combinations of species and hexagons
  select(species, hex_id) |>
  distinct()

species_hex_combos <- species_hex |>
  # join up hex and species ids from earlier datasets
  right_join(aus_hex_grid, by = "hex_id") |>
  right_join(species_data |> select(species, species_id), by = "species") |>
  rename(geometry = geometry) |>
  st_as_sf()

##### Join up Species Points to Hex Points #####
species_hex_points <- species_hex_combos |>
  left_join(aus_hex_vertices, by = c("hex_id", "species_id" = "hex_vertex")) |>
  mutate(point_loc = if_else(species_id == 7,
                             hex_centre,
                             st_union(hex_centre, vertex) |> st_centroid())) |>
  st_drop_geometry() |>
  select(species, hex_id, species_id, point_loc) |> 
  st_as_sf()

##### Plot #####
hex_map <- ggplot() +
  geom_sf(data = species_hex_combos |> select(geometry) |> distinct(), aes(geometry = geometry),
          fill = NA, col = alpha("grey30", 1), linewidth = 0.5) +
  geom_sf(data = aus, 
          col = alpha("grey40", 1), fill = NA, linewidth = 0.5) +
  geom_sf(data = ibra, 
          col = alpha("grey40", 1), fill = NA, linewidth = 0.6) +
  geom_sf(data = species_hex_points, aes(geometry = point_loc, col = species),
          alpha = 0.95, size = 1.7) +
  scale_colour_manual(values = set_names(species_data$colour, species_data$species)) +
  lims(x = c(105, 160), y = c(-47, -7)) +
  # expand_limits(x = 200) +
  guides(colour = guide_legend(
    title = element_blank(),
    label.theme = element_text(colour = "gray90", size = 8),
    byrow = TRUE
  )
  ) + 
  theme_void() +
  theme(plot.background = element_rect(fill = "gray5"),
        legend.justification = c(0, 0), 
        legend.position = c(0.01,0),
        legend.spacing.y = unit(-0.04, "in"))
hex_map