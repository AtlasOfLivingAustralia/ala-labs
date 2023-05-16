#---
# title: Function to make and save research highlights thumbnail
# author: Olivia Torresan, Dax Kellie
# date: 5 May, 2023
#---

make_paper_thumbnail <- function(title,
                                 authors,
                                 main_colour,
                                 text_colour,
                                 line_colour) {
  p <- ggplot() +
    geom_textbox(aes(x = 0.47,
                     y = 0.6,
                     label = {title}),
                 size = 15,
                 width = unit(29, "lines"),
                 stat = "unique",
                 family = "Poppins",
                 colour = {text_colour},
                 fill = NA,
                 box.colour = NA) +
    geom_textbox(aes(x = 0.45,
                     y = 0.2,
                     label = {authors}),
                 size = 10,
                 width = unit(27, "lines"),
                 stat = "unique",
                 family = "Poppins",
                 colour = {text_colour},
                 fill = NA,
                 box.colour = NA) +
    geom_segment(aes(x = 0, xend = 1, y = 0.1, yend = 0.1),
                 # fill = "#DAA983",
                 linewidth = 5,
                 color = {line_colour}) +
    scale_y_continuous(limits = c(0,1),
                       expand = c(0,0)) +
    scale_x_continuous(limits = c(0, 1),
                       expand = c(0,0)) +
    theme(panel.border = element_blank(),
          panel.background = element_rect(fill = {main_colour}, color = NA),
          plot.background = element_rect(fill = {main_colour}), # remove white space from x/y region
          panel.grid = element_blank(), # remove labels, ticks etc.
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          plot.margin = unit(c(0,0,0,0),"cm"),
          panel.spacing = unit(c(0,0,0,0), "cm"))
  p


  # Save
  showtext_opts(dpi = 600)

  ggsave(p, file = here("research", "images", "thumbnail.png"),
         device = "png",
         dpi = 600,
         width = 7,
         height = 7,
         unit = "in"
  )
}




