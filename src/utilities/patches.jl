const VonNeumann = CartesianIndex.([(-1, 0), (0, 0), (0, 1), (0, -1), (1, 0)])
const Moore = collect(CartesianIndices((-1:1, -1:1)))

function patches!(l::Landscape; stencil=Moore)
    # We start by giving each pixel in the landcape its own value, and then we do a little
    # bit of value propagation
    patch_id = collect(reshape(eachindex(l), size(l)))

    # We do not care about the background values when assigning the patches
    patch_id[background(l)] .= 0

    # We will have a flag to check that we have updated at least one of the values during
    # this round of updates
    has_updated = true

    # Now we can loop
    while (has_updated)

        # We will assume that there is no update yet
        has_updated = false

        # Now we loop
        for i in CartesianIndices(patch_id)

            # But only if the patch is not in the background
            if !iszero(patch_id[i])

                # Get the neighbors of the patch
                neighbors = filter(pos -> pos in CartesianIndices(patch_id), i .+ stencil)

                # We pick the value of the patch in the landscape
                target = l[i]

                # We need to get the neighbors that have the same value as the target patch
                inpatch = filter(n -> l[n] == target, neighbors)

                # If there are neighbors here...
                if !isempty(inpatch)

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

    # Now we update the values so that the largest patch has ID of 1
    patch_count = filter(x -> !iszero(x.first), collect(countmap(patch_id)))
    sort!(patch_count, by=x -> x.second, rev=true)

    for (i, k) in enumerate(patch_count)
        l.patches[findall(patch_id .== k.first)] .= i
    end

    return l
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
        1 1 1 1 1 5 5 5 0 0;
        1 1 1 6 6 6 0 0 0 0;
        1 1 2 2 2 2 4 4 3 3;
        1 2 2 2 2 2 4 4 3 3
    ]
    @test all(M .== patches(l))
end
