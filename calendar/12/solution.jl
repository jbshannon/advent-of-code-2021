links = map(x -> split(x, '-'), eachline("input.txt"))
caverns = links |> Base.Iterators.flatten |> collect |> sort! |> unique!
const graph = Dict(c => Set{typeof(c)}() for c in caverns)
for c in caverns
    for link in links
        c in link && push!(graph[c], (only∘setdiff)(link, (c, )))
    end
    graph[c] = setdiff(graph[c], ("start",))
end

const smalls = setdiff(filter(islowercase ∘ first, caverns), ("start", "end"))
function count_small(path) # return true if no small cave is visited twice
    for s in smalls
        count(==(s), path) > 1 && return false
    end
    return true
end

function find_paths(path)
    paths = Vector{typeof(path)}()
    for adj ∈ graph[last(path)]
        if adj ∉ path || isuppercase(first(adj)) || count_small(path)
            newpath = copy(path)
            push!(newpath, adj)
            if adj == "end"
                push!(paths, newpath)
            else
                newpaths = find_paths(newpath)
                for np in newpaths; push!(paths, np); end
            end
        end
    end
    return paths
end

paths = find_paths(["start"])
@info "Part 1: $(length(filter(count_small, paths)))"
@info "Part 2: $(length(paths))"
