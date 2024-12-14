using Boot
using DataFrames
using MLJ
using Test

##########################################################################################
####################################Test de mes fonctions ################################
##########################################################################################

## 1er test: bonjour ##
function test_bonjour(name::String)
    @test bonjour(name) == "coucou $name" && bonjour() == "coucou le monde"
end
test_bonjour("yanis")


## 2eme test: randstring ##
function test_randstring(possible_chars::Vector{Char}, length_string::Int, size_vector::Int)
    # Génération des chaînes aléatoires
    vec = randstring(possible_chars,length_string,size_vector)
 
    @test length(vec) == size_vector

    for s in vec
        for c in s
            @test c ∈ possible_chars
        end
    end
end

test_randstring(vcat('A','N'),10,10)

## 3 eme test: bootstrapp ##
function accuracy(yhat, y)
    return mean(mode.(yhat) .== y)
end
function logloss2(yhat,y)
    return StatisticalMeasures.log_loss(yhat,y)
end

function test_bootstrap(B::Int,constant::Int)
    data = [1, 2, 3, 4, 5]
    data2 = fill(constant,100)
    statistic = std
    boot_values = bootstrap(data,statistic,B)
    @test length(boot_values) == B
    @test all(0.0 <= r <= 2.0 for r in boot_values)
    statistic = mean
    boot_values = bootstrap(data2,statistic,B)
    @test mean(boot_values) == constant
end

test_bootstrap(10)

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
