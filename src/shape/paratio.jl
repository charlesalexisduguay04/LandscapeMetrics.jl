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
