

## plotting







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
```julia
f, ax, p = network_graph_plot(network_graph; layout=GraphMakie.Buchheim(), figure_size=(1000, 1200), node_color=:black, node_size=automatic, node_marker=automatic, node_strokewidth=automatic, show_node_labels=false, show_edge_labels=false, edge_color=:black, elabels_color=:black, elabels_fontsize=10, tangents=((0,-1),(0,-1)), arrow_show=false, arrow_marker='➤', arrow_size=50, arrow_shift=0.5)
```
"""
function network_graph_plot(
                            network_graph::MetaDiGraph;

                            # figure
                            makie_backend=WGLMakie,
                            layout=GraphMakie.Buchheim(),
                            figure_size=(1000, 1200), #resolution
                            
                            #nodes
                            nlabels = nothing,
                            ilabels = nothing,
                            node_color = :black,
                            node_size=automatic,
                            node_marker=automatic,
                            node_strokewidth=automatic,
                            show_node_labels=false, #nlablels
                            
                            #edges
                            elabels = nothing,
                            show_edge_labels=false, #elabels
                            edge_color= :black,
                            elabels_color = :black,
                            #elabels_fontsize =  nothing,
                            tangents =((0,-1),(0,-1)),

                            # arrow
                            arrow_show=false,
                            arrow_marker='➤',
                            arrow_size=12,
                            arrow_shift=0.5,    
                            kwargs...
    
                            )

    makie_backend.activate!()
    #labels_theme = default_theme(makie_backend.Scene(), Makie.Text)
    #elabels_fontsize = isnothing(elabels_fontsize) ? labels_theme.fontsize : elabels_fontsize

    return graphplot(
                        network_graph;
                        layout=layout,
                        resolution=figure_size,
                        
                        #nodes
                        nlabels=nlabels,
                        ilabels=ilabels,
                        node_color=node_color,
                        node_size=node_size,
                        node_marker=node_marker,
                        node_strokewidth=node_strokewidth,
                        show_node_labels=show_node_labels,
                        
                        #edges
                        elabels=elabels,
                        show_edge_labels=show_edge_labels,
                        edge_color=edge_color,
                        elabels_color=elabels_color,
                        #elabels_fontsize=elabels_fontsize,
                        tangents=tangents,

                        # arrow
                        arrow_show=arrow_show,
                        arrow_marker=arrow_marker,
                        arrow_size=arrow_size,
                        arrow_shift=arrow_shift,

                        # edges are linesegments
                        edge_plottype=:linesegments,

                        kwargs...
                    )
end


function network_graph_plot!(
                            network_graph::MetaDiGraph;

                            # figure
                            makie_backend=WGLMakie,
                            layout=GraphMakie.Buchheim(),
                            figure_size=(1000, 1200), #resolution
                            
                            #nodes
                            nlabels = nothing,
                            ilabels = nothing,
                            node_color = :black,
                            node_size=automatic,
                            node_marker=automatic,
                            node_strokewidth=automatic,
                            show_node_labels=false, #nlablels
                            
                            #edges
                            elabels = nothing,
                            show_edge_labels=false, #elabels
                            edge_color= :black,
                            elabels_color = :black,
                            #elabels_fontsize =  nothing,
                            tangents =((0,-1),(0,-1)),

                            # arrow
                            arrow_show=false,
                            arrow_marker='➤',
                            arrow_size=12,
                            arrow_shift=0.5,    
                            kwargs...
    
                            )

    #makie_backend.activate!()
    #labels_theme = default_theme(makie_backend.Scene(), Makie.Text)
    #elabels_fontsize = isnothing(elabels_fontsize) ? labels_theme.fontsize : elabels_fontsize

    add_graph =  graphplot!(
                        network_graph;
                        layout=layout,
                        resolution=figure_size,
                        
                        #nodes
                        nlabels=nlabels,
                        ilabels=ilabels,
                        node_color=node_color,
                        node_size=node_size,
                        node_marker=node_marker,
                        node_strokewidth=node_strokewidth,
                        show_node_labels=show_node_labels,
                        
                        #edges
                        elabels=elabels,
                        show_edge_labels=show_edge_labels,
                        edge_color=edge_color,
                        elabels_color=elabels_color,
                        #elabels_fontsize=elabels_fontsize,
                        tangents=tangents,

                        # arrow
                        arrow_show=arrow_show,
                        arrow_marker=arrow_marker,
                        arrow_size=arrow_size,
                        arrow_shift=arrow_shift,

                        
                        # edges are linesegments
                        edge_plottype=:linesegments,
                        kwargs...
                    )
    translate!(add_graph, 0,0,100);
end



"""
    network_graph_map_plot(
        network_graph::MetaDiGraph,
        GraphLayout::Function;
        tiles_provider=TileProviders.Google(:satelite),
        zoom_lon=0.0942,
        zoom_lat=0.0942,
        makie_backend=WGLMakie,
        figure_size=(1000, 1200),
        nlabels=nothing,
        ilabels=nothing,
        node_color=:black,
        node_size=automatic,
        node_marker=automatic,
        node_strokewidth=automatic,
        show_node_labels=false,
        elabels=nothing,
        show_edge_labels=false,
        edge_color=:black,
        elabels_color=:black,
        elabels_fontsize=10,
        tangents=((0,-1),(0,-1)),
        arrow_show=false,
        arrow_marker='➤',
        arrow_size=12,
        arrow_shift=0.5,
        kwargs...
    )

