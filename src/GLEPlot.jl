module GLEPlot

# Base
import Base: /, |>, take!, isempty

# stdlib
using DelimitedFiles

# external
using Colors
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
    "ALL_FIGS"      => nothing,
    "CUR_FIG"       => nothing,
    "CUR_AXES"      => nothing,
    "CLEAN_TMP"     => true,
    "GLE_PATH"      => `gle`
)

function palette(cntr::Int)::Color
    ncols = length(GP_ENV["PALETTE"])
    idx   = mod(cntr, ncols)
    idx   = ifelse(idx == 0, ncols, idx)
    return GP_ENV["PALETTE"][idx]
end

# see subroutines/
const GLE_DRAW_SUB = LittleDict{String, String}()


include("utils.jl")
include("exceptions.jl")
include("gle_script.jl")
include("strings.jl")
include("defaults.jl")

include("types/style.jl")
include("types/drawing_2d.jl")
include("types/drawing_3d.jl")
include("types/ax_object.jl")
include("types/object_2d.jl")
include("types/object_3d.jl")
include("types/ax.jl")
include("types/figure.jl")
include("types/utils.jl")

include("set/prop_dicts.jl")
include("set/style.jl")
include("set/drawing.jl")
include("set/object.jl")
include("set/ax_object.jl")
include("set/legend.jl")
include("set/ax.jl")
include("set/figure.jl")
include("set/properties.jl")

include("apply/utils.jl")
include("apply/style.jl")
include("apply/drawing_2d.jl")
include("apply/drawing_3d.jl")
include("apply/object_2d.jl")
include("apply/ax_object.jl")
include("apply/legend.jl")
include("apply/ax.jl")
include("apply/figure.jl")

include("subroutines/boxplot.jl")
include("subroutines/heatmap.jl")
include("subroutines/marker.jl")
include("subroutines/palette.jl")
include("subroutines/plot3.jl")

include("calls/drawing_2d.jl")
include("calls/drawing_3d.jl")
include("calls/object_2d.jl")
include("calls/ax.jl")
include("calls/ax_object.jl")
include("calls/legend.jl")
include("calls/figure.jl")
include("calls/layout.jl")

include("render/show_text.jl")
include("render/show_image.jl")
include("render/savefig.jl")

end
