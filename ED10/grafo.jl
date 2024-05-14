"""
EDA 2024
Graphs.jl
Martinho Caeiro
30/04/2024

Gestão de Memória de Grafos
"""

mutable struct Vertice
    color::Symbol
    d::Union{Int, Nothing}
    pi::Union{Int, Nothing}
    f::Union{Int, Nothing}
end

struct Grafo
    num_vertices::Int
    vertices::Vector{Vertice}
    matriz_adj::Matrix{Bool}
    lista_adj::Vector{Vector{Int}}
end

function initialize_graph(num_vertices::Int)
    vertices = [Vertice(:white, nothing, nothing, nothing) for _ in 1:num_vertices]
    matriz_adj = falses(num_vertices, num_vertices)
    lista_adj = [Int[] for _ in 1:num_vertices]
    return Grafo(num_vertices, vertices, matriz_adj, lista_adj)
end

function adicionar_aresta!(grafo::Grafo, origem::Int, destino::Int)
    grafo.matriz_adj[origem, destino] = true
    push!(grafo.lista_adj[origem], destino)
end

function remover_aresta!(grafo::Grafo, origem::Int, destino::Int)
    grafo.matriz_adj[origem, destino] = false
    grafo.lista_adj[origem] = filter(x -> x != destino, grafo.lista_adj[origem])
end

function adicionar_vertice!(grafo::Grafo)
    grafo.num_vertices += 1
    push!(grafo.vertices, Vertice(:white, nothing, nothing, nothing))
    resize!(grafo.matriz_adj, grafo.num_vertices, grafo.num_vertices)
    push!(grafo.lista_adj, Int[])
end

function remover_vertice!(grafo::Grafo, vertice::Int)
    grafo.num_vertices -= 1
    grafo.vertices = grafo.vertices[setdiff(1:end, vertice)]
    grafo.matriz_adj = grafo.matriz_adj[setdiff(1:end, vertice), setdiff(1:end, vertice)]
    grafo.lista_adj = grafo.lista_adj[setdiff(1:end, vertice)]
    for i in 1:length(grafo.lista_adj)
        grafo.lista_adj[i] = filter(x -> x != vertice, grafo.lista_adj[i])
    end
end

function breadth_search!(G, s)
    for u in G.vertices
        u.color = :white
        u.d = nothing
        u.pi = nothing
    end

    s.color = :gray
    s.d = 0
    s.pi = nothing
    Q = [s]

    while !isempty(Q)
        u = popfirst!(Q)
        index = findfirst(x -> x === u, G.vertices)  # find the index of u
        for v in G.lista_adj[index]
            if G.vertices[v].color == :white
                G.vertices[v].color = :gray
                G.vertices[v].d = u.d + 1
                G.vertices[v].pi = u
                push!(Q, G.vertices[v])  # push the vertex object, not the index
            end 
        end
        G.vertices[index].color = :black
    end

function depth_search!(G, u, time)
    time += 1
    u.d = time
    u.color = :gray

    for v in G.lista_adj[u]
        if G.vertices[v].color == :white
            G.vertices[v].pi = u
            depth_search!(G, G.vertices[v], time)
        end  
    end

    u.color = :black
    time += 1
    u.f = time
end

function topological_sort!(G)
    time = 0
    for u in G.vertices
        u.color = :white
        u.d = nothing
        u.f = nothing
        u.pi = nothing
    end

    for u in G.vertices
        if u.color == :white
            depth_search!(G, u, time)
        end
    end

    topological_sort = filter(u -> u.f !== nothing, G.vertices)
    return reverse(sort(topological_sort, by = u -> u.f))
end

function strongly_connected!(G)
    time = 0
    for u in G.V
        if u.color == :white
            depth_search!(G, u, time)
        end
    end

    G_transpose = transpose_graph(G)

    time = 0
    for u in G_transpose.V
        if u.color == :white
            depth_search!(G_transpose, u, time)
        end
    end

    strongly_connected_components = []

    for u in G_transpose.V
        if u.f > 0
            push!(strongly_connected_components, u)
        end
    end

    return strongly_connected_components
end

function connected!(G)
    for v in 1:G.num_vertices
        MAKE_SET(v)
    end

    for u in 1:G.num_vertices
        for v in G.lista_adj[u]
            if FIND_SET(u) != FIND_SET(v)
                UNION(u, v)
            end
        end
    end
end

function main()
    # Initialize a graph with a certain number of vertices
    num_vertices = 5
    G = initialize_graph(num_vertices)

    # Add some edges to the graph
    adicionar_aresta!(G, 1, 2)
    adicionar_aresta!(G, 1, 3)
    adicionar_aresta!(G, 2, 4)
    adicionar_aresta!(G, 3, 4)
    adicionar_aresta!(G, 4, 5)

    # Print the adjacency list representation of the graph
    println("Adjacency list representation:")
    for i in 1:num_vertices
        println("$i: ", G.lista_adj[i])
    end

    # Perform breadth-first search from vertex 1a
    println("\nBreadth-first search from vertex 1:")
    breadth_search!(G, G.vertices[1])
    for i in 1:num_vertices
        println("Vertex $i: d = $(G.vertices[i].d), pi = $(G.vertices[i].pi)")
    end

    # Perform depth-first search and topological sort
    println("\nTopological sort:")
    sorted_vertices = topological_sort!(G)
    for vertex in sorted_vertices
        println("Vertex: $vertex, f = $(vertex.f)")
    end

    # Perform strongly connected components
    println("\nStrongly connected components:")
    strongly_connected_components = strongly_connected!(G)
    for component in strongly_connected_components
        println("Component: ", component)
    end
end
end

# Call the main function to execute the tests
main()

