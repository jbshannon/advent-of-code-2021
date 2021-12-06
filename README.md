# advent-of-code-2021
My solutions to 2021's [Advent of Code](https://adventofcode.com/2021) puzzles. My goal is to create the simplest "first-pass" solutions I can using only Base [Julia](https://julialang.org).

## Day 1

```julia
# Load data
data = parse.(Int, readlines("input.txt"))

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

for line in eachline("input.txt")
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

for line in eachline("input.txt")
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

## Day 3
```julia
# Part 1
diagnostic = map(x -> parse.(Bool, split(x, "")), readlines("input.txt"))
γ = sum(diagnostic) .>= length(diagnostic)/2
ϵ = .!γ
bit2decimal(x) = sum([2^(i-1) for i in eachindex(x) if Bool(x[end-(i-1)])])
@info "Power consumption = $(prod(bit2decimal, [γ, ϵ]))" bit2decimal(γ) bit2decimal(ϵ)

# Part 2
bitfilter(y, b, i) = filter(y) do x
    target = sum(z -> z[i], y) >= length(y)/2
    length(y) > 1 ? b ? x[i] == target : x[i] != target : true
end

function findrate(z, b)
    inds = (reverse ∘ eachindex ∘ first)(z)
    funs = [x -> bitfilter(x, b, i) for i in inds]
    (only ∘ reduce(∘, funs))(z)
end

O₂, CO₂ = map(x -> findrate(diagnostic, x), [true, false])
@info "Life support rating = $(prod(bit2decimal, [O₂, CO₂]))" bit2decimal(O₂) bit2decimal(CO₂)
```

## Day 4
```julia
# Read input
readarray(x) = "[$x]" |> Meta.parse |> eval
firstline, rest = Base.Iterators.peel(readlines("input.txt"))
nums = readarray(firstline)
boards = map(readarray ∘ x -> join(x, '\n'), Base.Iterators.partition(rest, 6))

# Bingo functions
bingo_rows = vcat(
    [[CartesianIndex(i, j) for i in 1:5] for j in 1:5], # column indices
    [[CartesianIndex(i, j) for j in 1:5] for i in 1:5], # row indices
)
mark_board(board, i) = reduce(.|, nums[j] .∈ board for j in 1:i)
check_win(marks) = map(all ∘ x -> marks[x], bingo_rows) |> any
win_time(board) = map(check_win ∘ i -> mark_board(board, i), eachindex(nums)) |> findfirst
score_board(board) = (i = win_time(board); nums[i] * sum(board[.!mark_board(board, i)]))
win_times = map(win_time, boards)

# Part 1
first_time, i = findmin(win_times)
@info "Score of first winning board = $(score_board(boards[i]))" first_time

# Part 2
last_time, i = findmax(win_times)
@info "Score of last winning board = $(score_board(boards[i]))" last_time
```

## Day 5
```julia
vents = map(split(read("input.txt", String), '\n')) do line
    parse.(Int, match(r"(\d*),(\d*) -> (\d*),(\d*)", line).captures)
end
ocean_floor = fill(0, (999, 999))

isvert(p) = p[1] == p[3] || p[2] == p[4]
function mark_vents!(ocean_floor, vents)
    for vent in vents
        x₁, y₁, x₂, y₂ = vent
        dx, dy = x₂-x₁, y₂-y₁
        for i in range(0, mapreduce(abs, max, (dx, dy)), step=1)
            ocean_floor[x₁ + i*sign(dx), y₁ + i*sign(dy)] += 1
        end
    end
end

# Part 1
mark_vents!(ocean_floor, filter(isvert, vents))
@info "Horizontal/vertical danger zones: $(count(>(1), ocean_floor))"

# Part 2
mark_vents!(ocean_floor, filter(!isvert, vents))
@info "All danger zones: $(count(>(1), ocean_floor))"
```

## Day 6
```julia
ages = parse.(Int, split(read("input.txt", String), ","))
# 🐟 = [count(==(i), ages) for i in 0:8] # this is costly
🐟 = zeros(Int, 9)
for i in eachindex(🐟); 🐟[i] = count(==(i-1), ages) end
🐡 = copy(🐟)

function evolve!(🐟, 🐡)
    copyto!(🐡, 🐟) # copy state of population
    circshift!(🐟, 🐡, -1) # reduce age by one, add newborn fish to age = 8
    🐟[7] += 🐡[1] # copy parent fish to age = 6
end

# Part 1
for t in 1:80; evolve!(🐟, 🐡); end
@info "Number of lanternfish after  80 days = $(sum(🐟))"

# Part 2
for t in 81:256; evolve!(🐟, 🐡); end
@info "Number of lanternfish after 256 days = $(sum(🐟))"
```