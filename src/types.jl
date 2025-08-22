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

interiorbackground(l::Landscape) = isequal(l.nodata).(l.grid)
exteriorbackground(l::Landscape) = l.grid .< zero(eltype(l))
background(l::Landscape) = interiorbackground(l) .| exteriorbackground(l)

