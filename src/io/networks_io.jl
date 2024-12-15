function load_enwl_model(ntw::Int, fdr::Int)
    return load(joinpath(BASE_DIR,"test/data/MENWL/Ntw_$(ntw)_Fdr_$(fdr).jld2"))
end

function load_enwl_model(ntw::Int, fdr::Int, type::String)
    # Create a map to map the type to folder_name
    if type == "original dataset"
        return load(joinpath(BASE_DIR,"test/data/OG-ENWL/Ntw_$(ntw)_Fdr_$(fdr).jld2"))
    else 

    folder_name_map = Dict(
        "four-wire" => "Four-wire-PMD",
        "kron-reduced" => "Three-wire-Kron-reduced",
        "modified-three-wire-pn" => "Three-wire-modified-phase-to-neutral",
        "Three-wire-phase-to-neutral" => "three-wire-pn"
    )
    # Get the folder_name using the type parameter
    folder_name = get(folder_name_map, type, "default_folder")  # "default_folder" is a fallback if type is not found
    folder_name == "default_folder" && error("Invalid type parameter")
    # Load the data from the appropriate folder
    return load(joinpath(BASE_DIR, "test/data/CSIRO-data", folder_name, "Ntw_$(ntw)_Fdr_$(fdr).jld2"))
    end 
end


function all_en_names()
    return readdir(joinpath(Pliers.BASE_DIR, "test/data/Four-wire-PMD"))
end


function load_en_model(model::String)
    return load(joinpath(BASE_DIR,"test/data/Four-wire-PMD/$model"))
end

#TODO: add a unique model to use for loading JLD2 rightaway (not from internatl library)

function save_network(eng::Dict{String, Any}, name::String)
    save(joinpath(BASE_DIR,"test/data/OG-ENWL/$name.jld2"), eng)
end






function load_spanish_feeder(feederno::Int)

    # match the file that has Feeder_$feederno in the name and load it, although the rest of the name is not known
    files = []
    file_name = "Feeder_$(feederno)_"
    for (root, dirs, file) in walkdir("test/data/spanish_feeders_eng")
        for f in file
            if occursin(file_name, f)
                push!(files, joinpath(root, f))
            end
        end
    end

    isempty(files) && error("No file found for the given feederno")

    
    return length(files) > 1 ?  load.(files) : load(files[1])
end

function network_strings()
    # walk the directory of the spanish feeders and collect the network strings by matching the regex Ntw_* in the file name and return a list of unique networks
    network_strings = []
    for (root, dirs, file) in walkdir("test/data/spanish_feeders_eng")
        for f in file
            if occursin("Ntw_", f)
                m = match(r"Ntw_\w+", f)
                if m !== nothing
                    push!(network_strings, string(split(m.match, "_")[2]))
                end
            end
        end
    end
    return unique(network_strings)
end

function load_spanish_network(network_string::String)

    # match the file that has Feeder_$feederno in the name and load it, although the rest of the name is not known
    files = []
    file_name = "Ntw_$(network_string)"
    for (root, dirs, file) in walkdir("test/data/spanish_feeders_eng")
        for f in file
            if occursin(file_name, f)
                push!(files, joinpath(root, f))
            end
        end
    end

    isempty(files) && error("No file found for the given Network")

    return length(files) > 1 ?  load.(files) : load(files[1])
end


## FILE SEARCHING 

function search_files(directory, file_name)
    files = []
    for (root, dirs, file) in walkdir(directory)
        for f in file
            if occursin(file_name, f)
                push!(files, joinpath(root, f))
            end
        end
    end
    return files
end

# write a search for directory

function search_directories(directory, directory_name)
    directories = []
    for (root, dirs, file) in walkdir(directory)
        for d in dirs
            if occursin(directory_name, d)
                push!(directories, joinpath(root, d))
            end
        end
    end
    return directories
end