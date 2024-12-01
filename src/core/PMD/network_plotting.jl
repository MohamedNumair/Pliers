

## plotting






## Generic Graph Creation and Plot

### Generic Graph Creation
# internal function that will take in the eng dictionary and create a graph
# then layout will be added
# then the graph will be plotted
# the function will return the plot object



"""
    create_network_graph(eng::Dict{String,Any}) -> MetaDiGraph

Creates a network graph from the given engineering model dictionary `eng`.

# Arguments
- `eng::Dict{String,Any}`: A dictionary representing the engineering model.

# Returns
- `MetaDiGraph`: A graph object representing the network.

# Description
This function performs the following steps:
1. Transforms loops in the engineering model using `PowerModelsDistribution.transform_loops!`.
2. Converts the keys in the engineering model dictionary to symbols.
3. Creates an empty `MetaDiGraph` object.
4. Adds bus keys as `:bus_id` to each bus in the engineering model.
5. Adds line keys as `:line_id` to each line in the engineering model.
6. Adds the `sourcebus` as the root vertex in the graph.
7. Adds the remaining buses as vertices in the graph.
8. Sets `:bus_id` as the indexing property for the graph.
9. Adds edges between buses based on the `f_bus` and `t_bus` indices in the lines.

# Errors
- Throws an error if `sourcebus` is not found in the bus data.
"""
function create_network_graph(eng::Dict{String,Any})
    PowerModelsDistribution.transform_loops!(eng)
    eng_sym = convert_keys_to_symbols(deepcopy(eng))
    network_graph = MetaDiGraph()

    # Add bus keys as :bus_id
    for (b, bus) in eng_sym[:bus]
        bus[:bus_id] = b
    end    

    for (l, line) in eng_sym[:line]
        line[:line_id] = l
    end

    # Add `sourcebus` first to make it the root
    if haskey(eng_sym[:bus], :sourcebus)
        add_vertex!(network_graph, eng_sym[:bus][:sourcebus])
    else 
        error("sourcebus not found in the bus data. It is needed to have the root bus with key sourcebus in the ENGINEERING model. Please add sourcebus to the bus data.")
    end

    # Add the rest of the buses
    for (b, bus) in eng_sym[:bus]
        if bus[:bus_id] != :sourcebus
            add_vertex!(network_graph, bus)
        end
    end

    # Use bus_id as the indexing property
    set_indexing_prop!(network_graph, :bus_id)

    # Add edges based on the f_bus and t_bus bus_id indices
    for (l, line) in eng_sym[:line]
        f_bus = Symbol(line[:f_bus])
        t_bus = Symbol(line[:t_bus])
        f_vertex = network_graph[f_bus, :bus_id]
        t_vertex = network_graph[t_bus, :bus_id]
        add_edge!(network_graph, f_vertex, t_vertex, line)
    end

    return network_graph
end


"""
    network_graph_plot(network_graph::MetaDiGraph; layout=GraphMakie.Buchheim(), figure_size=(1000, 1200), node_color=:black, node_size=automatic, node_marker=automatic, node_strokewidth=automatic, show_node_labels=false, show_edge_labels=false, edge_color=:black, elabels_color=:black, elabels_fontsize=10, tangents=((0,-1),(0,-1)), arrow_show=false, arrow_marker='➤', arrow_size=50, arrow_shift=0.5)

Plots the given network graph using the specified layout and styling options.

# Arguments
- `network_graph::MetaDiGraph`: The network graph to be plotted.

# Keyword Arguments
- `layout`: The layout algorithm to use for positioning the nodes (default: `GraphMakie.Buchheim()`).
- `figure_size`: The size of the figure in pixels (default: `(1000, 1200)`).
- `node_color`: The color of the nodes (default: `:black`).
- `node_size`: The size of the nodes (default: `automatic`).
- `node_marker`: The marker style for the nodes (default: `automatic`).
- `node_strokewidth`: The stroke width of the nodes (default: `automatic`).
- `show_node_labels`: Whether to show labels on the nodes (default: `false`).
- `show_edge_labels`: Whether to show labels on the edges (default: `false`).
- `edge_color`: The color of the edges (default: `:black`).
- `elabels_color`: The color of the edge labels (default: `:black`).
- `elabels_fontsize`: The font size of the edge labels (default: `10`).
- `tangents`: The tangents for the edges (default: `((0,-1),(0,-1))`).
- `arrow_show`: Whether to show arrows on the edges (default: `false`).
- `arrow_marker`: The marker style for the arrows (default: `'➤'`).
- `arrow_size`: The size of the arrows (default: `50`).
- `arrow_shift`: The shift of the arrows along the edges (default: `0.5`).

# Returns
- A plot object representing the network graph.

# Example

f, ax, p = network_graph_plot(network_graph; layout=GraphMakie.Buchheim(), figure_size=(1000, 1200), node_color=:black, node_size=automatic, node_marker=automatic, node_strokewidth=automatic, show_node_labels=false, show_edge_labels=false, edge_color=:black, elabels_color=:black, elabels_fontsize=10, tangents=((0,-1),(0,-1)), arrow_show=false, arrow_marker='➤', arrow_size=50, arrow_shift=0.5)
"""
function network_graph_plot(
                            network_graph::MetaDiGraph;

                            # figure
                            layout=GraphMakie.Buchheim(),
                            figure_size=(1000, 1200), #resolution
                            
                            #nodes
                            node_color = :black,
                            node_size=automatic,
                            node_marker=automatic,
                            node_strokewidth=automatic,
                            show_node_labels=false, #nlablels
                            
                            #edges
                            show_edge_labels=false, #elabels
                            edge_color= :black,
                            elabels_color = :black,
                            elabels_fontsize = 10,
                            tangents =((0,-1),(0,-1)),

                            # arrow
                            arrow_show=false,
                            arrow_marker='➤',
                            arrow_size=50,
                            arrow_shift=0.5,    
    
                            )


    return graphplot(network_graph; layout=layout, resolution=resolution)
