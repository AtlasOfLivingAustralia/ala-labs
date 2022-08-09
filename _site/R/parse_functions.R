# Functions for updating author pages

get_nested_files <- function(path, suffix){
  dirs_relative <- list.files(path)
  dirs_absolute <- paste(path, dirs_relative, sep = "/")
  # dirs <- paste(path, list.files(path), sep = "/")
  files <- unlist(lapply(dirs_absolute, function(a){
    all_files <- list.files(a)
    relevant_files <- all_files[grepl(paste0(".", suffix, "$"), all_files)]
    return(relevant_files)}))
  result <- data.frame(
    relative_path = paste0("/", dirs_relative, "/", files),
    local_path = paste0(dirs_absolute, "/", files)
  )
  return(result)
}

parse_blog_html <- function(a){
  # import
  html_text <- scan(a, what = "character", sep = "\n")
  # get all article metadata
  # first work out where metadata is stored
  row <- which(grepl("<script id=\"distill-front-matter\" type=\"text/json\">", html_text)) + 1
  # extract only the relevant metadata (note: assumes each blog has only 1 author)
  text_raw <- strsplit(html_text[row],",")[[1]]
  text_raw <- gsub("^\\{|\\}$", "", text_raw) # remove start and end brackets
  # paste broken strngs back together
  text_list <- split(
    text_raw,
    cumsum(as.numeric(grepl("^\"", text_raw))))
  text_cleaned <- unlist(lapply(
    text_list,
    function(x){paste(x, collapse = ",")}))
  text_cleaned <- gsub("\"|\\{|\"authors\":\\[\\{\"", "", text_cleaned)
  # convert to data.frame
  # note: assumes titles and descriptions don't contain ":"
  split_list <- strsplit(text_cleaned, ":")
  text_df <- as.data.frame(lapply(split_list,
    function(a){a[2]}))
  colnames(text_df) <- unlist(lapply(split_list,
    function(a){a[1]}))
  # text_df <- as.data.frame(text_list)
  # colnames(text_df) <- c("tag", "content")
  text_df$blog_local_path <- a
  return(text_df)
}

add_author_posts <- function(a){
  # import rmd
  rmd_text <- scan(a$author_local_path[1], what = "character", sep = "\n")

  # If there are already posts, remove them
  post_lookup <- rmd_text == "<h2>Posts</h2>"
  if(any(post_lookup)){
    rmd_text <- rmd_text[seq_len(which(post_lookup) - 1)]
  }
  # write text
  texts <- a[order(a$publishedDate, decreasing = TRUE), ]
  texts <- texts[seq_len(min(c(3, nrow(texts)))), ]
  text_list <- lapply(
    split(texts, seq_len(nrow(texts))),
    function(x){
      paste0(
        "<a href='",
          x$blog_url,
        "'>",
        x$title,
        "</a><br><em>",
        x$description,
        "</em><br><br>"
      )
    })
  text_final <- c(rmd_text, "<h2>Posts</h2>", "", unlist(text_list))

  # save
  write.table(text_final,
    file = a$author_local_path[1],
    sep = "\n",
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE)
}