Plots a network graph on a map using the specified layout and visual properties.

# Arguments
- `network_graph::MetaDiGraph`: The network graph to be plotted.
- `GraphLayout::Function`: The layout function for positioning the nodes.
- `tiles_provider`: The tile provider for the map background. Default is `TileProviders.Google(:satelite)`.
- `zoom_lon`: The longitudinal zoom level. Default is `0.0942`.
- `zoom_lat`: The latitudinal zoom level. Default is `0.0942`.
- `makie_backend`: The Makie backend to use for plotting. Default is `WGLMakie`.
- `figure_size`: The size of the figure in pixels. Default is `(1000, 1200)`.
- `nlabels`: Node labels. Default is `nothing`.
- `ilabels`: Internal labels. Default is `nothing`.
- `node_color`: Color of the nodes. Default is `:black`.
- `node_size`: Size of the nodes. Default is `automatic`.
- `node_marker`: Marker style for the nodes. Default is `automatic`.
- `node_strokewidth`: Stroke width of the nodes. Default is `automatic`.
- `show_node_labels`: Whether to show node labels. Default is `false`.
- `elabels`: Edge labels. Default is `nothing`.
- `show_edge_labels`: Whether to show edge labels. Default is `false`.
- `edge_color`: Color of the edges. Default is `:black`.
- `elabels_color`: Color of the edge labels. Default is `:black`.
- `elabels_fontsize`: Font size of the edge labels. Default is `10`.
- `tangents`: Tangents for the edges. Default is `((0,-1),(0,-1))`.
- `arrow_show`: Whether to show arrows on the edges. Default is `false`.
- `arrow_marker`: Marker style for the arrows. Default is `'➤'`.
- `arrow_size`: Size of the arrows. Default is `12`.
- `arrow_shift`: Shift of the arrows. Default is `0.5`.
- `kwargs`: Additional keyword arguments.

