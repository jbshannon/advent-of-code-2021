lines = readlines("input.txt")

function syntax_check(lines)
    B = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>') # brackets
    ES = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137) # error scores
    CS = Dict('(' => 1, '[' => 2, '{' => 3, '<' => 4) # completion scores

    lefts = Char[]
    error_score = 0
    completion_score = 0
    completion_scores = Int[]

    for line in lines
        for c in line
            if c in keys(B)
                push!(lefts, c)
            else
                if c == B[pop!(lefts)]
                    continue
                else
                    error_score += ES[c]
                    empty!(lefts)
                    break
                end
            end
        end
        if !isempty(lefts)
            while !isempty(lefts)
                completion_score = 5*completion_score + CS[pop!(lefts)]
            end
            push!(completion_scores, completion_score)
            completion_score -= completion_score
        end
    end
    return error_score, completion_scores
end

error_score, completion_scores = syntax_check(lines)
@info "Syntax error score = $error_score"
@info "Median completion score = $(sort!(completion_scores)[end÷2+1])"
