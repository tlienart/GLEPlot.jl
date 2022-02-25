#
# Attached to AXIS
#

abstract type AxisObject end

@with_kw mutable struct Title <: AxisObject
    text::String = ""
    # ---
    textstyle::TextStyle = TextStyle()
    # ---
    dist::Option{F64} = ∅  # distance labels - title
end

@with_kw mutable struct TicksLabels <: AxisObject
    names::Vector{String} = String[]
    # ---
    textstyle::TextStyle = TextStyle()
    # ---
    angle ::Option{F64} = ∅ # rotation of labels
    format::Option{String}  = ∅ # format of the ticks labels
    shift ::Option{F64} = ∅ # move labels to left/right
    dist  ::Option{F64} = ∅ # ⟂ distance to spine
    # --- toggle-able
    off   ::Bool = false # whether to suppress the labels
end

@with_kw mutable struct Ticks <: AxisObject
    labels   ::TicksLabels = TicksLabels() # their label
    linestyle::LineStyle   = LineStyle()   # how the ticks marks look
    # ---
    places   ::Vector{F64} = F64[] # where the ticks are
    length   ::Option{F64} = ∅         # how long the ticks spine (negative for outside)
    # --- toggle-able
    symticks ::Bool = false # draws ticks on 2 sides of
    off      ::Bool = false # whether to suppress them
    grid     ::Bool = false # ticks increased to mirrorred axis
end

#
# Attached to AXES
#

abstract type AxesObject end

@with_kw mutable struct Legend <: AxesObject
    handles::Vector{DrawingHandle} = DrawingHandle[]
    labels::Vector{Union{String,Vector{String}}} = String[]
    # ---
    position::Option{String}   = ∅
    textstyle::TextStyle       = TextStyle()
    offset  ::T2F              = (0.0, 0.0)
    bgcolor ::Option{Colorant} = ∅
    margins ::Option{T2F}      = ∅
    nobox   ::Bool             = false
    off     ::Bool             = false
    # TODO: can this take a textstyle?
    # entries *not* contained in the struct, they're generated elsewhere
    # nobox      ::Option{Bool}                = ∅
end
