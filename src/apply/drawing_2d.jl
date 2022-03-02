"""
    apply_drawings!(f, drawings, figid, axidx)

Internal function to apply a vector of `Drawing` objects contained in an
`Axes` container in a GLE context. The `axidx` and `figid` help keep track
of where individual drawings belong to which is useful when writing auxiliary
files containing the drawing data.
"""
function apply_drawings!(
            f::Figure,
            drawings::Vector{<:Drawing},
            figid::String,
            axidx::Int
        )::Nothing

    # the element counter helps indicate which column in auxilliary files
    # to look into. A drawing application increments it depending on
    # how many columns it looks at.
    el_cntr = 1
    for drawing ∈ drawings
        el_cntr = apply_drawing!(f, drawing, el_cntr, figid, axidx)
    end
    return
end


"""
    auxpath(h, fid, axid)

Internal function to generate a path to an auxiliary file storing drawing
data for the current axes of the current figure.
The argument `h` is the hash of what has to be written (so that if the exact
same command is issued, the file is not re-written). The `axidx` and `figid`
are there to make the auxiliary file unique and easy to delete after use.
"""
auxpath(h::UInt, fid::String, axid::Int) =
    GP_ENV["TMP_PATH"] / "$(fid)_$(axid)_$h.csv"

"""
    auxdata(o, fid, axid)

Write the auxilliary data to a Drawing to file taking into account the figure
and axes id to avoid replacing an-already existing file.
"""
function auxdata(
            o::Drawing,
            fid::String,
            axid::Int;
            #
            nomiss = false
        )::String

    # write data to a temporary CSV file
    faux = auxpath(hash(o.data), fid, axid)
    # don't rewrite if it's the exact same zipper
    isfile(faux) || csv_writer(faux, o.data, !nomiss && o.hasmissing)
    return faux
end


##########################################################################
##########################################################################


"""
    apply_drawing!(f, scatter, ...)

Apply Scatter2D plot. Missing values are allowed.
"""
function apply_drawing!(
            f::Figure,
            scatter::Scatter2D,
            el_cntr::Int,
            figid::String,
            axidx::Int
        )::Int

    faux = auxdata(scatter, figid, axidx)
    #
    # GLE syntax is:
    #
    #   data datafile.dat d1=c1,c2
    #   d1 line blue ...
    #
    # we do that for each object in the scatter.
    #
    for k ∈ 1:scatter.nobj

        # (1) indicate what data to read
        "\n\tdata \"$faux\" d$(el_cntr)=c1,c$(k+1)" |> f

        # if no color has been specified, assign one according to the palette
        if !isdef(scatter.linestyles[k].color)
            scatter.linestyles[k].color = palette(el_cntr)
        end

        # (2) Line and Marker description
        # (2.A) - there is a line
        if scatter.linestyles[k].lstyle != -1
            # Line
            "\n\td$el_cntr line" |> f
            apply_linestyle!(f, scatter.linestyles[k])

            # Marker
            mcol   = false
            mscale = 1.0
            # > if a marker color is specified and is different than the
            # > current line color, we need to add a dedicated GLE routine
            # > that can handle this on the relevant figure.
            if isdef(scatter.markerstyles[k].color) &&
                    (scatter.markerstyles[k].color != scatter.linestyles[k].color)
                mcol = true
                f    = Figure(figid; _noreset=true)
                add_sub_marker!(f, scatter.markerstyles[k])
                mscale = f.textstyle.hei
            end
            apply_markerstyle!(f, scatter.markerstyles[k]; mcol, mscale)

        # (2.B) - only markers
        else
            # Scatter plot; if there's no specified marker color,
            # take the default line color
            if !isdef(scatter.markerstyles[k].color)
                scatter.markerstyles[k].color = scatter.linestyles[k].color
            end
            "\n\td$el_cntr" |> f
            apply_markerstyle!(f, scatter.markerstyles[k])
        end

        el_cntr += 1
    end
    return el_cntr
