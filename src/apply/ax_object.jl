"""
    apply_title!(f, t, p, parent_font)

Internal function to apply a `Title` object `t` in a GLE context.
The argument `p` specifies the prefix.
"""
function apply_title!(
            f::Figure,
            t::Title,
            p::String,
            parent_font::String
        )::Nothing

    # [x]title ...
    "\n\t$(p)title \"$(t.text)\"" |> f
    add(f, t, :dist)
    apply_textstyle!(f, t.textstyle, parent_font)
    return
end


"""
    apply_ticks!(f, t, p)

Internal function to apply a `Ticks` object `t` in a GLE context for an axis
prefixed by `p`.
"""
function apply_ticks!(
            f::Figure,
            t::Ticks,
            prefix::String,
            parent_font::String
        )::Nothing

    # [x]ticks ...
    "\n\t$(prefix)ticks" |> f
    if t.off
        "off" |> f
        # also discard the labels and don't call anything else
        "\n\t$(prefix)labels off" |> f
        return
    end
    # - style
    add(f, t, :length)
    apply_linestyle!(f, t.linestyle)
    # [x]places pos1 pos2 ...
    isempty(t.places) || "\n\t$(prefix)places $(vec2str(t.places))" |> f
    # [x]xaxis symticks
    t.symticks && "\n\t$(prefix)axis symticks" |> f
    apply_tickslabels!(f, t.labels, prefix, parent_font)
    return
end


"""
    apply_tickslabels!(f, t, p)

Internal function to apply a `TicksLabels` object `t` in a GLE context.
The prefix `p` indicates which axis we're on.
"""
function apply_tickslabels!(
            f::Figure,
            t::TicksLabels,
            prefix::String,
            parent_font::String
        )::Nothing

    # [x]names "names1" ...
    isempty(t.names) || "\n\t$(prefix)names $(vec2str(t.names))" |> f
    # [x]labels ...
    "\n\t$(prefix)labels" |> f
    add(f, t, :off, :dist)
    apply_textstyle!(f, t.textstyle, parent_font)
    # [x]axis ...
    if any(isdef, (t.angle, t.format))
        "\n\t$(prefix)axis" |> f
        add(f, t, :angle, :format, :shift)
    end
    return
end
