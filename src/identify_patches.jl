function patches(l::Landscape; stencil=CartesianIndices((-1:1, -1:1)))
    # We start by giving each pixel in the landcape its own value, and then we do a little
    # bit of value propagation
    patch_id = collect(reshape(eachindex(l.grid), size(l.grid)))

    # We do not care about the background values
    patch_id[background(l)] .= 0

    # We will have a flag to check that we have updated at least one of the values during
    # this round of updates
    has_updated = true

    # Now we can loop
    while(has_updated)

        # We will assume that there is no update yet
        has_updated = false

        # Now we loop
        for i in CartesianIndices(patch_id)

            # But only if the patch is not in the background
            if !iszero(patch_id[i])

                # Get the neighbors of the patch
                neighbors = filter(pos -> pos in CartesianIndices(patch_id), i .+ stencil)

                # We pick the value of the patch in the landscape
                target = l.grid[i]

                # We need to get the neighbors that have the same value as the target patch
                inpatch = filter(n -> l.grid[n] == target, neighbors)

                # If there are neighbors here...
                if ~isempty(inpatch)

                    # We can now look at whether all the values are the same
                    current_patch_id = patch_id[inpatch]

                    # We will now merge the patche
                    if length(unique(current_patch_id)) > 1
                        has_updated = true
                        patch_id[inpatch] .= minimum(current_patch_id)
                    end
                end
            end
        end

    end

    # TODO: update the patch ID so that they are ordered by number or cells in the patch

    return patch_id
end
