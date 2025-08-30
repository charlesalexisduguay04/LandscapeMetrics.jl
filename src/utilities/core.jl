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
    distance_away(cartesian) = sqrt(sum((s .* cartesian.I) .^ 2))

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
    S = LandscapeMetrics.make_stencil(L, sqrt(2.0) - 0.01)
    for i in VonNeumann
        @test i in S
    end
end

function identify_border_cells(l::Landscape, p::Integer)

    # We start by getting the values that are in the patch
    in_patch = findall(patches(l) .== p)

    # Border cells are those that are in the patch and in contact with non-patch cells, so
    # we need to figure out what the patch value is
    class = unique(l[in_patch])

    # We can now loop at the cells in the patch and retain only those that are in contact
    # with cells that are not part of the same class -- we use the Von Neuman neighborhood
    # for this
    border = CartesianIndex[]
    for cell in in_patch
        to_evaluate = filter(c -> c in CartesianIndices(l), cell .+ VonNeumann)
        # We start by looking whether the cell is near the edge of the landscape, in which
        # case it is a potential border
        if length(to_evaluate) < length(VonNeumann)
            push!(border, cell)
        else
            # If the cell is not near the edge of the landscape, we simply check for the
            # presence of other values than the patch class
            neighbor_classes = l[to_evaluate]
            if any(neighbor_classes .!= class)
                push!(border, cell)
            end
        end
    end

    return border
end

@testitem "We can identify the cells that form the border of a patch" begin
    L = Landscape([
            0 1 1 0 1 0;
            0 1 1 1 1 0;
            0 0 1 0 0 0
        ]; nodata=0)
    border = LandscapeMetrics.identify_border_cells(L, 1)
    expected_border = [CartesianIndex(1, 2),
        CartesianIndex(1, 3),
        CartesianIndex(1, 5),
        CartesianIndex(2, 2),
        CartesianIndex(2, 5),
        CartesianIndex(3, 3)
    ]
    for i in eachindex(L)
        @test (i in expected_border) == (i in border)
    end
end

function corepatches(l::Landscape{T}, edges::Matrix{T}) where {T<:Integer}
    return nothing
end
