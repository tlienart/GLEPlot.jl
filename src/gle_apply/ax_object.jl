"""
    apply_title!(g, t, p, parent_font)

Internal function to apply a `Title` object `t` in a GLE context.
The argument `p` specifies the prefix.
"""
function apply_title!(
            g::GS,
            t::Title,
            p::String,
            parent_font::String
        )::Nothing

    # [x]title ...
    "\n\t$(p)title \"$(t.text)\"" |> g
    add(g, t, :dist)
    apply_textstyle!(g, t.textstyle, parent_font)
    return
end


"""
    apply_ticks!(g, t, p)

Internal function to apply a `Ticks` object `t` in a GLE context for an axis
prefixed by `p`.
"""
function apply_ticks!(
            g::GS,
            t::Ticks,
            prefix::String,
            parent_font::String
        )::Nothing

    # [x]ticks ...
    "\n\t$(prefix)ticks" |> g
    if t.off
        "off" |> g
        # also discard the labels and don't call anything else
        "\n\t$(prefix)labels off" |> g
        return
    end
    # - style
    add(g, t, :length)
    apply_linestyle!(g, t.linestyle)
    # [x]places pos1 pos2 ...
    isempty(t.places) || "\n\t$(prefix)places $(vec2str(t.places))" |> g
    # [x]xaxis symticks
    t.symticks && "\n\t$(prefix)axis symticks" |> g
    apply_tickslabels!(g, t.labels, prefix, parent_font)
    return
end


"""
    apply_tickslabels!(g, t, p)

Internal function to apply a `TicksLabels` object `t` in a GLE context.
The prefix `p` indicates which axis we're on.
"""
function apply_tickslabels!(
            g::GS,
            t::TicksLabels,
            prefix::String,
            parent_font::String
        )::Nothing

    # [x]names "names1" ...
    isempty(t.names) || "\n\t$(prefix)names $(vec2str(t.names))" |> g
    # [x]labels ...
    "\n\t$(prefix)labels" |> g
    add(g, t, :off, :dist)
    apply_textstyle!(g, t.textstyle, parent_font)
    # [x]axis ...
    if any(isdef, (t.angle, t.format))
        "\n\t$(prefix)axis" |> g
        add(g, t, :angle, :format, :shift)
    end
    return
end
