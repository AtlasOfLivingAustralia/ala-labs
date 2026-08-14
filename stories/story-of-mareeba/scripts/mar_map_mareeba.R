
# Title: Mareeba on Australia map

# packages
library(ozmaps)
library(sf)
library(ggplot2)
library(showtext)
font_add_google("Roboto", "roboto")
showtext_auto()


aus <- ozmaps::ozmap_country

arrows <- tibble::tibble(
  x1 = 151.2,
  x2 = 147,
  y1 = -15,
  y2 = -16.1
)

aus_map <- ggplot() +
  geom_sf(
    data = aus,
    fill = "#232323",
    colour = "#e2e2e2"
  ) +
  geom_point(
    aes(x = 145.423,
        y = -16.991),
    colour = "#FFC557",
    size = 3
  ) +
  geom_curve(
    data = arrows, aes(x = x1, y = y1, xend = x2, yend = y2),
    arrow = arrow(length = unit(0.08, "inch")),
    linewidth = 1.5,
    color = "#FFC557",
    curvature = 0.3) +
  annotate("text", x = 156, y = -15, label = "Mareeba", size = 6, colour = "#FFC557") +
  theme_void() +
  theme(
    panel.background = element_rect(fill = "#232323", colour = "#232323"),
    plot.background = element_rect(fill = "#232323", colour = "#232323"),
    text = element_text(family = "roboto")
  )

showtext_opts(dpi = 300)
ggsave(
  aus_map,
  file = here::here("stories", "plots", "aus_map.png"),
  dpi = 300
)

