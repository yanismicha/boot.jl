function acc(yhat::AbstractVector, y::AbstractVector)::Float64
    return mean(mode.(yhat) .== y)
end
