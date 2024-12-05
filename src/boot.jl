module boot
using Random,MLJ,DataFrames,MLJDecisionTreeInterface
export bonjour,bootstrap,randstring,acc

# Write your package code here.
include("bonjour.jl")
include("bootstrap.jl")
include("randomstring.jl")
include("scores.jl")

end
