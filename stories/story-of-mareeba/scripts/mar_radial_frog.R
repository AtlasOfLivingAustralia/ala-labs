
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

# Litoria gracilenta

counts <- galah_call() |>
  identify("Litoria gracilenta") |>
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
    aes(yintercept = 25),
    colour = "grey50"
  ) +
  geom_hline(
    aes(yintercept = 50),
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
    limits = c(-20, 75),
    expand = c(0, 0),
    breaks = c(0, 25, 50)
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
    y = 30,
    label = "25",
    geom = "text",
    color = "gray40",
    family = "roboto"
  ) +
  annotate(
    x = 0.5,
    y = 55,
    label = "50",
    geom = "text",
    color = "gray40",
    family = "roboto"
  ) +
  geomtextpath::geom_textpath(
    data = data.frame(
      x = c(1, 2),
      y = -7,
      label = "summer"
    ),
    aes(x = x, y = y, label = label),
    colour = "#c58a86",
    family = "roboto"
  ) +
  geomtextpath::geom_textpath(
    data = data.frame(
      x = c(7, 8),
      y = -7,
      label = "winter"
    ),
    aes(x = x, y = y, label = label),
    colour = "#8cabce",
    family = "roboto"
  )

showtext_opts(dpi = 300)

ggsave(
  file = here::here("stories", "plots", "radial_frog.png"),
  dpi = 300,
  height = 7.5,
  width = 7.5
)



# exploratory version
# ggplot() +
#   geom_bar(
#     data = counts_edit,
#     aes(
#       x = month,
#       y = count
#     ),
#     fill = "navy",
#     stat = "identity"
#   ) +
#   coord_polar() +
#   pilot::theme_pilot(axes = "",
#                      grid = "")




