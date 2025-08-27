const VonNeumann = CartesianIndex.([(-1, 0), (0, 0), (0, 1), (0, -1), (1, 0)])
const Moore = collect(CartesianIndices((-1:1, -1:1)))

function patches!(l::Landscape; stencil=Moore)

    # We start by emptying the allocation of patches, and assigning each value to its own
    # patch
    for i in LinearIndices(l.patches)
        l.patches[i] = i
    end
    @assert allunique(l.patches)

    # And we create a grid to keep track of the visited patches - it is initially all false,
    # which means that we need to visit all the patches
    visited = zeros(Bool, size(l.patches))

    # We do not assign the background to patches, so we can already rule these out. We give
    # them a value of 0, and we also set their visit value to true so we do not update them
    # further
    for bg in findall(background(l))
        visited[bg] = true
        l.patches[bg] = 0
    end

    # Now we will visit the patches in turn, until we have visited all the patches -- this
    # will happen when all the values in the visited matrix are true
    while !all(visited)
        start_update_at = findfirst(!, visited)

        # This will work through all the possible patches connected to the starting update
        # point by the stencil
        _propagate_labels!(l, visited, start_update_at, stencil)
    end

    # Now we update the values so that the largest patch has ID of 1

    # This line ensures that the patch index are larger than what we have encountered, so we
    # cannot over-write values
    l.patches[l.patches.!=0] .+= prod(size(l.patches)) + 1

    # We start by counting the values for all patches and ranking them
    patch_count = filter(x -> !iszero(x.first), collect(countmap(l.patches)))
    sort!(patch_count, by=x -> x.second, rev=true)

    for i in eachindex(patch_count)
        l.patches[findall(l.patches .== patch_count[i].first)] .= i
    end

    return l

end

function _propagate_labels!(landscape, visits, position, neighborhood)
    # Identify all neighbors, which are given by the position to which we add the stencil.
    # The positions that are outside the grid (the Julia matrix) are removed
    neighbors = filter(pos -> pos in CartesianIndices(visits), position .+ neighborhood)

    # We get the patch id of the current patch. This is the value we will propagate to the
    # rest of the connected cells
    current_patch = landscape.patches[position]

    # We can mark the fact that this position has been visited, and we have given it a patch
    # value
    visits[position] = true

    # The patches to visit have the same class value
    n_with_same_class = filter(pos -> landscape[pos] == landscape[position], neighbors)

    # But we also only want to visit the neighbors that have not been visited yet
    n_to_visit = filter(pos -> !visits[pos], n_with_same_class)

    if isempty(n_to_visit)
        # We quit if there are no neighbors left to work on
        return nothing
    else
        # Otherwise, we will loop through the various neighbors to update
        for visit in n_to_visit
            # We set the value of the neighbor to visit to the value of the patch we are
            # currently on
            landscape.patches[visit] = current_patch

            # Then we go and update the neighbours of this patch
            _propagate_labels!(landscape, visits, visit, neighborhood)
        end
    end

    return nothing
end

patches(l::Landscape) = l.patches

@testitem "We can correctly identify the patches for a landscape" begin
    # These are the patches, the nodata value is five
    V = [
        1 1 1 1 1 3 3 3 5 5;
        1 1 1 2 2 2 5 5 5 5;
        1 1 3 3 3 3 2 2 3 3;
        1 3 3 3 3 3 2 2 3 3
    ]
    l = Landscape(V; nodata=5)
    # This is what it should look like with the Moore neighborhood
    patches!(l; stencil=Moore)
    M = [
        1 1 1 1 1 5 5 5 0 0;
        1 1 1 3 3 3 0 0 0 0;
        1 1 2 2 2 2 3 3 4 4;
        1 2 2 2 2 2 3 3 4 4
    ]
    @test all(M .== patches(l))
    # This is what it should look like with the VonNeumann neighborhood
    patches!(l; stencil=VonNeumann)
    M = [
        1 1 1 1 1 6 6 6 0 0;
        1 1 1 5 5 5 0 0 0 0;
        1 1 2 2 2 2 3 3 4 4;
        1 2 2 2 2 2 3 3 4 4
    ]
    @test all(M .== patches(l))
end
