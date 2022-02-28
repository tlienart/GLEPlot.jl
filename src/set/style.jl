####
#### COLOR:
####  set_color!, set_colors!, set_fill!, set_fills!, set_alpha!
####

"""
    set_color!(obj, col)
    set_textcolor!(obj, col)

Internal functions to set the color value `col` (after parsing) to the
appropriate field of object `obj`. In some case nothing can be given as `col`
for instance for a background.
"""
set_color!(o::Style, c::Color) =
    (o.color = c;)
set_color!(o::Union{Figure, Legend}, c::Option{Color}) =
    (o.bgcolor = c;)
set_color!(o::Hist2D, c::Color) =
    set_color!(o.barstyle, c)
set_color!(o::Union{Ticks, StraightLine2D, Box2D, Scatter3D}, c::Color) =
    set_color!(o.linestyle, c)
set_color!(o::Colorbar, c::Color) =
    set_color!(o.ticks, c)

set_textcolor!(o::Ticks, c::Color) =
    set_color!(o.labels.textstyle, c)
set_textcolor!(o::Colorbar, c::Color) =
    set_color!(o.ticks, c)
set_textcolor!(o::Union{Figure, Axis, Title}, c::Color) =
    set_color!(o.textstyle, c)


"""
    set_colors!(obj, cols)

Internal function to set the color values `cols`.
If a single value is passed, all fields will be assigned to that value.
"""
function set_colors!(
            vs::Vector,
            c::Vector{<:Color},
            field::Option{Symbol}=nothing
        )::Nothing

    # check dimensions match
    length(c) == length(vs) || throw(
        DimensionMismatch("colors // dimensions don't match")
    )
    # assign
    if isnothing(field)
        for (i, col) ∈ enumerate(c)
            set_color!(vs[i], col)
        end
    else
        for (i, col) ∈ enumerate(c)
            set_color!(getfield(vs[i], field), col)
        end
    end
    return
end
set_colors!(vs::Vector, c::Color, f) = set_colors!(vs, fill(c, length(vs)), f)


"""
    set_fill!(obj, col)

Internal functions to set the fill color value `v` (after parsing) to the
appropriate field of object `obj`.
"""
set_fill!(o::Union{FillStyle,BarStyle}, c::Color) =
    (o.fill = c;)
set_fill!(o::Fill2D, c::Color) =
    set_fill!(o.fillstyle, c)
set_fill!(o::Hist2D, c::Color) =
    set_fill!(o.barstyle, c)

function set_fill!(
            o::Box2D,
            c::Color
        )::Nothing

    isnothing(o.fillstyle) && (o.fillstyle = FillStyle())
    set_fill!(o.fillstyle, c)
end


"""
    set_fills!(obj, cols)

Internal functions to set the fill color values `cols`.
If a single value is passed, all fields will be assigned to that value.
"""
function set_fills!(
            vs::Vector,
            c::Vector{<:Color},
            field::Option{Symbol}=nothing
        )::Nothing
    # check dimensions match
    length(c) == length(vs) || throw(
        DimensionMismatch("fills // dimensions don't match")
    )
    # assign
    if isnothing(field)
        for (i, col) ∈ enumerate(c)
            set_fill!(vs[i], col)
        end
    else
        for (i, col) ∈ enumerate(c)
            set_fill!(getfield(vs[i], field), col)
        end
    end
    return
end
set_fills!(vs::Vector, c::Color, f) = set_fills!(vs, fill(c, length(vs)), f)


"""
    set_alpha!(obj, α)

Internal function to set the alpha value of `obj.field` to `α`. There must be
a color value available, it will be reinterpreted with the given alpha value.
"""
function set_alpha!(
            o::Union{Fill2D, Hist2D, Box2D},
            α::F64,
            parent::Symbol
        )::Nothing
    eval(:($o.$parent.fill = coloralpha($o.$parent.fill, $α)))
    return
end
set_alpha!(o::Union{Fill2D, Box2D}, α::F64) = set_alpha!(o, α, :fillstyle)
set_alpha!(o::Hist2D, α::F64)               = set_alpha!(o, α, :barstyle)
set_alpha!(o::Union{Figure,Legend}, α::F64) = (o.bgcolor = coloralpha(o.bgcolor, α);)


####
#### TEXT
####  set_font!, set_hei!
####

"""
    set_font!(obj, font)

Internal function to set the font associated with an object `obj` to the value
`font`.
"""
function set_font!(
            ts::TextStyle,
            font::String
        )::Nothing

    ts.font = get(GLE_FONTS, font) do
        throw(
            OptionValueError("font", font, "(Unknown font)")
        )
    end
    return
end
set_font!(o::Ticks,    f::String) = set_font!(o.labels.textstyle, f)
set_font!(o::Colorbar, f::String) = set_font!(o.ticks, f)
set_font!(o,           f::String) = set_font!(o.textstyle, f)

"""
    set_hei!(obj, fontsize)

Internal function to set the font associated with an object `obj` to the value
`fontsize`.
"""
set_hei!(ts::TextStyle, v::F64) = (ts.hei = v * PT_TO_CM)
set_hei!(o::Ticks, v::F64)      = set_hei!(o.labels.textstyle, v)
set_hei!(o::Colorbar, v::F64)   = set_hei!(o.ticks, v)
set_hei!(o, v::F64)             = set_hei!(o.textstyle, v)


####
#### Line related
####

