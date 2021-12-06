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
