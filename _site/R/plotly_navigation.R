# code to plot a basic dendrogram for use as a site navigator using plotly

# load libraries
library(plotly)
library(ggplot2)
library(htmlwidgets)
library(data.tree)
library(tidygraph)
library(ggraph)
library(dplyr)
base_url <- "https://labs.ala.org.au/"

# build a data.tree with requisite nodes
Eukaryota <- Node$new("Eukaryota")
  Animalia <- Eukaryota$AddChild("Animalia")
    Chordata <- Animalia$AddChild("Chordata")
      Aves <- Chordata$AddChild("Aves")
      Mammalia <- Chordata$AddChild("Mammalia")
  Plantae <- Eukaryota$AddChild("Plantae")
    

# ensure 'levels' from original graph are preserved for plotting
graph_levels <- ToDataFrameTree(Eukaryota, "name", "level")[, 2:3]

# convert graph to tbl
tg <- tidygraph::as_tbl_graph(Eukaryota)

# add levels and leaves to graph
tg <- tg %>% 
  activate(nodes) %>%
  left_join(., graph_levels) %>%
  mutate(leaf = node_is_leaf())
  
# force layout to follow levels from original tree
tg_layout <- create_layout(tg, "dendrogram")
tg_layout$y <- max(tg_layout$level) - tg_layout$level

# append this to the graph
tg <- tg %>% 
    mutate(x = tg_layout$x, y = tg_layout$y, graph = 'original')

# to get the initial plot
graph <- ggraph(tg) +
  geom_edge_diagonal() +
  geom_node_text(aes(label = name))

# extract data from the plot to pass to plotly
point_data <- layer_data(graph, 2)[, c("x", "y", "label")]
point_data$y <- max(point_data$y) - point_data$y
# add leaf status
point_data <- merge(
  point_data,
  as.data.frame(select(tg, "name", "leaf")),
  by.x = "label",
  by.y = "name")
point_data$link <- paste0(
  base_url,
  "posts.html#category:",
  point_data$label)

# edges
edge_data <- layer_data(graph, 1)[, c("x", "y", "group")]
edge_data$y <- max(edge_data$y) - edge_data$y

# draw dendrogram using plotly, 
# with labels for terminal nodes
# and hover text for all nodes
# on click, link to blog categories
p <- edge_data %>% 
  group_by(group) %>%
  plot_ly() %>%
  add_paths(
    x = ~y, 
    y = ~x,
    color = I("#9D9D9D"),
    hoverinfo = "none") %>%
  add_markers(
    data = point_data,
    x = ~y,
    y = ~x,
    text = ~label,
    color = I("#F26649"),
    marker = list(size = 10),
    hoverinfo = "text",
    hoverlabel = list(
      bgcolor = I("#F26649"),
      bordercolor = I("#F26649"),
      font = list(color = "white")),
    customdata = ~link
  ) %>%
  add_text(
    data = point_data[point_data$leaf, ],
    x = ~y + 0.3,
    y = ~x,
    text = ~label,
    textposition = "middle right",
    hoverinfo = "none") %>%
  layout(
    showlegend = FALSE,
    xaxis = list(
      visible = FALSE, 
      range = c(-0.5, 5),
      fixedrange = TRUE),
    yaxis = list(
      visible = FALSE,
      fixedrange = TRUE),
    margin = list(l = 10, r = 10, t = 10, b = 10, pad = 0)) %>%
  config(displayModeBar = FALSE)


# add live links
plotly_image <- as_widget(onRender(
  p, "
  function(el) {
    el.on('plotly_click', function(d) {
      var url = d.points[0].customdata;
      window.open(url, '_parent');
    });
  }
"))

# export html to a useable location
dir_path <- here("_site", "images", "plotly")
if(!dir.exists(dir_path)){
  dir.create(dir_path)
}
saveWidget(plotly_image, 
  here("images", "plotly", "taxonomy_navigation.html"))