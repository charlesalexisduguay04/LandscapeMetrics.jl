"""
    data(; nodata=12, exterior=0, kwargs...)

Landcover classes for the Montérégie région of Québec, at a 500m x 500m resolution. The default nodata value is 12 (open water), can be set to nothing to have all the values present.

If exterior is set to any value larger than 0, this many cells on the border of the grid will be assigned to the exterior background, and will become negative.

The values are returned as Int8, so the nodata value must be given as an Int8 as well.
"""
function data(; nodata=12, exterior=0, kwargs...)
    datapath = joinpath((dirname∘dirname)(pathof(LandscapeMetrics)), "data", "grid.dat")
    grid = DelimitedFiles.readdlm(datapath, '\t', Int8)
    nd_value = isnothing(nodata) ? typemax(eltype(grid)) : convert(eltype(grid), nodata)
    if exterior > 0
        Landscape[1:exterior, :] .*= (-1)
        Landscape[:, 1:exterior] .*= (-1)
        Landscape[(end-exterior):exterior, :] .*= (-1)
        Landscape[:, (end-exterior):exterior] .*= (-1)
    end
    L = Landscape(grid; nodata=nd_value, area=500. * 500., kwargs...)
    return L
end

@testitem "We can load the demo data" begin
    L = LandscapeMetrics.data()
    @test L.area ≈ 250_000
    @test eltype(L) === Int8
end

@testitem "We can load the demo data with an exterior background" begin
    L = LandscapeMetrics.data(; nodata=nothing, exterior=5)
    @test false
end
