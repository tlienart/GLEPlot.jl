abstract type AxisObject end


mutable struct Title <: AxisObject
    text::String
    #
    textstyle::TextStyle
    dist     ::Option{F64}  # distance labels - title
end
Title(t) = default(Title, t)


mutable struct TicksLabels <: AxisObject
    names::Vector{String}
    #
    textstyle::TextStyle
    angle    ::Option{F64}     # rotation of labels
    format   ::Option{String}  # format of the ticks labels
    shift    ::Option{F64}     # move labels to left/right
    dist     ::Option{F64}     # ⟂ distance to spine
    off      ::Bool            # whether to suppress the labels
end
TicksLabels(n) = default(TicksLabels, n)


mutable struct Ticks <: AxisObject
    places::Vector{F64}     # where the ticks are
    labels::TicksLabels     # their label
    #
    linestyle::LineStyle    # how the ticks marks look
    length   ::Option{F64}  # how long the ticks spine (negative for outside)
    symticks ::Bool         # draws ticks on 2 sides of
    off      ::Bool         # whether to suppress them
    grid     ::Bool         # ticks increased to mirrorred axis
end
Ticks(p=Float64[], l=fl2str.(p)) = default(Ticks, p, TicksLabels(l))



abstract type AxesObject end


mutable struct Legend <: AxesObject
    handles::Vector{DrawingHandle}
    labels::Vector{Union{String,Vector{String}}}
    #
    position::Option{String}
    textstyle::TextStyle
    offset  ::T2F
    bgcolor ::Option{String}
    margins ::Option{T2F}
    nobox   ::Bool
    off     ::Bool
end
Legend(h, l) = default(Legend, h, l)
