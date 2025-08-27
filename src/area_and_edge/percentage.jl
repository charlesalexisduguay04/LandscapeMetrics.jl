"""
    percentage(l::Landscape{T}, c::T) where {T <: Integer}

Returns the percentage of the total area that is occupied by a given class type.
"""
function percentage(l::Landscape{T}, c::T) where {T<:Integer}
    @assert c in unique(values(l.grid))
    relevant_cells = count((l.grid .== c) .& foreground(l))
    return 100 * (relevant_cells * l.area) / totalarea(l)
end

@testitem "We can calculate the percentage of a landscape with missing data" begin
    A = [
        1 1 1 2;
        1 1 2 2;
        2 2 2 2
    ]
    L = Landscape(A; nodata=2)
    @test percentage(L, 1) ≈ 100 * (count(A .== 1) / prod(size(A)))
end

@testitem "We can calculate the percentage of a landscape with exterior background" begin
    A = [
        -1 -1 -1 -1 -1;
        -1 1 1 1 -1
        -1 2 2 1 -1;
        -1 2 1 1 -1;
        -1 -1 -1 -1 -1
    ]
    L = Landscape(A; nodata=2)
    @test percentage(L, 1) ≈ 100 * (count(A .== 1) / prod(size(A)))
end
