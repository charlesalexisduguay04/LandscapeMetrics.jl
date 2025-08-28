"""
    cellcenters(l::Landscape)

Returns a matrix of tuples giving the cell center positions in metres. The size of the cells is measured as the square root of their area.
"""
function cellcenters(l::Landscape)

    # We get the centers as a matrix of vectors, as we will need to change the values
    centers = [[idx.I...] for idx in CartesianIndices(l)]

    # We will now make it that the center of the grid is at the 0, 0 coordinate - this is
    # not particularly difficult as we simply need to substract half of the size of the
    # matrix
    offset = fill([0.5 .* (size(l) .+ 1)...], size(l))

    # We now scale this by the size of the cells
    return [tuple(x...) for x in (centers .- offset) .* side(l)]

end

@testitem "We can get the center of cells" begin
    A = [1 2 3; 4 5 6; 7 8 9]
    L = Landscape(A; area=4.0)
    @test cellcenters(L)[2, 2] == (0.0, 0.0)
    @test cellcenters(L)[1, 1] == (-2.0, -2.0)
end
