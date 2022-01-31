# Render posts
# (do not save over this file)
# (fill in the correct information for the rmarkdown file you want to render)

## Step 1: Update your post's renv lockfile

# If you have added or removed any packages to a post, update your renv snapshot
# (no need to use `here` to locate the folder, refinery will do this automatically)
refinery::renv_snapshot("name-of-post-folder")


## Step 2: Restart R

# If you were just working on a post, restart your R session (Ctl/Cmd + Shift + F10)


## Step 3: Render your post

# Now run the following code:
# (I recommend copying and pasting below with correct details to render your post, then delete when finished)

library(galah)
galah_config(email = "your-email@email.com")

library(here)
path <- here("_posts", "folder", "file-name.Rmd")
rmarkdown::render(path)

