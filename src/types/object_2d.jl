"""
    Object

Overarching type for objects displayable on `Axes`.
"""
abstract type Object end


"""
    Object2D

Overarching type for objects displayable on `Axes2D`.
"""
abstract type Object2D <: Object end


"""
    Text2D <: Object2D

Place text somewhere relative to current axes.
"""
mutable struct Text2D <: Object2D
    anchor::T2F            # where the text is located (x,y) position, relative to the axes
    text  ::String         # what to write
    #
    position ::String      # position with respect to anchor (by default centered on anchor)
    textstyle::TextStyle
end
Text2D(a, t) = default(Text2D, a, t)


"""
    StraightLine2D <: Object2D

Place either a vertical or horizontal straightline at given anchor (from axis
to axis).
"""
mutable struct StraightLine2D <: Object2D
    anchor::F64
    horiz ::Bool
    #
    linestyle::LineStyle
end
StraightLine2D(a, h) = default(StraightLine2D, a, h)


"""
    Box2D <: Object2D

Place a 2D filled box.
"""
mutable struct Box2D <: Object2D
    anchor::T2F  # where the box is (in graph units)
    size  ::T2F  # width, hei (in graph units)
    #
    position ::String             # position of the anchor with respect to the box
    nobox    ::Bool               # show an edge or not
    linestyle::LineStyle          # style of the box edge
    fillstyle::Option{FillStyle}  # if none --> transparent box
    # text::String
    # textStyle::TextStyle = TextStyle()
end
Box2D(a, s) = default(Box2D, a, s)


"""
    Colorbar <: Object2D

Add a colorbar.
"""
mutable struct Colorbar <: Object2D
    zmin::F64
    zmax::F64
    cmap::Vector{Color}
    #
    ticks   ::Ticks        # constructed
    size    ::Option{T2F}  # (width, height)
    pixels  ::Int          # resolution for the color bar
    nobox   ::Bool         #
    position::String       # left, right, bottom, top
    offset  ::T2F          # h, v distance from closest corner of the graph
end
Colorbar(zmin, zmax, cmap) = default(Colorbar,
    zmin, zmax, cmap, Ticks(collect(range(zmin, stop=zmax, length=5))[2:end-1])
)