# Returns
- A map object with the plotted network graph.
"""
function network_graph_map_plot(
                            network_graph::MetaDiGraph,
                            GraphLayout:: Function;
                            # map 
                            tiles_provider =  TileProviders.Google(:satelite), # :roadmap, :satelite, :terrain, :hybrid
                            zoom_lon=0.0942,
                            zoom_lat=0.0942,
                            # figure
                            makie_backend=WGLMakie,
                            figure_size=(1000, 1200), #resolution
                            
                            #nodes
                            nlabels = nothing,
                            ilabels = nothing,
                            node_color = :black,
                            node_size=automatic,
                            node_marker=automatic,
                            node_strokewidth=automatic,
                            show_node_labels=false, #nlablels
                            
                            #edges
                            elabels = nothing,
                            show_edge_labels=false, #elabels
                            edge_color= :black,
                            elabels_color = :black,
                            elabels_fontsize = 10,
                            tangents =((0,-1),(0,-1)),

                            # arrow
                            arrow_show=false,
                            arrow_marker='➤',
                            arrow_size=12,
                            arrow_shift=0.5,    
                            kwargs...
    
                            )
                            
    map_layout = GraphLayout(1)
    center_lon = mean(lonslats[1] for lonslats in map_layout)
    center_lat = mean(lonslats[2] for lonslats in map_layout)
    max_lon = maximum(lonslats[1] for lonslats in map_layout)
    max_lat = minimum(lonslats[2] for lonslats in map_layout)
    cent_to_max_lon = abs(max_lon - center_lon)*2
    cent_to_max_lat = abs(max_lat - center_lat)*2

    zoom_lon == 0.0942 ? zoom_lon = cent_to_max_lon : zoom_lon = zoom_lon
    zoom_lat == 0.0942 ? zoom_lat = cent_to_max_lat : zoom_lat = zoom_lat

    makie_backend.activate!()
    map_window_coords = Rect2f(center_lon - zoom_lon/2, center_lat - zoom_lat/2, zoom_lon, zoom_lat)


    m= Tyler.Map(map_window_coords; provider=tiles_provider, crs=Tyler.wgs84);
    hidedecorations!(m.axis) ;
    hidespines!(m.axis);





    graph = graphplot!(
                        network_graph;
                        layout=GraphLayout,
                        resolution=figure_size,
                        
                        #nodes
                        nlabels=nlabels,
                        ilabels=ilabels,
                        node_color=node_color,
                        node_size=node_size,
                        node_marker=node_marker,
                        node_strokewidth=node_strokewidth,
                        show_node_labels=show_node_labels,
                        
                        #edges
                        elabels=elabels,
                        show_edge_labels=show_edge_labels,
                        edge_color=edge_color,
                        elabels_color=elabels_color,
                        elabels_fontsize=elabels_fontsize,
                        tangents=tangents,

                        # arrow
                        arrow_show=arrow_show,
                        arrow_marker=arrow_marker,
                        arrow_size=arrow_size,
                        arrow_shift=arrow_shift,

                        
                        # edges are linesegments
                        edge_plottype=:linesegments,
                        kwargs...
                    );

    translate!(graph, 0,0,100);

    return m
end



"""
    plot_network_tree(eng::Dict{String,Any}; makie_backend=WGLMakie)

Plots a network tree based on the given engineering model dictionary `eng`.