end


"""
    apply_drawing!(f, fill, ...)

Apply Fill2D plot. Missing values are NOT allowed.
"""
function apply_drawing!(
            f::Figure,
            fill::Fill2D,
            el_cntr::Int,
            figid::String,
            axidx::Int
        )::Int

    faux = auxdata(fill, figid, axidx; nomiss=true)
    #
    # GLE syntax is:
    #
    #   data datafile.dat d1=c1,c2 d2=c1,c3
    #   fill d1,d2 color rgb(1,1,1) xmin 0 xmax 1
    #
    "\n\tdata \"$faux\" d$(el_cntr)=c1,c2 d$(el_cntr+1)=c1,c3" |> f

    "\n\tfill d$(el_cntr),d$(el_cntr+1)"    |> f
    "color $(col2str(fill.fillstyle.fill))" |> f
    add(f, fill, :xmin, :xmax)

    el_cntr += 2
    return el_cntr
end


"""
    apply_drawing!(f, hist, ...)

Apply Hist2D plot. Missing values are allowed.
"""
function apply_drawing!(
            f::Figure,
            hist::Hist2D,
            el_cntr::Int,
            figid::String,
            axidx::Int
        )::Int

    faux = auxdata(hist, figid, axidx)
    #
    # GLE syntax is:
    #
    #   data datafile.dat d1
    #   let d2 = hist d1 from xmin to xmax bins nbins
    #   bar d2 width width$ fill col$ color col2$ pattern pat$ horiz
    #

    # if no color has been specified, assign one according to the PALETTE
    if !isdef(hist.barstyle.color)
        if hist.barstyle.fill == c"white"
            cc = mod(el_cntr, GP_ENV["SZ_PALETTE"])
            (cc == 0) && (cc = GP_ENV["SZ_PALETTE"])
            hist.barstyle.color = GP_ENV["PALETTE"][cc]
        else
            hist.barstyle.color = c"white" # looks nicer than black
        end
    end

    # (1) indicate what data to read
    "\n\tdata \"$faux\" d$(el_cntr)" |> f

    # (2) hist description  | let d(k+1) = hist dk from min to max
    minx, maxx = hist.range
    "\n\tlet d$(el_cntr+1) = hist d$(el_cntr)" |> f
    "from $minx to $maxx" |> f
    el_cntr += 1

    # number of bins
    nobs = hist.nobs
    nbauto = (nobs == 0 ? 1 : ceil(Integer, log2(nobs))+1) # sturges, see StatsBase
    bins = isdef(hist.bins) ? hist.bins : nbauto
    add(f, hist, :bins)

    # (3) compute appropriate scaling
    width   = (maxx - minx) / bins
    scaling = 1.0
    hist.scaling == "probability" && (scaling /= nobs)
    hist.scaling == "pdf"         && (scaling /= (nobs * width))
    "\n\tlet d$(el_cntr) = d$(el_cntr)*$scaling" |> f

    # (4) apply histogram
    "\n\tbar d$(el_cntr) width $width" |> f

    # apply styling
    apply_barstyle!(f, hist.barstyle)
    add(f, hist, :horiz)

    return el_cntr + 1
end


