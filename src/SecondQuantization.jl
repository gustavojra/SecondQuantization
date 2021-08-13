module SecondQuantization

export @holes, @particles

abstract type AbstractIndex end

struct ParticleIndex <: AbstractIndex
    symbol::Char
end

struct HoleIndex <: AbstractIndex
    symbol::Char
end

function Base.:(==)(p::T, q::T) where T <: AbstractIndex
    return p.symbol == q.symbol
end

macro holes(x...)
    out = quote end
    symbols = repr.(x)
    for i = eachindex(x)
        s = symbols[i][2]
        push!(out.args, :($(x[i]) = SecondQuantization.HoleIndex($s)))
    end
    return out |> esc
end

macro particles(x...)
    out = quote end
    symbols = repr.(x)
    for i = eachindex(x)
        s = symbols[i][2]
        push!(out.args, :($(x[i]) = SecondQuantization.HoleIndex($s)))
    end
    return out |> esc
end

abstract type AbstractSQOperator end

struct CreationOperator{T<:AbstractIndex} <: AbstractSQOperator
    index::T
end

struct AnihilationOperator{T<:AbstractIndex} <: AbstractSQOperator
    index::T
end

macro creation(x...)
    out = quote end
    symbols = repr.(x)
    for i = eachindex(x)
        s = symbols[i][2]
        push!(out.args, :($(x[i]) = SecondQuantization.CreationOperator($s)))
    end
    return out |> esc
end

struct KroneckerDelta{T1<:AbstractIndex,T2<:AbstractIndex}
    p::T1
    q::T2
end

function anticomutator(p::T, q::T) where T <: AbstractSQOperator
    return 0
end

function anticomutator(p::T1, q::T2) where {T1 <: AbstractSQOperator, T2 <: AbstractSQOperator}
    return KroneckerDelta(p.index,q.index)
end
    
end # module
