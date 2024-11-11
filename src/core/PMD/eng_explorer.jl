## eng_report
"""
    eng_report(eng::Dict{String, Any})

Generate a report for the electrical network described by the dictionary `eng`.

# Arguments
- `eng::Dict{String, Any}`: A dictionary containing various components of the electrical network.

# Description
This function extracts various components from the `eng` dictionary, such as buses, lines, linecodes, loads, voltage sources, time series data, conductor IDs, name, settings, files, and data model. It then prints a formatted report summarizing the contents of the network, including the number of each component present.

# Example
```julia
using PowerModelsDistribution
using PowerDistributionAnalysis 
eng= PowerModelsDistribution.parse_file("example.dss")
eng_report(eng)
```
"""
function eng_report(eng::Dict{String, Any}; detailed = false)
    print(UNDERLINE(BLUE_FG("Report for the ",   BOLD("$(get(eng, "data_model", nothing))"),
     " model of the network  ", BOLD("$(get(eng, "name", nothing))")," prased from ",BOLD("$(split(get(eng,"files",[nothing])[1],"/")[end])"), " \n")))

    print(WHITE_FG("This network has:\n"))
    print("             $(BOLD("$(length(get(eng, "voltage_source", [])))")) voltage sources, \n")
    print("             $(BOLD("$(length(get(eng, "bus", [])))")) buses, \n")
    print("             $(BOLD("$(length(get(eng, "conductor_ids", [])))")) terminals per bus, \n")
    print("             $(BOLD("$(length(get(eng, "line", [])))")) lines, \n")
    print("             $(BOLD("$(length(get(eng, "linecode", [])))")) linecodes, \n")
    print("             $(BOLD("$(length(get(eng, "load", [])))")) loads, \n")
    print("             $(BOLD("$(length(get(eng, "time_series", [])))")) time series data points.\n")

if detailed == true
    buses_table(eng)
    lines_table(eng)
    loads_table(eng)
end

end


## buses_table
"""
    buses_table(eng::Dict{String, Any})

Generate a table summarizing the buses in the electrical network described by the dictionary `eng`.

# Arguments
- `eng::Dict{String, Any}`: A dictionary containing various components of the electrical network.

# Description
This function extracts the buses from the `eng` dictionary and creates a DataFrame with the bus ID, status, terminals, resistance to ground (rg), reactance to ground (xg), and grounding status. It then prints a formatted table of the buses.

# Example
```julia
using PowerModelsDistribution
using PowerDistributionAnalysis 
eng= PowerModelsDistribution.parse_file("example.dss")
buses_table(eng)
```
"""  
function buses_table(eng::Dict{String, Any})
    buses = haskey(eng, "bus") ? eng["bus"] : nothing
    buses_df = DataFrame(   bus_id = String[],
    status = String[],
    terminals = Array{Int64, 1}[],
    rg = Array{Float64, 1}[],
    xg = Array{Float64, 1}[],
    grounded = Array{Int64, 1}[]
    )
    
    for (bus_id, bus) in buses
        push!(buses_df, (   bus_id,
        string(get(bus,"status","")),
        get(bus, "terminals", Int[]),
        get(bus, "rg", Float64[]),
        get(bus, "xg", Float64[]),
        get(bus, "grounded", Int[])
        ))
    end
    header("Buses Table ($(nrow(buses_df)) buses)")
    pretty_table(sort!(buses_df))
    extra_keys(buses, ["status", "terminals", "rg", "xg", "grounded"])
end

"""
    buses_table(eng::Dict{String,Any}, condition)

Generate and display a filtered table of buses from the given engineering data.

# Arguments
- `eng::Dict{String,Any}`: A dictionary containing engineering data, which must include a "bus" key with bus information.
- `condition`: A function that takes a bus dictionary as input and returns a boolean indicating whether the bus meets the filtering criteria.

# Description
This function extracts bus information from the provided engineering data dictionary, applies the given condition to filter the buses, and then displays the filtered buses in a formatted table. Each bus is augmented with its `bus_id` before filtering. The table includes columns for `bus_id`, `status`, `terminals`, `rg`, `xg`, and `grounded`.

# Example
```julia
using PowerModelsDistribution
using PowerDistributionAnalysis 
eng= PowerDistributionAnalysis.parse_file("example.dss")
buses_table(eng, bus -> bus["bus_id"] =="sourcebus")

````
or 

```julia
buses_table(eng, bus -> haskey(bus, "grounded") && bus["grounded"]==[4])
```
"""
function buses_table(eng::Dict{String,Any}, condition::Function)
    buses = haskey(eng, "bus") ? eng["bus"] : nothing
    # adding the bus_id to the bus dictionary so it can be filtered by name
    for (bus_id, bus) in buses
        bus["bus_id"] = bus_id
    end
    
    buses_df = DataFrame(   bus_id = String[],
    status = String[],
    terminals = Array{Int64, 1}[],
    rg = Array{Float64, 1}[],
    xg = Array{Float64, 1}[],
    grounded = Array{Int64, 1}[]
    )
    
    for (bus_id, bus) in buses
        if condition(bus)
            push!(buses_df, (bus_id,  string(bus["status"]), bus["terminals"], bus["rg"], bus["xg"], bus["grounded"]))
        end
    end
    header("Filtered Buses Table ($(nrow(buses_df)) buses)")
    pretty_table(sort!(buses_df))
    extra_keys(buses, ["status", "terminals", "rg", "xg", "grounded"])
