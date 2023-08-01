library(igraph)

# Define the edges
edges <- read.table("full_network.txt", header = FALSE)

# Create an igraph graph object
graph <- graph_from_data_frame(edges, directed = TRUE)

# Starting node for which we want to find neighbors
start_node <- "LOS1"

# Find the 1st, 2nd, and 3rd level neighbors
neighbors <- ego(graph, order = 1, nodes = start_node, mode = "all")[[1]]

# Extract the subgraph consisting of the neighbors
subgraph <- subgraph(graph, vids = neighbors)

# Plot the subgraph
plot(subgraph, edge.arrow.size = 0.5, vertex.color = "lightblue", vertex.size = 20,
     vertex.label.color = "black", vertex.label.cex = 0.8, edge.color = "gray")