# Arguments
- `eng::Dict{String,Any}`: A dictionary containing the engineering model data.
- `makie_backend`: The backend to use for plotting. Defaults to `WGLMakie`.
- `network_graph::MetaDiGraph`: The network graph to be plotted.
- `GraphLayout::Function`: The layout function for positioning the nodes.
- `tiles_provider`: The tile provider for the map background. Default is `TileProviders.Google(:satelite)`.
- `zoom_lon`: The longitudinal zoom level. Default is `0.0942`.
- `zoom_lat`: The latitudinal zoom level. Default is `0.0942`.
- `makie_backend`: The Makie backend to use for plotting. Default is `WGLMakie`.
- `figure_size`: The size of the figure in pixels. Default is `(1000, 1200)`.
- `nlabels`: Node labels. Default is `nothing`.
- `ilabels`: Internal labels. Default is `nothing`.
- `node_color`: Color of the nodes. Default is `:black`.
- `node_size`: Size of the nodes. Default is `automatic`.
- `node_marker`: Marker style for the nodes. Default is `automatic`.
- `node_strokewidth`: Stroke width of the nodes. Default is `automatic`.
- `show_node_labels`: Whether to show node labels. Default is `false`.
- `elabels`: Edge labels. Default is `nothing`.
- `show_edge_labels`: Whether to show edge labels. Default is `false`.
- `edge_color`: Color of the edges. Default is `:black`.
- `elabels_color`: Color of the edge labels. Default is `:black`.
- `elabels_fontsize`: Font size of the edge labels. Default is `10`.
- `tangents`: Tangents for the edges. Default is `((0,-1),(0,-1))`.
- `arrow_show`: Whether to show arrows on the edges. Default is `false`.
- `arrow_marker`: Marker style for the arrows. Default is `'➤'`.
- `arrow_size`: Size of the arrows. Default is `12`.
- `arrow_shift`: Shift of the arrows. Default is `0.5`.
- `kwargs`: Additional keyword arguments.

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
                            data::Dict{String,Any};
                            figure_size=(1000, 1200),
                            show_node_labels = false,
                            show_edge_labels = false,
                            layout=GraphMakie.Buchheim(),
                            kwargs...
                            )    
    # Create the network meta graph 
   network_graph, _, _ = create_network_graph(data, layout)
    #
    # Handle labels if required
    nlabels = show_node_labels ? [string(network_graph[i, :bus_id]) for i in 1:nv(network_graph)] : nothing
    elabels = show_edge_labels ? _is_eng(data) ? [string(get_prop(network_graph, e, :line_id)) for e in edges(network_graph)] : [string(get_prop(network_graph, e, :branch_id)) for e in edges(network_graph)] : nothing 

    # FORCED NODE FORMATTING:
    # 1. Identify the sourcebus
    _decorate_nodes!(network_graph, data)
    node_color = [ props(network_graph, i)[:node_color] for i in 1:nv(network_graph)]
    node_marker = [ props(network_graph, i)[:node_marker] for i in 1:nv(network_graph)]
    node_size = [ props(network_graph, i)[:marker_size] for i in 1:nv(network_graph)]
    
    _decorate_edges(network_graph, data)
    edge_color = [ get_prop(network_graph, e, :edge_color) for e in edges(network_graph)]
    # plot and return the network 
   return network_graph_plot(
                                network_graph;
                                layout=layout,
                                figure_size=figure_size,
                                show_node_labels=show_node_labels,
                                nlabels=nlabels, 
                                show_edge_labels=show_edge_labels,
                                elabels=elabels,
                                node_color=node_color,
                                node_marker=node_marker,
                                node_size=node_size,
                                edge_color=edge_color,
                                kwargs...
                            )
end






"""
    plot_network_tree(dss::String; kwargs...)

Plots a network tree from a given DSS file.

# Arguments
- `dss::String`: The path to the DSS file containing the network data.
- `makie_backend`: The Makie backend to use for plotting. Defaults to `WGLMakie`.

# Description
This function parses the DSS file to create an engineering model of the network, transforms loops in the model, and converts keys to symbols. It then constructs a network graph using `MetaDiGraph`, adds vertices for each bus, and sets the `sourcebus` as the root. Edges are added based on the `f_bus` and `t_bus` indices of the lines. Finally, it plots the network graph using `graphplot` with a specified layout and labels for nodes and edges.

# Returns
A plot of the network graph.
"""
function plot_network_tree(dss::String; kwargs...)
    eng = PowerModelsDistribution.parse_file(dss)
    plot_network_tree(eng, kwargs...)
end



