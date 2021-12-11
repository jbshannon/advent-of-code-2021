A = mapreduce(line -> parse.(Int8, split(line, "")), hcat, readlines("input.txt"))
const CI = CartesianIndex
const udlr = [CI(1, 0), CI(-1, 0), CI(0, -1), CI(0, 1)]
const AI = CartesianIndices(A)

function find_danger_points(A)
    danger_points = Set{CartesianIndex}()
    for I in AI
        if A[I] < minimum(A[I + x] for x in udlr if I + x in AI)
            push!(danger_points, I)
        end
    end
    return collect(danger_points)
end

function expand!(basin)
    for b in basin
        for a in udlr
          n = b + a
            if n in AI && A[b] <= A[n] < 9
                push!(basin, n)
            end
        end
    end
    return basin
end

function basin_size(I)
    basin = Set([I])
    B₀, B₁ = 0, 1
    while B₁ > B₀
        B₀ = B₁
        expand!(basin)
        B₁ = length(basin)
    end
    return B₁
end

danger_points = find_danger_points(A)
@info "Risk scores = $(sum(i -> A[i]+1, danger_points))"
@info "Product of three largest basins = $(prod(sort!(map(basin_size, danger_points), rev=true)[1:3]))"
