
List of all functions
<details class='jldocstring custom-block' open>
<summary><a id='Pliers.buses_table-Tuple{Dict{String, Any}, Function}' href='#Pliers.buses_table-Tuple{Dict{String, Any}, Function}'><span class="jlbinding">Pliers.buses_table</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
buses_table(eng::Dict{String,Any}, condition)
```


Generate and display a filtered table of buses from the given engineering data.

**Arguments**
- `eng::Dict{String,Any}`: A dictionary containing engineering data, which must include a &quot;bus&quot; key with bus information.
  
- `condition`: A function that takes a bus dictionary as input and returns a boolean indicating whether the bus meets the filtering criteria.
  

**Description**

This function extracts bus information from the provided engineering data dictionary, applies the given condition to filter the buses, and then displays the filtered buses in a formatted table. Each bus is augmented with its `bus_id` before filtering. The table includes columns for `bus_id`, `status`, `terminals`, `rg`, `xg`, and `grounded`.

**Example**

`````julia
using PowerModelsDistribution
using Pliers 
eng= Pliers.parse_file("example.dss")
buses_table(eng, bus -> bus["bus_id"] =="sourcebus")

````
or 

`````


julia buses_table(eng, bus -&gt; haskey(bus, &quot;grounded&quot;) &amp;&amp; bus[&quot;grounded&quot;]==[4]) ```


