pstr, istr = split(read("input.txt", String), "\n\n")
insertions = split.(split(istr, '\n'), " -> ")
pp = map(x -> x[1], insertions)
chars = unique(string(pp...))
P = Dict(pp[i] => i for i in eachindex(pp))

const polymer = zeros(Int, length(pp))
for i in 1:length(pstr)-1
    polymer[P[string(pstr[i], pstr[i+1])]] += 1
end

const M = zeros(Int, length(pp), length(pp))
for (pair, inserted) in insertions
    M[P[string(pair[1], inserted)], P[pair]] += 1
    M[P[string(inserted, pair[2])], P[pair]] += 1
end

const C = zeros(Int8, length(chars), length(pp))
for i in eachindex(chars)
    for j in eachindex(pp)
        C[i, j] = count(==(chars[i]), pp[j])
    end
end
const adjustment = in((first(pstr), last(pstr))).(chars)
solution(num) = (A = C*M^num*polymer + adjustment; Int((maximum(A) - minimum(A))/2))

@info "Part 1: $(solution(10))"
@info "Part 2: $(solution(40))"
