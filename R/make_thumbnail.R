# ---
# title: Make and save a research highlight thumbnail
# authors: Dax Kellie, Olivia Torresan
# date: 8 May 2023
# ---

# load packages
library(ggtext)
library(extrafont)
library(ggplot2)
library(here)
library(scales)
library(glue)
library(showtext)

source(here("R", "functions-thumbnail.R"))

# Load font
font_add_google("Poppins", bold.wt = 500)
showtext_auto(enable = TRUE)

# ALA colours
ala_colours <- c("#E06E53", "#B8573E", "#667073", "#FFC557",
                 "#B7CD96", "#6BDAD5", "#EEECEA", "#9E9E9F",
                 "#222322", "#003A70", "#A191B2", "#691C32")

# Edit these parameters for highlighted paper
#
title <- "Changing farming climates: The future of growing peanuts"
authors <- "Haerani et al. 2023"
main_colour <- "#B7CD96" # use an ALA colour as your main colour
text_colour <- "#754C06" # choose your own matching text colours: https://coolors.co/
line_colour <- "#CB8752"

# Save thumbnail in ./research/images/thumbnail.png
make_paper_thumbnail(title, authors, main_colour, text_colour, line_colour)

# If happy with result, copy/paste thumbnail image in highlights folder
