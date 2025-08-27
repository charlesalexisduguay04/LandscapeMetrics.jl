module LandscapeMetrics

using TestItems
using Test
using StatsBase
import DelimitedFiles

# Patches, generic utilies, and overloads
include("types.jl")
export Landscape
export background
export foreground
export exteriorbackground, interiorbackground

# Some demonstration data
include("demo.jl")
include("utilities/data.jl") # Montérégie

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
export classarea

include("area_and_edge/percentage.jl")
export percentage

include("area_and_edge/largestpatch.jl")
export largestpatchindex

# Shape
include("shape/paratio.jl")
export paratio, perimeterarearatio
export shapeindex
export fractaldimensionindex

end # module LandscapeMetrics
