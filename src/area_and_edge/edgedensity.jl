"""
   edgedensity(l::Landscape)

Returns the edge density of the landscape, defined as the total edge length divided by the total area.

"""

function edgedensity(l::Landscape)
    return totaledge(l) / totalarea(l)
end