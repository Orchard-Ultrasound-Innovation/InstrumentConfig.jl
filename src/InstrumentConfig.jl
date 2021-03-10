module InstrumentConfig

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
end

function create_config(config; dir=homedir())
    if Sys.iswindows()
        error("create_config() is not supported on windows yet")
    end
    file_path = joinpath(dir, config.name)
    if isempty(config.example)
        @info """
        No example config specified creating empty config file at:
            $file_path
        """
        Base.run(`touch $file_path`)
    else
        Base.run(`wget -q --show-progress -O $file_path $(config.example)`)
    end
    load_config(config)
end

function edit_config(config)
    @assert config.config != nothing """
    No config loaded.
    Cannot edit a config file that doesn't exists.

    Create a new empty config from your shell by running:
        touch $(config.name)

    Or

    To load the latest config use the create_config function
    """
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
    @info "Initialize not implemented for $(typeof(instr))"

terminate(instr) = 
    @info "Terminate not implemented for $(typeof(instr))"

end