end

  
## lines table

"""
    lines_table(eng::Dict{String, Any})

Generate a table summarizing the lines in the electrical network described by the dictionary `eng`.

# Arguments
- `eng::Dict{String, Any}`: A dictionary containing various components of the electrical network.

# Description
This function extracts the lines from the `eng` dictionary and creates a DataFrame with the line ID, status, from bus, to bus, length, resistance, reactance, and linecode. It then prints a formatted table of the lines.

# Example
```julia
using PowerModelsDistribution
using PowerDistributionAnalysis
eng= PowerModelsDistribution.parse_file("example.dss")
lines_table(eng)
```
"""
function lines_table(eng::Dict{String, Any})
    lines = haskey(eng, "line") ? eng["line"] : nothing
    
    lines_df = DataFrame(   line_id = String[],
    source_id = String[],
    f_bus = String[],
                            f_connections = Array{Int64, 1}[],
                            t_bus = String[],
                            t_connections = Array{Int64, 1}[],
                            length = Float64[],
                            linecode = String[],
                            status = String[],
                            )
                            
                            for (line_id, line) in lines
                                
        push!(lines_df, (   line_id,
        get(line, "source_id", ""),
        get(line, "f_bus", ""),
        get(line, "f_connections", Int[]),
        get(line, "t_bus", ""),
        get(line, "t_connections", Int[]),
        get(line, "length", 0.0),
        get(line, "linecode", ""),
        string(get(line, "status", "")),
        )
        )
        
    end
    header("Lines Table ($(nrow(lines_df)) lines)")
    pretty_table(sort!(lines_df, [:f_bus, :t_bus, :line_id]))
    
    extra_keys(lines, ["line_id","source_id", "status", "f_bus", "f_connections", "t_bus", "t_connections","length", "linecode"])
    
end

"""
    lines_table(eng::Dict{String,Any}, condition)

Generate and display a filtered table of lines from the given engineering data.

# Arguments
- `eng::Dict{String,Any}`: A dictionary containing engineering data, which must include a "line" key with line information.
- `condition`: A function that takes a line dictionary as input and returns a boolean indicating whether the line meets the filtering criteria.

# Description
This function extracts line information from the provided engineering data dictionary, applies the given condition to filter the lines, and then displays the filtered lines in a formatted table. Each line is augmented with its `line_id` before filtering. The table includes columns for `line_id`, `source_id`, `f_bus`, `f_connections`, `t_bus`, `t_connections`, `length`, `linecode`, and `status`.

# Example
```julia
using PowerModelsDistribution
using PowerDistributionAnalysis
eng= PowerModelsDistribution.parse_file("example.dss")
lines_table(eng, line -> line["length"] > 0.75)
```
"""

function lines_table(eng::Dict{String,Any}, condition::Function)
    lines = haskey(eng, "line") ? eng["line"] : nothing
    # adding the line_id to the line dictionary so it can be filtered by name
    for (line_id, line) in lines
        line["line_id"] = line_id
    end
    
    lines_df = DataFrame(   line_id = String[],
    source_id = String[],
    f_bus = String[],
    f_connections = Array{Int64, 1}[],
    t_bus = String[],
    t_connections = Array{Int64, 1}[],
    length = Float64[],
    linecode = String[],
    status = String[],
    )
    
    for (line_id, line) in lines
        if condition(line)
            push!(lines_df, (   line_id,
                                get(line, "source_id", ""),
                                get(line, "f_bus", ""),
                                get(line, "f_connections", Int[]),
                                get(line, "t_bus", ""),
                                get(line, "t_connections", Int[]),
                                get(line, "length", 0.0),
                                get(line, "linecode", ""),
                                string(get(line, "status", "")),
                                )
                                )
                            end
    end
    header("Filtered Lines Table ($(nrow(lines_df)) lines)")
    pretty_table(sort!(lines_df, [:f_bus, :t_bus, :line_id]))
    extra_keys(lines, ["line_id", "source_id", "status", "f_bus", "f_connections", "t_bus", "t_connections","length", "linecode"])
end


