# ---
# title: Make and save a research highlight thumbnail
# authors: Dax Kellie, Olivia Torresan
# date: 8 May 2023
# ---


#------------ Edit these parameters for highlighted paper ---------------------#

title <- "Open access habitat suitability maps of 10,633 Australian flora & fauna species"
authors <- "Archibald et al. 2024"
main_colour <- "#A191B2" # use an ALA colour as your main colour
text_colour <- "#FFFFFF" # choose your own matching text colour: https://coolors.co/
line_colour <- "#B7CD96" # choose your own matching line colour


# ALA colours to use as main colour
ala_colours <- c("#E06E53", "#B8573E", "#667073", "#FFC557",
                 "#B7CD96", "#6BDAD5", "#EEECEA", "#9E9E9F",
                 "#222322", "#003A70", "#A191B2", "#691C32")


#----------- Now run the code below to make and save thumbnail ----------------#

# load packages
library(ggtext)
library(extrafont)
library(ggplot2)
library(here)
library(scales)
library(glue)
library(showtext)

source(here("R", "functions_thumbnail.R"))

# Load font
font_add_google("Poppins", bold.wt = 500)
showtext_auto(enable = TRUE)

# Now run this function to generate and save thumbnail
# Thumbnails are saved in ./research/images/thumbnail.png
# Saved images will not be rendered until placed in specific paper folder
make_paper_thumbnail(title, authors, main_colour, text_colour, line_colour)


#------------------------------------------------------------------------------#
# When happy with thumbnail, copy/paste thumbnail.png into specific paper folder
#------------------------------------------------------------------------------#