[source](https://github.com/MohamedNumair/Pliers.jl)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Pliers.buses_table-Tuple{Dict{String, Any}}' href='#Pliers.buses_table-Tuple{Dict{String, Any}}'><span class="jlbinding">Pliers.buses_table</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
buses_table(eng::Dict{String, Any})
```


Generate a table summarizing the buses in the electrical network described by the dictionary `eng`.

**Arguments**
- `eng::Dict{String, Any}`: A dictionary containing various components of the electrical network.
  

**Description**

This function extracts the buses from the `eng` dictionary and creates a DataFrame with the bus ID, status, terminals, resistance to ground (rg), reactance to ground (xg), and grounding status. It then prints a formatted table of the buses.

**Example**

```julia
using PowerModelsDistribution
using Pliers 
eng= PowerModelsDistribution.parse_file("example.dss")
buses_table(eng)
```



[source](https://github.com/MohamedNumair/Pliers.jl)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Pliers.default_index_value-Tuple{Integer, Symbol, Set}' href='#Pliers.default_index_value-Tuple{Integer, Symbol, Set}'><span class="jlbinding">Pliers.default_index_value</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
default_index_value(v, prop, index_values; exclude=nothing)
```


Provides a default index value for a vertex if no value currently exists. The default is a string: &quot;$prop$i&quot; where `prop` is the property name and `i` is the vertex number. If some other vertex already has this name, a randomized string is generated (though the way it is generated is deterministic).


[source](https://github.com/MohamedNumair/Pliers.jl)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Pliers.diff_vectors-Tuple{Vector{Float64}, Vector{Float64}}' href='#Pliers.diff_vectors-Tuple{Vector{Float64}, Vector{Float64}}'><span class="jlbinding">Pliers.diff_vectors</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
diff_vectors(vec1::Vector{Float64}, vec2::Vector{Float64})
```


Prints the difference between two vectors element-wise.

**Arguments**
- `vec1::Vector{Float64}`: The first vector.
  
- `vec2::Vector{Float64}`: The second vector.
  

**Example**

diff_vectors([1.0, 2.0, 3.0], [1.0, 2.0, 4.0])


[source](https://github.com/MohamedNumair/Pliers.jl)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Pliers.eng_report-Tuple{Dict{String, Any}}' href='#Pliers.eng_report-Tuple{Dict{String, Any}}'><span class="jlbinding">Pliers.eng_report</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
eng_report(eng::Dict{String, Any})
```


Generate a report for the electrical network described by the dictionary `eng`.

**Arguments**
- `eng::Dict{String, Any}`: A dictionary containing various components of the electrical network.
  

**Description**

This function extracts various components from the `eng` dictionary, such as buses, lines, linecodes, loads, voltage sources, time series data, conductor IDs, name, settings, files, and data model. It then prints a formatted report summarizing the contents of the network, including the number of each component present.

**Example**

```julia
using PowerModelsDistribution
using Pliers 
eng= PowerModelsDistribution.parse_file("example.dss")
eng_report(eng)
```



[source](https://github.com/MohamedNumair/Pliers.jl)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Pliers.extra_keys-Tuple{Dict{String, Any}, Any}' href='#Pliers.extra_keys-Tuple{Dict{String, Any}, Any}'><span class="jlbinding">Pliers.extra_keys</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
extra_keys(eng_data::Dict{String, Any}, expected_keys)
```


Checks if there are extra keys in the KeySet of the dictionary `eng_data` that are not in the list `keys` and prints them.

**Arguments**
- `eng_data::Dict{String, Any}`: A dictionary containing the data to be checked.
  
- `expected_keys`: A list of keys that are expected to be in the dictionary.
  
- `show_keys=false`: A boolean indicating whether to print the expected keys, the keys in the dictionary, and the extra keys.
  

**Description**

This function compares the keys in the dictionary `eng_data` with the list of `expected_keys` and prints a warning message if there are extra keys in the dictionary that are not in the list. If `show_keys` is set to `true`, the expected keys, the keys in the dictionary, and the extra keys are printed.

**Example**

```julia
using PowerModelsDistribution
using Pliers
eng= PowerModelsDistribution.parse_file("example.dss")
extra_keys(eng, ["bus", "line", "linecode", "load", "voltage_source", "time_series", "conductor_ids", "name", "settings", "files", "data_model"])
```



[source](https://github.com/MohamedNumair/Pliers.jl)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Pliers.lines_table-Tuple{Dict{String, Any}}' href='#Pliers.lines_table-Tuple{Dict{String, Any}}'><span class="jlbinding">Pliers.lines_table</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
lines_table(eng::Dict{String, Any})
```


Generate a table summarizing the lines in the electrical network described by the dictionary `eng`.

**Arguments**
- `eng::Dict{String, Any}`: A dictionary containing various components of the electrical network.
  

**Description**

This function extracts the lines from the `eng` dictionary and creates a DataFrame with the line ID, status, from bus, to bus, length, resistance, reactance, and linecode. It then prints a formatted table of the lines.

**Example**

```julia
using PowerModelsDistribution
using Pliers
eng= PowerModelsDistribution.parse_file("example.dss")
lines_table(eng)
```



[source](https://github.com/MohamedNumair/Pliers.jl)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Pliers.loads_table-Tuple{Dict{String, Any}, Function}' href='#Pliers.loads_table-Tuple{Dict{String, Any}, Function}'><span class="jlbinding">Pliers.loads_table</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
loads_table(eng::Dict{String,Any}, condition)
```


Generate and display a filtered table of loads from the given engineering data.

**Arguments**
- `eng::Dict{String,Any}`: A dictionary containing engineering data, which must include a &quot;load&quot; key with load information.
  
- `condition`: A function that takes a load dictionary as input and returns a boolean indicating whether the load meets the filtering criteria.
  

**Description**

This function extracts load information from the provided engineering data dictionary, applies the given condition to filter the loads, and then displays the filtered loads in a formatted table. Each load is augmented with its `load_id` before filtering. The table includes columns for `load_id`, `source_id`, `bus`, `connections`, `vm_nom`, `pd_nom`, `qd_nom`, `configuration`, `model`, `dispatchable`, and `status`.

**Example**
- filter the loads by the value of `pd_nom`:   `julia   loads_table(eng, load -> load["pd_nom"] > [0.33])`
  
- filter the loads by the phase connectivity   `julia   loads_table(eng, load -> load["connections"] == [1, 4])`
  


[source](https://github.com/MohamedNumair/Pliers.jl)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Pliers.loads_table-Tuple{Dict{String, Any}}' href='#Pliers.loads_table-Tuple{Dict{String, Any}}'><span class="jlbinding">Pliers.loads_table</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
loads_table(eng::Dict{String, Any})
```


Generate a table summarizing the loads in the electrical network described by the dictionary `eng`.

**Arguments**
- `eng::Dict{String, Any}`: A dictionary containing various components of the electrical network.
  

**Description**

This function extracts the loads from the `eng` dictionary and creates a DataFrame with the load ID, status, bus, phases, kw, kvar, and kva. It then prints a formatted table of the loads.

**Example**

```julia
using PowerModelsDistribution
using Pliers
eng= PowerModelsDistribution.parse_file("example.dss")
loads_table(eng)
```



[source](https://github.com/MohamedNumair/Pliers.jl)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Pliers.plot_network_tree-Tuple{String}' href='#Pliers.plot_network_tree-Tuple{String}'><span class="jlbinding">Pliers.plot_network_tree</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
plot_network_tree(dss::String; makie_backend=WGLMakie)
```


Plots a network tree from a given DSS file.

**Arguments**
- `dss::String`: The path to the DSS file containing the network data.
  
- `makie_backend`: The Makie backend to use for plotting. Defaults to `WGLMakie`.
  

**Description**

This function parses the DSS file to create an engineering model of the network, transforms loops in the model, and converts keys to symbols. It then constructs a network graph using `MetaDiGraph`, adds vertices for each bus, and sets the `sourcebus` as the root. Edges are added based on the `f_bus` and `t_bus` indices of the lines. Finally, it plots the network graph using `graphplot` with a specified layout and labels for nodes and edges.

**Returns**

A plot of the network graph.


[source](https://github.com/MohamedNumair/Pliers.jl)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Pliers.set_indexing_prop!-Tuple{MetaGraphs.AbstractMetaGraph, Symbol}' href='#Pliers.set_indexing_prop!-Tuple{MetaGraphs.AbstractMetaGraph, Symbol}'><span class="jlbinding">Pliers.set_indexing_prop!</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
set_indexing_prop!(g, prop)
set_indexing_prop!(g, v, prop, val)
```


Make property `prop` into an indexing property. If any values for this property are already set, each vertex must have unique values. Optionally, set the index `val` for vertex `v`. Any vertices without values will be set to a default (&quot;(prop)(v)&quot;).


[source](https://github.com/MohamedNumair/Pliers.jl)

</details>

