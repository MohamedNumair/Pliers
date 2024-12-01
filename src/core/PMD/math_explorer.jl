
function math_buses_table(math::Dict{String, Any})
    buses = haskey(math, "bus") ? math["bus"] : error("No buses found in the MATHEMATICAL data check the data model has \"bus\" key") 
    

    
    buses_df = DataFrame(   
                           index = Int[],
                           bus_id = String[],
                           bus_type = Int[],
                           terminals = Vector{Int}[], 
                           grounded = Vector{Int}[],
                           vm_pair_ub = Vector{Tuple{Any, Any, Real}}[],
                           vm_pair_lb = Vector{Tuple{Any, Any, Real}}[],
                           source_id = String[],
                           vbase = Float64[],
                           vmin = Vector{Float64}[],
                           vmax = Vector{Float64}[],
                        )    
    for (bus_id, bus) in buses
        push!(buses_df, (   
                            get(bus, "index", missing),
                            bus_id,
                            get(bus, "bus_type", missing),
                            get(bus, "terminals", Int[]),
                            get(bus, "grounded", Int[]),
                            get(bus, "vm_pair_ub", Tuple{Any, Any, Real}[]),
                            get(bus, "vm_pair_lb", Tuple{Any, Any, Real}[]),
                            get(bus, "source_id", missing),
                            get(bus, "vbase", missing),
                            get(bus, "vmin", Float64[]),
                            get(bus, "vmax", Float64[]),
                        ))
    end
    header("Buses Table ($(nrow(buses_df)) buses)")
    pretty_table(buses_df)
    extra_keys(buses, ["index", "bus_id", "bus_type", "terminals", "grounded", "vm_pair_ub", "vm_pair_lb", "source_id", "vbase", "vmin", "vmax"])
end
