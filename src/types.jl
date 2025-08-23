"""
Landscape

The landscape is defined by a grid of values, and has a specific value for no data. When the value is nodata, the patch is considered empty. When the value is negative, the patch is consider a border.
"""
Base.@kwdef struct Landscape{T<:Integer}
    grid::Matrix{T}
    nodata::T = 99
    area::AbstractFloat = 1.0
end

Base.eltype(::Landscape{T}) where {T} = T
Base.size(l::Landscape) = size(l.grid)
Base.size(l::Landscape, args...) = size(l.grid, args...)
Base.ndims(l::Landscape) = ndims(l.grid)

"""
interiorbackground(l::Landscape)

Returns a bitmatrix that indicates whether a cell of the landscape is part of the interior background. The interior background is positive and has the `nodata` value.
"""
function interiorbackground(l::Landscape)
    return isequal(l.nodata).(l.grid)
end

"""
exteriorbackground(l.::Landscape)

Returns a bitmatrix that indicates whether a cell of the landscape is part of the exterior background. The interior background is negative, and can have either the `nodata` value or the value associated to a patch in the landscape.
"""
function exteriorbackground(l::Landscape)
    return l.grid .< zero(eltype(l))
end


"""
background(l::Landscape)

Returns the background for the landscape, which is composed of cells that are either in the interior of exterior bacground.
"""
background(l::Landscape) = interiorbackground(l) .| exteriorbackground(l)

@testitem "We can correctly identify the background" begin

    # We create a mock landscape with a single patch value
    _fill_value = 1
    A = fill(_fill_value, (4, 4))

    # Then we setup two masks, one with the interior and one with the exterior
    # background
    interior = [false false false false; false false true false; false true false false; false false false false]
    exterior = [true true true true; true false false true; true false false true; false false false false]

    # Now we use the correct values in the matrix
    _bg_value = 9
    A[findall(interior)] .= _bg_value
    A[findall(exterior)] .= -_bg_value

    # We will also add an exterior cell that is valued
    A[rand(findall(exterior))] = -_fill_value

    # We store this into an actual landscape
    L = Landscape(grid=A, nodata=_bg_value)

    # These are the three tests we care about
    @test interiorbackground(L) == interior
    @test exteriorbackground(L) == exterior
    @test background(L) == interior .| exterior
end
