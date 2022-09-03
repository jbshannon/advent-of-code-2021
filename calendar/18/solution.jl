L = readlines("input.txt")

# Convert starfish number string to a vector
function str2vec(str)
    io = IOBuffer(str)
    depth = 0
    out = Vector{Int8}[]
    while !eof(io)
        c = read(io, Char) # read the next character from the string
        depth = c == '[' ? depth+1 : c == ']' ? depth-1 : depth # update depth
        '0' <= c <= '9' && push!(out, [Int(c)-Int('0'), depth])
    end
    return out
end

# Convert vector back to a starfish number string
function vec2str(v)
    out = "["
    pos = [true]

    for i in eachindex(v)
        # Drop down to the current depth
        while v[i][2] > length(pos)
            out *= "["
            push!(pos, true)
        end

        # Add current value
        out *= string(v[i][1])

        # Move back to top of branch
        while length(pos) > 0 && !last(pos) # while current position is on the right
            out *= "]"
            pop!(pos) # move back one level
        end

        # Move from left to right
        if length(pos) > 0 && last(pos)
            out *= ","
            pos[end] = false
        end
    end
    return out
end

function explode!(x)
    i = findfirst(v -> v[2] > 4, x)
    if i === nothing
        return false
    else
        i > 1 && (x[i-1][1] += x[i][1]) # update left
        i+1 < length(x) && (x[i+2][1] += x[i+1][1]) # update right
        x[i][1] = 0 # replace pair with zero
        x[i][2] -= 1 # reduce depth at the deleted pair
        deleteat!(x, i+1) # remove second element of pair from the number
        return true
    end
end

function split!(x)
    i = findfirst(v -> v[1] > 9, x)
    if i === nothing
        return false
    else
        val, depth = x[i]
        d, r = divrem(val, 2)
        x[i] .= [d, depth+1]
        insert!(x, i+1, [d+r, depth+1])
        return true
    end
end

function addreduce(a, b)
    x = vcat(a, b)
    for i in eachindex(x); x[i][2] += 1; end # update depth
    while true
        explode!(x) && continue
        split!(x) && continue
        break
    end
    return x
end

magnitude(a::Int) = a
magnitude(a, b) = 3*magnitude(a) + 2*magnitude(b)
magnitude(v) = (while length(v) > 1; v = magnitude(v[1], v[2]); end; return v)
magnitude(s::AbstractString) = s |> Meta.parse |> eval |> magnitude
addmag(V) = mapfoldl(str2vec, addreduce, V) |> vec2str |> magnitude

@info "Part 1: $(addmag(L))"

maxmag = 0
for i in eachindex(L), j in eachindex(L)
    i != j && (maxmag = max(maxmag, addmag(L[[i, j]])))
end
@info "Part 2: $maxmag"
