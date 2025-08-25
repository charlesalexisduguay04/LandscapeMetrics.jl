module LandscapeMetrics

using TestItems
using StatsBase

# Patches, generic utilies, and overloads
include("types.jl")
export Landscape
export background
export foreground
export exteriorbackground, interiorbackground

# Some demonstration data
include("demo.jl")

# Functions to identify the patches
include("utilities/patches.jl")
export Moore, VonNeumann
export patches!, patches

# Area and edge
include("area_and_edge/perimeter.jl")
export perimeter

include("area_and_edge/area.jl")
export totalarea
export area

# Shape
include("shape/paratio.jl")
export paratio, perimeterarearatio
export shapeindex

end # module LandscapeMetrics
