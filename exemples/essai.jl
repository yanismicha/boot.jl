using boot
using Statistics
using DataFrames
#using StatisticalMeasures
using MLJ
using Random
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
