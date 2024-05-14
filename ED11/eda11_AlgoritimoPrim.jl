"""
Algoritmo de Prim
"""

mutable struct Graph
    V::Vector{Char}
    E::Vector{Tuple{Char,Char}}
end

function mst_prim(G, w, r)
    key = Dict(v => Inf for v in G.V)
    pi = Dict{Char,Union{Char,Nothing}}(v => nothing for v in G.V)

    key[r] = 0
    Q = Set(G.V)

    while !isempty(Q)
        u = extract_min(Q, key)

        for v in neighbors(G, u)
            if v in Q && w(u, v) < key[v]
                pi[v] = u
                key[v] = w(u, v)
            end
        end
    end

    return pi
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

function neighbors(G, u)
    neighbors = []
    for (v1, v2) in G.E
        if v1 == u
            push!(neighbors, v2)
        elseif v2 == u
            push!(neighbors, v1)
        end
    end
    return neighbors
end

function send_file(pi, filepath)
    file = open(filepath, "w")

    if file isa IOStream
        write(file, "Árvore geradora mínima para o algoritmo Prim:\n")
        for (v, parent) in pi
            if parent !== nothing
                write(file, "('$parent', '$v')\n")
            end
        end
        close(file)
        println("Árvore de envergadura mínima exportada para um arquivo")
    else
        println("Erro ao abrir o arquivo para escrita.")
    end
end

function total_weight(pi, w)
    total = 0
    for (v, parent) in pi
        if parent !== nothing
            total += w[(parent, v)]
        end
    end
    return total
end

function main()
    V = ['A', 'B', 'C', 'D', 'E']
    E = [('A', 'B'), ('A', 'C'), ('B', 'C'), ('B', 'D'), ('C', 'D'), ('C', 'E'), ('D', 'E')]
    w = Dict(('A', 'B') => 4, ('B', 'A') => 4,
        ('A', 'C') => 2, ('C', 'A') => 2,
        ('B', 'C') => 1, ('C', 'B') => 1,
        ('B', 'D') => 3, ('D', 'B') => 3,
        ('C', 'D') => 5, ('D', 'C') => 5,
        ('C', 'E') => 6, ('E', 'C') => 6,
        ('D', 'E') => 7, ('E', 'D') => 7)

    G = Graph(V, E)

    A = mst_prim(G, (u, v) -> w[(u, v)], 'A')
    println("Árvore geradora mínima encontrada pelo algoritmo de Prim:")
    for (v, parent) in A
        if parent !== nothing
            println("('$parent', '$v')")
        end
    end

    weight = total_weight(A, w)
    println("A soma das ponderações da árvore de envergadura mínima é $weight.")
    send_file(A, "./EDA/Minimal Tree/arvore_minima_prim.txt")
end

main()