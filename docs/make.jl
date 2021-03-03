using InstrumentConfig
using Documenter

DocMeta.setdocmeta!(InstrumentConfig, :DocTestSetup, :(using InstrumentConfig); recursive=true)

makedocs(;
    modules=[InstrumentConfig],
    authors="Morten F. Rasmussen <10264458+mofii@users.noreply.github.com> and contributors",
    repo="https://github.com/mofii/InstrumentConfig.jl/blob/{commit}{path}#{line}",
    sitename="InstrumentConfig.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mofii.github.io/InstrumentConfig.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mofii/InstrumentConfig.jl",
)
