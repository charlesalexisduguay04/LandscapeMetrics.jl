
"""
    radiusofgyration(l::Landscape)

Returns the mean distance between each cell in the patch and the patch centroid.

"""

function radiusofgyration(l::Landscape, patch)

    # We get the patches
    p = patches(l)

    # We get the coordinates of the patch
    patch_coordinates = findall(isequal(patch), p)

    # Extract row and column indices
    rows = [coord[1] for coord in patch_coordinates]
    cols = [coord[2] for coord in patch_coordinates]

    # Calculate center position
    centroid_row = mean(rows)
    centroid_col = mean(cols)

 
    # Compute distances from each cell to centroid
        distances = [hypot(r - centroid_row, c - centroid_col) for (r, c) in zip(rows, cols)]
     
    # Return mean distance
    return mean(distances)

end



@testitem "The smallest radiusofgyration is 0 when the patch consists in a single cell" begin
    A = [0 1 0]  # Single cell patch
    L = Landscape(A)
    @test radiusofgyration(L, 1) == 0
end


@testitem "We can measure the radius of gyration for a multi-cell patch" begin
    A = [
         2 1 2 2 2 2;
         1 1 1 3 3 3;
         2 1 2 2 2 2
    ]
    L = Landscape(A)
    @test radiusofgyration(L, 1) == 0.8
end


@testitem "We can measure the radius of gyration for a multi-cell patch" begin
    A = [
         1 1 1
    ]
    L = Landscape(A)
    @test radiusofgyration(L, 1) == 2/3
end 










