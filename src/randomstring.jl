#=
function randstring()
    return randstring(10)
end
=#
#=
function randstring(possible_chars::Vector{Char},length_string::Int,size_vector::Int)
    return [randstring(possible_chars,length_string) for _ in 1:size_vector]
end

function randstring(possible_chars::Vector{Char},length_string::Int,size_vector::Int)
    return [randstring(vcat('A':'Z','a':'z','0','9'),length_string) for _ in 1:size_vector]
end

function randstring(possible_chars::Vector{Char},length_string::Int,size_rows::Int,size_columns::Int)
    return [randstring(possible_chars,length_string) for _ in 1:size_rows,_ in 1:size_columns]
end

function randstring(length_string::Int,size_rows::Int,size_columns::Int)
    return [randstring(vcat('A':'Z','a':'z','0','9'),length_string) for _ in 1:size_rows,_ in 1:size_columns]
end
=#

# Default case: randstring() -> calls randstring(10)
function randstring()
    return Random.randstring(10)
end


# Generate a vector of random strings
function randstring(possible_chars::Vector{Char}, length_string::Int, size_vector::Int)
    return [Random.randstring(possible_chars, length_string) for _ in 1:size_vector]
end

# Generate a vector of random strings with default characters
function randstring(length_string::Int, size_vector::Int)
    return [Random.randstring(vcat('A':'Z', 'a':'z', '0':'9'), length_string) for _ in 1:size_vector]
end

# Generate a matrix of random strings
function randstring(possible_chars::Vector{Char}, length_string::Int, size_rows::Int, size_columns::Int)
    return [Random.randstring(possible_chars, length_string) for _ in 1:size_rows, _ in 1:size_columns]
end

# Generate a matrix of random strings with default characters
function randstring(length_string::Int, size_rows::Int, size_columns::Int)
    return [Random.randstring(vcat('A':'Z', 'a':'z', '0':'9'), length_string) for _ in 1:size_rows, _ in 1:size_columns]
end
