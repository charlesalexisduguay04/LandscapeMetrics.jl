module LandscapeMetrics

using TestItems
using StatsBase

include("types.jl")
export Landscape
export background

include("patches.jl")
export Moore, VonNeumann
export patches

# Area and edge
include("area_and_edge.jl")
export totalarea

end # module LandscapeMetrics
