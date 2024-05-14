function dijkstra(G, w, s)
    initialize_single_source(G, s)
    S = Set{Int}()
    Q = Set(G.V)
    while!isempty(Q)
        u = extract_min(Q, G.distance)
        push!(S, u)
        for v in G.Adj[u]
            relax(u, v, w)
        end
    end

function initialize_single_source(G, s)
    for v in values(G)
        v["distance"] = Inf
        v["predecessor"] = nothing
    end
    G[s]["distance"] = 0
end

function relax(u, v, w)
    if w[(u, v)] + G[u]["distance"] < G[v]["distance"]
        G[v]["distance"] = w[(u, v)] + G[u]["distance"]
    end
end

function extract_min(Q, key)
    min_key = Inf
    min_vertex = nothing

    for v in Q
        if key[v] < min_key
            min_key = key[v]
            min_vertex = v
        end
    end

    delete!(Q, min_vertex)
    return min_vertex
end

function main()
    # Create a sample graph
    G = Dict{Int,Any}()
    G[1] = Dict("V" => [1, 2, 3], "Adj" => Dict(1 => [2, 3], 2 => [1, 3], 3 => [1, 2]))
    G[2] = Dict("V" => [1, 2, 3], "Adj" => Dict(1 => [2, 3], 2 => [1, 3], 3 => [1, 2]))
    G[3] = Dict("V" => [1, 2, 3], "Adj" => Dict(1 => [2, 3], 2 => [1, 3], 3 => [1, 2]))

    # Initialize distances and predecessors
    for v in values(G[1])
        v["distance"] = Inf
        v["predecessor"] = nothing
    end
    # Define the weight function
    w = Dict((1, 2) => 2, (1, 3) => 3, (2, 1) => 2, (2, 3) => 1, (3, 1) => 3, (3, 2) => 1)

    # Run Dijkstra's algorithm
    dijkstra(G, w, 1)

    # Print the shortest distances and predecessors
    for v in G[1]["V"]
        println("Vertex $v: distance = $(G[v]["distance"]), predecessor = $(G[v]["predecessor"])")
    end
end

main()