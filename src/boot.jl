module boot
using Random
using DataFrames,MLJ,MLJDecisionTreeInterface
export bonjour,randstring,bootstrap
# Write your package code here.
include("bonjour.jl")
include("randomstring.jl")
include("bootstrap.jl")
end