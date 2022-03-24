# script to build the website
# note that working directory should be the site directory (`ala-labs`)

library(rmarkdown)
library(here)

# pre-calc
# add up to 3 recently-authored blog posts to each author profile
source(here("R", "parse_author_articles.R"))

# add tree-based blog navigation
source(here("R", "plotly_navigation.R"))

# build
rmarkdown::render_site()