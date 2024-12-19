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

function pf_results(eng::Dict{String, Any}; max_iter = 5000,kwargs...)

    is_explicit_netrual = length(eng["conductor_ids"]) > 3 ? true :  false
    math=transform_data_model(eng, kron_reduce=!is_explicit_netrual, phase_project=!is_explicit_netrual)
    
    add_start_vrvi!(math)
    PF = compute_mc_pf(math; explicit_neutral=is_explicit_netrual, max_iter=max_iter)

    return pf_results(PF,math, eng; kwargs...)
end



function pf_results(results::Dict{String, Any}, math::Dict{String, Any}, eng::Dict{String, Any}; detailed = false, keep_pu = false)
    
    # This is just the pretty table summary for results
    results_headings = ["Termination Status", "Iterations", "Total Time", "Build Time", "Post Time", "Solve Time", "Stationarity"]
    results_values = [results["termination_status"], results["iterations"], results["time_total"], results["time_build"], results["time_post"], results["time_solve"], results["stationarity"]]
    summary_table = DataFrame(Label = results_headings, Value = results_values)
    pretty_table(summary_table, highlighters=(_highlight_results_status))
    
    
    # Moving results into the ENG dictionary 
    eng = deepcopy(eng)
    pf_sol = results["solution"]
    is_perunit, vbase_V, sbase_VA, Zbase_Ω, Ibase_A = _calc_bases_from_sol_dict(pf_sol)

    for (b, bus) in pf_sol["bus"]
        bus["V"] = bus["vm"] .* exp.(im * bus["va"])
        terminals = math["bus"][b]["terminals"]

        # write a dictionary where the key is the terminal number and the value is the voltage at that terminal
        bus["V"] = Dict(string(term) => bus["V"][i] for (i, term) in enumerate(terminals))

        eng_bus_id = math["bus"][b]["name"]

        if eng_bus_id == "_virtual_bus.voltage_source.source"
            eng["virtual_bus"] = Dict()
            eng["virtual_bus"]["V"] = bus["V"]
            eng["virtual_bus"]["math_id"] = b
        else
            eng["bus"][eng_bus_id]["V"] = bus["V"]
            eng["bus"][eng_bus_id]["math_id"] = b
        end
    end

    for (br, branch) in pf_sol["branch"]
        len = Int(length(branch["cr"]) / 2)
        I_t = branch["cr"][1:len] + im * branch["ci"][1:len]
        I_f = branch["cr"][len+1:end] + im * branch["ci"][len+1:end]

        branch["I_t"] = Dict(string(term) => I_t[i] for (i, term) in enumerate(math["branch"][br]["t_connections"]))
        branch["I_f"] = Dict(string(term) => I_f[i] for (i, term) in enumerate(math["branch"][br]["f_connections"]))


        f_bus = string(math["branch"][br]["f_bus"])
        t_bus = string(math["branch"][br]["t_bus"])

        Vf = pf_sol["bus"][f_bus]["V"]
        Vt = pf_sol["bus"][t_bus]["V"]

        branch["S_f"] = Dict(string(term) => Vf[string(term)] * conj(branch["I_f"][string(term)]) for (_, term) in enumerate(math["branch"][br]["f_connections"]))
        branch["S_t"] = Dict(string(term) => Vt[string(term)] * conj(branch["I_t"][string(term)]) for (_, term) in enumerate(math["branch"][br]["t_connections"]))

        branch["S_f"] = Dict(string(term) => Vf[string(term)] * conj(branch["I_f"][string(term)]) for (_, term) in enumerate(math["branch"][br]["f_connections"]))
        branch["S_t"] = Dict(string(term) => Vt[string(term)] * conj(branch["I_t"][string(term)]) for (_, term) in enumerate(math["branch"][br]["t_connections"]))

        eng_branch_id = math["branch"][br]["name"]

        if eng_branch_id == "_virtual_branch.voltage_source.source"
            eng["virtual_branch"] = Dict()
            eng["virtual_branch"]["I_t"] = branch["I_t"]
            eng["virtual_branch"]["I_f"] = branch["I_f"]
            eng["virtual_branch"]["S_t"] = branch["S_t"]
            eng["virtual_branch"]["S_f"] = branch["S_f"]
            eng["virtual_branch"]["V_f"] = pf_sol["bus"][f_bus]["V"]
            eng["virtual_branch"]["V_t"] = pf_sol["bus"][t_bus]["V"]   
            eng["virtual_branch"]["math_id"] = br
        else
            eng["line"][eng_branch_id]["I_t"] = branch["I_t"]
            eng["line"][eng_branch_id]["I_f"] = branch["I_f"]
            eng["line"][eng_branch_id]["S_t"] = branch["S_t"]
            eng["line"][eng_branch_id]["S_f"] = branch["S_f"]
            eng["line"][eng_branch_id]["V_f"] = pf_sol["bus"][f_bus]["V"]
            eng["line"][eng_branch_id]["V_t"] = pf_sol["bus"][t_bus]["V"]
            eng["line"][eng_branch_id]["math_id"] = br
        end
    end

    for (g, gen) in pf_sol["gen"]
        Ig = gen["crg"] + im * gen["cig"]

        gen["Ig"] = Dict(string(term) => Ig[i] for (i, term) in enumerate(math["gen"][g]["connections"]))

        gen_bus = string(math["gen"][g]["gen_bus"])
        Vg = pf_sol["bus"][gen_bus]["V"]

        gen["Sg"] = Dict(string(term) => Vg[string(term)] * conj(gen["Ig"][string(term)]) for (i, term) in enumerate(math["gen"][g]["connections"]))

        gen_eng_id = math["gen"][g]["name"]

        if gen_eng_id == "_virtual_gen.voltage_source.source"
            #eng["voltage_source"]["source"] = Dict()
            eng["voltage_source"]["source"]["I_g"] = gen["Ig"]
            eng["voltage_source"]["source"]["S_g"] = gen["Sg"]
            eng["voltage_source"]["source"]["math_id"] = g
        else
            eng["voltage_source"][gen_eng_id]["I_g"] = gen["Ig"]
            eng["voltage_source"][gen_eng_id]["S_g"] = gen["Sg"]
            eng["voltage_source"][gen_eng_id]["math_id"] = g
        end
    end

    for (l, load) in pf_sol["load"]
        Il = load["crd"] + im * load["cid"]

        load["Il"] = Dict(string(term) => Il[i] for (i, term) in enumerate(math["load"][l]["connections"]))

        load_bus = string(math["load"][l]["load_bus"])
        Vl = pf_sol["bus"][load_bus]["V"]

        load["Sl"] = Dict(string(term) => Vl[string(term)] * conj(load["Il"][string(term)]) for (i, term) in enumerate(math["load"][l]["connections"]))

        load_eng_id = math["load"][l]["name"]
        eng["load"][load_eng_id]["I_l"] = load["Il"]
        eng["load"][load_eng_id]["S_l"] = load["Sl"]
        eng["load"][load_eng_id]["math_id"] = l
    end

    eng["bases"] = Dict(
        "is_perunit" => is_perunit,
        "vbase_V" => vbase_V,
        "sbase_VA" => sbase_VA,
        "Zbase_Ω" => Zbase_Ω,
        "Ibase_A" => Ibase_A
    )

    if detailed
        pf_results_buses(pf_sol, math; keep_pu)
    end

    return eng, math, results
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



    return V, Vm, θ
