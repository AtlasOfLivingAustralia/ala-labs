# script to parse author names from html files in `_posts` and add to 
# .Rmd files in `_people`

# libraries etc
library(xml2)


# locate author files that end in .html in _posts
people_paths <- here("SDS_website", "_people")
people_dirs <- paste(people_paths, list.files(people_paths), sep = "/")
author_rmd_files <- unlist(lapply(people_dirs, function(a){
  all_files <- list.files(a)
  return(
    paste(a, 
      all_files[grepl(".Rmd$", all_files)],
      sep = "/"))
}))

# get author names and associated titles, links
rmd_text <- scan(author_rmd_files[1], what = "character", sep = "\n")
author <- gsub("title:\\s|\"", "", rmd_text[2])



## locate _post files, and detect author names
html_text <- scan(html_files[1], what = "character", sep = "\n")
# row <- which(grepl("class=\"d-title\"", html_text)) + 1
# which(grepl("article:author", html_text)) # this is for finding the author in the article
author <- gsub("<h1>|</h1>", "", html_text[row])

# for each author, add to Rmd


# re-parse author HTML files

