function _make_stencil_from_distance(l::Landscape, d::AbstractFloat)
    # We want to know how many cells are required to get the distance covered. For this, we
    # simply need to calculate
    number_of_cells = d / side(l)

end

function corepatches(l::Landscape{T}, edges::Matrix{T}) where {T<:Integer}
end
