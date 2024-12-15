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