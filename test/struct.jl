##########################################################################################
####################################jeu avec les struct ####################################
##########################################################################################
mutable struct OrderedPairs
    x::Real
    y::Real
    OrderedPairs(x,y) = x > y ? error("out of order") : new(x,y)
end
p =OrderedPairs(2,3)

#########
struct Point{T<:Real}
    x::T
    y::T
end

p = Point(1.2,1.3)
p.y
p_π = Point(π,π)
p_int = Point(1,1.2)
Point(x::Int64, y::Float64) = Point(convert(Float64,x),y);
Point(x::Float64, y::Int64) = Point(x,convert(Float64,y));
p_int = Point(1,1.2)

Point(1//2,1) 
# il faudrait convertir pour tout les types
# au lieu de ca , on utilise promote
Point(x::Real, y::Real) = Point(promote(x,y)...);
Point(1//2,1) 


##########################################################################################
####################################Construction d'une struct ####################################
##########################################################################################
struct BootstrapEvaluator{V <: AbstractVector}
    X::DataFrame                 # Les prédicteurs
    y::V                     # La cible
    machine::Machine               # La machine à entraîner
    score::Function                # La fonction de score
    boot_scores::Vector{Float64}  # Les scores bootstrap

    function BootstrapEvaluator(X::DataFrame, y::AbstractVector, machine::Machine, score::Function; B::Int = 100)
        # Validation des dimensions
        size(X, 1) == length(y) || throw(ArgumentError("Les dimensions de X et y doivent correspondre"))
        
        # Application de bootstrap
        n = length(y)
        boot_scores = Vector{Float64}(undef, B)
        for b in 1:B
            idx = rand(1:n, n)  #indices bootstrap
            out_of_bag = setdiff(1:n, idx)  # Échantillons out-of-bag
            mach = deepcopy(machine) # copie profonde de la machine
            fit!(mach, rows=idx, verbosity=0)  # Entraînement sur l'échantillon bootstrap
            yhat = predict(mach, X[out_of_bag, :])  # Prédictions sur les données out-of-bag
            boot_scores[b] = score(yhat, y[out_of_bag])  # Calcul du score
        end
        
        return new{typeof(y)}(X, y, machine, score, boot_scores)
    end
end

##########################################################################################
####################################Test de ma struct ####################################
##########################################################################################
using DataFrames
using MLJ

# Exemple de données
data = load_iris()
iris = DataFrame(data)
y,X = unpack(iris,==(:target))

# Machine MLJ
Tree = @load DecisionTreeClassifier pkg=DecisionTree
tree = Tree(max_depth = 3)
mach = machine(tree, X, y)

# Fonction de score
function logloss2(yhat,y)
    return StatisticalMeasures.log_loss(yhat,y)
end
# Utilisation de la structure
B = 50  # Nombre de itérations bootstrap
evaluator = BootstrapEvaluator(X, y, mach, logloss2, B=B)



# Résultats
println("Score bootstrap: ", mean(evaluator.boot_scores))








