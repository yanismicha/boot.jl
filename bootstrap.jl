function bootstrap(data::AbstractVector, statistic::Function, B::Int=1000)
    n = length(data)
    boot_stats = Vector{Any}(undef, B)
    
    for b in 1:B
        boot_stats[b] = statistic(data[rand(1:n, n)])
    end
    
    return boot_stats
end

function bootstrap(data::AbstractVector,B::Int = 100)
    n = length(data)
    boot_stats = Matrix(undef,B,B)
    for b in 1:B
        boot_stats[:,b] = data[rand(1:n, n)]
    end
    return boot_stats
end

function bootstrap(data::DataFrame,model::DecisionTreeClassifier,score::Function,B::Int =100)
    y, X = unpack(data, ==(:target))
    n = length(y)
    boot_loss = Vector(undef, B)
    mach_orig = machine(model, X, y)
    for b in 1:B
        mach = deepcopy(mach_orig)
        idx = rand(1:n,n)
        out_of_bag = setdiff(1:n, idx)
        fit!(mach, rows= idx,verbosity = 0);
        yhat = predict(mach, X[out_of_bag,:]);
        boot_loss[b] = score(yhat,y[out_of_bag])
    end
    return boot_loss
end


function bootstrap(data::DataFrame,machine::Machine,score::Function,B::Int =100)
    y, X = unpack(data, ==(:target))
    n = length(y)
    boot_loss = Vector(undef, B)
    for b in 1:B
        idx = rand(1:n,n)
        out_of_bag = setdiff(1:n, idx)
        mach = deepcopy(machine)
        fit!(mach, rows= idx,verbosity = 0);
        yhat = predict(mach, X[out_of_bag,:]);
        boot_loss[b] = score(yhat,y[out_of_bag])
    end
    return boot_loss
end
