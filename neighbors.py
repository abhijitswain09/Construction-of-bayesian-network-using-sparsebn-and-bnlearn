from collections import defaultdict, deque
import sys

def construct_graph(file_path):
    graph = defaultdict(list)

    with open(file_path, 'r') as file:
        for line in file:
            source, target = line.strip().split()
            graph[source].append(target)
            graph[target].append(source)

    return graph

def find_neighbors(graph, start_node):
    # Dictionary to store the levels of each node
    levels = {start_node: 0}

    # Dictionary to store the neighbors at each level
    neighbors = {0: [start_node]}

    # Queue to perform breadth-first search
    queue = deque([(start_node, 0)])

    while queue:
        node, level = queue.popleft()

        # Stop exploring further if we have reached the 3rd level
        if level >= 3:
            break

        for neighbor in graph[node]:
            if neighbor not in levels:
                # Add the neighbor to the corresponding level
                if level + 1 not in neighbors:
                    neighbors[level + 1] = []
                neighbors[level + 1].append(neighbor)

                # Update the level of the neighbor
                levels[neighbor] = level + 1

                # Add the neighbor to the queue for further exploration
                queue.append((neighbor, level + 1))

    return neighbors
edge_file_path = '/media/scbb/data3/Abhijit/TF_NETWORK/N1/CytoscapeInput-edges-black-blue-brown-pink-turquoise-yellow.txt'

# Starting node for which we want to find neighbors
start_node = (sys.argv[1])

# Construct the graph from the edge connection file
graph = construct_graph(edge_file_path)

# Find the neighbors
result = find_neighbors(graph, start_node)

# Print the 1st, 2nd, and 3rd level neighbors
for level, neighbors in result.items():
    print(f"{level} level neighbors: {neighbors}")
