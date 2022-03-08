module GLEPlot

# Base
import Base: /, |>, take!, isempty

# stdlib
import DelimitedFiles: writedlm


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


# see subroutines/
const GLE_DRAW_SUB = Dict{String, String}()


# CORE ==========================================

include("utils.jl")
include("exceptions.jl")
include("gle_script.jl")
include("strings.jl")
include("defaults.jl")

const GP_ENV = Dict{Symbol, Any}(
    :tmp_path           => mktempdir(),
    :palette            => DEFAULTS[:palette],
    :continuous_preview => true,
    :all_figs           => nothing,
    :current_fig        => nothing,
    :current_axes       => nothing,
    :clean_tmp          => true,
)

function palette(cntr::Int)::String
    ncols = length(GP_ENV[:palette])
    idx   = mod(cntr, ncols)
    idx   = ifelse(idx == 0, ncols, idx)
    return GP_ENV[:palette][idx]
end


# TYPES =========================================
# Figure, Axes2D, Scatter2D etc

include("types/style.jl")
include("types/drawing_2d.jl")
include("types/drawing_3d.jl")
include("types/ax_object.jl")
include("types/object_2d.jl")
include("types/object_3d.jl")
include("types/ax.jl")
include("types/figure.jl")
include("types/utils.jl")

# PROPERTIES ====================================
# functions to set properties like lwidth etc

include("properties/prop_dicts.jl")
include("properties/style.jl")
include("properties/drawing.jl")
include("properties/object.jl")
include("properties/ax_object.jl")
include("properties/legend.jl")
include("properties/ax.jl")
include("properties/figure.jl")
include("properties/properties.jl")

# APPLY =========================================
# write style to a gle script

include("apply/utils.jl")
include("apply/style.jl")
include("apply/drawing_2d.jl")
include("apply/drawing_3d.jl")
include("apply/object_2d.jl")
include("apply/ax_object.jl")
include("apply/legend.jl")
include("apply/ax.jl")
include("apply/figure.jl")

# SUBROUTINES ===================================
# gle routines e.g. for color map or markers

include("subroutines/boxplot.jl")
include("subroutines/heatmap.jl")
include("subroutines/marker.jl")
include("subroutines/palette.jl")
include("subroutines/plot3.jl")

# CALLS =========================================
# plot, hist etc

include("calls/drawing_2d.jl")
include("calls/drawing_3d.jl")
include("calls/object_2d.jl")
include("calls/ax.jl")
include("calls/ax_object.jl")
include("calls/legend.jl")
include("calls/figure.jl")
include("calls/layout.jl")

# RENDER ========================================
# show methods, savefig

include("render/show_text.jl")
include("render/show_image.jl")
include("render/savefig.jl")

end
