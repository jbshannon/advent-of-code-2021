# based on https://julialang.zulipchat.com/#narrow/stream/307139-advent-of-code-.282021.29/topic/day.2022/near/265949526

const Box = NamedTuple{(:on, :x), Tuple{Bool, Tuple{UnitRange{Int64}, UnitRange{Int64}, UnitRange{Int64}}}}
box_intersect(a::Box, b::Box) = (on=!a.on, x=(a.x .∩ b.x))
volume(b::Box) = (b.on ? 1 : -1)*prod(length, b.x)
volume50(b::Box) = (b.on ? 1 : -1)*prod(x -> length(x ∩ (-50:50)), b.x)

function cleanpush!(boxes::Vector{Box}, b::Box)
    volume(b) == 0 && return
    i = findfirst(a -> a.on ⊻ b.on && a.x == b.x, boxes)
    isnothing(i) ? push!(boxes, b) : deleteat!(boxes, i)
    return boxes
end

function solve(instructions::Vector{Box})
    boxes = Box[]
    for b in instructions
        new = Box[]
        for box in boxes cleanpush!(new, box_intersect(box, b)) end
        for n in new cleanpush!(boxes, n) end
        b.on && cleanpush!(boxes, b)
    end
    return boxes
end

boxes = joinpath(@__DIR__, "input.txt") |> parse_input |> solve
answer₁, answer₂ = sum(volume50, boxes), sum(volume, boxes)
