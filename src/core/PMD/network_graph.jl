




function create_network_graph(data::Dict{String,Any}, fallback_layout)
    _is_eng(data) ? create_network_graph_eng(data, fallback_layout) : create_network_graph_math(data, fallback_layout)
end

"""
    create_network_graph_eng(eng::Dict{String,Any}, fallback_layout) -> MetaDiGraph, Function, Dict{Symbol,Any}
"""
function create_network_graph_eng(eng::Dict{String,Any}, fallback_layout) 
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
    

    # enriching buses with loads and shunts connected to them 

    for (_,bus) in eng_sym[:bus]
        bus[:loads] = []
        bus[:shunts] = []
        if haskey(eng_sym, :load)
        for (l,load) in eng_sym[:load]
            if Symbol(load[:bus]) == bus[:bus_id]
                push!(bus[:loads], load)
            end
        end
        end
        
        if haskey(eng_sym, :shunt)
        for (_,shunt) in eng_sym[:shunt]
            if Symbol(shunt[:bus]) == bus[:bus_id]
                push!(bus[:shunts], shunt)
            end
        end
        end

    end


    # enriching lines with the linecodes

    for (_, line) in eng_sym[:line]
        line[:linecodes] = eng_sym[:linecode][Symbol(line[:linecode])]
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
    for (_, bus) in eng_sym[:bus]
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
    for (_, line) in eng_sym[:line]
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
        @warn "Note there were no coordinates found for plotting, the fallback (e.g. tree layout) layout will be used"
        GraphLayout = fallback_layout
    end

    return network_graph, GraphLayout, eng_sym
end


"""
    create_network_graph_math(math::Dict{String,Any}, fallback_layout) -> MetaDiGraph, Function, Dict{Symbol,Any}
"""
function create_network_graph_math(math::Dict{String,Any}, fallback_layout) 
    math_sym = convert_keys_to_symbols(deepcopy(math))
    network_graph = MetaDiGraph()

    lons = []
    lats = []
    
    # Add bus keys as :bus_id and collect coordinates if present
    for (b, bus) in math_sym[:bus]
        bus[:bus_id] = b
        if haskey(bus, :lon) && haskey(bus, :lat)
            push!(lons, bus[:lon])
            push!(lats, bus[:lat])
        end
    end    
    
    for (l, branch) in math_sym[:branch]
        branch[:branch_id] = l
    end

    # Determine source coordinates if available
    lon_s, lat_s = nothing, nothing
    if length(lons) > 0
        virtual_branch = findfirst(branch -> contains(branch["name"], "_virtual_branch.voltage_source.source"), math["branch"])
        if virtual_branch !== nothing
            lon_s = math_sym[:bus][Symbol(math_sym[:branch][virtual_branch][:t_bus])][:lon]
            lat_s = math_sym[:bus][Symbol(math_sym[:branch][virtual_branch][:t_bus])][:lat]
        end
    end
    
    layouting_vector = []

    # Add `sourcebus` as the root
    virtual_bus = findfirst(bus -> contains(bus[:name], "virtual_bus.voltage_source.source"), math_sym[:bus])

    display(virtual_bus)
    if haskey(math_sym[:bus], virtual_bus)
        add_vertex!(network_graph, math_sym[:bus][virtual_bus])
        if length(lons) > 0 && lon_s !== nothing && lat_s !== nothing
            push!(layouting_vector, (lon_s, lat_s))
        end
    else 
        error("sourcebus not found in the bus data. Please add sourcebus to the bus data.")
    end

    # Add the rest of the buses
    for (_, bus) in math_sym[:bus]
        if bus[:bus_id] != virtual_bus
            add_vertex!(network_graph, bus)
            if haskey(bus, :lon) && haskey(bus, :lat)
                push!(layouting_vector, (bus[:lon], bus[:lat]))
            end
        end
    end

    # Use bus_id as the indexing property
    set_indexing_prop!(network_graph, :bus_id)

    # Add edges based on f_bus and t_bus
    for (_, branch) in math_sym[:branch]
        f_bus = Symbol(branch[:f_bus])
        t_bus = Symbol(branch[:t_bus])
        f_vertex = network_graph[f_bus, :bus_id]
        t_vertex = network_graph[t_bus, :bus_id]
        add_edge!(network_graph, f_vertex, t_vertex, branch)
    end
    
    # Decide on the layout
    if length(layouting_vector) > 1
        GraphLayout = _ -> layouting_vector
    else
        @warn "Note there were no coordinates found for plotting, the fallback (e.g. tree layout) layout will be used"
        GraphLayout = fallback_layout
    end

    return network_graph, GraphLayout, math_sym
end


function get_graph_node(G, node)
    Gidx = G[Symbol(node), :bus_id]
    return props(G, Gidx)
end


function get_graph_node(G, node, key)
    Gidx = G[Symbol(node), :bus_id]
    return props(G, Gidx)[Symbol(key)]
end

function get_graph_edge(G, edge_id)
    if _is_eng(G)
        Eid = findall(e -> e[:line_id] == Symbol(edge_id), G.eprops)  
    else
        Eid = findall(e -> e[:branch_id] == Symbol(edge_id), G.eprops)
    end
    return G.eprops[Eid...]
end
function get_graph_edge(G, edge_id, key)
    if _is_eng(G)
        Eid = findall(e -> e[:line_id] == Symbol(edge_id), G.eprops)  
    else
        Eid = findall(e -> e[:branch_id] == Symbol(edge_id), G.eprops)
    end
    return G.eprops[Eid...][Symbol(key)]
end