#loads_table
"""
    loads_table(eng::Dict{String, Any})

Generate a table summarizing the loads in the electrical network described by the dictionary `eng`.

# Arguments
- `eng::Dict{String, Any}`: A dictionary containing various components of the electrical network.

# Description
This function extracts the loads from the `eng` dictionary and creates a DataFrame with the load ID, status, bus, phases, kw, kvar, and kva. It then prints a formatted table of the loads.

# Example

```julia
using PowerModelsDistribution
using PowerDistributionAnalysis
eng= PowerModelsDistribution.parse_file("example.dss")
loads_table(eng)
```
"""
function loads_table(eng::Dict{String, Any})
    loads = haskey(eng, "load") ? eng["load"] : nothing
    loads_df = DataFrame(  load_id = String[],
    source_id = String[],
    bus = String[],
    connections = Array{Int64, 1}[],
    vm_nom = Float64[],
    pd_nom = Array{Float64, 1}[],
    qd_nom = Array{Float64, 1}[],
                            configuration = String[],
                            model = String[],
                            dispatchable = String[],
                            status = String[],
                        )

                        for (load_id, load) in loads
                            push!(loads_df, (   load_id,
                            get(load, "source_id", ""),
                            get(load, "bus", ""),
                            get(load, "connections", Vector{Int64}[]),
                            get(load, "vm_nom", 0.0),
                            get(load, "pd_nom", Vector{Float64}[]),
                            get(load, "qd_nom",Vector{Float64}[]),
                            string(get(load, "configuration", "")),
                            string(get(load, "model","")),
                            string(get(load, "dispatchable", "")),
                            string(get(load, "status", "")),
                            ))
                        end
    header("Loads Table ($(nrow(loads_df)) loads)")
    pretty_table(sort!(loads_df))
    extra_keys(loads, ["load_id","source_id", "status", "bus", "connections", "pd_nom", "qd_nom", "vm_nom", "model", "dispatchable", "configuration"])
 end

""" 
    loads_table(eng::Dict{String,Any}, condition)
Generate and display a filtered table of loads from the given engineering data.

# Arguments
- `eng::Dict{String,Any}`: A dictionary containing engineering data, which must include a "load" key with load information.
- `condition`: A function that takes a load dictionary as input and returns a boolean indicating whether the load meets the filtering criteria.

# Description
This function extracts load information from the provided engineering data dictionary, applies the given condition to filter the loads, and then displays the filtered loads in a formatted table. Each load is augmented with its `load_id` before filtering. The table includes columns for `load_id`, `source_id`, `bus`, `connections`, `vm_nom`, `pd_nom`, `qd_nom`, `configuration`, `model`, `dispatchable`, and `status`.

# Example
- filter the loads by the value of `pd_nom`:
    ```julia
    loads_table(eng, load -> load["pd_nom"] > [0.33])
    ```
- filter the loads by the phase connectivity
    ```julia
    loads_table(eng, load -> load["connections"] == [1, 4])
    ```
"""
function loads_table(eng::Dict{String,Any}, condition::Function)
    loads = haskey(eng, "load") ? eng["load"] : nothing
    # adding the load_id to the load dictionary so it can be filtered by name
    for (load_id, load) in loads
        load["load_id"] = load_id
    end

    loads_df = DataFrame(  load_id = String[],
                            source_id = String[],
                            bus = String[],
                            connections = Array{Int64, 1}[],
                            vm_nom = Float64[],
                            pd_nom = Array{Float64, 1}[],
                            qd_nom = Array{Float64, 1}[],
                            configuration = String[],
                            model = String[],
                            dispatchable = String[],
                            status = String[],
                        )

    for (load_id, load) in loads
        if condition(load)
            push!(loads_df, (   load_id,
                                get(load, "source_id", ""),
                                get(load, "bus", ""),
                                get(load, "connections", Vector{Int64}[]),
                                get(load, "vm_nom", 0.0),
                                get(load, "pd_nom", Vector{Float64}[]),
                                get(load, "qd_nom",Vector{Float64}[]),
                                string(get(load, "configuration", "")),
                                string(get(load, "model","")),
                                string(get(load, "dispatchable", "")),
                                string(get(load, "status", "")),
                            ))
        end
    end
    header("Filtered Loads Table ($(nrow(loads_df)) loads)")
    pretty_table(sort!(loads_df))
    extra_keys(loads, ["load_id","source_id", "status", "bus", "connections", "pd_nom", "qd_nom", "vm_nom", "model", "dispatchable", "configuration"])
end



# linecode table


function linecodes_table(eng::Dict{String, Any})
    linecodes = haskey(eng, "linecode") ? eng["linecode"] : nothing
    
    
    header("Linecodes Table ($(length(linecodes)) linecodes)")
    c = 0

    for (linecode_id, linecode) in linecodes    
        c=c+1
        sub_header("$(c) - Linecode: $(linecode_id)")
        
        for (key, matrix) in linecode
            sub_sub_header("$(linecode_id) - ($key) :")
            try
            isa(matrix, Array) || error("The $key is not a matrix")
            mx = deepcopy(matrix)
            mx = hcat([range(1, size(mx,1))...], mx)
            pretty_table(mx,
                         header=[range(0, size(mx,2)-1)...],
                         highlighters=(highlight_row_label, highlight_diagonal, highlight_off_diagonal),
                         formatters    = ft_printf("%1.0f", 1:1),
                         )
            catch e 
                error_text("parsing the $key it might not be a matrix: $(e)")
            end

        end
    end
    
    
    
    #pretty_table(sort!(linecodes_df))
    #extra_keys(linecodes, ["rs", "xs", "g_fr", "g_to", "b_fr", "b_to", "cm_ub"])
end