"""
    plot_network_coords(eng::Dict{String,Any}; show_node_labels=false, show_edge_labels=false, fallback_layout=GraphMakie.Buchheim(), kwargs...)

Plot a network graph with optional node and edge labels.

# Arguments
- `eng::Dict{String,Any}`: The engineering data used to create the network graph.
- `show_node_labels::Bool`: Whether to display labels for the nodes. Default is `false`.
- `show_edge_labels::Bool`: Whether to display labels for the edges. Default is `false`.
- `fallback_layout`: The layout algorithm to use if no specific layout is provided. Default is `GraphMakie.Buchheim()`.
- `network_graph::MetaDiGraph`: The network graph to be plotted.
- `GraphLayout::Function`: The layout function for positioning the nodes.
- `tiles_provider`: The tile provider for the map background. Default is `TileProviders.Google(:satelite)`.
- `zoom_lon`: The longitudinal zoom level. Default is `0.0942`.
- `zoom_lat`: The latitudinal zoom level. Default is `0.0942`.
- `makie_backend`: The Makie backend to use for plotting. Default is `WGLMakie`.
- `figure_size`: The size of the figure in pixels. Default is `(1000, 1200)`.
- `nlabels`: Node labels. Default is `nothing`.
- `ilabels`: Internal labels. Default is `nothing`.
- `node_color`: Color of the nodes. Default is `:black`.
- `node_size`: Size of the nodes. Default is `automatic`.
- `node_marker`: Marker style for the nodes. Default is `automatic`.
- `node_strokewidth`: Stroke width of the nodes. Default is `automatic`.
- `show_node_labels`: Whether to show node labels. Default is `false`.
- `elabels`: Edge labels. Default is `nothing`.
- `show_edge_labels`: Whether to show edge labels. Default is `false`.
- `edge_color`: Color of the edges. Default is `:black`.
- `elabels_color`: Color of the edge labels. Default is `:black`.
- `elabels_fontsize`: Font size of the edge labels. Default is `10`.
- `tangents`: Tangents for the edges. Default is `((0,-1),(0,-1))`.
- `arrow_show`: Whether to show arrows on the edges. Default is `false`.
- `arrow_marker`: Marker style for the arrows. Default is `'➤'`.
- `arrow_size`: Size of the arrows. Default is `12`.
- `arrow_shift`: Shift of the arrows. Default is `0.5`.
- `kwargs...`: Additional keyword arguments to pass to the plotting function.

# Returns
- A plot of the network graph with the specified layout and labels.

# Example
```julia
plot_network_coords(eng)
```
"""
function plot_network_coords(
                            data::Dict{String,Any};
                            show_node_labels=false,
                            show_edge_labels = false,
                            fallback_layout=GraphMakie.Buchheim(),
                            kwargs...
                            )

    network_graph, GraphLayout, _ = create_network_graph(data, fallback_layout)

    # Handle labels if required
    nlabels = show_node_labels ? [string(network_graph[i, :bus_id]) for i in 1:nv(network_graph)] : nothing
    elabels = show_edge_labels ? _is_eng(data) ? [string(get_prop(network_graph, e, :linecode)) for e in edges(network_graph)] : [string(get_prop(network_graph, e, :branch_id)) for e in edges(network_graph)] : nothing 
    # FORCED NODE FORMATTING:   
    _decorate_nodes!(network_graph, data)
    node_color = [ props(network_graph, i)[:node_color] for i in 1:nv(network_graph)]
    node_marker = [ props(network_graph, i)[:node_marker] for i in 1:nv(network_graph)]
    node_size = [ props(network_graph, i)[:marker_size] for i in 1:nv(network_graph)]

    _decorate_edges(network_graph, data)
    edge_color = [ get_prop(network_graph, e, :edge_color) for e in edges(network_graph)]


    # Plot the graph
    return  network_graph_plot(
                                    network_graph;
                                    layout=GraphLayout,
                                    
                                    show_node_labels=show_node_labels,
                                    nlabels=nlabels, 
                                    node_color=node_color,
                                    node_marker=node_marker,
                                    node_size=node_size,
                                    show_edge_labels=show_edge_labels,
                                    elabels=elabels,
                                    edge_color=edge_color,  
                                    kwargs...
                                )
end

