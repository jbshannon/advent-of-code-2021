pointstr, foldstr = split(read("input.txt", String), "\n\n")
points = map(x -> parse.(Int, split(x, ',')), split.(pointstr, '\n', keepempty=false))
folds = map(x -> split(x, "="), split.(foldstr, '\n', keepempty=false))

function fold!(points, directions)
    dim = directions[1] == "fold along x" ? 1 : 2
    mag = parse(Int, directions[2])
    for p in points
        Δ = p[dim] - mag
        Δ > 0 && (p[dim] -= 2*Δ)
    end
    return points
end

function display_code(points)
    points |> sort! |> unique!
    X, Y = maximum(reduce(hcat, points), dims=2)
    for y in 0:Y
        println()
        for x in 0:X
            print([x, y] in points ? repeat(Char(0x2588), 2) : "  ")
        end
    end
end

for d in folds
    fold!(points, d)
    d == first(folds) && @info "Part 1: $(length(unique(points)))"
end
display_code(points)