"""
    set_lstyle!(obj, lstyle)

Internal function to set the line style associated with object `obj`. The
style can be described by `lstyle` being a number or a String representing the
pattern.
"""
function set_lstyle!(
            o::LineStyle,
            v::Int
        )::Nothing

    0 < v || throw(
        OptionValueError("lstyle", v)
    )
    o.lstyle = v
    return
end
function set_lstyle!(
            o::LineStyle,
            v::String
        )::Nothing

    o.lstyle = get(GLE_LSTYLES, v) do
        throw(
            OptionValueError("lstyle", v)
        )
    end
    return
end
set_lstyle!(o, v::String) = set_lstyle!(o.linestyle, v)


"""
    set_lwidth!(obj, v)

Internal function to set the line width associated with the relevant field of
`obj` to `v`.
"""
set_lwidth!(o::Union{LineStyle, Axis}, v::F64) = (o.lwidth = v)
set_lwidth!(o, v::F64) = set_lwidth!(o.linestyle, v)

"""
    set_smooth!(obj, v)

Internal function to determine whether to use splines for a field of `obj`.
"""
set_smooth!(o::LineStyle, v::Bool) = (o.smooth = v)


####
#### Marker related
####

"""
    set_marker!(obj, marker)

Internal function to set the marker associated with object `obj`. The style
can be described by `marker` being a String describing the pattern.
"""
function set_marker!(
            o::MarkerStyle,
            v::String
        )::Nothing

    o.marker = get(GLE_MARKERS, v) do
        throw(
            OptionValueError("marker", v)
        )
    end
    return
end
set_marker!(o, v::String) = set_marker!(o.markerstyle, v)


"""
    set_msize!(obj, msize)

Internal function to set the marker size associated with object `obj`. If no
marker has been given, set it to a filled circle.
"""
function set_msize!(o::MarkerStyle, v::F64)
    isdef(o.marker) || (o.marker = "fcircle")
    o.msize = v
    return
end
set_msize!(o, v::F64) = set_msize!(o.markerstyle, v)


"""
    set_mcol!(obj, col)

Internal function to set the marker color. If no marker has been given, set it
to a filled circle.
"""
function set_mcol!(o::MarkerStyle, c::Color)
    isdef(o.marker) || (o.marker = "fcircle")
    o.color = c
    return
end
set_mcol!(o, v::Color) = set_mcol!(o.markerstyle, v)


# generate functions that take vector inputs for linestyle and markerstyle
for case ∈ ("lstyle", "lwidth", "smooth", "marker", "msize", "mcol")
    f_scalar! = Symbol("set_$(case)!")  # function with scalar input
    f_vector! = Symbol("set_$(case)s!") # e.g. set_markers!
    ex = quote
        # set function for a group of objects (e.g. linestyles, markerstyles)
        function $f_vector!(vs::Vector, v, f::Option{Symbol}=∅)
            length(vs) == length(v) || throw(
                DimensionMismatch($case*"s // dimensions don't match")
            )
            if !isdef(f)
                for (i, vi) ∈ enumerate(v)
                    $f_scalar!(vs[i], vi)
                end
            else
                for (i, vi) ∈ enumerate(v)
                    $f_scalar!(getfield(vs[i], f), vi)
                end
            end
            return
        end
        $f_vector!(vs::Vector, v::Vector, f) = $f_vector!(vs, fill(v, length(vs)), f)
    end
    eval(ex)
end


####
#### Bar related
####

"""
    set_bwidth!(obj, v)

Internal function to set the bin or box width to value `v`.
"""
set_bwidth!(o::Bar2D, v::F64) = (o.bwidth = v)


####
#### Boxplot related
####

function set_bp!(
            b::Boxplot,
            v::Vector,
            field::Symbol
        )::Nothing
    length(v) == b.nobj || throw(
        DimensionMismatch("$(field)s // dimensions don't match")
    )
    for k ∈ 1:b.nobj
        setfield!(b.boxstyles[k], field, v[k])
    end
    return
end
set_bp!(b, v, f) = set_bp!(b, fill(v, b.nobj), f)


"""
    set_bwidths!(b, v)

Internal function to set the box widths to values `v`.
"""
set_bwidths!(b::Boxplot, v) = set_bp!(b, v, :bwidth)


"""
    set_wwidth!(b, v)

Internal function to set the whisker width to value `v`.
"""
set_wwidths!(b::Boxplot, v) = set_bp!(b, v, :wwidth)


"""
    set_wrlengths!(b, v)

Internal function to set the whiskers relative lengths to value `v`.
"""
set_wrlengths!(b::Boxplot, v) = set_bp!(b, v, :wrlength)


"""
    set_show!(b, v, f)

Internal function to toggle the display of an element `f` in a boxplot.
See `set_mshow!` and `set_oshow!`.
"""
function set_show!(b::Boxplot, v::Vector{Bool}, field::Symbol)
    length(v) == b.nobj || throw(
        DimensionMismatch("set_mshow // dimensions don't match")
    )
    for (k, vk) ∈ enumerate(v)
        setfield!(b.boxstyles[k], field, vk)
    end
    return
end
set_show!(b::Boxplot, v::Bool, f) = set_show!(b, fill(v, b.nobj), f)


"""
    set_mshow!(b, v)

Internal function to toggle the display of the mean point in a boxplot.
(A vector can be passed to set this individually on each boxplot shown).
"""
set_mshow!(b::Boxplot, v) = set_show!(b, v, :mshow)


"""
    set_oshow!(b, v)

Internal function to toggle the display of outliers in a boxplot.
(A vector can be passed to set this individually on each boxplot shown).
"""
set_oshow!(b::Boxplot, v) = set_show!(b, v, :oshow)