function plot_network_coords!(
    data::Dict{String,Any};
    show_node_labels=false,
    show_edge_labels = false,
    fallback_layout=GraphMakie.Buchheim(),
    edge_labels_type = :line_id,
    kwargs...
    )

    network_graph, GraphLayout, _ = create_network_graph(data, fallback_layout)

    # Handle labels if required
    nlabels = show_node_labels ? [string(network_graph[i, :bus_id]) for i in 1:nv(network_graph)] : nothing
    elabels = show_edge_labels ? _is_eng(data) ? [string(get_prop(network_graph, e, edge_labels_type)) for e in edges(network_graph)] : [string(get_prop(network_graph, e, edge_labels_type == :line_id ? :branch_id : edge_labels_type)) for e in edges(network_graph)] : nothing 
    # FORCED NODE FORMATTING:   
    _decorate_nodes!(network_graph, data)
    node_color = [ props(network_graph, i)[:node_color] for i in 1:nv(network_graph)]
    node_marker = [ props(network_graph, i)[:node_marker] for i in 1:nv(network_graph)]
    node_size = [ props(network_graph, i)[:marker_size] for i in 1:nv(network_graph)]

    _decorate_edges(network_graph, data)
    edge_color = [ get_prop(network_graph, e, :edge_color) for e in edges(network_graph)]
    # Plot the graph
    return  network_graph_plot!(
                network_graph;
                layout=GraphLayout,
                
                show_node_labels=show_node_labels,
                nlabels=nlabels, 
                node_color=node_color,
                node_marker=node_marker,
                node_size=node_size,
                show_edge_labels=show_edge_labels,
                elabels=elabels,
                edge_color=edge_color,
                kwargs...
            )
end

"""
    plot_network_map(eng::Dict{String, Any}; show_node_labels=false, show_edge_labels=false, kwargs...)

Plots a network map based on the provided engineering data.

# Arguments
- `eng::Dict{String, Any}`: A dictionary containing the engineering data required to create the network graph.
- `show_node_labels::Bool`: A flag to indicate whether to display labels on the nodes. Default is `false`.
- `show_edge_labels::Bool`: A flag to indicate whether to display labels on the edges. Default is `false`.
- `network_graph::MetaDiGraph`: The network graph to be plotted.
- `GraphLayout::Function`: The layout function for positioning the nodes.
- `tiles_provider`: The tile provider for the map background. Default is `TileProviders.Google(:satelite)`.
- `zoom_lon`: The longitudinal zoom level. Default is `0.0942`.
- `zoom_lat`: The latitudinal zoom level. Default is `0.0942`.
- `makie_backend`: The Makie backend to use for plotting. Default is `WGLMakie`.
- `figure_size`: The size of the figure in pixels. Default is `(1000, 1200)`.
- `nlabels`: Node labels. Default is `nothing`.
- `ilabels`: Internal labels. Default is `nothing`.
- `node_color`: Color of the nodes. Default is `:black`.
- `node_size`: Size of the nodes. Default is `automatic`.
- `node_marker`: Marker style for the nodes. Default is `automatic`.
- `node_strokewidth`: Stroke width of the nodes. Default is `automatic`.
- `show_node_labels`: Whether to show node labels. Default is `false`.
- `elabels`: Edge labels. Default is `nothing`.
- `show_edge_labels`: Whether to show edge labels. Default is `false`.
- `edge_color`: Color of the edges. Default is `:black`.
- `elabels_color`: Color of the edge labels. Default is `:black`.
- `elabels_fontsize`: Font size of the edge labels. Default is `10`.
- `tangents`: Tangents for the edges. Default is `((0,-1),(0,-1))`.
- `arrow_show`: Whether to show arrows on the edges. Default is `false`.
- `arrow_marker`: Marker style for the arrows. Default is `'➤'`.
- `arrow_size`: Size of the arrows. Default is `12`.
- `arrow_shift`: Shift of the arrows. Default is `0.5`.
- `kwargs...`: Additional keyword arguments to customize the plot.

# Returns
- A plot of the network graph with optional node and edge labels.
# Example
```julia
plot_network_map(eng)
`````
"""

