module GLEPlot

# stdlib
using DelimitedFiles

# external
using Colors
using Parameters

const ∅   = nothing
const AV  = AbstractVector
const AVM = AbstractVecOrMat
const AM  = AbstractMatrix
const AVR = AV{<:Real}

const T2F = NTuple{2, Float64}
const T3F = NTuple{3, Float64}
# const T2R = NTuple{2, Real}
# const T3R = NTuple{3, Real}

const Option{T} = Union{Nothing, T}

# ----------------------------
# GPlot
# - /utils ✅
#
# types
# - style  ✅
# - drawing ✅
# - drawing2 ✅
# - drawing3d ✅
# - ax_elems ✅
# - legend ✅
# - object ✅
# - ax ✅
# - figure ✅
#
# ----------------------------

include("utils.jl")
include("exceptions.jl")
include("backend.jl")

include("types/style.jl")
include("types/drawing_2d.jl")
include("types/drawing_3d.jl")
include("types/ax_objects.jl")
include("types/object_2d.jl")
include("types/object_3d.jl")
include("types/ax.jl")
include("types/figure.jl")

include("show/axes+figure.jl")

end
