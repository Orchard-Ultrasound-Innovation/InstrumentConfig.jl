module InstrumentConfig

using Downloads

export
    initialize,
    terminate

using YAML

mutable struct Config
   name::String
   example::String
   file_locations::Array
   config::Union{Dict, Nothing}
   loaded_file::String

   function Config(name; example = "")
       dot = new()
       dot.name = name
       dot.example = example
       dot.file_locations = [joinpath(i, name) for i in [pwd(), homedir()]]
       dot.config = nothing
       dot.loaded_file = ""
       return dot
   end

   function Config(name, mod; example = name)
       module_path = pathof(mod)
       pkg_dir = isnothing(module_path) ? pwd() : dirname(dirname(module_path))
       example_path = joinpath(pkg_dir, example)
       return Config(name; example=example_path)
   end
end

function create_config(config; dir=homedir())
    file_path = joinpath(dir, config.name)
    # Local
    if !occursin("http", config.example)
        if Sys.iswindows()
            run(`powershell cp $(config.example) $(file_path)`)
        else
            run(`cp $(config.example) $(file_path)`)
        end
        load_config(config)
        return
    end
    if isempty(config.example)
        @info """
        No example config specified creating empty config file at:
            $file_path
        """
        Base.run(`touch $file_path`)
    else
        Downloads.download(config.example, file_path)
    end
    load_config(config)
end

function edit_config(config)
    config.config == nothing && error("""
    No config loaded.
    Cannot edit a config file that doesn't exists.

    Create a new empty config from your shell by running:
        touch $(config.name)

    Or

    To load the latest config use the create_config function
    """)
    editor, file = ENV["EDITOR"], config.loaded_file
    if Sys.iswindows()
        Base.run(`powershell "$editor $file"`)
    else
        Base.run(`$editor $file`)
    end
    load_config(config)
end

function load_config(config)
    for f in config.file_locations
        if isfile(f)
            config.loaded_file = f
            break
        end
    end
    if isempty(config.loaded_file)
        config.config = Dict()
        @info "No configuration file found:\n$(config.file_locations)"
        return
    end
    try
        config.config = YAML.load_file(config.loaded_file)
        @info "$(config.loaded_file) ~ loaded"
    catch
        @info "$(config.loaded_file) is empty"
        config.config = Dict()
    end
end

function get_config(config)
    if config.config == nothing
        load_config(config)
    end
    return config.config
end

initialize(instr) =
    error("Initialize not implemented for $(typeof(instr))")

terminate(instr) = 
    error("Terminate not implemented for $(typeof(instr))")

end
