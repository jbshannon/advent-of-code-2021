m = match(r"x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)", read("input.txt", String))
xs = parse.(Int, (m[1], m[2]))
ys = parse.(Int, (m[3], m[4]))

step!(p, v) = (p .+= v; v .= [max(v[1]-1,  0), v[2]-1])

valid = Vector{Vector{Int64}}()
for x in 1:xs[2]
    for y in ys[1]:(-ys[1])
        p, v = [0, 0], [x, y]
        while p[1] <= xs[2] && p[2] >= ys[1]
            step!(p, v)
            p[1] in xs[1]:xs[2] && p[2] in ys[1]:ys[2] && (push!(valid, [x, y]); break)
        end
    end
end

@info "Part 1: $(maximum(v -> v[2], valid))"
@info "Part 2: $(length(valid))"
