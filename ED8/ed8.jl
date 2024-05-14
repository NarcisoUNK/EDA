mutable struct Node
    data::Int
    left::Union{Node, Nothing}
    right::Union{Node, Nothing}
    parent::Union{Node, Nothing}  # New parent pointer
    
    function Node(val::Int)
        new(val, nothing, nothing, nothing)
    end
end

function Inorder_Tree_Walk(root::Union{Node, Nothing})
    if root !== nothing
        Inorder_Tree_Walk(root.left)
        println(root.data)
        Inorder_Tree_Walk(root.right)
    end
end

function Tree_Search(x::Union{Node, Nothing}, k::Int)
    if x === nothing || k == x.data
        return x
    elseif k < x.data
        return Tree_Search(x.left, k)
    else
        return Tree_Search(x.right, k)
    end
end
function Iterative_Tree_Search(x::Union{Node, Nothing}, k::Int)
    while x !== nothing && k !== x.data
        if k < x.data 
            x = x.left
        else
            x = x.right
        end
    end
    return x
end
function Tree_Minimum(x::Union{Node, Nothing})
    while x.left !== nothing
        x = x.left
    end
    return x
end

function Tree_Maximum(x::Union{Node, Nothing})
    while x.right !== nothing
        x = x.right
    end
    return x 
end
function Tree_Successor(x::Union{Node, Nothing})
    if x.right !== nothing
        return Tree_Minimum(x.right)
    end
    y = x.parent
    while y !== nothing && x === y.right
        x = y
        y = y.parent
    end
    return y
end
function Tree_Predecessor(x::Union{Node, Nothing})
    if x.left !== nothing
        return Tree_Maximum(x.left)
    end
    y = x.parent
    while y !== nothing && x === y.left
        x = y
        y = y.parent
    end
    return y
end
function tree_insert(T::Node, z::Node)
    y = nothing
    x = T
    while x !== nothing 
        y = x
        if z.data < x.data
            x = x.left
        else
            x = x.right
        end
    end  
    z.parent = y
    if y === nothing
        T = z
    elseif z.data < y.data 
        y.left = z
    else
        y.right = z
    end
end
function main_tree_insert()
    # Create a root node
    root = Node(5)
    
    # Insert nodes into the tree
    nodes_to_insert = [3, 8, 2, 4, 7, 10]
    for val in nodes_to_insert
        node = Node(val)
        tree_insert(root, node)
    end

    # Print the tree to verify insertion
    println("Binary Search Tree after insertion:")
    print_tree(root)
end

function print_tree(root::Union{Node, Nothing}, indent=0)
    if root === nothing
        return
    end
    print_tree(root.right, indent + 4)
    println(" " ^ indent, root.data)
    print_tree(root.left, indent + 4)
end
function Transplant(T::Node, u::Node, v::Node)
    if u.parent === nothing
        T = v
    elseif u === u.parent.left
        u.parent.left = v
    else
        u.parent.right = v
    end
    if v !== nothing
        v.parent = u.parent
    end
end
# Delete node with given value from tree rooted at root; n is the node to delete
function Tree-Delete(T,z)
end
function Test_Inorder_Search_Normal()
    # create root
    root = Node(5)
    
    # following is the tree after above statement
    #     5
    #    / \
    #  NULL NULL
    root.left = Node(3)
    root.right = Node(8)
    
    # 3 and 8 become left and right children of 5
    #       5
    #      / \
    #     3   8
    #    / \ / \
    # NULL NULL NULL NULL
    root.left.left = Node(2)
    root.left.right = Node(4)
    root.right.left = Node(7)
    root.right.right = Node(10)
    
    # Perform searches
    println("Searching for values:")
    println("Search for 3: ", Tree_Search(root, 3))
    println("Search for 7: ", Tree_Search(root, 7))
    println("Search for 10: ", Tree_Search(root, 10))
    println("Inorder traversal:")
    Inorder_Tree_Walk(root)
end
function test_interative()
    # create root
    root = Node(10)
    
    # following is the tree after above statement
    #     10
    #    / \
    #  NULL NULL
    root.left = Node(5)
    root.right = Node(15)
    
    # 5 and 15 become left and right children of 10
    #       10
    #      / \
    #     5   15
    #    / \ / \
    # NULL NULL NULL NULL
    root.left.left = Node(3)
    root.left.right = Node(8)
    root.right.left = Node(12)
    root.right.right = Node(18)
    
    # Perform searches
    println("Searching for values:")
    println("Search for 5: ", Iterative_Tree_Search(root, 5))
    println("Search for 12: ", Iterative_Tree_Search(root, 12))
    println("Search for 18: ", Iterative_Tree_Search(root, 18))
    println("Search for 1: ", Iterative_Tree_Search(root, 1))
    println("Search for 6: ", Iterative_Tree_Search(root, 6))
end
function main_tree_min_max()
    # create root
    root = Node(10)
    
    # following is the tree after above statement
    #     10
    #    / \
    #  NULL NULL
    root.left = Node(5)
    root.right = Node(15)
    
    # 5 and 15 become left and right children of 10
    #       10
    #      / \
    #     5   15
    #    / \ / \
    # NULL NULL NULL NULL
    root.left.left = Node(3)
    root.left.right = Node(8)
    root.right.left = Node(12)
    root.right.right = Node(18)
    
    # Find minimum and maximum
    println("Minimum value in the tree: ", Tree_Minimum(root).data)
    println("Maximum value in the tree: ", Tree_Maximum(root).data)
end
function main_tree_successor_predecessor()
    # create root
    root = Node(10)
    
    # following is the tree after above statement
    #     10
    #    / \
    #  NULL NULL
    root.left = Node(5)
    root.right = Node(15)
    
    # 5 and 15 become left and right children of 10
    #       10
    #      / \
    #     5   15
    #    / \ / \
    # NULL NULL NULL NULL
    root.left.left = Node(3)
    root.left.right = Node(8)
    root.right.left = Node(12)
    root.right.right = Node(18)
    
    # Test successor and predecessor for various nodes
    println("Successor of root (10): ", Tree_Successor(root))
    println("Predecessor of root (10): ", Tree_Predecessor(root))
    println("Successor of node with value 5: ", Tree_Successor(root.left))
    println("Predecessor of node with value 5: ", Tree_Predecessor(root.left))
    println("Successor of node with value 15: ", Tree_Successor(root.right))
    println("Predecessor of node with value 15: ", Tree_Predecessor(root.right))
    println("Successor of node with value 3: ", Tree_Successor(root.left.left))
    println("Predecessor of node with value 3: ", Tree_Predecessor(root.left.left))
    println("Successor of node with value 8: ", Tree_Successor(root.left.right))
    println("Predecessor of node with value 8: ", Tree_Predecessor(root.left.right))
    println("Successor of node with value 12: ", Tree_Successor(root.right.left))
    println("Predecessor of node with value 12: ", Tree_Predecessor(root.right.left))
    println("Successor of node with value 18: ", Tree_Successor(root.right.right))
    println("Predecessor of node with value 18: ", Tree_Predecessor(root.right.right))
end
main_tree_insert()
#main_tree_successor_predecessor()

#main_tree_successor()
#main_tree_min_max()

# Test_Inorder_Search_Normal()
#test_interative()