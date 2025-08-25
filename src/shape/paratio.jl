"""
    paratio(l::Landscape, p::Integer)

Returns the perimeter-area ratio of a given patch. Also offered as `perimeterarearatio`. Note that `shapeindex` is a normalized version of this.
"""
function paratio(l::Landscape, p::Integer)
    @assert p in patches(l)
    return perimeter(l, p) / area(l, p)
end

const perimeterarearatio = paratio

@testitem "We can measure the perimeter area ratio of a square" begin
    A = [
        3 3 3 3;
        3 1 1 3;
        3 1 1 3;
        3 3 3 3
    ]
    L = Landscape(A; nodata=3)
    @test paratio(L, 1) == 8 / 4
    @test perimeterarearatio(L, 1) == paratio(L, 1)
end

"""
    shapeindex(l::Landscape, p::Integer)

Returns the perimeter divided by the square root of the area, multiplied by a constant so that the shape index is one for square patches. This is an alternative to `paratio`.
"""
function shapeindex(l::Landscape, p::Integer)
    @assert p in patches(l)
    pij = perimeter(l, p)
    aij = area(l, p)
    return 0.25 * pij / sqrt(aij)
end

@testitem "The shape index of a square patch is 1" begin
    A = [
        3 3 3 3 3 3;
        3 1 1 3 2 3;
        3 1 1 3 3 3;
        3 3 3 3 3 3
    ]
    L = Landscape(A; nodata=3)
    for p in filter(!iszero, unique(patches(L)))
        @test shapeindex(L, p) == 1
    end
end

"""
    fractaldimensionindex(l::Landscape, p::Integer)

Return the ratio of the log of the perimeter and the log of the patch area, after the perimeter is normalized assuming a square. Note that this version has been normalized to return results in between 0 (square) and maximally complex form (1).
"""
function fractaldimensionindex(l::Landscape, p::Integer)
    @assert p in patches(l)
    pij = perimeter(l, p)
    aij = area(l, p)
    return 2log(0.25 * pij) / log(aij) - 1
end

@testitem "The fractal dimension index for a square is ≈ 0" begin
    A = [
        3 3 3 3 3 3;
        3 1 1 3 3 3;
        3 1 1 3 3 3;
        3 3 3 3 3 3
    ]
    L = Landscape(A; nodata=3)
    @test fractaldimensionindex(L, 1) ≈ 0
end

@testitem "The fractal dimension index for a patch more complex than a square is between 0 and 1" begin
    A = [
        3 3 3 3 3 3;
        3 1 1 1 1 3;
        3 1 1 3 1 3;
        3 3 3 3 1 3
        3 1 1 1 1 3
        3 1 3 3 3 3
        3 1 3 3 1 3
        3 1 1 1 1 3
        3 3 3 3 1 3
        3 3 1 1 1 3
        3 3 3 3 3 3
    ]
    L = Landscape(A; nodata=3)
    @test fractaldimensionindex(L, 1) < 1
end
