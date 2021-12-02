# advent-of-code-2021
My solutions to 2021's [Advent of Code](https://adventofcode.com/2021) puzzles. My goal is to create the simplest "first-pass" solutions I can using only Base [Julia](https://julialang.org).

## Day 1

```julia
# Load data
data = parse.(Int, readlines(joinpath(@__DIR__, "input.txt")))

# Part 1
ans1 = sum([data[i] > data[i-1] for i in 2:length(data)])
@info "Number of times depth measurement increases = $ans1"

# Part 2
ans2 = sum([sum(data[i-2:i]) > sum(data[i-3:i-1]) for i in 4:length(data)])
@info "Number of times the sum of a three-measurement window increases = $ans2"
```

## Day 2
```julia
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
```
