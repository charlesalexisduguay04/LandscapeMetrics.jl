module LandscapeMetrics

using TestItems

include("types.jl")
export Landscape
export background

include("identify_patches.jl")
export patches

end # module LandscapeMetrics
