module LandscapeMetrics

using TestItems
using StatsBase

include("types.jl")
export Landscape
export background

include("patches.jl")
export Moore, VonNeumann
export patches

end # module LandscapeMetrics
