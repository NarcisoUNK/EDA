mutable struct Node
    color::Symbol  # Cor associada ao nó
    key::Any       # Chave do nó (pode ser de qualquer tipo)
    left::Union{Node, Nothing}   # Apontador para o nó descendente esquerdo
    right::Union{Node, Nothing}  # Apontador para o nó descendente direito
    parent::Union{Node, Nothing}  # Apontador para o nó progenitor
    
    function Node(color::Symbol, key::Any, left::Union{Node, Nothing}, right::Union{Node, Nothing}, parent::Union{Node, Nothing})
        new(color, key, left, right, parent)
    end
end

function left_rotate(T::Tree, x::Node)
    y = x.right
    
    # Faz a rotação
    x.right = y.left
    if y.left !== nothing
        y.left.parent = x
    end
    
    y.parent = x.parent
    if x.parent === nothing
        T.root = y
    elseif x == x.parent.left
        x.parent.left = y
    else
        x.parent.right = y
    end
    
    y.left = x
    x.parent = y
end
function right_rotate(T::Tree, y::Node)
    x = y.left
    
    # Faz a rotação
    y.left = x.right
    if x.right !== nothing
        x.right.parent = y
    end
    
    x.parent = y.parent
    if y.parent === nothing
        T.root = x
    elseif y == y.parent.right
        y.parent.right = x
    else
        y.parent.left = x
    end
    
    x.right = y
    y.parent = x
end
function RB_insert(T::Tree, z::Node)
    y = T.nothing
    x = T.root
    
    while x !== T.nothing
        y = x
        if z.key < x.key
            x = x.left
        else
            x = x.right
        end
    end
    
    z.parent = y
    if y === T.nothing
        T.root = z
    elseif z.key < y.key
        y.left = z
    else
        y.right = z
    end
    
    z.left = T.nothing
    z.right = T.nothing
    z.color = :RED  # Assuming RED is defined elsewhere as a Symbol
    
    # Call a function to fix the tree properties here (e.g., fix_insertion_properties(T, z))
end
function RB-INSERT-FIXUP(T::Tree,z::Node)
    while z.parent !== nothing && z.parent.color == :RED
        if z.parent == z.parent.parent.left
            y = z.parent.parent.right
            
            if y !== nothing && y.color == :RED
                z.parent.color = :BLACK
                y.color = :BLACK
                z.parent.parent.color = :RED
                z = z.parent.parent
            else
                if z == z.parent.right
                    z = z.parent
                    left_rotate(T, z)
                end
                z.parent.color = :BLACK
                z.parent.parent.color = :RED
                right_rotate(T, z.parent.parent)
            end
        else
            y = z.parent.parent.left
            
            if y !== nothing && y.color == :RED
                z.parent.color = :BLACK
                y.color = :BLACK
                z.parent.parent.color = :RED
                z = z.parent.parent
            else
                if z == z.parent.left
                    z = z.parent
                    right_rotate(T, z)
                end
                z.parent.color = :BLACK
                z.parent.parent.color = :RED
                left_rotate(T, z.parent.parent)
            end
        end
    end
    T.root.color = :BLACK  
end
function RB_Transplant(T::Tree, u::Node, v::Node)
    if u.parent == T.nothing
        T.root = v
    elseif u == u.parent.left
        u.parent.left = v
    else
        u.parent.right = v
    end
    
    v.parent = u.parent
end

function RB-DELETE(T::Tree,z::Node)

    y = z
    z-original-color = y.color
    if z.left == T.nothing
        x = z.right
        RB_Transplant(T,z,z.right)
    elseif z.right == T.nothing
        x = z.left
        RB_Transplant(T,z,z.left)
    else y = TREE-Minimum(z.right)
        y-original-color = y.color
        x = y.right
        if y.parent === z
            x.parent = y
        else RB-Transplant(T)
end