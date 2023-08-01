library(igraph)

# Read the edge connections from file
edges <- read.table("cyt_fullnetwork.txt", header = FALSE)

# Create an igraph graph object
graph <- graph_from_data_frame(edges, directed = TRUE)

# Starting node for which we want to find neighbors
start_node <- "ABF1"

# Find the 1st, 2nd, and 3rd level neighbors
neighbors <- ego(graph, order = 3, nodes = start_node, mode = "out")[[1]]

# Set the level attribute for each node
V(graph)$level <- 0  # Initialize all nodes with level 0
V(graph)[V(graph)$name == start_node]$level <- 1  # Set level 1 for the starting node

if (length(neighbors) > 0) {
  neighbor_indices <- match(neighbors, V(graph)$name)
  valid_indices <- !is.na(neighbor_indices)
  valid_levels <- !is.na(neighbors$level)
  V(graph)$level[neighbor_indices[valid_indices & valid_levels]] <- neighbors$level[valid_indices & valid_levels]
}
# Create a layout for the graph
layout <- layout_with_kk(graph)

# Plot the graph using plot
tkplot(graph, layout = layout, vertex.color = V(graph)$level, vertex.frame.color = "black",
     vertex.label = V(graph)$name, edge.arrow.size = 0.5)
