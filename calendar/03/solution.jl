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