function plot_network_map(  
                            data::Dict{String, Any}; 
                            show_node_labels=false,
                            show_edge_labels=false,
                            kwargs...
                        )
    network_graph, GraphLayout = create_network_graph(data, GraphMakie.Buchheim())
    nlabels = show_node_labels ? [string(network_graph[i, :bus_id]) for i in 1:nv(network_graph)] : nothing
    elabels = show_edge_labels ? [string(get_prop(network_graph, e, :line_id)) for e in edges(network_graph)] : nothing

    if !isa(GraphLayout, Function)
        @warn "You are attempting to plot a network without coordinates on the map, that is not possible, instead the network tree graph will be plotted"
        return plot_network_coords(data, show_node_labels=show_node_labels, show_edge_labels=show_edge_labels, kwargs...)
    else
        @info "Plotting network map with coordinates on the map -- it is your responsibility to ensure the coordinates are at the correct place"
        _decorate_nodes!(network_graph, data)
        node_color = [ props(network_graph, i)[:node_color] for i in 1:nv(network_graph)]
        node_marker = [ props(network_graph, i)[:node_marker] for i in 1:nv(network_graph)]
        node_size = [ props(network_graph, i)[:marker_size] for i in 1:nv(network_graph)]

        _decorate_edges(network_graph, data)
        edge_color = [ get_prop(network_graph, e, :edge_color) for e in edges(network_graph)]
            
        return network_graph_map_plot(
                                        network_graph, GraphLayout;
                                        nlabels=nlabels,
                                        elabels=elabels,
                                        show_node_labels=show_node_labels,
                                        show_edge_labels=show_edge_labels,
                                        node_color=node_color,
                                        node_marker=node_marker,
                                        node_size=node_size,
                                        edge_color=edge_color,
                                        kwargs...
                                    )
    
    end

end



function _decorate_nodes!(network_graph::MetaDiGraph, data::Dict{String,Any})
    if _is_eng(data)
        sourcebus = data["voltage_source"]["source"]["bus"]

        for (_, node) in network_graph.vprops
            if node[:bus_id] == Symbol(sourcebus)
                node[:node_color] = :orange
                node[:node_marker] = :star5
                node[:marker_size] = 25
            else
                if !isempty(node[:loads])

                if length(node[:loads]) == 1
                    if length(node[:loads][1][:connections]) == 1
                        if node[:loads][1][:connections] == [1]
                            node[:node_color] = :red
                            node[:node_marker] = :dtriangle  # `↓`
                        elseif node[:loads][1][:connections] == [2]
                            node[:node_color] = :green
                            node[:node_marker] = :dtriangle  # `↓`
                        elseif node[:loads][1][:connections] == [3]
                            node[:node_color] = :blue
                            node[:node_marker] = :dtriangle  # `↓`
                        elseif node[:loads][1][:connections] == [4]
                            node[:node_color] = :black
                            node[:node_marker] = :dtriangle  # `↓`
                        else
                            error("Unexpected load connections of length $(length(node[:loads])): $(node[:loads][1][:connections]) at node $(string(node[:bus_id]))")
                        end
                    elseif length(node[:loads][1][:connections]) == 2
                        if node[:loads][1][:connections] == [1, 4]
                            node[:node_color] = :red
                            node[:node_marker] = :utriangle  # `↕`
                        elseif node[:loads][1][:connections] == [2, 4]
                            node[:node_color] = :green
                            node[:node_marker] = :utriangle  # `↕`
                        elseif node[:loads][1][:connections] == [3, 4]
                            node[:node_color] = :blue
                            node[:node_marker] = :utriangle  # `↕`
                        elseif node[:loads][1][:connections] == [1, 2]
                            node[:node_color] = :blue
                            node[:node_marker] = :rtriangle  # `↔`
                        elseif node[:loads][1][:connections] == [2, 3]
                            node[:node_color] = :blue
                            node[:node_marker] = :rtriangle  # `↔`
                        elseif node[:loads][1][:connections] == [3, 1]
                            node[:node_color] = :blue
                            node[:node_marker] = :rtriangle  # `↔`
                        else
                            error("Unexpected load connections of length $(length(node[:loads])): $(node[:loads][1][:connections]) at node $(string(node[:bus_id]))")
                        end
                    elseif length(node[:loads][1][:connections]) == 3
                        if node[:loads][1][:connections] == [1, 2, 3]
                            node[:node_color] = :purple
                            node[:node_marker] = :pentagon
                        else
                            error("Unexpected load connections of length $(length(node[:loads])): $(node[:loads][1][:connections]) at node $(string(node[:bus_id]))")
                        end 
                    elseif length(node[:loads][1][:connections]) == 4
                        if node[:loads][1][:connections] == [1, 2, 3, 4]
                            node[:node_color] = :purple
                            node[:node_marker] = :pentagon
                        else
                            error("Unexpected load connections of length $(length(node[:loads])): $(node[:loads][1][:connections]) at node $(string(node[:bus_id]))")
                        end
                    else
                        error("Unexpected load connections of length $(length(node[:loads])): $(node[:loads][1][:connections]) at node $(string(node[:bus_id]))")
                    end
                    node[:marker_size] = 10
                else
                    node[:node_color] = :purple
                    node[:node_marker] = :xcross
                    node[:marker_size] = 10
                end
                    
                else
                    node[:node_color] = :black
                    node[:node_marker] = :circle
                    node[:marker_size] = 1
                end
            end
        end
    else
        # TODO: MATH related formatting
    end
