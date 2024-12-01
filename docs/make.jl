
using Pliers
using Documenter
using DocumenterVitepress

#DocMeta.setdocmeta!(Example, :DocTestSetup, :(using Example); recursive=true)  

makedocs(;
    modules = [Pliers],
    repo = "https://github.com/MohamedNumair/Pliers.jl",
    authors = "Mohamed Numair <Mo7amednumair@gmail.com>",
    #sitename = "Example.jl",
    format = DocumenterVitepress.MarkdownVitepress(
        repo = "https://github.com/MohamedNumair/Pliers.jl",
        md_output_path = ".",    # comment when deploying
        build_vitepress = false, # comment when deploying
    ),
    pages = [
        "Home" => "index.md",
        #"Tutorials" => "tutorials.md",
        "API" => "api.md",
        #"Contributing" => "contributing.md"
    ],
    clean = false,
)

deploydocs(;
    repo = "https://github.com/MohamedNumair/Pliers.jl",
    target = "build", # this is where Vitepress stores its output
    devbranch = "main",
    branch = "gh-pages",
    push_preview = true,
)