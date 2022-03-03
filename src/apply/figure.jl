export debug

"""
    write_figure(f)

Internal function to generate and write the GLE script associated with the
figure object `f`.
"""
function write_figure(
            f::Figure,
            opath::String = ""
        )::String

    g = f.script
    "size $(f.size[1]) $(f.size[2])" |> f

    # >> apply background color if different than nothing
    # Note that if it's white, we apply it as this makes a
    # difference for transparent outputs like SVG.
    if isdef(f.bgcolor)
        # add a box that is slightly larger than the size
        "\namove -0.05 -0.05" |> f
        "\nbox $(f.size[1]+0.1) $(f.size[2]+0.1)" |> f
        "fill $(f.bgcolor) nobox" |> f
    end

    # >> apply latex
    # check if has latex
    haslatex = any(isdef, (f.texscale, f.texpreamble))
    isdef(f.texlabels) && (haslatex = f.texlabels)
    # line for texstyle, it may be empty if nothing is given
    apply_textstyle!(f, f.textstyle, addset=true)
    # latex if required
    if haslatex
        if isdef(f.texpreamble)
            "\nbegin texpreamble\n" |> f
            f.texpreamble           |> f
            "\nend texpreamble"     |> f
        end
        "\nset texlabels 1" |> f
        "\nset texscale"    |> f
        ifelse(isdef(f.texscale), f.texscale, "scale") |> f
    end
    write(g.io, "\n")

    # >> apply axes
    # NOTE: this organisation is so that if axes need extra
    # subroutines, these will be generated after applying axes
    # but need to be put before in the GLE script

    ftemp = Figure(GS(), "__temp__")
    for (i, aᵢ) ∈ enumerate(f.axes)
        apply_axes!(ftemp, aᵢ, f.id, i)
    end
    if !isempty(f.subroutines)
        ks = keys(f.subroutines)
        # subroutines for palettes
        for key ∈ Iterators.filter(k -> startswith(k, "cmap_"), ks)
            f.subroutines[key] |> f
        end
        # subroutines for drawings
        # -- boxplot, heatmap
        for key ∈ Iterators.filter(k -> startswith(k, "bp_") || startswith(k, "hm_"), ks)
            f.subroutines[key] |> f
        end
        # subroutines for markercolors
        for key ∈ Iterators.filter(k->startswith(k, "mk_"), ks) # special markers
            f.subroutines[key] |> f
        end
        # --------------
        # 3D subroutines
        # --------------
        "plot3" ∈ ks && f.subroutines["plot3"] |> f
    end
    ftemp |> f

    # >> either return as string or write to file
    isempty(opath) && return String(take!(f))
    write(opath, take!(f))
    return ""
end


"""
    debug_gle(f)

Print the GLE script associated with figure `f` for debugging.
"""
debug(f::Figure) = println(write_figure(f))
debug()          = debug(gcf())
