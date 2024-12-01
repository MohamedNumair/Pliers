
function extract_network_and_feeder(file_path::String; pattern::String = r"(?i)Four-wire\\Network_(\d+)\\Feeder_(\d+)\\Master.dss")
    # Define the regular expression pattern with case-insensitive flag
    pattern = r"(?i)Four-wire\\Network_(\d+)\\Feeder_(\d+)\\Master.dss"
    
    # Match the pattern against the file path
    matchedPattern = match(pattern, file_path)
    
    if matchedPattern !== nothing
        # Extract the network and feeder numbers
        Ntw = parse(Int, matchedPattern.captures[1])
        Fdr = parse(Int, matchedPattern.captures[2])
        return Ntw, Fdr
    else
        error("Pattern not found in the given file path")
    end
end



transBritishto4326 = Proj.Transformation("EPSG:27700", "EPSG:4326") # British National Grid OSGB36 to WGS84


"""


#CSIRO_path = "C:/Users/mnumair/OneDrive - KU Leuven/Research/Distribution Networks/Four-wire_low_voltage_power_network_dataset-QEzDvqEq-/data"

cd("C:/Users/mnumair/OneDrive - KU Leuven/Research/Distribution Networks/Four-wire_low_voltage_power_network_dataset-QEzDvqEq-/data")


search_pattern = "Four-wire/**/**/Master.dss"    
search_pattern = "Three-wire-Kron-reduced/**/**/Master.dss"    
search_pattern = "Three-wire-modified-phase-to-neutral/**/**/Master.dss"    
search_pattern = "Three-wire-phase-to-neutral/**/**/Master.dss"    
"""