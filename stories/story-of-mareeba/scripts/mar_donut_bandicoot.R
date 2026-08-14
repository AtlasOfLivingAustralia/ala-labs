
# Sunburst plot: Bandicoot records day vs night

library(lubridate)
library(dplyr)
library(tidyr)
library(tibble)
library(ggplot2)
library(galah)
library(stringr)
library(showtext)
library(geomtextpath)
font_add_google("Roboto", "roboto")
showtext_auto()

galah_config(email = "dax.kellie@csiro.au")

# Isoodon macrourus
records <- galah_call() |>
  identify("Isoodon macrourus") |>
  # filter(stateProvince == "Queensland") |>
  geolocate(lat = -16.991,
            lon = 145.423,
            radius = 20,
            type = "radius") |>
  select(eventDate) |>
  atlas_occurrences()

time <- records |>
  mutate(
    time = ymd_hms(eventDate) |> hms::as_hms()
  ) |>
  drop_na() |>
  mutate(
    is_day = case_when(
      time > hms::as_hms("18:00:00") ~ "night",
      time < hms::as_hms("08:00:00") ~ "night",
      .default = "day"
    )
  )

time_edited <- time |>
  group_by(is_day) |>
  count() |>
  ungroup() |>
  mutate(
    total = sum(n),
    percent = (n/total) |> round(2),
    labels = ifelse(percent > .50,
                    glue::glue("{n} records ({percent*100}%)"),
                    glue::glue(" ")
                    )
  )

time_edited |>
  ggplot() +
  geom_col(aes(x = 1, y = percent, fill = is_day)) +
  geom_textpath(aes(x = 1, y = percent, label = labels),
                position = position_stack(vjust = 0.5),
                angle = 90,
                size = 7.6,
                color = "white",
                family = "roboto"
                ) +
  scale_fill_manual(values = c(
    "day" = "#FFC557",
    "night" = "#5F84AF")) +
  xlim(-1, 2) +
  pilot::theme_pilot(grid = "", axes = "") +
  coord_polar(theta = "y") +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    panel.background = element_rect(fill = "#232323", colour = "#232323"),
    plot.background = element_rect(fill = "#232323", colour = "#232323"),
    text = element_text(family = "roboto", colour = "white"),
    legend.position = "none",
    plot.margin = margin(t=1, l=1, b=1, r=1, unit = "cm")
  ) +
  geomtextpath::geom_textpath(
    data = data.frame(
      x = -.01,
      y = c(.95, 1),
      label = "day"
    ),
    aes(x = x, y = y, label = label),
    colour = "#FFC557",
    family = "roboto"
  ) +
  geomtextpath::geom_textpath(
    data = data.frame(
      x = -.01,
      y = c(.45, .5),
      label = "night"
    ),
    aes(x = x, y = y, label = label),
    colour = "#5F84AF",
    family = "roboto"
  )

showtext_opts(dpi = 300)

ggsave(
  file = here::here("stories", "plots", "donut_bandicoot.png"),
  dpi = 300,
  height = 7.5,
  width = 7.5
)

