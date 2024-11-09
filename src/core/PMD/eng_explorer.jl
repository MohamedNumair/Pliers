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
function eng_report(eng::Dict{String, Any})
    # Get the eng
    buses = haskey(eng, "bus") ? eng["bus"] : nothing
    lines = haskey(eng, "line") ? eng["line"] : nothing
    linecodes = haskey(eng, "linecode") ? eng["linecode"] : nothing
    loads = haskey(eng, "load") ? eng["load"] : nothing
    voltage_sources = haskey(eng, "voltage_source") ? eng["voltage_source"] : nothing
    time_series = haskey(eng, "time_series") ? eng["time_series"] : nothing
    conductor_ids = haskey(eng, "conductor_ids") ? eng["conductor_ids"] : nothing
    name = haskey(eng, "name") ? eng["name"] : nothing
    settings = haskey(eng, "settings") ? eng["settings"] : nothing
    files = haskey(eng, "files") ? eng["files"] : nothing
    data_model = haskey(eng, "data_model") ? eng["data_model"] : nothing
    
    print(UNDERLINE(BLUE_FG("Report for the ",   BOLD("$data_model"), " model of the network  ", BOLD("$name")," prased from ",BOLD("$(split(files[1],"/")[end])"), " \n")))

    print(WHITE_FG("This network has:\n"))
    print("             $(BOLD("$(length(get(eng, "voltage_source", [])))")) voltage sources, \n")
    print("             $(BOLD("$(length(get(eng, "bus", [])))")) buses, \n")
    print("             $(BOLD("$(length(get(eng, "conductor_ids", [])))")) terminals per bus, \n")
    print("             $(BOLD("$(length(get(eng, "line", [])))")) lines, \n")
    print("             $(BOLD("$(length(get(eng, "linecode", [])))")) linecodes, \n")
    print("             $(BOLD("$(length(get(eng, "load", [])))")) loads, \n")
    print("             $(BOLD("$(length(get(eng, "time_series", [])))")) time series data points.\n")


    buses_table(eng)
    lines_table(eng)

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
    print(UNDERLINE(BLUE_FG("Buses Table\n")))
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
    pretty_table(buses_df)

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
    print(UNDERLINE(BLUE_FG("Filtered Buses Table\n")))
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
    pretty_table(buses_df)
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
    """the eng["line"] is with Dict{String, Any} with 8 entries:
        "length"        => 1.0
        "t_connections" => [1, 2, 3]
        "f_bus"         => "primary"
        "source_id"     => "line.quad"
        "status"        => ENABLED
        "t_bus"         => "loadbus"
        "linecode"      => "4/0quad"
        "f_connections" => [1, 2, 3]
    """
    print(UNDERLINE(BLUE_FG("Lines Table\n")))
    lines = haskey(eng, "line") ? eng["line"] : nothing

    lines_df = DataFrame(   line_id = String[],
                            source_id = String[],
                            status = String[],
                            f_bus = String[],
                            f_connections = Array{Int64, 1}[],
                            t_bus = String[],
                            t_connections = Array{Int64, 1}[],
                            length = Float64[],
                            linecode = String[]
                        )

    for (line_id, line) in lines

        push!(lines_df, (   line_id,
                            get(line, "source_id", ""),
                            string(get(line, "status", "")),
                            get(line, "f_bus", ""),
                            get(line, "f_connections", Int[]),
                            get(line, "t_bus", ""),
                            get(line, "t_connections", Int[]),
                            get(line, "length", 0.0),
                            get(line, "linecode", "")
                        ))
    
    end
    pretty_table(lines_df)

    extra_keys(lines, ["source_id", "status", "f_bus", "f_connections", "t_bus", "t_connections","length", "linecode"])

end

"""
    lines_table(eng::Dict{String,Any}, condition)

Generate and display a filtered table of lines from the given engineering data.
"""






"""
    extra_keys(eng_data::Dict{String, Any}, expected_keys)
Checks if there are extra keys in the KeySet of the dictionary `eng_data` that are not in the list `keys` and prints them.

# Arguments
- `eng_data::Dict{String, Any}`: A dictionary containing the data to be checked.
- `expected_keys`: A list of keys that are expected to be in the dictionary.
- `show_keys=false`: A boolean indicating whether to print the expected keys, the keys in the dictionary, and the extra keys.

# Description
This function compares the keys in the dictionary `eng_data` with the list of `expected_keys` and prints a warning message if there are extra keys in the dictionary that are not in the list. If `show_keys` is set to `true`, the expected keys, the keys in the dictionary, and the extra keys are printed.

# Example
```julia
using PowerModelsDistribution
using PowerDistributionAnalysis
eng= PowerModelsDistribution.parse_file("example.dss")
extra_keys(eng, ["bus", "line", "linecode", "load", "voltage_source", "time_series", "conductor_ids", "name", "settings", "files", "data_model"])
```

"""

function extra_keys(eng_data::Dict{String, Any}, expected_keys; show_keys=false)
    eng_data_keys = keys(first(eng_data).second)
    extra_keys = setdiff(eng_data_keys,expected_keys)
    
    if length(extra_keys) > 0
        print(RED_FG("Warning: Extra coulmns exist in the data model: $(extra_keys) \n"))
    end

    if show_keys
        @show expected_keys
        @show eng_data_keys
        @show extra_keys
    end
end
