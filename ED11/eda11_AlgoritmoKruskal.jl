
"""
Algoritmo de Kruskal
"""

mutable struct Graph
    V::Vector{Char}  
    E::Vector{Tuple{Char, Char}}  
end

function mst_kruskal!(G, w)
    parent = Dict()
    rank = Dict()

    for v in G.V
        make_set(parent, rank, v)
    end

    edges = sort(G.E, by=x->w[x])

    A = []

    for (u, v) in edges
        if find_set(parent, u) != find_set(parent, v)
            push!(A, (u, v))
            union!(parent, rank, u, v)
        end
    end

    return A
end

function make_set(parent, rank, v)
    parent[v] = v
    rank[v] = 0
end

function find_set(parent, v)
    if parent[v] != v
        parent[v] = find_set(parent, parent[v])
    end
    return parent[v]
end

function union!(parent, rank, u, v)
    pu = find_set(parent, u)
    pv = find_set(parent, v)

    if rank[pu] > rank[pv]
        parent[pv] = pu
    elseif rank[pu] < rank[pv]
        parent[pu] = pv
    else
        parent[pu] = pv
        rank[pv] += 1
    end
end

function send_file(A, filepath)
    file = open(filepath, "w")

    if file isa IOStream
        for edge in A
            write(file, join(edge, ", "), "\n")
        end

        close(file)
        println("Árvore de envergadura mínima exportada para um arquivo")
    else
        println("Erro ao abrir o arquivo para escrita.")
    end
end

function total_weight(A, w)
    total = 0

    for edge in A
        total += w[edge]
    end

    return total
end


function main()
    V = ['A', 'B', 'C', 'D', 'E']
    E = [('A', 'B'), ('A', 'C'), ('B', 'C'), ('B', 'D'), ('C', 'D'), ('C', 'E'), ('D', 'E')]
    w = Dict(('A', 'B') => 4, ('A', 'C') => 2, ('B', 'C') => 1, ('B', 'D') => 3, ('C', 'D') => 5, ('C', 'E') => 6, ('D', 'E') => 7)

    G = Graph(V, E)

    A = mst_kruskal!(G, w)
    
    println("Arestas da árvore geradora mínima:")
    for edge in A
        println(edge)
    end
    
    weight = total_weight(A, w)
    println("A soma das ponderações da árvore de envergadura mínima é $weight.")
    send_file(A, "C:/Users/Marti/Documents/VSCode/EDA/Minimal Tree/arvore_minima.txt")
end

main()
