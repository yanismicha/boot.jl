using boot 
using Statistics
using DataFrames
#using StatisticalMeasures
using MLJ
using Random
#using Base.Threads
################## tests de mes fonctions ################
bonjour("yanis")
data = randn(100);
bootstrap(data)
bootstrap
#methods(bootstrap)
function accuracy(yhat, y)
    return StatisticalMeasures.accuracy(mode.(yhat),y)#mean(mode.(yhat) .== y)
end
function logloss(yhat,y)
    return StatisticalMeasures.log_loss(yhat,y)
end
iris = load_iris()
iris = DataFrame(iris);
Tree = @load DecisionTreeClassifier pkg=DecisionTree
tree = Tree(max_depth = 3)
acc = mean(bootstrap(iris,tree,logloss))




################## tests de MLJ ################

iris = load_iris()
selectrows(iris, 1:3) |> pretty
iris = DataFrame(iris);
y, X = unpack(iris, ==(:target); rng=123);
models(matching(X,y))
Tree = @load DecisionTreeClassifier pkg=DecisionTree
tree = Tree(max_depth = 3)
#evaluate(tree, X, y, resampling=CV(shuffle=true),measures=[log_loss, accuracy],verbosity=0)

mach = machine(tree, X, y)
train, test = partition(eachindex(y), 0.75);
fit!(mach, rows=train);
yhat = predict(mach, X[test,:]);
log_loss(yhat,y[test])
evaluate!(mach, resampling=Holdout(fraction_train=0.75),measures=[log_loss, accuracy],verbosity=0)
accuracy(yhat,y[test])

function bootstrap1(data::AbstractMatrix, statistic::Function, B::Int=100 ; kwargs...)
    out = Array{Any, 1}(undef,B)
    nb_rows = size(data)[1]
    Threads.@threads for idx in 1:B
        boot_matrix = data[rand(1:nb_rows, nb_rows),:]
        out[idx] = statistic(boot_matrix,kwargs...)
    end
    return out
end


mat = [1 2 ; 3 4 ; 5 6]

print(bootstrap1(mat, sum, 10, a=1, b=2))

function f(data, a=4,b=5)
    n_col = size(data)[2]
    out = 0
    println("a = ",a,", b = ", b)
    #println(keys(a))
    println(typeof(a))
    p
    println("a+b=",a[:a]+b[:b])
    #for i in 1:n_col
    #    out += arg(data[:,i])
    #end
    return out
end

size(mat)
out = bootstrap(mat, f, 10 , a=1,b=2)
print(out)
print(mat[1,:])

print(mat[[1,3,3],:])

function m2(; kwargs...)
    println(kwargs)
    println(kwargs[:a])
end

m2(a=1,b=2,c=3)