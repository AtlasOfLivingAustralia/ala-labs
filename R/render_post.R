# Render posts
# (fill in the correct information for your rmarkdown file)
# (do not save over this file)

library(galah)
galah_config(email = "your-email@email.com")

library(here)
path <- here("_posts", "folder", "file-name.Rmd")
rmarkdown::render(path)

