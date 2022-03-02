"""
    apply_textstyle!(f, s, parent_font; addset)

Internal function to apply the textstyle `s` to figure `f`.
"""
function apply_textstyle!(
            f::Figure,
            s::TextStyle,
            parent_font::String = "";
            #
            addset::Bool = false
        )::Nothing

    if !isdef(s.font) && !isempty(parent_font)
        s.font = parent_font
    end
    isanydef(s) || return

    addset && "\nset" |> f
    add(f, s, :font, :hei, :color)
    return
end


"""
    apply_linestyle!(f, s; nosmooth, addset)

Internal function to apply the linestyle `s` in a GLE context.

## Kwargs

    * nosmooth: while for a line plot the smooth option is allowed, for the
                line property of e.g. a tick, it doesn't make sense.
    * addset: whether to add a set.
"""
function apply_linestyle!(
            f::Figure,
            s::LineStyle;
            #
            nosmooth::Bool = false,
            addset::Bool   = false
        )::Nothing

    isanydef(s) || return

    addset && "\nset" |> f
    add(f, s, :lstyle, :lwidth, :color)
    if !nosmooth
        add(f, s, :smooth)
    end
    return
end


"""
    apply_markerstyle!(f, s; mcol, mscale)

Internal function to apply the markerstyle `s` in a GLE context.
"""
function apply_markerstyle!(
            f::Figure,
            s::MarkerStyle;
            #
            mcol::Bool      = false,
            mscale::Float64 = 1.0
        )::Nothing

    isanydef(s) || return
    isdef(s.marker) && s.marker == "none" && return

    if !mcol
        add(f, s, :marker, :msize, :color)
    else
        "marker $(str(s))" |> f
        "msize"            |> f
        if isdef(s.msize)
            ms = "$(fl2str(s.msize / mscale))"
        else
            ms = "$(0.4 / mscale)"
        end
        ms |> f
    end
    return
end


"""
    apply_barstyle!(f, s)

Internal function to apply the barstyle `s` in a GLE context.
"""
function apply_barstyle!(
            f::Figure,
            s::BarStyle
        )::Nothing

    isanydef(s) || return
    add(f, s, :color, :fill)
    return
end


"""
    apply_barstyles_nostack!(f, v)

Internal function to apply the Vector of barstyles `v` in a GLE context where
the bars are not stacked.
"""
function apply_barstyles_nostack!(
            f::Figure,
            v::Vector{BarStyle}
        )::Nothing
    # assumption that if one is defined, all are defined (this is checked
    # with the set_properties!)
    isanydef(v[1]) || return
    if isdef(v[1].color)
        cv = svec2str((col2str(s.color) for s ∈ v))
        "color $cv" |> f
    end
    if isdef(v[1].fill)
        cv = svec2str((col2str(s.fill) for s ∈ v))
        "fill $cv"  |> f
    end
    return
end


"""
    apply_boxplotstyle!(f, s)

Internal function to apply the BoxplotStyle `s` in a GLE context.
Note that this is the context of a subroutine so we just pass raw
arguments, see also `gle_sub/boxplot`.
"""
function apply_boxplotstyle!(
            f::Figure,
            s::BoxplotStyle,
        )::Nothing

    join(
        vec2str.(
            # BOX
            s.bwidth,          # box width
            s.wwidth,          # whiskers width
            s.lstyle,          # box line style
            s.blstyle.lwidth,  # box line width
            s.blstyle.color,   # box line colour
            # MEDIAN LINE
            s.mlstyle.lstyle,   # median line style
            s.mlstyle.lwidth,   # median line width
            s.mlstyle.color,    # median line color
            # MEAN MARKER
            Int(s.mshow),                       # show mean marker
            s.mmstyle.marker,                   # marker symbol
            s.mmstyle.msize / f.textstyle.hei,  # scaled marker size (≈ scatter msize)
            s.mmstyle.color
            ),
        " "
    ) |> f
    return
end
