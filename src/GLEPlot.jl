module GLEPlot

# Base
import Base: /, |>, take!, isempty

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
const T2R = NTuple{2, Real}
const T3R = NTuple{3, Real}

const PT_TO_CM   = 0.0352778         # 1pt in cm
const Option{T}  = Union{Nothing, T}
const CanMiss{T} = Union{Missing, T}
const Listable   = Union{Tuple, NTuple, AV}


const PALETTE_1 = [ # imitated from tableau 10 - 2
    RGB(0.33, 0.47, 0.64),
    RGB(0.90, 0.57, 0.26),
    RGB(0.82, 0.37, 0.36),
    RGB(0.51, 0.70, 0.69),
    RGB(0.42, 0.62, 0.35),
    RGB(0.91, 0.79, 0.37),
    RGB(0.66, 0.49, 0.62),
    RGB(0.95, 0.63, 0.66),
    RGB(0.59, 0.46, 0.38),
    RGB(0.72, 0.69, 0.67)
]

const GP_ENV = LittleDict{String, Any}(
    "TMP_PATH"     => mktempdir(),   # where intermediate files are stored
    "PALETTE"      => PALETTE_1,
    "CONT_PREVIEW" => true,
    "ALLFIGS"      => nothing,
    "CURFIG"       => nothing,
    "CURAXES"      => nothing
)

function palette(cntr::Int)::Color
    ncols = length(GP_ENV["PALETTE"])
    idx   = mod(cntr, ncols)
    idx   = ifelse(idx == 0, ncols, idx)
    return GP_ENV["PALETTE"][idx]
end

# see gle_sub/
const GLE_DRAW_SUB = LittleDict{String, String}()

# ----------------------------
# GPlot
# - /utils ✅
#
# types ✅
# set_prop  ✅
#
#
# ----------------------------

include("utils.jl")
include("exceptions.jl")
include("gle_script.jl")

include("types/style.jl")
include("types/drawing_2d.jl")
include("types/drawing_3d.jl")
include("types/ax_object.jl")
include("types/object_2d.jl")
include("types/object_3d.jl")
include("types/ax.jl")
include("types/figure.jl")
include("types/utils.jl")

include("set_prop/prop_dicts.jl")
include("set_prop/style.jl")
include("set_prop/drawing.jl")
include("set_prop/object.jl")
include("set_prop/ax_object.jl")
include("set_prop/legend.jl")
include("set_prop/ax.jl")
include("set_prop/figure.jl")
include("set_prop/properties.jl")

include("gle_apply/style.jl")
include("gle_apply/drawing_2d.jl")
include("gle_apply/drawing_3d.jl")
include("gle_apply/object_2d.jl")
include("gle_apply/ax_object.jl")
include("gle_apply/legend.jl")
include("gle_apply/ax.jl")
include("gle_apply/figure.jl")

include("gle_sub/boxplot.jl")
include("gle_sub/heatmap.jl")
include("gle_sub/marker.jl")
include("gle_sub/palette.jl")
include("gle_sub/plot3.jl")

include("calls/drawing_2d.jl")
include("calls/drawing_3d.jl")
include("calls/object_2d.jl")
include("calls/ax.jl")
include("calls/ax_object.jl")
include("calls/legend.jl")
include("calls/figure.jl")
include("calls/layout.jl")

include("show/axes+figure.jl")

end
