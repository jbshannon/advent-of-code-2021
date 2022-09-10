function read_input(path)
    ms = eachmatch(r"position: (\d{1,2})$"m, read(path, String))
    return map(m -> parse(Int, m[1]), ms)
end

roll!(dice) = mod(dice, 100) + 1
move(position, rolls) = mod1(position+rolls, 10)

function turn!(positions, scores, dice, i)
    rolls = 0
    for _ in 1:3
        rolls += dice
        dice = roll!(dice)
    end
    positions[i] = move(positions[i], rolls)
    scores[i] += positions[i]
    return positions, scores, dice
end

function deterministic(positions)
    scores = [0, 0]
    dice = 1
    counter = 0
    player = 2

    while maximum(scores) < 1000
        counter += 3
        player = rem(player, 2) + 1
        positions, scores, dice = turn!(positions, scores, dice, player)
    end
    return minimum(scores)*counter
end

function trace(start_pos)
    counts = zeros(Int, 10, 21)
    counts′ = zeros(Int, 10, 21)
    counts[start_pos, 1] = 1
    min_score = max_score = 1 # index of starting score
    outcomes = Tuple{Int, Int}[(1, 0)]
    while true
        not_reached = reached = 0 # number of outcomes where player doesn't win/wins
        min_score′, max_score′ = 21, 1
        for score in min_score:max_score, pos in 1:10
            count = counts[pos, score]
            count == 0 && continue # skip states that have been done
            counts[pos, score] = 0 # mark state as done

            for rolls in 3:9 # loop over possible sums of three individual rolls
                pos′ = mod1(pos + rolls, 10)
                score′ = score + pos′
                count′ = count * copies[rolls] # multiply by number of possible outcomes
                if score′ > 21 # rolls wins
                    reached += count′ # number of outcomes where goal is reached
                else
                    not_reached += count′ # number of outcomes where goal is not reached
                    counts′[pos′, score′] += count′ # add count of outcomes to the state counters
                    min_score′ = min(min_score′, score′)
                    max_score′ = max(max_score′, score′)
                end
            end
        end

        # Swap items
        counts, counts′ = counts′, counts
        min_score, max_score = min_score′, max_score′

        push!(outcomes, (not_reached, reached))
        not_reached == 0 && break # losing is impossible
    end

    push!(outcomes, (0, 0)) # add empty tuple to end to avoid index error
    return outcomes
end

function dirac(positions)
    start₁, start₂ = positions
    outcomes₁ = trace(start₁)
    outcomes₂ = trace(start₂)
    win₁ = win₂ = 0
    for turn = 2:min(length(outcomes₁), length(outcomes₂))
        not_reached₁, reached₁ = outcomes₁[turn]
        not_reached₂ = outcomes₂[turn - 1][1]
        reached₂ = outcomes₂[turn][2]
        win₁ += reached₁ * not_reached₂
        win₂ += not_reached₁ * reached₂
    end
    return max(win₁, win₂)
end

positions = joinpath(@__DIR__, "input.txt") |> read_input
answer₁ = deterministic(positions)
answer₂ = dirac(positions)
