function read_input(path)
    scanners = map(split(read(path, String), "\n\n")) do scanner
        map(split(scanner, '\n')[2:end]) do coordinates
            parse.(Int, split(coordinates, ',')) # |> Tuple
        end
    end
    return scanners
end
scanners = read_input(joinpath(@__DIR__, "input.txt"))

# Get matrices for all 24 orientations
Y = [0 1 0; -1 0 0; 0 0 1] # x to y
Z = [0 0 1; 0 1 0; -1 0 0] # x to z
R = [1 0 0; 0 0 1; 0 -1 0] # 90° clockwise
const D24 = reduce(vcat, [[A*R^n for n in 0:3] for A in [Y, Y^2, Y^3, Y^4, Z, Z^3]])

# Get relative distance signatures of beacons picked up from each scanner
compute_signature(s) = [sort(abs.(s[i] - s[j])) for i in eachindex(s) for j in 1:i-1]
sig_inds = [(i, j) for i in eachindex(scanners[1]) for j in 1:i-1]
sigs = compute_signature.(scanners)

# Functions
function find_distance(x, sig, scanner)
    a, b = sig_inds[findfirst(==(x), sig)]
    return scanner[a] - scanner[b]
end

function find_orientations(i, j, x, scanners, sigs)
    Δ = (k -> find_distance(x, sigs[k], scanners[k])).((i, j))
    return filter(T -> Δ[1] in (T*Δ[2], -T*Δ[2]), D24)
end

function find_unique_transformation(i, j, X, scanners, sigs)
    iter = Iterators.Stateful(X)
    Ts = find_orientations(i, j, popfirst!(iter), scanners, sigs)
    while length(Ts) > 1 && !isempty(iter)
        intersect!(Ts, find_orientations(i, j, popfirst!(iter), scanners, sigs))
    end
    return only(Ts)
end

function find_scanner_position(i, j, x, T, scanners, sigs)
    ia, ib = sig_inds[findfirst(==(x), sigs[i])]
    ja, jb = sig_inds[findfirst(==(x), sigs[j])]
    si, sj = scanners[[i, j]]
    return si[ia] - T*sj[si[ia] - si[ib] == T*sj[ja] - T*sj[jb] ? ja : jb]
end

function align_scanner!(aligned, scanner_positions, scanners, sigs)
    for i in aligned, j in setdiff(eachindex(scanners), aligned)
        X = intersect(sigs[i], sigs[j])
        if length(X) >= 66
            # Find the transformation
            T = find_unique_transformation(i, j, X, scanners, sigs)
            Δ = find_scanner_position(i, j, first(X), T, scanners, sigs)

            # Move beacons to scanner 0 coordinate system
            for k in eachindex(scanners[j])
                scanners[j][k] .= T*scanners[j][k] + Δ
            end

            push!(aligned, j)
            push!(scanner_positions, Δ)
            return j, Δ
        end
    end
end

function align_scanners!(scanners, sigs)
    aligned, scanner_positions = [1], [[0, 0, 0]]
    while length(aligned) < length(scanners)
        align_scanner!(aligned, scanner_positions, scanners, sigs)
    end
    return aligned, scanner_positions
end

aligned, scanner_positions = align_scanners!(scanners, sigs)
manhattan_dists(s) = [sum(abs.(s[i] - s[j])) for i in eachindex(s) for j in 1:i-1]

answer = (
    reduce(union, scanners) |> length, # Part 1
    manhattan_dists(scanner_positions) |> maximum, # Part 2
)
