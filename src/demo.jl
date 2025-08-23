nbnb() = Landscape(grid=[
        1 1 1 1 1 2 2 2 2 4 4 4 4 4;
        1 1 1 3 3 2 2 2 2 4 4 1 1 1;
        1 1 1 3 3 3 3 4 4 4 4 4 4 4;
        1 1 1 3 3 3 3 4 3 3 3 3 4 4;
        2 2 2 3 3 3 3 4 3 3 3 3 4 4;
        2 2 2 3 3 3 3 4 4 4 4 4 4 4;
        2 2 2 3 3 1 1 1 4 4 4 4 4 4;
        4 4 4 4 4 1 1 1 2 2 2 2 2 2;
        4 4 4 4 4 4 4 4 2 2 2 2 2 2
    ], nodata=9)

ibnb() = Landscape(grid=[
        1 1 1 1 1 2 2 2 2 4 4 4 4 4;
        1 1 1 3 3 2 2 2 2 4 4 1 1 1;
        1 1 1 3 3 3 3 4 4 4 4 4 4 4;
        1 1 1 3 3 3 3 4 9 9 9 9 4 4;
        9 9 9 3 3 3 3 4 9 9 9 9 4 4;
        9 9 9 3 3 3 3 4 4 4 4 4 4 4;
        9 9 9 3 3 9 9 9 4 4 4 4 4 4;
        4 4 4 4 4 9 9 9 2 2 2 2 2 2;
        4 4 4 4 4 4 4 4 2 2 2 2 2 2
    ], nodata=9)

function ebnb()
    g = fill(-9, size(ibnb()) .+ (2, 2))
    g[2:(end-1), 2:(end-1)] .= replace(ibnb().grid, 9 => -9)
    return Landscape(grid=g, nodata=9)
end

function iebnb()
    g = fill(-9, size(ibnb()) .+ (2, 2))
    g[2:(end-1), 2:(end-1)] .= ibnb().grid
    return Landscape(grid=g, nodata=9)
end

