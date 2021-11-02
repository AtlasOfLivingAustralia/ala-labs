# circular plotting functions

# TREE OPERATIONS
prep_tree <- function(tree){
  
  x <- Clone(tree)
  # create a sequence showing min of index to leaves in sub-branches
  leaves <- Traverse(x, filterFun = isLeaf)
  # length(leaves)
  x$Set(leaf_min = NA)
  Set(leaves, leaf_min = seq_along(leaves))
  x$Do(
    function(a){
      a$leaf_min <- Aggregate(
        node = a, 
        attribute = "leaf_min", 
        aggFun = function(b){min(b, na.rm = TRUE)})},
    traversal = "post-order")
  # print(x, "leaf_min", limit = NULL)

  # repeat for max
  x$Set(leaf_max = NA)
  Set(leaves, leaf_max = seq_along(leaves))
  x$Do(
    function(a){
      a$leaf_max <- Aggregate(
        node = a, 
        attribute = "leaf_max", 
        aggFun = function(b){max(b, na.rm = TRUE)})},
    traversal = "post-order")
  # print(x, "leaf_min", "leaf_max", limit = NULL)

  # add is_leaf as a column
  x$Set(is_leaf = FALSE)
  Set(leaves, is_leaf = TRUE)

  return(x)
}

prune_leafless_branches <- function(tree, value = "order"){
  tree$Do(
    function(a){a$rank_value <- as.numeric(a$rank == value)}) 
  tree$Do(
    function(a){a$rank_value <- Aggregate(
      node = a, attribute = "rank_value", aggFun = sum)},
    traversal = "post-order")
  invisible(Prune(tree, pruneFun = function(a){a$rank_value > 0}))
  tree$Set(rank_value = NULL) # remove column used for calculations
  return(tree)
}

# SEGMENT POLYGONS
get_segments <- function(df){
  # get coordinates for circle segments to show higher taxa
  segment_list <- lapply(
    split(df, seq_len(nrow(df))),
    function(a){
      result <- calc_segment(
        from = a$segment_start,
        to = a$segment_end,
        k = a$level,
        width = 0.6)
      result$rank <- a$rank
      result$level <- a$level
      result$name <- a$name
      return(result)
    })
  segment_list <- lapply(
    seq_along(segment_list), 
    function(a){
      result <- segment_list[[a]]
      result$group <- a
      return(result)})
  segment_df <- do.call(rbind, segment_list)
  return(segment_df)
}

# make a segment
calc_segment <- function(
  from, to, # start and end of segment in degrees
  k, # radius
  width = 0.1, # how wide should the polygon be? Same units as k
  res = 3
){
  half_width <- 0.5 * width
  radians_seq <- seq(
    from = from, 
    to = to, 
    length.out = (to - from) * res) * (pi / 180) 
  radians_seq <- radians_seq + (pi/2) ## add 90 degrees so everything starts from vertical
  values <- data.frame(
    theta = radians_seq,
    x = c(
      -((k - half_width) * cos(radians_seq)), # minus is so that the circle moves clockwise
      rev(-((k + half_width) * cos(radians_seq)))
    ), 
    y = c((k - half_width) * sin(radians_seq),
      rev((k + half_width) * sin(radians_seq)))
  ) 
  values <- rbind(values, values[1, ]) # close the end
  return(values)
}

## SEGMENT TEXT
get_segment_text <- function(df){
  text_list <- lapply(
    split(df, seq_len(nrow(df))),
    function(a){
      calc_segment_text(
        start = a$segment_start,
        end = a$segment_end,
        # start_angle = mean(c(a$segment_start, a$segment_end)),
        label = a$name,
        k = a$level)
    }
  )
  return(do.call(rbind, text_list))
}

calc_segment_text <- function(start, end, label, k, gap = 0.2
){
  start_angle <- mean(c(start, end))
  if(gap/k > 1){stop("gap too large")}
  letter_angle <- asin(gap/k) * 180/pi # distance between letters in degrees, given k
  text_df <- data.frame(label = strsplit(label, "")[[1]])
  angle_vec <- seq_len(nrow(text_df)) * letter_angle
  angle_vec <- angle_vec - mean(angle_vec) + start_angle
  if(min(angle_vec) < start & max(angle_vec) > end){
    return(NULL)
  }else{
    text_df$theta <- ((angle_vec + 90) * (pi / 180))
    text_df$x <- -k * cos(text_df$theta)
    text_df$y <- k * sin(text_df$theta)
    if(start_angle < 90 | start_angle > 270){
      text_df$rotation <- 360 - angle_vec
    }else{
      text_df$label <- rev(text_df$label)
      text_df$rotation <- 180 - angle_vec
    }
    return(text_df)
  }
}

# LEAVES
calc_leaf_text <- function(angle, label, k, width, gap){
  theta <- (angle + 90) * (pi / 180)
  k_adj <- (k - 1) + (width * 0.5) + gap
  text_df <- data.frame(
    label = label,
    x = -k_adj * cos(theta),
    y = k_adj * sin(theta),
    rotation = 90 - angle,
    hjust = 0
  )
  return(text_df)
}


get_leaf_text <- function(df){
  df_leaves <- df[df$rank == "order", ]
  leaf_list <- lapply(
    split(df_leaves, seq_len(nrow(df_leaves))),
    function(a){
      calc_leaf_text(
        angle = mean(c(a$segment_start, a$segment_end)),
        label = a$name,
        k = a$level,
        width = 0.6,
        gap = 0.1)
    }
  )
  leaf_df <- do.call(rbind, leaf_list)
  inverted_text <- leaf_df$rotation < -90
  leaf_df$rotation[inverted_text] <- 180 + leaf_df$rotation[inverted_text]
  leaf_df$hjust[inverted_text] <- 1
  return(leaf_df)
}

# MISC
# order ranks
factorize_ranks <- function(df){
  df$index <- seq_len(nrow(df))
  df <- merge(df, find_ranks(), 
    by.x = "rank", by.y = "name",
    all.x = TRUE, all.y = FALSE)
  df$id[df$rank == "informal"] <- 100
  df$id[df$rank == "unranked"] <- 100
  df$id <- as.numeric(as.factor(df$id))
  rank_order <- unlist(lapply(
    split(df$rank, df$id),
    function(a){a[[1]]}))
  df$rank_factor <- factor(
    df$id,
    levels = seq_along(rank_order),
    labels = str_to_title(rank_order))
  df <- df[order(df$index), ]
  return(df$rank_factor)
}