end



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
function plot_network_tree(
                            eng::Dict{String,Any};
                            makie_backend=WGLMakie,
                            figure_size=(1000, 1200),
                            
                            #nodes
                            node_color = :black,
                            node_size=automatic,
                            node_marker=automatic,
                            node_strokewidth=automatic,
                            show_node_labels=false, #nlablels
                            
                            #edges
                            show_edge_labels=false, #elabels
                            edge_color= :black,
                            elabels_color = :black,
                            elabels_fontsize = 10,
                            tangents =((0,-1),(0,-1)),

                            # arrow
                            arrow_show=false,
                            arrow_marker='➤',
                            arrow_size=50,
                            arrow_shift=0.5,
                            layout=GraphMakie.Buchheim(),
 
                            )

    makie_backend.activate!()
    
    network_graph = create_network_graph(eng)
    
    # Handle labels if required
    nlabels = show_node_labels ? [string(network_graph[i, :bus_id]) for i in 1:nv(network_graph)] : nothing
    elabels = show_edge_labels ? [string(get_prop(network_graph, e, :line_id)) for e in edges(network_graph)] : nothing

    f, ax, p = network_graph_plot(
        network_graph;
        layout=layout,
        figure_size=figure_size,
        
        #nodes
        node_color = node_color,
        node_size=node_size,
        node_marker=node_marker,
        node_strokewidth=node_strokewidth,
        show_node_labels=show_node_labels,
        
        #edges
        show_edge_labels=show_edge_labels,
        edge_color=edge_color,
        elabels_color=elabels_color,
        elabels_fontsize=elabels_fontsize,
        tangents=tangents,
        
        #arrow
        arrow_show=arrow_show,
        arrow_marker=arrow_marker,
        arrow_size=arrow_size,
        arrow_shift=arrow_shift,
    )
    # Plot the graph
    return graphplot(
        network_graph;
        layout=layout,

        nlabels=nlabels,
        node_color = node_color,
        
        elabels = elabels,
        edge_color = edge_color,
        arrow_show=arrow_show,
        arrow_marker=arrow_marker,
        resolution=figure_size,
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


function plot_network_coords(
                            eng::Dict{String,Any};
                            makie_backend=WGLMakie,
                            figure_size=(800, 600),
                            show_labels=false,
                            show_arrow=false,
                            fallback_layout=GraphMakie.Buchheim()
                            )

    makie_backend.activate!()
    PowerModelsDistribution.transform_loops!(eng)
    eng_sym = convert_keys_to_symbols(deepcopy(eng))
    network_graph = MetaDiGraph()

    lons = []
    lats = []
    
    # Add bus keys as :bus_id and collect coordinates if present
    for (b, bus) in eng_sym[:bus]
        bus[:bus_id] = b
        if haskey(bus, :lon) && haskey(bus, :lat)
            push!(lons, bus[:lon])
            push!(lats, bus[:lat])
        end
    end    
    
    for (l, line) in eng_sym[:line]
        line[:line_id] = l
    end

    # Determine source coordinates if available
    lon_s, lat_s = nothing, nothing
    if length(lons) > 0
        source_line = findfirst(line -> line[:f_bus] == "sourcebus", eng_sym[:line])
        if source_line !== nothing
            lon_s = eng_sym[:bus][Symbol(eng_sym[:line][source_line][:t_bus])][:lon]
            lat_s = eng_sym[:bus][Symbol(eng_sym[:line][source_line][:t_bus])][:lat]
        end
    end
    
    layouting_vector = []

    # Add `sourcebus` as the root
    if haskey(eng_sym[:bus], :sourcebus)
        add_vertex!(network_graph, eng_sym[:bus][:sourcebus])
        if length(lons) > 0 && lon_s !== nothing && lat_s !== nothing
            push!(layouting_vector, (lon_s, lat_s))
        end
    else 
        error("sourcebus not found in the bus data. Please add sourcebus to the bus data.")
    end

    # Add the rest of the buses
    for (b, bus) in eng_sym[:bus]
        if bus[:bus_id] != :sourcebus
            add_vertex!(network_graph, bus)
            if haskey(bus, :lon) && haskey(bus, :lat)
                push!(layouting_vector, (bus[:lon], bus[:lat]))
            end
        end
    end

    # Use bus_id as the indexing property
    set_indexing_prop!(network_graph, :bus_id)

    # Add edges based on f_bus and t_bus
    for (l, line) in eng_sym[:line]
        f_bus = Symbol(line[:f_bus])
        t_bus = Symbol(line[:t_bus])
        f_vertex = network_graph[f_bus, :bus_id]
        t_vertex = network_graph[t_bus, :bus_id]
        add_edge!(network_graph, f_vertex, t_vertex, line)
    end
    
    # Decide on the layout
    if length(layouting_vector) > 1
        GraphLayout = _ -> layouting_vector
    else
        @warn "No coordinates found for plotting, using fallback layout."
        GraphLayout = fallback_layout
    end

    # Handle labels if required
    nlabels = show_labels ? [string(network_graph[i, :bus_id]) for i in 1:nv(network_graph)] : nothing

#    Plot the graph
    return graphplot(
        network_graph;
        layout=GraphLayout,
        
        #nodes

        nlabels=nlabels,
        resolution=figure_size,
        #edges


        #arrows
        arrow_show= show_arrow,
        arrow_marker='➤',

    )
end



function plot_network_map(eng::Dict{String, Any}; makie_backend= WGLMakie, tiles_provider = TileProviders.Google())
    makie_backend.activate!()
    PowerModelsDistribution.transform_loops!(eng)
    eng_sym = convert_keys_to_symbols(deepcopy(eng))
    network_graph = MetaDiGraph()

    lons = []
    lats = []
    # add bus keys as :bus_id
    for (b,bus) in eng_sym[:bus]
        bus[:bus_id] = b
        if haskey(bus, :lon) && haskey(bus, :lat)
            push!(lons, bus[:lon])
            push!(lats, bus[:lat])
        end
    end    


    center_lon = mean(lons)
    center_lat = mean(lats)
    
    map_window_coords = Rect2f(center_lon,center_lat, 0.009, 0.009)
    
    ## possible tile providers
    # provider = TileProviders.nlmaps(:standaard)
    # google = TileProviders.Google()
    # esri = TileProviders.Esri(:WorldImagery)
    # MORE: Tyler.TileProviders.list_providers()
    m = Tyler.Map(map_window_coords; provider=tiles_provider, crs=Tyler.wgs84)
    hidedecorations!(m.axis) 
    hidespines!(m.axis)



    for (l, line) in eng_sym[:line]
        line[:line_id] = l
    end
    
    if length(lons) > 0
        lon_s = eng_sym[:bus][Symbol(eng_sym[:line][findfirst(line-> line[:f_bus] =="sourcebus" , eng_sym[:line])][:t_bus])][:lon]
        lat_s = eng_sym[:bus][Symbol(eng_sym[:line][findfirst(line-> line[:f_bus] =="sourcebus" , eng_sym[:line])][:t_bus])][:lat] 
    end
    
    layouting_vector = []
    # adding `sourcebus` first to make it root
    
    if haskey(eng_sym[:bus], :sourcebus)
        add_vertex!(network_graph, eng_sym[:bus][:sourcebus])
        length(lons) > 0 ? push!(layouting_vector, (lon_s, lat_s)) : nothing
    else 
        error_text("sourcebus not found in the bus data, it is needed to have the root bus with key sourcebus in the ENGINEERING model")
        error("please add sourcebus to the bus data")
    end

    # adding rest of the buses
    for (b,bus) in eng_sym[:bus]
        if bus[:bus_id] != :sourcebus
        add_vertex!(network_graph, bus)
            if haskey(bus, :lon) && haskey(bus, :lat)
                push!(layouting_vector, (bus[:lon], bus[:lat]))
            end
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
    
    
    fixed_layout(_) = layouting_vector

    if length(layouting_vector) > 1
        GraphLayout = fixed_layout
    else
        @warn "No coordinates found for plotting, using tree layout instead"
        error_text("For the function `plot_network_coords` to work, the bus data must contain `lon` and `lat` keys for each bus, please add these keys to the bus data The network will be plotted using the tree layout instead, please use the function `plot_network_tree` to plot the network tree if that what was intended")
        GraphLayout = GraphMakie.Buchheim()
    end

    
    graph = graphplot!(m.axis, network_graph;
                                    layout = GraphLayout,
                                    #nlabels = [string.(network_graph[i, :bus_id]) for i in 1:nv(network_graph)],
                                    #ilabels=[network_graph[i, :bus_id] for i in 1:nv(network_graph)],
                                    #elabels=[" $(string(get_prop(network_graph, e, :line_id))), $(string(get_prop(network_graph, e, :length))) m " for e in edges(network_graph)],
                                    arrow_shift=0.5
                                    )

    translate!(graph, 0,0,100)
    return m
end