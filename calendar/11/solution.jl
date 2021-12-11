🐙 = mapreduce(line -> parse.(Int8, split(line, "")), hcat, readlines("input.txt"))
💡 = fill(false, size(🐙))
const R = CartesianIndices(🐙)
const If, Il = extrema(R)
const I1 = one(If)

function flash!(🐙, 💡, I)
    💡[I] = true
    for i in max(I-I1, If):min(I+I1, Il)
        🐙[i] += 1
        🐙[i] > 9 && !💡[i] && flash!(🐙, 💡, i)
    end
end

function step!(🐙, 💡)
    fill!(💡, false)
    for I in R; 🐙[I] += 1; end
    for I in R; 🐙[I] > 9 && !💡[I] && flash!(🐙, 💡, I); end
    for I in R; 💡[I] && (🐙[I] = 0); end
end

function solve(🐙, 💡)
    🧮 = 💥 = i = 0
    while !all(💡) || i <= 100
        i += 1
        step!(🐙, 💡)
        🧮 = i <= 100 ? 🧮 + sum(💡) : 🧮
        💥 = all(💡) ? 💥 + i : 💥
    end
    return 🧮, 💥
end

🧮, 💥 = solve(🐙, 💡)
@info "Number of flashes in first 100 steps = $🧮"
@info "First step where all flash = $💥"
