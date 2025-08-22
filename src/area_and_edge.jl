"""
    totalarea(l::Landscape)

Total area of the landscape including the interior background. This is measured as the number of cells that are not part of the exterior background, multiplied by the cell area.
"""
function totalarea(l::Landscape)
    interior_cells = prod(size(l.grid)) - count(exteriorbackground(l.grid))
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
