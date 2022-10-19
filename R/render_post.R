#------------------------------------------------------------------------------#
# Render posts
# (do not save over this file)
# (fill in the correct information for the rmarkdown file you want to render)
#------------------------------------------------------------------------------#

# |(I recommend copying the following code and pasting it again just below or in a new local R script.
# |Then you can fill in the correct details to render your post and delete when finished)

library(galah)
galah_config(email = "your-email@email.com", verbose = FALSE)

library(here)
path <- here("_posts", "name-of-post-folder", "file-name.Rmd")
rmarkdown::render(path)