end


function _decorate_edges(network_graph::MetaDiGraph, data::Dict{String,Any})
    if _is_eng(data)
        for (_, edge) in network_graph.eprops
            if !isempty(edge[:t_connections])
                if length(edge[:t_connections]) == 1
                    if edge[:t_connections] == [1]
                        edge[:edge_color] = :red
                    elseif edge[:t_connections] == [2]
                        edge[:edge_color] = :green
                    elseif edge[:t_connections] == [3]
                        edge[:edge_color] = :blue
                    elseif edge[:t_connections] == [4]
                        edge[:edge_color] = :black
                    else
                        error("Unexpected connections: $(edge[:t_connections])")
                    end
                elseif length(edge[:t_connections]) == 2
                    if edge[:t_connections] == [1, 4]
                        edge[:edge_color] = :red
                    elseif edge[:t_connections] == [2, 4]
                        edge[:edge_color] = :green
                    elseif edge[:t_connections] == [3, 4]
                        edge[:edge_color] = :blue
                    elseif edge[:t_connections] == [1, 2]
                        edge[:edge_color] = :blue
                    elseif edge[:t_connections] == [2, 3]
                        edge[:edge_color] = :blue
                    elseif edge[:t_connections] == [3, 1]
                        edge[:edge_color] = :blue
                    else
                        error("Unexpected connections: $(edge[:t_connections])")
                    end
                elseif length(edge[:t_connections]) == 3
                    if edge[:t_connections] == [1, 2, 3]
                        edge[:edge_color] = :purple
                    elseif edge[:t_connections] == [1, 2, 4]
                        edge[:edge_color] = :blue
                    elseif edge[:t_connections] == [2, 3, 4]
                        edge[:edge_color] = :blue
                    elseif edge[:t_connections] == [3, 1, 4]
                        edge[:edge_color] = :blue
                    else
                        error("Unexpected connections: $(edge[:t_connections])")
                    end
                elseif length(edge[:t_connections]) == 4
                    if edge[:t_connections] == [1, 2, 3, 4]
                        edge[:edge_color] = :purple
                    else
                        error("Unexpected connections: $(edge[:t_connections])")
                    end
                else
                    edge[:edge_color] = :gray
                end
            else
                edge[:edge_color] = :black
            
            end
        end 
    else
        #TODO: MATH related formatting
    end
end
