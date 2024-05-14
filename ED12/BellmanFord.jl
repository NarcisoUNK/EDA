# A struct to represent a weighted edge in a graph
struct Edge
    src::Int
    dest::Int
    weight::Int
end

# A struct to represent a connected, directed and weighted graph
struct Graph
    # V -> Number of vertices, E -> Number of edges
    V::Int
    E::Int

    # graph is represented as an array of edges
    edge::Vector{Edge}
end

# Creates a graph with V vertices and E edges
function create_graph(V::Int, E::Int)
    graph = Graph(V, E, Vector{Edge}(undef, E))
    return graph
end

# A utility function to print the solution
function print_arr(dist::Vector{Int}, V::Int)
    for i in 1:V
        println("Vertex $i -> Distance: $(dist[i])")
    end
end

# The main function that finds shortest distances from src to
# all other vertices using Bellman-Ford algorithm. The function
# also detects negative weight cycle
function bellman_ford(graph::Graph, src::Int)
    V = graph.V
    E = graph.E
    dist = fill(typemax(Int), V)

    # Step 1: Initialize distances from src to all other
    # vertices as INFINITE
    dist[src + 1] = 0

    # Step 2: Relax all edges |V| - 1 times. A simple
    # shortest path from src to any other vertex can have
    # at-most |V| - 1 edges
    for i in 1:V - 1
        for j in 1:E
            u = graph.edge[j].src
            v = graph.edge[j].dest
            weight = graph.edge[j].weight
            if dist[u + 1]!= typemax(Int) && dist[u + 1] + weight < dist[v + 1]
                dist[v + 1] = dist[u + 1] + weight
            end
        end
    end

    # Step 3: check for negative-weight cycles.  The above
    # step guarantees shortest distances if graph doesn't
    # contain negative weight cycle.  If we get a shorter
    # path, then there is a cycle.
    for i in 1:E
        u = graph.edge[i].src
        v = graph.edge[i].dest
        weight = graph.edge[i].weight
        if dist[u + 1]!= typemax(Int) && dist[u + 1] + weight < dist[v + 1]
            println("Graph contains negative weight cycle")
            return
        end
    end

    print_arr(dist, V)

    return
end

# Driver's code
function main()
    # Let us create the graph given in the above example
    V = 5 # Number of vertices in graph
    E = 8 # Number of edges in graph
    graph = create_graph(V, E)

    # add edge 0-1 (or A-B in above figure)
    graph.edge[1] = Edge(0, 1, -1)

    # add edge 0-2 (or A-C in above figure)
    graph.edge[2] = Edge(0, 2, 4)

    # add edge 1-2 (or B-C in above figure)
    graph.edge[3] = Edge(1, 2, 3)

    # add edge 1-3 (or B-D in above figure)
    graph.edge[4] = Edge(1, 3, 2)

    # add edge 1-4 (or B-E in above figure)
    graph.edge[5] = Edge(1, 4, 2)

    # add edge 3-2 (or D-C in above figure)
    graph.edge[6] = Edge(3, 2, 5)

    # add edge 3-1 (or D-B in above figure)
    graph.edge[7] = Edge(3, 1, 1)

    # add edge 4-3 (or E-D in above figure)
    graph.edge[8] = Edge(4, 3, -3)

    # Function call
    bellman_ford(graph, 0)

    return
end

main()