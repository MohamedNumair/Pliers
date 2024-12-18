#=
The Idea here is to get the results dictionary of PMD power flow or optimal power flow and then match it with eng files.
=#


function _calc_bases_from_sol_dict(pf_sol::Dict{String,Any})
    is_perunit = pf_sol["per_unit"]
    vbase_V = first(pf_sol["settings"]["vbases_default"]).second*pf_sol["settings"]["voltage_scale_factor"]
    sbase_VA = pf_sol["settings"]["sbase_default"]*pf_sol["settings"]["power_scale_factor"]
    Zbase_Ω = vbase_V^2/sbase_VA
    Ibase_A = sbase_VA/vbase_V
    return is_perunit, vbase_V, sbase_VA, Zbase_Ω, Ibase_A
end



# function to get the results dictionary


function pf_results(results::Dict{String, Any}, math::Dict{String, Any}, eng::Dict{String, Any}; detailed = false, keep_pu = false)
    
    eng = deepcopy(eng)
    
    results_headings = ["Termination Status", "Iterations", "Total Time", "Build Time", "Post Time", "Solve Time",  "Stationarity"]
    results_values = [results["termination_status"], results["iterations"], results["time_total"], results["time_build"], results["time_post"], results["time_solve"], results["stationarity"]]
    summary_table = DataFrame(Label = results_headings, Value = results_values)
    pretty_table(summary_table, highlighters=(_highlight_results_status))

    pf_sol = results["solution"]

    is_perunit, vbase_V, sbase_VA, Zbase_Ω, Ibase_A = _calc_bases_from_sol_dict(pf_sol)


    for (b, bus) in pf_sol["bus"]
        bus["V"] = bus["vm"].*exp.(im*bus["va"])
        eng_bus_id = math["bus"][b]["name"]

        if eng_bus_id == "_virtual_bus.voltage_source.source"
            eng["bus"]["virtual_bus"] = Dict()
            eng["bus"]["virtual_bus"]["V"] = bus["V"]
            eng["bus"]["virtual_bus"]["math_id"] = b
        else
            eng["bus"][eng_bus_id]["V"] = bus["V"]
            eng["bus"][eng_bus_id]["math_id"] = b
        end

    end

    for (br, branch) in pf_sol["branch"]
        len = Int(length(branch["cr"])/2)
        branch["I_t"] = branch["cr"][1:len] + im*branch["ci"][1:len]
        branch["I_f"] = branch["cr"][len+1:end] + im*branch["ci"][len+1:end] #note the swap (If is the second half)
        f_bus = string(math["branch"][br]["f_bus"])
        t_bus = string(math["branch"][br]["t_bus"])
        
        if math["bus"][f_bus]["terminals"] != math["branch"][br]["f_connections"]
           warning_text(" for branch $br, the from terminals are $(math["branch"][br]["f_connections"]) which is different than f_bus $f_bus $(math["bus"][f_bus]["terminals"] )")
            Vf = [pf_sol["bus"][f_bus]["V"][i] for i in math["branch"][br]["f_connections"]]
        else
            Vf = pf_sol["bus"][f_bus]["V"]
        end
        
        if math["bus"][t_bus]["terminals"] != math["branch"][br]["t_connections"]
           warning_text(" for branch $br, the to terminals are $(math["branch"][br]["t_connections"]) which is different than t_bus $t_bus $(math["bus"][t_bus]["terminals"] )")
            Vt = [pf_sol["bus"][t_bus]["V"][i] for i in math["branch"][br]["t_connections"]]
        else
            Vt = pf_sol["bus"][t_bus]["V"]
        end

        if math["branch"][br]["f_connections"] != math["branch"][br]["t_connections"]
            error(" for branch $br, the connections are not the same")
        end

        branch["S_f"] = Vf.*conj.(branch["I_f"])
        branch["S_t"] = Vt.*conj.(branch["I_t"])


        eng_branch_id = math["branch"][br]["name"]
        
        if eng_branch_id == "_virtual_branch.voltage_source.source"
            eng["line"]["virtual_branch"] = Dict()
            
            eng["line"]["virtual_branch"]["I_t"] = branch["I_t"]
            eng["line"]["virtual_branch"]["I_f"] = branch["I_f"]

            eng["line"]["virtual_branch"]["S_t"] = branch["S_t"]
            eng["line"]["virtual_branch"]["S_f"] = branch["S_f"]
            
            eng["line"]["virtual_branch"]["math_id"] = br
        else 
            eng["line"][eng_branch_id]["I_t"] = branch["I_t"]
            eng["line"][eng_branch_id]["I_f"] = branch["I_f"]
            
            eng["line"][eng_branch_id]["S_t"] = branch["S_t"]
            eng["line"][eng_branch_id]["S_f"] = branch["S_f"]

            eng["line"][eng_branch_id]["math_id"] = br
        end


    end

    for (g, gen) in pf_sol["gen"]
        gen["I"] = gen["crg"] + im*gen["cig"]

        gen_bus = string(math["gen"][g]["gen_bus"])
        Vg = pf_sol["bus"][gen_bus]["V"]
        gen["S"] = Vg.*conj.(gen["I"])

        gen_eng_id = math["gen"][g]["name"]

        if gen_eng_id == "_virtual_gen.voltage_source.source"
            eng["voltage_source"]["source"]["I"] = gen["I"]
            eng["voltage_source"]["source"]["S"] = gen["S"]
            eng["voltage_source"]["source"]["math_id"] = g
        else
            eng["voltage_source"][gen_eng_id]["I"] = gen["I"]
            eng["voltage_source"][gen_eng_id]["S"] = gen["S"]
            eng["voltage_source"][gen_eng_id]["math_id"] = g
        end
    end

    for (l, load) in pf_sol["load"]
        load["I"] = load["crd"] + im*load["cid"]

        load_bus = string(math["load"][l]["load_bus"])
        Vl = pf_sol["bus"][load_bus]["V"]
        load["S"] = Vl.*conj.(load["I"])




        load_eng_id = math["load"][l]["name"]
        eng["load"][load_eng_id]["I"] = load["I"]
        eng["load"][load_eng_id]["S"] = load["S"]


        eng["load"][load_eng_id]["math_id"] = l

    end

    
    shunts_res = pf_sol["shunt"] #TODO: shunt results
    transformers_res = pf_sol["transformer"] #TODO: transformer results
    switches_res = pf_sol["switch"] #TODO: switch results
    storages_res = pf_sol["storage"] #TODO: storage results


    eng["bases"] = Dict(
                         "is_perunit" => is_perunit,
                         "vbase_V" => vbase_V,
                         "sbase_VA" => sbase_VA,
                         "Zbase_Ω" => Zbase_Ω,
                         "Ibase_A" => Ibase_A
                        )
    
    if detailed    
        pf_results_buses(pf_sol,math;  keep_pu)
        #pf_results_branches(pf_sol,math;  keep_pu)
        #pf_results_gens(pf_sol,math;  keep_pu)
        #pf_results_loads(pf_sol,math;  keep_pu)
    end 



    
    return eng, math, results
