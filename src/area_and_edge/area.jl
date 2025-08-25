"""
    area(l::Landscape, p::Integer)

Area of a specific patch in the landscape.
"""
area(l::Landscape, p::Integer) = l.area * count((patches(l) .== p) .& foreground(l))


@testitem "We can measure the area of a patch" begin
    A = [
        1 1 1 2 2;
        1 1 1 1 2;
        1 1 1 3 3
    ]
    L = Landscape(A; nodata=3)
    patches!(L)
    @test area(L, 1) == 10
    @test area(L, 2) == 3
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
    L = Landscape(A)
    @test totalarea(L) == 12
end

@testitem "With no interior background, the total area is the sum of patch areas" begin
    A = [
        1 1 1 1 2 2;
        1 1 2 2 2 3;
        1 2 2 3 3 3;
        3 3 3 3 3 3
    ]
    L = Landscape(A)
    patches!(L)
    a = [area(L, p) for p in unique(patches(L))]
    @test sum(a) == totalarea(L)
end

@testitem "With interior background, the total area is larger than the sum of patch areas" begin
    A = [
        1 1 1 1 2 2;
        1 1 2 2 2 3;
        1 2 2 3 3 3;
        3 3 3 3 3 3
    ]
    L = Landscape(A; nodata=2)
    patches!(L)
    a = [area(L, p) for p in unique(patches(L))]
    @test sum(a) < totalarea(L)
end
