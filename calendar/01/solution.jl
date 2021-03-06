# Load data
data = parse.(Int, readlines("input.txt"))

# Part 1
ans1 = sum([data[i] > data[i-1] for i in 2:length(data)])
@info "Number of times depth measurement increases = $ans1"

# Part 2
ans2 = sum([sum(data[i-2:i]) > sum(data[i-3:i-1]) for i in 4:length(data)])
@info "Number of times the sum of a three-measurement window increases = $ans2"
