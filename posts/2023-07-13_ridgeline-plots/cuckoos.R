library(galah)
library(tidyverse)
library(ggridges)

galah_config(email = "dax.kellie@csiro.au", atlas = "Australia")

search_taxa("Cuculidae")

# this gets a weird error
# galah_call() |>
#   identify("Cuculidae") |>
#   filter(year > 2000) |>
#   galah_apply_profile(ALA) |>
#   galah_group_by(year) |>
#   # group_by(year) # a different error with this instead
#   count()

# download data
cuckoos <- galah_call() |>
  galah_identify("Cuculidae") |>
  galah_filter(year > 2000) |>
  galah_apply_profile(ALA) |>
  galah_select(eventDate, scientificName) |>
  atlas_occurrences()

# format date, extract month
cuckoos_cleaned <- cuckoos |>
  drop_na() |>
  mutate(
    eventDate = as_date(eventDate),
    month = month(eventDate, abbr = TRUE, label = TRUE),
    date_julian = lubridate::yday(eventDate)
  )

# remove some higher-level names with low counts
names_to_remove <- c("CUCULIDAE",
                     "Cacomantis",
                     "Cacomantis (Cacomantis)")

cuckoos_filtered <- cuckoos_cleaned |>
  group_by(scientificName, date_julian) |>
  filter(!scientificName %in% names_to_remove)

cuckoos_filtered |> distinct(scientificName)



## PLOT
ggplot(
  data = cuckoos_filtered,
  aes(
    x = date_julian,
    y = fct_reorder(scientificName, date_julian, .fun = mean),
    colour = fct_reorder(scientificName, date_julian, .fun = mean),
    fill = fct_reorder(scientificName, date_julian, .fun = mean)
  )) +
  ggridges::geom_density_ridges(
    scale = 2,
    alpha = .8,
    size = .7,
    rel_min_height = 0.02
  ) +
  scale_x_continuous(
    breaks = c(1, 91, 182, 274),
    labels = c("Jan", "Apr", "Jul", "Oct")
  ) +
  pilot::scale_color_pilot() +
  pilot::scale_fill_pilot() +
  pilot::theme_pilot(
    grid = "hv",
    axes = ""
  ) +
  labs(x = "Month",
       y = "Scientific name",
       title = "Daily number of Cuckoo observations") +
  theme(legend.position = "none")



# bird look-up
cuckoos_filtered |>
  filter(str_detect(scientificName, "Chrysoco"))



## Broome/Darwin observations

search_all(fields, "ibra")

search_all(fields, "cl1049") |> search_values("Pindanland")
search_all(fields, "basisOfRecord") |> search_values("hum")

# download "wader" bird records
waders <- galah_call() |>
  galah_identify("Charadriiformes") |>
  galah_filter(year > 2000,
               cl1049 == "Pindanland",
               basisOfRecord == "HUMAN_OBSERVATION") |>
  galah_apply_profile(ALA) |>
  galah_select(eventDate, scientificName) |>
  atlas_occurrences()

# format date, extract month
waders_cleaned <- waders |>
  drop_na() |>
  mutate(
    eventDate = as_date(eventDate),
    month = month(eventDate, abbr = TRUE, label = TRUE),
    date_julian = lubridate::yday(eventDate)
  )

# remove some higher-level names with low counts
names_to_remove <- c("SCOLOPACIDAE",
                     "LARIDAE",
                     "CHARADRIIFORMES")

waders_filtered <- waders_cleaned |>
  group_by(scientificName, date_julian) |>
  filter(!scientificName %in% names_to_remove)


## PLOT
ggplot(
  data = waders_filtered,
  aes(
    x = date_julian,
    y = fct_reorder(scientificName, date_julian, .fun = mean),
    colour = fct_reorder(scientificName, date_julian, .fun = mean),
    fill = fct_reorder(scientificName, date_julian, .fun = mean)
  )) +
  ggridges::geom_density_ridges(
    scale = 2,
    alpha = .8,
    size = .7,
    rel_min_height = 0.02
  ) +
  scale_x_continuous(
    breaks = c(1, 91, 182, 274),
    labels = c("Jan", "Apr", "Jul", "Oct")
  ) +
  pilot::scale_color_pilot() +
  pilot::scale_fill_pilot() +
  pilot::theme_pilot(
    grid = "hv",
    axes = ""
  ) +
  labs(x = "Month",
       y = "Scientific name",
       title = "Daily number of Wader bird observations",
       subtitle = "Pindanland bioregion") +
  theme(legend.position = "none")


cuckoos_filtered |> distinct(scientificName)