end





#=
 __     __         _______                       ______   __  __           
/  |   /  |       /       \                     /      \ /  |/  |          
$$ |   $$ |       $$$$$$$  | ______    ______  /$$$$$$  |$$/ $$ |  ______  
$$ |   $$ |______ $$ |__$$ |/      \  /      \ $$ |_ $$/ /  |$$ | /      \ 
$$  \ /$$//      |$$    $$//$$$$$$  |/$$$$$$  |$$   |    $$ |$$ |/$$$$$$  |
 $$  /$$/ $$$$$$/ $$$$$$$/ $$ |  $$/ $$ |  $$ |$$$$/     $$ |$$ |$$    $$ |
  $$ $$/          $$ |     $$ |      $$ \__$$ |$$ |      $$ |$$ |$$$$$$$$/ 
   $$$/           $$ |     $$ |      $$    $$/ $$ |      $$ |$$ |$$       |
    $/            $$/      $$/        $$$$$$/  $$/       $$/ $$/  $$$$$$$/ 
=#


## FIRST: GET LENGTHS
# I will try to create an aglorithm that starts from each node of the network, and then finds the line that connects to it and then goes to the parent node of that bus and so on unitl it reaches the root bus that has no lines going to it

# first a function that find the parent line of a bus
function find_parent_line(eng, bus_id)
    for (l, line) in eng["line"]
        if haskey(line, "t_bus") && line["t_bus"] == bus_id
            return l
        end
    end
