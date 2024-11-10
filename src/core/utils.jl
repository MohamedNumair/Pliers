
#extract_keys (compares missing keys and shows a warning)
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
        warning_text("Extra coulmns exist in the data model but are not displayed: $(extra_keys)")
    end

    if show_keys
        @show expected_keys
        @show eng_data_keys
        @show extra_keys
    end
end
