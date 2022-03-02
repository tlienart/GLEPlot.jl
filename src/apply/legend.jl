"""
    apply_legend_spec!(...)

Internal helper functions to apply the legend element corresponding to a
specific drawing handle.
"""
function apply_legend_spec!(
            f::Figure,
            h::DrawingHandle{<:Scatter2D},
            labels::Union{String, Vector{String}},
            figid::String
        )::Nothing

    scatter = h.drawing
    labels isa Vector || (labels = fill(labels, scatter.nobj))
    for k ∈ 1:scatter.nobj
        "\n\ttext \"$(labels[k])\"" |> f
        if scatter.linestyles[k].lstyle != -1
            # line plot
            "line" |> f; apply_linestyle!(f, scatter.linestyles[k]; nosmooth=true)
            mcol = false
            if isdef(scatter.markerstyles[k].color) &&
                    (scatter.markerstyles[k].color != scatter.linestyles[k].color)
                mcol = true
                add_sub_marker!(Figure(figid; _noreset=true), scatter.markerstyles[k])
            end
            # apply markerstyle
            apply_markerstyle!(f, scatter.markerstyles[k], mcol=mcol)
        else
            # scatter plot
            if !isdef(scatter.markerstyles[k].color)
                scatter.markerstyles[k].color = scatter.linestyles[k].color
            end
            apply_markerstyle!(f, scatter.markerstyles[k])
        end
    end
    return
end
function apply_legend_spec!(
            f::Figure,
            h::DrawingHandle{<:Fill2D},
            label::String,
            ::String
        )::Nothing

    fill = h.drawing
    "\n\ttext \"$label\" fill $(col2str(fill.fillstyle.fill))" |> f
    return
end
function apply_legend_spec!(
            f::Figure,
            h::DrawingHandle{<:Hist2D},
            label::String,
            ::String
        )::Nothing

    hist = h.drawing
    "\n\ttext \"$label\"" |> f
    # precedence of fill over color
    if hist.barstyle.fill != c"white"
        "fill $(col2str(hist.barstyle.fill))" |> f
    else
        "marker square color $(col2str(hist.barstyle.color))" |> f
    end
    return
end
function apply_legend_spec!(
            f::Figure,
            h::DrawingHandle{<:Bar2D},
            labels::Union{String,Vector{String}},
            ::String
        )::Nothing

    bar = h.drawing
    labels isa Vector || (labels = fill(labels, bar.nobj))
    for (k, barstyle) ∈ enumerate(bar.barstyles)
        "\n\ttext \"$(labels[k])\"" |> f
        if barstyle.fill != c"white"
            "fill $(col2str(barstyle.fill))" |> f
        else
            "marker square color $(col2str(barstyle.color))" |> f
        end
    end
    return
end


"""
    apply_legend!(f, leg, parent_font)

Internal function to apply a `Legend` object `leg` in a GLE context with
entries `entries` (constructed through the `apply_drawings` process).
"""
function apply_legend!(
            f::Figure,
            l::Legend,
            parent_font::String,
            figid::String
        )::Nothing

    l.off && return
    isempty(l.handles) && return
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "\nbegin key"  |> f
    apply_textstyle!(f, l.textstyle, parent_font; addset=true)

    # global commands
    "\n\tcompact"      |> f
    l.nobox && "nobox" |> f
    isdef(l.bgcolor)   && "background $(col2str(l.bgcolor))"        |> f
    isdef(l.margins)   && "margins $(l.margins[1]) $(l.margins[2])" |> f
    sum(l.offset) > 0  && "offset $(l.offset[1]) $(l.offset[2])"    |> f
    isdef(l.position)  && "\n\tposition $(l.position)"              |> f

    for (handle, label) ∈ zip(l.handles, l.labels)
        apply_legend_spec!(f, handle, label, figid)
    end
    #
    "\nend key"    |> f
    # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    return
end
