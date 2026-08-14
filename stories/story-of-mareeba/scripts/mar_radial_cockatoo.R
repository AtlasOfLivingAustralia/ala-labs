
# Radial bar plots: Seasonality

library(lubridate)
library(dplyr)
library(tidyr)
library(tibble)
library(ggplot2)
library(galah)
library(stringr)
library(showtext)
font_add_google("Roboto", "roboto")
showtext_auto()

galah_config(email = "dax.kellie@csiro.au")

counts <- galah_call() |>
  identify("Calyptorhynchus (Calyptorhynchus) banksii") |>
  geolocate(lat = -16.991,
            lon = 145.423,
            radius = 20,
            type = "radius") |>
  group_by(month) |>
  atlas_counts()

counts_edit <- counts |>
  mutate(
    month = lubridate::month(as.numeric(month), label = TRUE)
  ) |>
  arrange(month)

palette_heat <- c(
  Jan = "#A94A44",
  Feb = "#B55649",
  Mar = "#C06C58",
  Apr = "#BE846C",
  May = "#A6A0A0",
  Jun = "#7E9FBE",
  Jul = "#5F84AF",
  Aug = "#6D93B8",
  Sep = "#8FA6B7",
  Oct = "#AA928B",
  Nov = "#B77063",
  Dec = "#A64C46"
)

ggplot() +
  geom_hline(
    aes(yintercept = 200),
    colour = "grey50"
  ) +
  geom_hline(
    aes(yintercept = 400),
    colour = "grey50"
  ) +
  geom_bar(
    data = counts_edit,
    aes(
      x = month,
      y = count,
      fill = month
    ),
    stat = "identity"
  ) +
  coord_polar() +
  scale_y_continuous(
    limits = c(-150, 575),
    expand = c(0, 0),
    breaks = c(0, 200, 400)
  ) +
  scale_fill_manual(values = palette_heat) +
  pilot::theme_pilot(axes = "",
              grid = "") +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text.x = element_text(family = "roboto", colour = "white", face = "bold"),
    axis.text.y = element_blank(),
    panel.background = element_rect(fill = "#232323", colour = "#232323"),
    plot.background = element_rect(fill = "#232323", colour = "#232323"),
    text = element_text(family = "roboto", colour = "white"),
    legend.position = "none",
    plot.margin = margin(t=1, l=1, b=1, r=1, unit = "cm")
  ) +
  # Annotate custom scale inside plot
  annotate(
    x = 0.5,
    y = 230,
    label = "200",
    geom = "text",
    color = "gray40",
    family = "roboto"
  ) +
  annotate(
    x = 0.5,
    y = 430,
    label = "400",
    geom = "text",
    color = "gray40",
    family = "roboto"
  ) +
  geomtextpath::geom_textpath(
    data = data.frame(
      x = c(1, 2),
      y = -50,
      label = "summer"
    ),
    aes(x = x, y = y, label = label),
    colour = "#c58a86",
    family = "roboto"
  ) +

  geomtextpath::geom_textpath(
    data = data.frame(
      x = c(7, 8),
      y = -50,
      label = "winter"
    ),
    aes(x = x, y = y, label = label),
    colour = "#8cabce",
    family = "roboto"
  )



showtext_opts(dpi = 300)

# birds
ggsave(
  file = here::here("stories", "plots", "radial_cockatoo.png"),
  dpi = 300,
  height = 7.5,
  width = 7.5
)


# using actual records, not count summary
# records <- galah_call() |>
#   identify("Geopelia humeralis") |>
#   filter(stateProvince == "Queensland") |>
#   select(eventDate) |>
#   atlas_occurrences()
#
# occs_by_month <- records |>
#   select(eventDate) |>
#   mutate(eventDate = lubridate::month(eventDate, label = TRUE)) |>
#   group_by(eventDate) |>
#   drop_na() |>
#   count()

