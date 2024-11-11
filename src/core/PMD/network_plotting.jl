

## plotting

"""
    plot_network_tree(eng::Dict{String,Any}; makie_backend=WGLMakie)

Plots a network tree based on the given engineering model dictionary `eng`.

# Arguments
- `eng::Dict{String,Any}`: A dictionary containing the engineering model data.
- `makie_backend`: The backend to use for plotting. Defaults to `WGLMakie`.

# Returns
- A tuple `(f, ax, p)` where `f` is the figure, `ax` is the axis, and `p` is the plot object.

# Details
1. Activates the specified Makie backend.
2. Converts the keys of the engineering model dictionary to symbols.
3. Creates a `MetaDiGraph` to represent the network graph.
4. Adds bus keys as `:bus_id` and line keys as `:line_id`.
5. Adds the `sourcebus` as the root vertex of the network graph.
6. Adds the rest of the buses to the network graph.
7. Sets the indexing property of the network graph to `:bus_id`.
8. Adds edges to the network graph based on the `f_bus` and `t_bus` indices.
9. Plots the network graph using `graphplot` with labels for nodes and edges.
10. Hides decorations and spines of the plot axis.

# Errors
- Throws an error if `sourcebus` is not found in the bus data.
"""

function plot_network_tree(eng::Dict{String,Any}; makie_backend=WGLMakie)
    makie_backend.activate!()
    PowerModelsDistribution.transform_loops!(eng)
    eng_sym = convert_keys_to_symbols(deepcopy(eng))
    network_graph = MetaDiGraph()

    # add bus keys as :bus_id
    for (b,bus) in eng_sym[:bus]
        bus[:bus_id] = b
    end    
    for (l, line) in eng_sym[:line]
        line[:line_id] = l
    end
    
    # adding `sourcebus` first to make it root
    
    if haskey(eng_sym[:bus], :sourcebus)
        add_vertex!(network_graph, eng_sym[:bus][:sourcebus])
    else 
        error_text("sourcebus not found in the bus data, it is needed to have the root bus with key sourcebus in the ENGINEERING model")
        error("please add sourcebus to the bus data")
    end
    # adding rest of the buses
    for (b,bus) in eng_sym[:bus]
        if bus[:bus_id] != :sourcebus
        add_vertex!(network_graph, bus)
        end
    end

    # use bus_id as indexing property
    set_indexing_prop!(network_graph, :bus_id)

    # adding edges based on the f_bus and t_bus bus_id indices
    for (l, line) in eng_sym[:line]
        f_bus = Symbol(line[:f_bus])
        t_bus = Symbol(line[:t_bus])
        f_vertix = network_graph[f_bus, :bus_id]
        t_vertix = network_graph[t_bus, :bus_id]
        add_edge!(network_graph, f_vertix, t_vertix, line)
    end
    
    
    return graphplot(network_graph;
                                    layout = GraphMakie.Buchheim(),
                                    nlabels = [string.(network_graph[i, :bus_id]) for i in 1:nv(network_graph)],
                                    #ilabels=[network_graph[i, :bus_id] for i in 1:nv(network_graph)],
                                    elabels=[" $(string(get_prop(network_graph, e, :line_id))), $(string(get_prop(network_graph, e, :length))) m " for e in edges(network_graph)],
                                    #arrow_shift=:center
                                    )

    end



"""
    plot_network_tree(dss::String; makie_backend=WGLMakie)

Plots a network tree from a given DSS file.

# Arguments
- `dss::String`: The path to the DSS file containing the network data.
- `makie_backend`: The Makie backend to use for plotting. Defaults to `WGLMakie`.

# Description
This function parses the DSS file to create an engineering model of the network, transforms loops in the model, and converts keys to symbols. It then constructs a network graph using `MetaDiGraph`, adds vertices for each bus, and sets the `sourcebus` as the root. Edges are added based on the `f_bus` and `t_bus` indices of the lines. Finally, it plots the network graph using `graphplot` with a specified layout and labels for nodes and edges.

# Returns
A plot of the network graph.
"""
function plot_network_tree(dss::String; makie_backend=WGLMakie)
    eng = PowerModelsDistribution.parse_file(dss)
    plot_network_tree(eng, makie_backend=makie_backend)
end
