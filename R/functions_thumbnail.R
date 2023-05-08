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
                     label = lab_long),
                 size = 15,
                 width = unit(29, "lines"),
                 stat = "unique",
                 family = "Poppins",
                 colour = {text_colour},
                 fill = NA,
                 box.colour = NA) +
    geom_textbox(aes(x = 0.45,
                     y = 0.2,
                     label = authors),
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


#------------------------------------------------------------------------------#

#### Generate ALA colour palette that is closest match to image

# packages
library(ggplot2)
library(here)
library(scales)
library(paletter) # remotes::install_github("AndreaCirilloAC/paletter")

# CHOOSE YOUR IMAGE

#generate palette from selected image
image_pal <- create_palette(
  image_path = here(""),
  type_of_variable = "categorical",
  number_of_colors = 5)
image_pal


# MATCH IMAGE PALETTE TO CLOSEST ALA PALETTE COLOURS

# Sample list of hex codes (ALA colours)
hex_list1 <- c("#E06E53", "#B8573E", "#667073", "#FFC557", "#B7CD96", "#6BDAD5", "#EEECEA", "#9E9E9F", "#222322","#003A70", "#A191B2", "#691C32")

# List of hex codes to match against - what we extracted from our image
hex_list2 <- image_pal

# Function to get the closest match from hex_list2 for a given hex code
get_closest_match <- function(hex_code) {

  # Convert hex code to RGB
  rgb_code <- col2rgb(hex_code)

  # Calculate distance between each color in the two lists
  distances <- apply(col2rgb(hex_list2), 2, function(x) sum((x - rgb_code)^2))

  # Return the hex code with the closest match
  hex_list2[which.min(distances)]
}

# Get the closest match for each hex code in hex_list1
closest_matches <- sapply(hex_list1, get_closest_match)

# Remove duplicates and NA values and keep only the first three elements
closest_matches <- head(unique(na.omit(closest_matches)), 3)

# Print the matching hex codes
print(closest_matches)

# Visualise the matching hex codes
show_col(closest_matches)

