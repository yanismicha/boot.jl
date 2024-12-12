using boot
using DataFrames
using MLJ

##########################################################################################
####################################Test de mes fonctions ################################
##########################################################################################
function accuracy(yhat, y)
    return mean(mode.(yhat) .== y)
end
function logloss2(yhat,y)
    return StatisticalMeasures.log_loss(yhat,y)
end

function test_boot_MLJ(data::DataFrame;target::Symbol= :target,score::Function = acc)
    
    y, X = unpack(data, ==(target));
    Tree = @load DecisionTreeClassifier pkg=DecisionTree
    tree = Tree(max_depth = 3)
    mach = machine(tree, X, y)
    acc = mean(bootstrap(data,mach,score))
    acc2 = mean(bootstrap(data,tree,score))
    return acc,acc2
end

iris = load_iris() |> DataFrame
tmp,tmp2 = test_boot_MLJ(iris,score = logloss2)
