
library(ggplot2)
library(ggchicklet) # remotes::install_github("hrbrmstr/ggchicklet")
library(dplyr)
library(tibble)
library(cli)
library(showtext)
font_add_google("Roboto", "roboto")
showtext_auto()

data <- tibble(
  num = 1:6,
  length = 1,
  month = c("Jan - Feb", "Mar - Apr", "May - Jun", "Jul - Aug", "Sep - Oct", "Nov - Dec"),
  colour = c("blue", "green", "yellow", "orange", "red", "#4b0082"),
  order(6:1)
)

ggplot(data = data,
       aes(x = reorder(num, -num),
           y = length,
           fill = colour)) +
  geom_chicklet(colour = NA, alpha = 0.85, width = 0.9) +
  geom_text(
    aes(y = 0.5,
        label = month,
        colour = ifelse(colour %in% c("yellow", "green", "orange"), "#232323", "#fff")),
    size = 2.8,
    hjust = .5,
    fontface = "bold",
    family = "roboto"
  ) +
  scale_fill_identity() +
  scale_colour_identity() +
  coord_flip() +
  theme_void() +
  theme(
    panel.background = element_rect(fill = "#232323", colour = "#232323"),
    plot.background = element_rect(fill = "#232323", colour = "#232323"),
    text = element_text(family = "roboto"),
    legend.position = "none",
    plot.margin = margin(t=1, l=1, b=1, r=1, unit = "cm")
  )

showtext_opts(dpi = 300)
ggsave(
  file = here::here("stories", "plots", "legend-colours.png"),
  dpi = 300,
  height = 3,
  width = 3
)
