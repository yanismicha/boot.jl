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
"""
    randstring()

Returns a random string of 10 characters.
Is the default case of the randstring function. Calls randstring(10) from the Random package.

# Returns:
    -  Random string of 10 characters.
"""
function randstring()
    return Random.randstring(10)
end


# Generate a vector of random strings
"""
    randstring(possible_chars::Vector{Char}, length_string::Int, size_vector::Int)

Returns a random string vector among possible characters.

# Args:
    - possible_chars: vector of characters that can be generated
    - length_string: size of each string.
    - size_vector: vector size.

# Returns:
    - Vector of random characters.
"""
function randstring(possible_chars::Vector{Char}, length_string::Int, size_vector::Int)
    return [Random.randstring(possible_chars, length_string) for _ in 1:size_vector]
end


"""
    randstring(length_string::Int, size_vector::Int)

Returns a random string vector.

# Args:
    - length_string: size of each string.
    - size_vector: vector size.

# Returns:
    - Vector of random characters.
"""
function randstring(length_string::Int, size_vector::Int)
    return [Random.randstring(vcat('A':'Z', 'a':'z', '0':'9'), length_string) for _ in 1:size_vector]
end


"""
    randstring(possible_chars::Vector{Char}, length_string::Int, size_rows::Int, size_columns::Int)

Returns a random string matrix among possible characters.

# Args:
    - possible_chars: vector of characters that can be generated
    - length_string: size of each string.
    - size_rows: number of matrix rows.
    - size_columns: number of matrix columns

# Returns:
    - Vector of random characters.
"""
function randstring(possible_chars::Vector{Char}, length_string::Int, size_rows::Int, size_columns::Int)
    return [Random.randstring(possible_chars, length_string) for _ in 1:size_rows, _ in 1:size_columns]
end


"""
    randstring(length_string::Int, size_rows::Int, size_columns::Int)

Returns a random string matrix.

# Args:
    - length_string: size of each string.
    - size_rows: number of matrix rows.
    - size_columns: number of matrix columns

# Returns:
    - Vector of random characters.
"""
function randstring(length_string::Int, size_rows::Int, size_columns::Int)
    return [Random.randstring(vcat('A':'Z', 'a':'z', '0':'9'), length_string) for _ in 1:size_rows, _ in 1:size_columns]
end
