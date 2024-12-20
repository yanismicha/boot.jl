# renvoie un vecteur de  paramètre statistic bootstrapé de taille B (nombre de boostrap)
"""
    bootstrap(data::AbstractVector, statistic::Function, B::Int=1000)

Performes a bootstraped statistical test of the provided `statistic` on the provided `data` `B` times.

# Args:
    - data: The vector of data to be used in the bootstrap.
    - ststistic: A function that takes a vector as first argument and returns a statistic.
    - B: The number of bootstraps to be performed.

# Returns:
    - A vector of length `B` containing the `statistic` for each bootstrap iteration.
"""
function bootstrap(data::AbstractVector, statistic::Function, B::Int=1000)
    n = length(data)
    boot_stats = Vector{Any}(undef, B)
    
    for b in 1:B
        boot_stats[b] = statistic(data[rand(1:n, n)])
    end
    
    return boot_stats
end

# renvoie une matrice de B boostrap de notre data
"""
    bootstrap(data::AbstractVector,B::Int = 100)

Performes `B` bootstraps on the provided data and returns a matrix containing the bootstraped vectors as columns.

# Args:
    - data: The vector of data to be used in the bootstrap.
    - B: The number of bootstraps to be performed.

# Returns:
    - A matrix of `B` bootstraped columns.
"""
function bootstrap(data::AbstractVector,B::Int = 100)
    n = length(data)
    boot_stats = Matrix(undef,B,B)
    for b in 1:B
        boot_stats[:,b] = data[rand(1:n, n)]
    end
    return boot_stats
end

"""
    bootstrap(data::DataFrame,model::DecisionTreeClassifier,score::Function;target::Symbol = :target,B::Int =100)

Performes `B` bootstraps of a DecisionTreeClassifier using the provided data and returns a vector of scores.

# Args:
    - data: The vector of data to be used in the bootstrap.
    - model: A DecisionTreeClassifier from the MLJ package.
    - score: The score function used to eveluate the model.
    - target: Symbol corresponding to the variable to be explained
    - B: The number of bootstraps to be performed.

# Returns:
    - Vector of length `B` containing the scores for each bootstrap iteration. 
"""
function bootstrap(data::DataFrame,model::DecisionTreeClassifier,score::Function;target::Symbol = :target,B::Int =100)
    y, X = unpack(data, ==(target))
    n = length(y)
    boot_score = Vector(undef, B)
    mach_orig = machine(model, X, y)
    for b in 1:B
        mach = deepcopy(mach_orig)
        idx = rand(1:n,n)
        out_of_bag = setdiff(1:n, idx)
        fit!(mach, rows= idx,verbosity = 0);
        yhat = predict(mach, X[out_of_bag,:]);
        boot_score[b] = score(yhat,y[out_of_bag])
    end
    return boot_score
end

"""
    bootstrap(data::DataFrame,machine::Machine,score::Function;target::Symbol = :target,B::Int =100)

Performes `B` bootstraps using a machine from the MLJ package using the provided data and returns a vector of scores.

# Args:
    - data: The vector of data to be used in the bootstrap.
    - machine: non-driven MLJ machine containing the driven model
    - score: The score function used to eveluate the model.
    - target: Symbol corresponding to the variable to be explained
    - B: The number of bootstraps to be performed.

# Returns:
    - Vector of length `B` containing the scores for each bootstrap iteration. 
"""
function bootstrap(data::DataFrame,machine::Machine,score::Function;target::Symbol = :target,B::Int =100)
    y, X = unpack(data, ==(:target))
    n = length(y)
    boot_score = Vector(undef, B)
    for b in 1:B
        idx = rand(1:n,n)
        out_of_bag = setdiff(1:n, idx)
        mach = deepcopy(machine)
        fit!(mach, rows= idx,verbosity = 0);
        yhat = predict(mach, X[out_of_bag,:]);
        boot_score[b] = score(yhat,y[out_of_bag])
    end
    return boot_score
end


"""
    bootstrap(data::AbstractMatrix, statistic::Function, B::Int=100 ; kwargs...)

Performes `B` bootstraps using a machine from the MLJ package using the provided data and returns a vector of scores.

# Args:
    - data: The vector of data to be used in the bootstrap.
    - ststistic: A function that takes a vector as first argument and returns a statistic.
    - B: The number of bootstraps to be performed.
    - kwargs: Extra arguments to be passed to the to the statistic function.

# Returns:
    - Vector of length `B` containing the scores for each bootstrap iteration. 
"""
function bootstrap(data::AbstractMatrix, statistic::Function, B::Int=100 ; kwargs...)
    out = Array{Any, 1}(undef,B)
    nb_rows = size(data)[1]
    Threads.@threads for idx in 1:B
        boot_matrix = data[rand(1:nb_rows, nb_rows),:]
        out[idx] = statistic(boot_matrix,kwargs...)
    end
    return out
end