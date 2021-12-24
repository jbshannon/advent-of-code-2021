function hex2bin(io)
    data = UInt8[]
    b = zeros(UInt8, 4)
    for c in readeach(io, Char)
        digits!(b, parse(Int, c, base=16), base=2)
        for x in reverse(b); push!(data, x); end
    end
    return data
end

const ops = (+, *, min, max, identity, >, <, ==)
binstr(hexstr) = string(hex2bin(IOBuffer(hexstr))...)
readbin(io, n) = parse(Int, string(read(io, n)...), base=2)

function evaluate_packet(io)
    version = readbin(io, 3)
    type = readbin(io, 3)
    if type == 4
        valstr = ""
        while true
            c = read(io, Bool)
            valstr *= string(read(io, 4)...)
            !c && break
        end
        value = parse(Int, valstr, base=2)
        return version, value
    else
        lentype = read(io, Bool)
        values = Int[]
        if !lentype
            L = readbin(io, 15)
            p = position(io)
            while position(io)-p < L
                ver, val = evaluate_packet(io)
                version += ver
                push!(values, val)
            end
        else
            N = readbin(io, 11)
            for _ in 1:N
                ver, val = evaluate_packet(io)
                version += ver
                push!(values, val)
            end
        end
        value = foldl(ops[type+1], values) |> Int
    end
    return version, value
end

function evaluate_hexstr(hexstr)
    io = collect(parse(UInt8, c) for c in binstr(hexstr)) |> IOBuffer
    version, value = evaluate_packet(io)
    return version, value
end

version, value = evaluate_hexstr(read("input.txt", String))
@info "Part 1: $version"
@info "Part 2: $value"
