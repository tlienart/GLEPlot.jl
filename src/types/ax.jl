#
# AXIS
#

mutable struct Axis
    prefix::String # x, y, x2, y2, z
    #
    ticks    ::Ticks          # ticks of the axis
    textstyle::TextStyle      # parent textstyle of axis
    title    ::Option{Title}  # title of the axis
    base     ::Option{F64}    # scale font and ticks
    lwidth   ::Option{F64}    # width of the axis spine
    min      ::Option{F64}    # minimum span of the axis
    max      ::Option{F64}    # maximum span of the axis
    off      ::Bool           # if true, axis is not shown
    log      ::Bool           # log scale
end
Axis(p) = default(Axis, p)


#
# AXES (set of 2 or more axis)
#

abstract type Axes end


mutable struct Axes2D <: Axes
    parent  ::String # id of the parent figure
    xaxis   ::Axis
    x2axis  ::Axis
    yaxis   ::Axis
    y2axis  ::Axis
    drawings::Vector{Drawing2D}
    objects ::Vector{Object2D}
    #
    title ::Option{Title}
    size  ::Option{T2F}     # (width cm, height cm)
    legend::Option{Legend}
    origin::Option{T2F}     # related to layout
    math  ::Bool            # axis crossing (0, 0)
    off   ::Bool
    scale ::String
end
Axes2D(p=""; parent=p) = default(Axes2D,
    parent, Axis("x"), Axis("x2"), Axis("y"), Axis("y2"),
    Drawing2D[], Object2D[]
)


mutable struct Axes3D <: Axes
end

#
# @with_kw mutable struct Axes3D <: Axes
#     parent::String
#     # --
#     xaxis::Axis = Axis("x"; min=0, max=1) # NOTE color = ticks, not spine if box
#     yaxis::Axis = Axis("y"; min=0, max=1) # if nobox, then spine
#     zaxis::Axis = Axis("z"; min=0, max=1)
#     # ---
#     drawings::Vector{Drawing3D} = Vector{Drawing3D}()
#     objects ::Vector{Object3D}  = Vector{Object3D}()
#     # ---
#     title::Option{Title} = ∅
#     size ::T2F           = (20.,10.) # box size
#     # cube
#     nocube   ::Bool      = false # XXX if true, then xaxis have an expressed linestyle
#     cubedims ::T3F       = (20.,20.,10.) # cube sides x,y,z
#     linestyle::LineStyle = LineStyle() # XXX only lstyle, color, see set
#     origin   ::Option{T2F} = ∅
#     rotate   ::Option{T2F} = ∅
#     off      ::Bool = false # do not show
# end
# Axes3D(p) = default(Axes3D,
#     p, Axis("x")
# )
