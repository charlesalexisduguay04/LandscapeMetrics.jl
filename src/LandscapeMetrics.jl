module LandscapeMetrics

using TestItems
using StatsBase

# Patches, generic utilies, and overloads
include("types.jl")
export Landscape
export background
export exteriorbackground, interiorbackground

# Some demonstration data
include("demo.jl")

# Functions to identify the patches
include("patches.jl")
export Moore, VonNeumann
export patches

# Area and edge
include("area_and_edge.jl")
export totalarea

end # module LandscapeMetrics
