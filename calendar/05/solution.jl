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
