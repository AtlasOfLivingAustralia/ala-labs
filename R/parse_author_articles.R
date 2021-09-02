# script to parse author names from html files in `_posts` and add to 
# .Rmd files in `_people`

# libraries etc
library(data.table)
library(rmarkdown)
library(here)
source("R/parse_functions.R")

# locate author files that end in .html in _posts
# Q: group this path search and extraction to a function?
people_paths <- here("_people")
author_rmd_files  <- get_nested_files(people_paths, suffix = "Rmd")

# get author names and associated titles, links
authors <- unlist(lapply(author_rmd_files$absolute_path, function(a){
  rmd_text <- scan(a, what = "character", sep = "\n")
  return(gsub("title:\\s|\"", "", rmd_text[2]))
}))

# convert to df
author_df <- data.frame(
  author = authors,
  author_absolute_path = author_rmd_files$absolute_path,
  author_relative_path = author_rmd_files$relative_path)


## locate _post files, and detect author names
post_paths <- here("_posts")
post_html_files <- get_nested_files(post_paths, "html")

# get data.frame of post metadata
post_content_list <- lapply(post_html_files$absolute_path, parse_blog_html)
post_df <- rbindlist(post_content_list, fill = TRUE)
post_df$blog_relative_path <- post_html_files$relative_path

# remove irrelevant info from dates
post_df$publishedDate <- substr(post_df$publishedDate, 1, 10)
# remove line breaks from descriptions
post_df$description <- gsub("\\n", " ", post_df$description, fixed = TRUE)
  
# merge author and post information
merge_df <- merge(author_df, post_df, all.x = FALSE, all.y = TRUE)

# for each author, add to Rmd
lapply(
  split(merge_df, merge_df$author_relative_path),
  add_author_posts)

# re-parse author HTML files
lapply(unique(merge_df$author_absolute_path), render)

