🦀 = parse.(Int, split(read("input.txt", String), ","))
fuel1, fuel2 = typemax(Int), typemax(Int)
for loc in minimum(🦀):maximum(🦀)
    fuel1 = min(fuel1, sum(x -> abs(x - loc), 🦀))
    fuel2 = min(fuel2, sum(x -> sum(1:abs(x - loc)), 🦀))
end
@info "Part 1: minimum fuel usage = $fuel1"
@info "Part 2: minimum fuel usage = $fuel2"
