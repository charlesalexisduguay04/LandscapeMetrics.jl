function make_stencil(l::Landscape, d::AbstractFloat)
    # We want to know how many cells are required to get the distance covered. For this, we
    # simply need to calculate
    number_of_cells = ceil(Int, d / side(l))

    # We will now generate the initial stencil, which is not yet filtered by distance to the
    # center of the focal cell
    span = -number_of_cells:number_of_cells
    stencil = CartesianIndices((span, span))

    # We can now filter from the center of the focal cell, and if we remember that the
    # distance is relative to the 0,0 coordinate, we can write this very simply as the
    # square root of the sum of coordinates square, after we have rescaled the cartesian
    # coordinates by the length of the cell side
    s = side(l)
    distance_away(cartesian) = sqrt(sum((s .* cartesian.I).^2))

    # We now filter these cells - note that the center cell is always included, which is
    # fine because we use this stencil to remove the cells that are NOT part of the
    # patch core, and we only add the stencil to the cells that are in contact with at least
    # one cell of a different patch type.
    stencil = filter(c -> distance_away(c) < d, stencil)

    return stencil
end

@testitem "We can create a stencil based on a cell distance" begin
    L = Landscape([
        1 1 1 1;
        1 1 1 1;
        1 1 1 1;
        1 1 1 1
    ])
    @test area(L) == 1.0
    @test side(L) == 1.0

    # Stencil of size 1 should be the focal cell only
    S = LandscapeMetrics.make_stencil(L, 1.0)
    @test S[1] == CartesianIndex(0, 0)

    # Stencil of size 2 should be a Moore neighborhood
    S = LandscapeMetrics.make_stencil(L, 2.0)
    for i in Moore
        @test i in S
    end

    # Stencil of size a little less than sqrt(2) should be Von Neuman neighborhood
    S = LandscapeMetrics.make_stencil(L, sqrt(2.0)-0.01)
    for i in VonNeumann
        @test i in S
    end
end

function corepatches(l::Landscape{T}, edges::Matrix{T}) where {T<:Integer}
    return nothing
end
