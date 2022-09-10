const CI = CartesianIndex
const CI1 = CI(1, 1)

function read_input(path)
    alg, imstr = split(read(path, String), "\n\n")
    img = mapreduce(hcat, split(imstr)) do line
        map(==('#'), collect(line))
    end
    return map(==('#'), collect(alg)), img
end

bin2dec(x) = sum([2^(i-1) for i in eachindex(x) if Bool(x[end-(i-1)])])

function expand(A::Matrix{Bool}; autoborder::Bool=true, n::Int=1)
    border = autoborder ? first(A) : false
    B = repeat([border], size(A, 1)+2n, size(A, 2)+2n)
    copyto!(@view(B[1+n:end-n, 1+n:end-n]), A)
    return B
end

function border_indices(A)
    axs = axes(A)
    return Iterators.filter(Iterators.product(axs...)) do inds
        any(inds[i] in extrema(axs[i]) for i in eachindex(axs))
    end
end

function enhance(img::Matrix{Bool}, alg::Vector{Bool})
    A = expand(img) # output image
    B = copy(A) # original image to enhance
    I = CartesianIndices(A)
    for R in first(I)+CI1:last(I)-CI1
        A[R] = alg[1 + bin2dec(B[R-CI1:R+CI1])]
    end
    A[CI.(border_indices(A))] .= alg[1 + bin2dec(repeat([first(A)], 9))] # fill border
    return A
end

# Solution
alg, img = joinpath(@__DIR__, "input.txt") |> read_input
A = expand(img; autoborder=false)
for i in 1:50
    global A
    A = enhance(A, alg)
    i in (2, 50) && println("$i times: $(sum(A)) pixels")
end
