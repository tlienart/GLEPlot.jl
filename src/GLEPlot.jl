module GLEPlot

# stdlib
using DelimitedFiles

# external
using Colors
using Parameters
using OrderedCollections: LittleDict


const ∅   = nothing
const AV  = AbstractVector
const AVM = AbstractVecOrMat
const AM  = AbstractMatrix
const AVR = AV{<:Real}
const F64 = Float64

const T2F = NTuple{2, F64}
const T3F = NTuple{3, F64}
# const T2R = NTuple{2, Real}
# const T3R = NTuple{3, Real}

const PT_TO_CM   = 0.0352778         # 1pt in cm
const Option{T}  = Union{Nothing, T}
const CanMiss{T} = Union{Missing, T}
const Listable   = Union{Tuple, NTuple, AV}

# ----------------------------
# GPlot
# - /utils ✅
#
# types ✅
#
# set_prop
# - dictsgle, dictshared, style, drawing, object ✅
# - axelem
# - legend
# - ax
# - figure
# - properties
#
# ----------------------------

include("utils.jl")
include("exceptions.jl")
include("backend.jl")

include("types/style.jl")
include("types/drawing_2d.jl")
include("types/drawing_3d.jl")
include("types/ax_object.jl")
include("types/object_2d.jl")
include("types/object_3d.jl")
include("types/ax.jl")
include("types/figure.jl")

include("set_prop/prop_dicts.jl")
include("set_prop/style.jl")
include("set_prop/drawing.jl")
include("set_prop/object.jl")
include("set_prop/ax_object.jl")
include("set_prop/legend.jl")
include("set_prop/ax.jl")
include("set_prop/figure.jl")
include("set_prop/properties.jl")

include("show/axes+figure.jl")

end
