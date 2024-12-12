# renvoie un vecteur de  paramètre statistic bootstrapé de taille B (nombre de boostrap)
function bootstrap(data::AbstractVector, statistic::Function, B::Int=1000)
    n = length(data)
    boot_stats = Vector{Any}(undef, B)
    
    for b in 1:B
        boot_stats[b] = statistic(data[rand(1:n, n)])
    end
    
    return boot_stats
end

# renvoie une matrice de B boostrap de notre data
function bootstrap(data::AbstractVector,B::Int = 100)
    n = length(data)
    boot_stats = Matrix(undef,B,B)
    for b in 1:B
        boot_stats[:,b] = data[rand(1:n, n)]
    end
    return boot_stats
end


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

function bootstrap(data::AbstractMatrix, statistic::Function, B::Int=100)
    out = Array{Any, 1}(undef,B)
    sampling_data = reshape(data, (1, :))
    for idx in 1:B
        boot_matrix = sampling_data[rand(1:length(sampling_data), length(sampling_data))]
        out[idx] = statistic(reshape(boot_matrix, size(data)))
    end
    return out
end