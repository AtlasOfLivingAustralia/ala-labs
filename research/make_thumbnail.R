# ---
# title: Make and save a research highlight thumbnail
# authors: Dax Kellie, Olivia Torresan
# date: 8 May 2023
# ---


#------------ Edit these parameters for highlighted paper ---------------------#


title <- "Protecting Australia's freshwater fish at risk of extinction"
authors <- "Linterman et al. 2024"
main_colour <- "#FFEDCF" # use an ALA colour as your main colour
text_colour <- "#C44D34" # choose your own matching text colour: https://coolors.co/
line_colour <- "#EB9D07" # choose your own matching line colour


# ALA primary colours
ala_p_colours <- c("#F26649", "#C44D34", "#637073")

# ALA secondary colours 
ala_s_colours <- c("#F2F2F2", "#9D9D9D", "#212121")

# ALA extended colours

ala_ext_colours <- c("#FFC557", "#B7CD96", "#68DAD5", "#003A70", "#A191B2", "#691C32")

# ALA expanded colours 

ala_exp_colours <- c("#EB9D07", "#076164", "#1B5D81", "#5B397D", "#FFEDCF", "#38613D", "#C3EDEF", "#921D11")

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
