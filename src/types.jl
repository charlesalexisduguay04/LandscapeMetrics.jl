"""
    AbstractLandscape

This is an abstract class for all landscapes that we will work on -- the overwhelming majority of methods should dispatch on this, and we can build interfaces as required for the more specific types
"""
abstract type AbstractLandscape end

"""
    RegularLandscape

This type represents a landscape in which the cells have the same area -- this is the default type of landscape
"""
struct RegularLandscape{T,S<:Real} <: AbstractLandscape
    grid::Matrix{T}
    area::S
end

"""
    IrregularLandscape

This type represents a landscape in which the cells have different surfaces -- this is notably useful when the grid comes from a layer represented as WGS84
"""
struct IrregularLandscape{T,S<:Real} <: AbstractLandscape
    grid::Matrix{T}
    area::Matrix{S}
end

"""
    grid(::AbstractLandscape)

Returns the grid of values for a given landscape
"""
grid(M <: AbstractLandscape) = M.grid

"""
    area(::IrregularLandscape)

Returns the matrix of cell surface area for an irregularly sized landscape
"""
area(M::IrregularLandscape) = M.area

"""
    area(::RegularLandscape)

Returns the area of each cell (as a matrix) for a regularly sized landscape
"""
area(M::RegularLandscape) = fill(M.area, size(grid(M)))