end


# then a function that finds the parent bus of a line
function find_parent_bus(eng, line_id)
    return eng["line"][line_id]["f_bus"]
end


# define the root bus as the bus that doesn't have a line that takes it as a ["t_bus"]
function find_root_bus(eng)
    for (b, _) in eng["bus"]
        if isnothing(find_parent_line(eng, b))
            return b
        end
    end
end


# Now loop through all the buses and find the path to the root bus

function find_path_to_root(eng)
    root_bus = find_root_bus(eng)
    paths = Dict()
    for (b,_) in eng["bus"]
        papa = b
        paths[b] = []
        while papa != root_bus
            line_upstream = find_parent_line(eng, papa)
            papa = find_parent_bus(eng, line_upstream )
            push!(paths[b], line_upstream)
        end
    end
    return paths
end



# now I want a lengths dictionary for each bus that sums the length of the lines in the path

function find_path_lengths(eng)
    paths = find_path_to_root(eng)
    lengths = Dict()

    for (b, path) in paths
        lengths[b] = 0
        for l in path
            lengths[b] += eng["line"][l]["length"]
        end
    end
    return lengths
end


## SECOND: the plot of Voltages of a certain phase using bus["V"] value with length in X-axis and Voltage Magnitude in Y-axis



function distance_voltage_array(eng_res, Distances, phase)
    bus_labels = []
    x_distances_m = []
    y_voltages_V = []
    for (b, bus) in eng_res["bus"]
        Vbase = eng_res["bases"]["vbase_V"]
        display(b)
        if haskey(bus["V"], phase)
            push!(bus_labels, b)
            push!(x_distances_m, Distances[b])
            push!(y_voltages_V, abs(bus["V"][phase])*Vbase)
            println("Bus: $b, X: $(Distances[b]) Y= $(abs.(bus["V"][phase])*Vbase) ")
        end
    end
    return bus_labels, x_distances_m, y_voltages_V
end


function plot_voltage_profile(eng_res; size = (800, 1000))
    
    @info "Calculating path lengths from each bus to the root bus"
    Distances = find_path_lengths(eng_res)
    @info "Phew done! d=====(￣▽￣*)b that took a while"

    f = Figure(size = size)
    colors = [:red, :green, :blue, :black]
    for (i, color) in enumerate(colors)
        ax = Axis(f[i,1])
        bus_labels, x_distances_m, y_voltages_V = distance_voltage_array(eng_res,Distances, string(i))
        if isempty(bus_labels)
            display("No bus found for phase $( Dict("1" => "a", "2" => "b", "3" => "c", "4" => "n")[string(i)])") 
            return Distances
        end
        scatter!(ax, x_distances_m, y_voltages_V, color = color)

        ax.title = "Phase $( Dict("1" => "a", "2" => "b", "3" => "c", "4" => "n")[string(i)]) the network"  
        ax.xlabel = "Distance (m)"
        ax.ylabel = "Voltage (V)"
    end
    return f
