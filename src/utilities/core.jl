function _make_stencil_from_distance(l::Landscape, d::AbstractFloat)
    # We want to know how many cells are required to get the distance covered. For this, we
    # simply need to calculate
    number_of_cells = ceil(Int, d / side(l))

    # We will now generate the initial stencil, which is not yet filtered by distance to the
    # center of the focal cell
    span = -number_of_cells:number_of_cells
    stencil = CartesianIndices((span, span))

    return nothing

end

function corepatches(l::Landscape{T}, edges::Matrix{T}) where {T<:Integer}
end
