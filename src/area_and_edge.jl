"""
    totalarea(l::Landscape)

Total area of the landscape including the interior background. This is measured as the number of cells that are not part of the exterior background, multiplied by the cell area.
"""
function totalarea(l::Landscape)
    interior_cells = prod(size(l.grid)) - count(exteriorbackground(l.grid))
    return interior_cells * l.area
end
