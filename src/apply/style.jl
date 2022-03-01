"""
    apply_textstyle!(g, s, parent_font; addset)

Internal function to apply the textstyle `s` in a GLE context.
"""
function apply_textstyle!(
            g::GS,
            s::TextStyle,
            parent_font::String = "";
            #
            addset::Bool = false
        )::Nothing

    if !isdef(s.font) && !isempty(parent_font)
        s.font = parent_font
    end
    isanydef(s) || return

    addset && "\nset" |> g
    add(g, s, :font, :hei, :color)
    return
end


"""
    apply_linestyle!(g, s; nosmooth, addset)

Internal function to apply the linestyle `s` in a GLE context.

## Kwargs

    * nosmooth: while for a line plot the smooth option is allowed, for the
                line property of e.g. a tick, it doesn't make sense.
    * addset: whether to add a set.
"""
function apply_linestyle!(
            g::GS,
            s::LineStyle;
            #
            nosmooth::Bool = false,
            addset::Bool   = false
        )::Nothing

    isanydef(s) || return

    addset && "\nset" |> g
    add(g, s, :lstyle, :lwidth, :color)
    if !nosmooth
        add(g, s, :smooth)
    end
    return
end


"""
    apply_markerstyle!(g, s; mcol, mscale)

Internal function to apply the markerstyle `s` in a GLE context.
"""
function apply_markerstyle!(
            g::GS,
            s::MarkerStyle;
            #
            mcol::Bool      = false,
            mscale::Float64 = 1.0
        )::Nothing

    isanydef(s) || return
    isdef(s.marker) && s.marker == "none" && return

    if !mcol
        add(g, s, :marker, :msize, :color)
    else
        "marker $(str(s))" |> g
        "msize"            |> g
        if isdef(s.msize)
            ms = "$(fl2str(s.msize / mscale))"
        else
            ms = "$(0.4 / mscale)"
        end
        ms |> g
    end
    return
end


"""
    apply_barstyle!(g, s)

Internal function to apply the barstyle `s` in a GLE context.
"""
function apply_barstyle!(
            g::GS,
            s::BarStyle
        )::Nothing

    isanydef(s) || return
    add(g, s, :color, :fill)
    return
end


"""
    apply_barstyles_nostack!(g, v)

Internal function to apply the Vector of barstyles `v` in a GLE context where
the bars are not stacked.
"""
function apply_barstyles_nostack!(
            g::GS,
            v::Vector{BarStyle}
        )::Nothing
    # assumption that if one is defined, all are defined (this is checked
    # with the set_properties!)
    isanydef(v[1]) || return
    if isdef(v[1].color)
        cv = svec2str((col2str(s.color) for s ∈ v))
        "color $cv" |> g
    end
    if isdef(v[1].fill)
        cv = svec2str((col2str(s.fill) for s ∈ v))
        "fill $cv"  |> g
    end
    return
end


"""
    apply_boxplotstyle!(g, s)

Internal function to apply the BoxplotStyle `s` in a GLE context.
Note that this is the context of a subroutine so we just pass raw
arguments, see also `gle_sub/boxplot`.
"""
function apply_boxplotstyle!(
            g::GS,
            s::BoxplotStyle,
            f::Figure
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
    ) |> g
    return
end