end 



function pf_results(eng::Dict{String, Any}; kwargs...)

    is_explicit_netrual = length(eng["conductor_ids"]) > 3 ? true :  false
    math=transform_data_model(eng, kron_reduce=!is_explicit_netrual, phase_project=!is_explicit_netrual)
    
    add_start_vrvi!(math)
    PF = compute_mc_pf(math; explicit_neutral=is_explicit_netrual, max_iter=15)

    return pf_results(PF,math, eng; kwargs...)
end



function pf_results_buses(pf_sol::Dict{String, Any}, math; keep_pu::Bool)
    is_perunit, vbase_V, sbase_VA, Zbase_Ω, Ibase_A = _calc_bases_from_sol_dict(pf_sol)
    header("Buses Results")

    if keep_pu*is_perunit
        buses_res_df = DataFrame(   Bus = String[],
                                    Vm_pu = Vector{Float64}[],
                                    θ_rad = Vector{Float64}[],
                                    V_pu = Vector{ComplexF64}[],
                                )

        for (b, bus) in pf_sol["bus"]
            push!(buses_res_df,(
                                    math["bus"][b]["name"], 
                                    bus["vm"],
                                    bus["va"],
                                    bus["V"],
                                ))
        end
    else
        buses_res_df = DataFrame(   Bus = String[],
                                    Vm_V = Vector{Float64}[],
                                    θ_deg = Vector{Float64}[],
                                    V_V = Vector{ComplexF64}[],
                                )



        for (b, bus) in pf_sol["bus"]
            push!(buses_res_df,(
                                    math["bus"][b]["name"], 
                                    bus["vm"]*vbase_V,
                                    rad2deg.(bus["va"]),
                                    bus["V"]*vbase_V,
                                ))
        end
    end

    return pretty_table(buses_res_df)

end




function bus_res(eng::Dict{String, Any}, bus_id::String; keep_pu::Bool= false, makie_backend=WGLMakie,
    )
    is_perunit = eng["bases"]["is_perunit"]
    vbase_V = eng["bases"]["vbase_V"]
    
    # sbase_VA = eng["bases"]["sbase_VA"]
    # Zbase_Ω = eng["bases"]["Zbase_Ω"]
    # Ibase_A = eng["bases"]["Ibase_A"]

    bus = eng["bus"][bus_id]




    if keep_pu*is_perunit
        V = bus["V"]
        Vm = abs.(V_pu)
        θ = angle.(V_pu)
    else
        V = bus["V"]*vbase_V
        Vm = abs.(V)
        θ = rad2deg.(angle.(V)) 
    end 





    


    # create a makie plot for the bus

    makie_backend.activate!()
bus_id






    return V, Vm, θ
end