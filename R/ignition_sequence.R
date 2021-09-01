# build this website
# note that working directory should be one above `SDS_website`

library(rmarkdown)

# pre-calc
# add section here to add article information to authorship pages

# build
rmarkdown::render_site("SDS_website")

# post-calc
source(here("SDS_website", "R", "plotly_navigation.R"))