"""
    apply_drawing!(f, bar, ...)

Apply Bar2D plot. Missing values are allowed.
"""
function apply_drawing!(
            f::Figure,
            bar::Bar2D,
            el_cntr::Int,
            figid::String,
            axidx::Int
        )::Int

    faux = auxdata(bar, figid, axidx)
    #
    # general GLE syntax is:
    # (1) data datafile.dat d1 d2 ...
    # (2) bar d1,d2,d3 fill color_ color color_
    # (STACKED, NO GROUP)
    # bar d1 ...
    # bar d2 from d1 ...
    #
    # XXX (STACKED, GROUP) ---> see first whether this has a use case...
    # could solve it by specifying what gets stacked stack=[(1, 2), ...] but
    # clunky (and tbf not great visualisation anyway...)
    # bar d1,d2 ...
    # bar d3,d4 from d1,d2 ...
    #

    # if no color has been specified, assign with palette
    for c ∈ eachindex(bar.barstyles)
        if !isdef(bar.barstyles[c].color)
            if bar.barstyles[c].fill == c"white"
                bar.barstyles[c].color = palette(el_cntr + c - 1)
            else
                bar.barstyles[c].color = c"white"
            end
        end
    end

    nbars = bar.nobj

    # (1) indicate what data to read "data file d1 d2 d3..."
    "\n\tdata \"$faux\""      |> f
    dlist(el_cntr .+ 1:nbars) |> f

    # (2) non stacked (or single barset)
    if nbars==1 || !bar.stacked
        # bar d1,d2,d3
        "\n\tbar"                          |> f
        dlist(el_cntr .+ 1:nbars, sep=",") |> f
        # styling
        isdef(bar.bwidth) && "width $(bar.bwidth)" |> f
        apply_barstyles_nostack!(f, bar.barstyles)
        add(f, bar, :horiz)

    # (2) stacked
    else
        # first base bar
        "\n\tbar d$(el_cntr)"                      |> f
        isdef(bar.bwidth) && "width $(bar.bwidth)" |> f
        apply_barstyle!(f, bar.barstyles[1])
        add(f, bar, :horiz)
        # bars stacked on top
        for i ∈ 2:nbars
            "\n\tbar d$(el_cntr+i-1) from d$(el_cntr+i-2)" |> f
            apply_barstyle!(f, bar.barstyles[i])
        end
    end

    return el_cntr + nbars
end


"""
    apply_drawing!(f, boxplot, ...)

Apply Boxplot.
"""
function apply_drawing!(
            f::Figure,
            bp::Boxplot,
            el_cntr::Int,
            figid::String,
            axidx::Int
        )::Int

    # 1. add boxplot subroutines (vertical and horizontal) if not there already
    subname = ifelse(bp.horiz, "bp_horiz", "bp_vert")
    f       = Figure(figid; _noreset=true)
    if subname ∉ keys(f.subroutines)
        f.subroutines[subname] = GLE_DRAW_SUB[subname]
    end

    # draw the boxplots one by one
    for k ∈ 1:bp.nobj
        # 1. retrieve the statistics and map to spaced string
        stats_str = vec2str(bp.stats[k, :])

        # 2. call the subroutine and apply the style
        s = bp.boxstyles[k]
        "\n\tdraw $subname $k $stats_str" |> f
        apply_boxplotstyle!(f, s, f)

        el_cntr += 1
    end
    return el_cntr
end


"""
    apply_drawing!(f, hm, ...)

Apply Heatmap.
"""
function apply_drawing!(
            f::Figure,
            hm::Heatmap,
            el_cntr::Int,
            figid::String,
            axidx::Int
        )::Int

    # 1. apply the subroutine with a hash depending on figid and axidx
    hashid = hash((figid, axidx))
    add_sub_heatmap!(Figure(figid; _noreset=true), hm, hashid)

    # 2. write the zfile
    faux = auxpath(hash(hm.data), figid, axidx)
    isfile(faux) || csv_writer(faux, hm.transpose ? hm.data' : hm.data, false)

    # infer bw/bh based on ncols/nrows
    nrows, ncols = size(hm.data)
    bw, bh       = 1.0 ./ (ncols, nrows)
    hm.transpose && (tmp = bw; bw = bh; bh = bw)

    # number of columns of the final heatmap
    nct = ifelse(hm.transpose, nrows, ncols)

    # 3. load data
    vs = join(("d$j=c0,c$j" for j ∈ 1:nct), " ")
    "\n\tdata \"$faux\" $vs" |> f

    # 4. go over all the columns and draw the boxes (scales linearly with # cols)
    for j ∈ 1:nct
        "\n\tdraw hm_$hashid $j d$j $bw $bh" |> f
    end
    return el_cntr + 1
end
