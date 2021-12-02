# Part 1
horizontal, depth = 0, 0

for line in eachline(joinpath(@__DIR__, "input.txt"))
    direction, distance = split(line, " ")
    distance = parse(Int, distance)
    if direction == "forward"
        horizontal += distance
    elseif direction == "down"
        depth += distance
    elseif direction == "up"
        depth -= distance
    end
end

@info "Final horizontal position times final depth = $(horizontal*depth)" horizontal depth

# Part 2
horizontal, depth, aim = 0, 0, 0

for line in eachline(joinpath(@__DIR__, "input.txt"))
    direction, distance = split(line, " ")
    distance = parse(Int, distance)
    if direction == "forward"
        horizontal += distance
        depth += aim*distance
    elseif direction == "down"
        aim += distance
    elseif direction == "up"
        aim -= distance
    end
end

@info "Final horizontal position times final depth = $(horizontal*depth)" horizontal depth aim
