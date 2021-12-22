M = mapreduce(line -> parse.(Int, split(line, ""))', vcat, readlines("input.txt"))
CI = CartesianIndex
udlr = [CI(1, 0), CI(-1, 0), CI(0, -1), CI(0, 1)]

function shift(M, n)
    A = similar(M)
    for i in eachindex(M); A[i] = rem(M[i] - 1 + n, 9) + 1; end
    return A
end

A = mapreduce(vcat, 0:4) do j
    mapreduce(hcat, 0:4) do i
        shift(M, i+j)
    end
end

function check_neighbors!(I, A, B)
    for adj in udlr
        N = I + adj
        N in CartesianIndices(A) && (B[N] = min(B[N], B[I] + A[N]))
    end
end

B = fill(100000, size(A))
B[1] = 0
s₀, s₁ = last(B), 0
while s₀ != s₁
    s₀ = s₁
    for I in CartesianIndices(A)
        check_neighbors!(I, A, B)
    end
    s₁ = last(B)
end

@info "Part 1: $(B[100, 100])"
@info "Part 2: $s₁"
