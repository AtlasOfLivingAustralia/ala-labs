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

# peaceful dove
dove <- counts_joined |>
  ggplot() +
  geom_bar(aes(
    x = reorder(scientificName, -count),
    y = count,
    fill = ifelse(count > 5500, "#FFC557", "grey50")
  ),
  stat = "identity") +
  labs(y = "Number of records") +
  scale_fill_identity() +
  scale_y_continuous(labels = scales::comma) +
  pilot::theme_pilot(axes = "",
                     grid = "") +
  theme(
    panel.background = element_rect(fill = "#232323", colour = "#232323"),
    plot.background = element_rect(fill = "#232323", colour = "#232323"),
    text = element_text(family = "roboto", colour = "white"),
    axis.title = element_text(colour = "white"),
    axis.text = element_text(colour = "white"),
    axis.text.x = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "none",
    plot.margin = margin(t=1, l=1, b=1, r=1, unit = "cm")
  )

dove

# Diplacodes haematodes (scarlet percher)
dragonfly <- counts_joined |>
  ggplot() +
  geom_bar(aes(
    x = reorder(scientificName, -count),
    y = count,
    fill = ifelse(scientificName == "Diplacodes haematodes", "#C4CA50", "grey50")
  ),
  stat = "identity") +
  labs(y = "Number of records") +
  scale_fill_identity() +
  scale_y_continuous(labels = scales::comma) +
  pilot::theme_pilot(axes = "",
                     grid = "") +
  theme(
    panel.background = element_rect(fill = "#232323", colour = "#232323"),
    plot.background = element_rect(fill = "#232323", colour = "#232323"),
    text = element_text(family = "roboto", colour = "white"),
    axis.title = element_text(colour = "white"),
    axis.text = element_text(colour = "white"),
    axis.text.x = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "none",
    plot.margin = margin(t=1, l=1, b=1, r=1, unit = "cm")
  )

dragonfly

# fish
fish <- counts_joined |>
  ggplot() +
  geom_bar(aes(
    x = reorder(scientificName, -count),
    y = count,
    fill = ifelse(group == "Fish", "#4aacde", "grey50")
  ),
  stat = "identity") +
  labs(y = "Number of records") +
  scale_fill_identity() +
  scale_y_continuous(labels = scales::comma) +
  pilot::theme_pilot(axes = "",
                     grid = "") +
  theme(
    panel.background = element_rect(fill = "#232323", colour = "#232323"),
    plot.background = element_rect(fill = "#232323", colour = "#232323"),
    text = element_text(family = "roboto", colour = "white"),
    axis.title = element_text(colour = "white"),
    axis.text = element_text(colour = "white"),
    axis.text.x = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "none",
    plot.margin = margin(t=1, l=1, b=1, r=1, unit = "cm")
  )

fish

showtext_opts(dpi = 300)
ggsave(
  dove,
  file = here::here("stories", "plots", "bar_counts_dove.png"),
  dpi = 300,
  height = 6,
  width = 6
)

ggsave(
  dragonfly,
  file = here::here("stories", "plots", "bar_counts_dragonfly.png"),
  dpi = 300,
  height = 6,
  width = 6
)

ggsave(
  fish,
  file = here::here("stories", "plots", "bar_counts_fish.png"),
  dpi = 300,
  height = 6,
  width = 6
)



counts_joined |>
  mutate(
    is_bird = case_when(
      group == "Bird" ~ "bird",
      .default = "not bird"
    )
  ) |>
  group_by(is_bird) |>
  summarise(n_records = sum(count))

1874/60411
1874/5551
