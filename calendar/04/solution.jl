# Read input
readarray(x) = "[$x]" |> Meta.parse |> eval
firstline, rest = Base.Iterators.peel(readlines("input.txt"))
nums = readarray(firstline)
boards = map(readarray ∘ x -> join(x, '\n'), Base.Iterators.partition(rest, 6))

# Bingo functions
bingo_rows = vcat(
    [[CartesianIndex(i, j) for i in 1:5] for j in 1:5], # column indices
    [[CartesianIndex(i, j) for j in 1:5] for i in 1:5], # row indices
    [[CartesianIndex(i, i) for i in 1:5]], # diagonal
    [[CartesianIndex(6-i, i) for i in 1:5]], # other diagonal
)
mark_board(board, i) = reduce(.|, nums[j] .∈ board for j in 1:i)
check_win(marks) = map(all ∘ x -> marks[x], bingo_rows) |> any
win_time(board) = map(check_win ∘ i -> mark_board(board, i), eachindex(nums)) |> findfirst
score_board(board) = (i = win_time(board); nums[i] * sum(board[.!mark_board(board, i)]))
win_times = map(win_time, boards)

# Part 1
first_time = findmin(win_times)[2]
first_winner = boards[first_time]
@info "Score of first winning board = $(score_board(first_winner))" first_time

# Part 2
last_time = findmax(win_times)[2]
last_winner = boards[last_time]
@info "Score of last winning board = $(score_board(last_winner))" last_time
