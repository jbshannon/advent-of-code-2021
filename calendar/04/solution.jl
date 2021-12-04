# Read input
readarray(x) = "[$x]" |> Meta.parse |> eval
firstline, rest = Base.Iterators.peel(readlines("input.txt"))
nums = readarray(firstline)
boards = map(readarray ∘ x -> join(x, '\n'), Base.Iterators.partition(rest, 6))

# Bingo functions
bingo_rows = vcat(
    [[CartesianIndex(i, j) for i in 1:5] for j in 1:5], # column indices
    [[CartesianIndex(i, j) for j in 1:5] for i in 1:5], # row indices
)
mark_board(board, i) = reduce(.|, nums[j] .∈ board for j in 1:i)
check_win(marks) = map(all ∘ x -> marks[x], bingo_rows) |> any
win_time(board) = map(check_win ∘ i -> mark_board(board, i), eachindex(nums)) |> findfirst
score_board(board) = (i = win_time(board); nums[i] * sum(board[.!mark_board(board, i)]))
win_times = map(win_time, boards)

# Part 1
first_time, i = findmin(win_times)
@info "Score of first winning board = $(score_board(boards[i]))" first_time

# Part 2
last_time, i = findmax(win_times)
@info "Score of last winning board = $(score_board(boards[i]))" last_time
