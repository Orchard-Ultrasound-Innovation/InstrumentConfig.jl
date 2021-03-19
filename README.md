# InstrumentConfig

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://orchard-ultrasound-innovation.github.io/InstrumentConfig.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://orchard-ultrasound-innovation.github.io/InstrumentConfig.jl/dev)
[![Build Status](https://github.com/orchard-ultrasound-innovation/InstrumentConfig.jl/workflows/CI/badge.svg)](https://github.com/orchard-ultrasound-innovation/InstrumentConfig.jl/actions)
[![Build Status](https://travis-ci.com/orchard-ultrasound-innovation/InstrumentConfig.jl.svg?branch=master)](https://travis-ci.com/orchard-ultrasound-innovation/InstrumentConfig.jl)
[![Coverage](https://codecov.io/gh/orchard-ultrasound-innovation/InstrumentConfig.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/orchard-ultrasound-innovation/InstrumentConfig.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)


This package contains an interface for saving and reading configuration options from a YAML file. It's especially useful for instrument interface packages.

Inspired by unix config-file/dotfile style configuration.

Your current working directory (normally your julia project root) 
is first searched for a config file. If no config is found, your home
directory is then searched for a config file.

## Installation
TcpInstruments can be installed using the Julia package manager. From the Julia REPL, type ] to enter the Pkg REPL mode and run

```julia
pkg> add InstrumentConfig
```

## Usage
### Instrument Functions
This library exports the `initialize` and `terminate`
functions so that they can be overridden and implemented
in other packages.

### Configuration
Create a new configuration
```julia
const myPkg_config = InstrumentConfig.Config(
    "{desired-name-of-configuration-file}"; 
    example = "{location-of-your-config}"
)
```

Implement the four main functions
```julia
# A getter function to be used in your code. Returns a dictionary of the
# loaded config file or loads the config if it has not yet been loaded
get_config() = InstrumentConfig.get_config(myPkg_config)

# If a location for the example/default file is specified
# users can create a global one in their home directory or they can call
# create_config(;dir=pwd()) to load the default config in their
# current working directory (normally the root of their julia project)
create_config(;dir=homedir()) = InstrumentConfig.create_config(myPkg_config; dir=dir)

# Will open the currently loaded config file in the users preferred
# editor( Uses the $EDITOR ENV variable)
edit_config() = InstrumentConfig.edit_config(myPkg_config)

# Loads your specified config file
load_config() = InstrumentConfig.load_config(myPkg_config)
```

Your package can now be used as follows:
```julia
using YourPackageName; YourPackageName.load_config()
```

## Example
```julia
TODO: EXAMPLE FILE Doesn't have to be a url. It can also be copied from package directory

const EXAMPLE_FILE = "https://raw.githubusercontent.com/Orchard-Ultrasound-Innovation/TcpInstruments.jl/master/.tcp_instruments.yml" 

const tcp_config = InstrumentConfig.Config(
    ".tcp_instruments.yml"; 
    example = EXAMPLE_FILE
)
```

Implement these default functions for your package

Following the `tcp_config` example created above:
```julia
function get_config()
    return InstrumentConfig.get_config(tcp_config)
end

function create_config(;dir=homedir())
    InstrumentConfig.create_config(tcp_config; dir=dir)
end

function edit_config()
    InstrumentConfig.edit_config(tcp_config)
end

function load_config()
    InstrumentConfig.load_config(tcp_config)
end
```

You can add additional functionality to the default functions:

Lets say you want to validate the user's config whenever you load config
```julia
function my_validation_function(tcp_config)
    ....
end

function load_config()
    InstrumentConfig.load_config(tcp_config)
    my_validation_function(tcp_config)
    @info "My super friendly message"
    additional_malicious_malware_function()
    .... (etc)
end
```

## Packages that use this library
- [ThorlabsLTStage](https://github.com/Orchard-Ultrasound-Innovation/ThorlabsLTStage.jl)
- [TcpInstruments](https://github.com/Orchard-Ultrasound-Innovation/TcpInstruments.jl)
