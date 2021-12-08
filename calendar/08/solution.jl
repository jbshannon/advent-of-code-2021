lines = map(split(read("input.txt", String), '\n')) do line
    map(split(line, " | ")) do side
        split(side, " ")
    end
end

# Part 1
unique_lengths = Set([2, 3, 4, 7])
ans1 = sum(line -> count(map(in(unique_lengths) ∘ length, line[2])), lines)
@info "Number of times (1, 4, 7, 8) appear = $ans1"

# Part 2
signals = Bool.([
#   a b c d e f g
    1 1 1 0 1 1 1 # 0
    0 0 1 0 0 1 0 # 1
    1 0 1 1 1 0 1 # 2
    1 0 1 1 0 1 1 # 3
    0 1 1 1 0 1 0 # 4
    1 1 0 1 0 1 1 # 5
    1 1 0 1 1 1 1 # 6
    1 0 1 0 0 1 0 # 7
    1 1 1 1 1 1 1 # 8
    1 1 1 1 0 1 1 # 9
])
chars = 'a':'g'
M = Dict(Set(chars[signals[i, :]]) => i-1 for i in 1:10)

function deduce(signal)
    sets = Set.(signal)
    h(len) = reduce(∩, sets[findall(s -> length(s) == len, sets)])

    a = setdiff(h(3), h(2)) |> only # 7 ∖ 1
    cf = h(2) # 1
    bd = setdiff(h(4), h(3)) # 4 ∖ 7
    eg = setdiff(h(7), h(2), h(3), h(4)) # 8 ∖ (1 ∪ 7 ∪ 4)
    abfg = h(6) # 0 ∩ 6 ∩ 9
    f = intersect(abfg, cf) |> only
    c = setdiff(cf, f) |> only
    abg = setdiff(abfg, f)
    g = intersect(abg, eg) |> only
    e = setdiff(eg, g) |> only
    b = intersect(abg, bd) |> only
    d = setdiff(bd, b) |> only

    return Dict(a => 'a', b => 'b', c => 'c', d => 'd', e => 'e', f => 'f', g => 'g')
end

function unscramble(line)
    signal, output = line
    m = deduce(signal)
    O = [M[Set(m[char] for char in num)] for num in output]
    return parse(Int, string(O...))
end

@info "Sum of output values = $(sum(unscramble, lines))"
