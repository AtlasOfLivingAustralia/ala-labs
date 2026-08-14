
# Bar plot: Compare group counts

library(here)
library(dplyr)
library(tidyr)
library(tibble)
library(readxl)
library(ggplot2)
library(galah)
library(marquee)
library(stringr)
library(showtext)
font_add_google("Roboto", "roboto")
showtext_auto()

data <- readxl::read_xlsx(here::here("stories", "data", "species-counts.xlsx"),
                          sheet = 1) |>
  janitor::clean_names() |>
  filter(!is.na(name)) # remove species not in painting


names <- data |> pull(scientific_name)

ala_names <- names |>
  purrr::map(
    \(name) {
      search_taxa(name)
    }
  ) |>
  bind_rows()

ala_names

counts <- galah_call() |>
  filter(scientificName == ala_names$scientific_name) |>
  geolocate(lat = -16.991,
            lon = 145.423,
            radius = 20,
            type = "radius") |>
  group_by(scientificName) |>
  atlas_counts()

counts_joined <- counts |>
  right_join(ala_names |> select(scientific_name, search_term),
             join_by(scientificName == scientific_name)) |>
  right_join(data |> select(scientific_name, group),
             join_by(search_term == scientific_name)
  ) |>
  # handle species with no records
  replace_na(list(count = 0)) |>
  # capitalise group names
  mutate(
    group = stringr::str_to_sentence(group)
  )


# birds
title <- marquee_glue("{#FFC557 **Birds**}")

birds <- counts_joined |>
  ggplot() +
  geom_bar(aes(
    x = reorder(scientificName, -count),
    y = count,
    fill = ifelse(group == "Bird", "#FFC557", "grey50")
  ),
  stat = "identity") +
  labs(
    # title = title,
    y = "Number of records"
    ) +
  scale_fill_identity() +
  scale_y_continuous(labels = scales::comma) +
  pilot::theme_pilot(axes = "",
                     grid = "") +
  theme(
    panel.background = element_rect(fill = "#232323", colour = "#232323"),
    plot.background = element_rect(fill = "#232323", colour = "#232323"),
    text = element_text(family = "roboto", colour = "white"),
    plot.title = element_marquee(family = "roboto", size = 11),
    axis.title = element_text(colour = "white"),
    axis.text = element_text(colour = "white"),
    axis.text.x = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "none",
    plot.margin = margin(t=1, l=1, b=1, r=1, unit = "cm")
  )



# all

# palette
palette <- c(
  "Amphibian" = "#458F75",
  "Bird" = "grey50",
  "Fish" = "#4aacde",
  "Insect" = "#C4CA50",
  "Mammal" = "#E9AB57",
  "Monotreme" = "#E47653",
  "Reptile" = "#82935B"
)

title <- marquee_glue("{#C99059 **Insects**}, {#8FA2D2 **Amphibians**}, {#C35E4F **Mammals**},
                      {#d74731 **Monotremes**}, {#C9D195 **Reptiles**} and {#8EE7DD **Fish**}")

other_groups <- counts_joined |>
  ggplot() +
  geom_bar(aes(
    x = reorder(scientificName, -count),
    y = count,
    fill = group
  ),
  stat = "identity") +
  labs(
    # title = title,
    y = "Number of records"
  ) +
  scale_fill_manual(values = palette) +
  scale_y_continuous(labels = scales::comma) +
  pilot::theme_pilot(axes = "",
                     grid = "") +
  theme(
    panel.background = element_rect(fill = "#232323", colour = "#232323"),
    plot.background = element_rect(fill = "#232323", colour = "#232323"),
    text = element_text(family = "roboto", colour = "white"),
    plot.title = element_marquee(family = "roboto", colour = "white", size = 11),
    axis.title = element_text(colour = "white"),
    axis.text = element_text(colour = "white"),
    axis.text.x = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "none",
    plot.margin = margin(t=1, l=1, b=1, r=1, unit = "cm")
  )

birds

other_groups

showtext_opts(dpi = 300)

# birds
ggsave(
  birds,
  file = here::here("stories", "plots", "bar_counts_birds.png"),
  dpi = 300,
  height = 6,
  width = 6
)

# other groups
ggsave(
  other_groups,
  file = here::here("stories", "plots", "bar_counts_other-taxa.png"),
  dpi = 300,
  height = 6,
  width = 6
)

