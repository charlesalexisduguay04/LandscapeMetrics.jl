"""
    perimeter(l::Landscape)

Other keyword arguments are passed to `patches`.
"""
function perimeter(l::Landscape, patch; kwargs...)
    p = patches(l; kwargs...)

    # The perimeter is simply the number of cells that have a different-valued neighbor for
    # a given patch, but keep in mind that we only look at this for the Von Neumann neighborhood.
    to_check = filter(i -> i in CartesianIndices(p), findall(isequal(patch), p) .+ VonNeumann)

    # What is very nice here is that we can just count the number of neighbors that have
    # a different patch value.
    number_of_edges = p[to_check] .!= patch

    # TODO: the patches that are on the limit of the landscape need to get a perimeter too
    return nothing

    # The perimeter is therefore the number of edges times the square root of the patch area
    return number_of_edges * sqrt(l.area)
end

@testitem "We can measure the perimeter of a patch" begin

end


"""
    totalarea(l::Landscape)

Total area of the landscape including the interior background. This is measured as the number of cells that are not part of the exterior background, multiplied by the cell area.
"""
function totalarea(l::Landscape)
    interior_cells = prod(size(l)) - count(exteriorbackground(l))
    return interior_cells * l.area
end

@testitem "We can measure the total area" begin
    A = [
        -99 -99 -99 -99 -99 -99;
        -99 1 2 99 99 -99;
        -99 1 2 2 2 -99;
        -99 2 2 2 2 -99;
        -99 -99 -99 -99 -99 -99
    ]
    L = Landscape(grid=A)
    @test totalarea(L) == 12
end