end


# A phasor plotter 


function bus_phasor(eng::Dict{String, Any}, bus_id::String; keep_pu::Bool= false, makie_backend=WGLMakie,
    )
    vbase_V = eng["bases"]["vbase_V"]
    
    # V = bus["V"]*vbase_V
    # Vm = abs.(V)
    # θ = rad2deg.(angle.(V)) 

    makie_backend.activate!()

    f = Figure(size=(800, 1200))

    colors = [:red, :green, :blue, :black]

    ax = PolarAxis(f[1,1], title = "Bus $bus_id Phasors", thetaticks = Makie.AngularTicks(180 / pi, "°"))
    div = 50
   # axa = PolarAxis(f[2, 1], title = "thetalimits", thetalimits = (-pi/div, pi/div))
   # axb = PolarAxis(f[3, 1], title = "thetalimits", thetalimits = (-2pi/3 - pi/div , -2pi/3 + pi/div))
   # axc = PolarAxis(f[4, 1], title = "thetalimits", thetalimits = (2pi/3 - pi/div , 2pi/3 + pi/div))
   axN = PolarAxis(f[2, 1], title = "Neutral Phasor")

    bus = eng["bus"][bus_id]
    for (i, color) in enumerate(colors)
        
        if haskey(bus["V"], string(i))
            V = bus["V"][string(i)]
            V = bus["V"][string(i)]
            Vm = abs(V)*vbase_V
            θ = angle(V)
            lines!(ax, [0,θ], [0,Vm], color = color, linewidth = 2, linestyle = :solid)
            # lines!(axa, [0,θ], [0,Vm], color = color, linewidth = 2, linestyle = :solid)
            # lines!(axb, [0,θ], [0,Vm], color = color, linewidth = 2, linestyle = :solid)
            # lines!(axc, [0,θ], [0,Vm], color = color, linewidth = 2, linestyle = :solid)
            if i == 4
                  lines!(axN, [0,θ], [0,Vm], color = color, linewidth = 2, linestyle = :solid) 
            end 
        
        else
            V = 0
            Vm = 0
            θ = 0
        end

    end

    return f 
end

function line_current_phasor(eng::Dict{String, Any}, line_id::String; keep_pu::Bool= false, makie_backend=WGLMakie,
    )
    Ibase_A = eng["bases"]["Ibase_A"]
    
    makie_backend.activate!()

    f = Figure(size=(800, 1200), title= "Current Phasors for line $line_id")

    colors = [:red, :green, :blue, :black]

    ax = PolarAxis(f[1,1], title = "Line $line_id Current Phasors", thetaticks = Makie.AngularTicks(180 / pi, "°"))
    div = 50
   # axa = PolarAxis(f[2, 1], title = "thetalimits", thetalimits = (-pi/div, pi/div))
   # axb = PolarAxis(f[3, 1], title = "thetalimits", thetalimits = (-2pi/3 - pi/div , -2pi/3 + pi/div))
   # axc = PolarAxis(f[4, 1], title = "thetalimits", thetalimits = (2pi/3 - pi/div , 2pi/3 + pi/div))

    line = eng["line"][line_id]
    for (i, color) in enumerate(colors)
        
        if haskey(line["I_f"], string(i))
            I = line["I_f"][string(i)]
            Im = abs(I)*Ibase_A
            θ = angle(I)
            lines!(ax, [0,θ], [0,Im], color = color, linewidth = 2, linestyle = :solid)
           # lines!(axa, [0,θ], [0,Vm], color = color, linewidth = 2, linestyle = :solid)
           # lines!(axb, [0,θ], [0,Vm], color = color, linewidth = 2, linestyle = :solid)
           # lines!(axc, [0,θ], [0,Vm], color = color, linewidth = 2, linestyle = :solid)
        
        else
            I = 0
            Im = 0
            θ = 0
        end

    end

    return f 
end