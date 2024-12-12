using MLJ
using DataFrames
#########################################################################################
####################################Test de MLJ #########################################
#########################################################################################
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
accuracy(yhat,y[test])
evaluate!(mach, resampling=Holdout(fraction_train=0.75),measures=[log_loss, accuracy],verbosity=0)
accuracy(yhat,y[test])


