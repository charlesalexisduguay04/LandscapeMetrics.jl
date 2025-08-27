"""
    largestpatchindex(l::Landscape)

Returns the percentage of the landscape that is covered by the largest patch. This is related to `percentage`.
"""
function largestpatchindex(l::Landscape)
    most_common_patch = StatsBase.mode(filter(!iszero, patches(l)))
    patch_cover = count(patches(l) .== most_common_patch) * l.area
    return 100 * (patch_cover / totalarea(l))
end

@testitem "The largest patch index is 100 when the landscape has a single patch" begin
    A = [
        1 1 1;
        1 1 1;
        1 1 1
    ]
    @test largestpatchindex(Landscape(A)) == 100
end

@testitem "We can get the largest patch index with background values" begin
    A = [
        1 1 1;
        1 1 2;
        1 1 1
    ]
    @test largestpatchindex(Landscape(A; nodata=2)) ≈ 100 * (8 / 9)
end

@testitem "We can get the largest patch index with multiple patches" begin
    A = [
        1 1 2;
        1 1 2;
        1 1 2
    ]
    @test largestpatchindex(Landscape(A)) ≈ 100 * (6 / 9)
end
