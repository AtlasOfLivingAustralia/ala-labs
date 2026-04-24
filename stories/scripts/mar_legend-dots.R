
library(ggplot2)
library(dplyr)
library(tibble)
library(cli)
library(showtext)
font_add_google("Roboto", "roboto")
showtext_auto()

data <- tibble(
  group = 1,
  location = 1:3,
  numbers = c(1, 10, 100),
  size = c(1, 10, 100)
)

data_labels <- data |>
  rowwise() |>
  mutate(
    label = pluralize("{numbers} observation{?s}")
  )

ggplot(data = data_labels,
       aes(x = group,
           y = location)
       ) +
  geom_point(aes(size = size), colour = "white") +
  geom_text(aes(label = label),
            nudge_x = 0.2, check_overlap = TRUE, colour = "white",
            size = 3,
            hjust = 0) +
  scale_size_continuous(range = c(1.5, 10)) +
  xlim(c(0, 2)) +
  ylim(c(0.8, 3.5)) +
  theme_void() +
  theme(
    panel.background = element_rect(fill = "#232323", colour = "#232323"),
    plot.background = element_rect(fill = "#232323", colour = "#232323"),
    text = element_text(family = "roboto"),
    legend.position = "none",
    plot.margin = margin(t=2, l=-3, b=2, r=0, unit = "cm")
  )

showtext_opts(dpi = 300)
ggsave(
  file = here::here("stories", "plots", "legend-dots.png"),
  dpi = 300,
  height = 3.5,
  width = 3.5
)
