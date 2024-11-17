function load_en_model(ntw::Int, fdr::Int)
    return load(joinpath(BASE_DIR,"test/data/Four-wire-PMD/Ntw_$(ntw)_Fdr_$(fdr).jld2"))
end


function all_en_names()
    return readdir(joinpath(Pliers.BASE_DIR, "test/data/Four-wire-PMD"))
end


function load_en_model(model::String)
    return load(joinpath(BASE_DIR,"test/data/Four-wire-PMD/$model"))
end

#TODO: add a unique model to use for loading JLD2 rightaway (not from internatl library)