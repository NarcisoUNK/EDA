using DataStructures

# Define the adjacency list node
mutable struct AdjListNode
    v::Int
    weight::Int
end

# Class to represent a graph using adjacency list
mutable struct DAG
    V::Int    # Number of vertices
    adj::Vector{Vector{AdjListNode}}  # Adjacency lists

    # Constructor
    function DAG(V)
        new(V, [Vector{AdjListNode}() for i in 1:V])
    end

    # Function to add an edge to the graph
    function addEdge(g::DAG, u::Int, v::Int, weight::Int)
        node = AdjListNode(v, weight)
        push!(g.adj[u], node) # Add v to u's list
    end

    # Function to find shortest paths from given source vertex
    function shortestPath(g::DAG, s::Int)
        stack = Stack{Int}()
        dist = fill(typemax(Int), g.V)

        # Mark all the vertices as not visited
        visited = falses(g.V)

        # Topological Sort
        for i in 1:g.V
            if!visited[i]
                topologicalSortUtil(i, visited, stack, g, dist)
            end
        end

        # Initialize distances to all vertices as infinite
        # and distance to source as 0
        dist[s] = 0

        # Process vertices in topological order
        while!isempty(stack)
            u = pop!(stack)

            # Update distances of all adjacent vertices
            for node in g.adj[u]
                if dist[node.v] > dist[u] + node.weight
                    dist[node.v] = dist[u] + node.weight
                end
            end
        end

        # Print the calculated shortest distances
        for i in 1:g.V
            print("$(dist[i]) ")
        end
        println()
    end
end

# Recursive function used by shortestPath
function topologicalSortUtil(v::Int, visited::Vector{Bool}, stack::Stack{Int}, g::DAG, dist::Vector{Int})
    # Mark the current node as visited
    visited[v] = true

    # Recur for all the vertices adjacent to this vertex
    for i in g.adj[v]
        if!visited[i.v]
            topologicalSortUtil(i.v, visited, stack, g, dist)
        end
    end

    # Push current vertex to stack which stores topological sort
    push!(stack, v)
end

# Create a graph given in the above diagram
g = DAG(6)
addEdge(g, 0, 1, 5)
addEdge(g, 0, 2, 3)
addEdge(g, 1, 3, 6)
addEdge(g, 1, 2, 2)
addEdge(g, 2, 4, 4)
addEdge(g, 2, 5, 2)
addEdge(g, 2, 3, 7)
addEdge(g, 3, 4, -1)
addEdge(g, 4, 5, -2)

# Find shortest paths from vertex 1
shortestPath(g, 1)