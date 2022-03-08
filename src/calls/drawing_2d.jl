export plot!, plot, scatter!, scatter,
       fill_between!, fill_between,
       hist!, hist, bar!, bar,
       boxplot, heatmap, heatmap_ticks

"""
    plot_data(x)
    plot_data(x, ys...)

I/ Preprocess data for a 2D plot.
"""
function plot_data(
            x::AVM{<:CanMiss{<:Real}}
        )::NamedTuple

    isempty(x) && throw(
        ArgumentError("Cannot display empty vectors.")
    )
    hasmissing = Missing <: eltype(x) ||
                   any(isinf, x)      ||
                   any(isnan, x)
    return (
        data       = zip(1:size(x, 1), eachcol(x)...),
        hasmissing = hasmissing,
        nobj       = size(x, 2)
    )
end
# NOTE: these typechecks within the function body is to avoid clashes/ambiguity with plot_data(x)
function plot_data(
            x,
            ys...
        )::NamedTuple

    isempty(x) && throw(
        ArgumentError("Cannot display empty vectors.")
    )
    x isa AV{<:CanMiss{<:Real}} || throw(
        ArgumentError("""
            'x' has un-handled type $(typeof(x)), expected a vector of reals
            possibly with missing values.
            """
        )
    )

    nobj       = 0
    hasmissing = Missing <: eltype(x) ||
                   any(isinf, x)      ||
                   any(isnan, x)
    for y ∈ ys
        y isa AVM{<:CanMiss{<:Real}} || throw(
            ArgumentError(
                """
                'y' has un-handled type $(typeof(y))"), expected a vector or
                a matrix of reals, possibly with missing values.
                """
            )
        )
        size(y, 1) == length(x) || throw(
            DimensionMismatch("y data must match x")
        )

        nobj       += size(y, 2)
        hasmissing |= Missing <: eltype(y) ||
                        any(isinf, y)      ||
                        any(isnan, y)
    end
    return (
        data       = zip(x, (view(y, :, j) for y ∈ ys for j ∈ axes(y, 2))...),
        hasmissing = hasmissing,
        nobj       = nobj
    )
end


"""
    fill_data(x, y1, y2)

I/ Preprocess data for a Fill2D.
"""
function fill_data(
            x::AVR,
            y1::Union{Real,AVR},
            y2::Union{Real,AVR}
        )::NamedTuple

    isempty(x) && throw(
        ArgumentError("Cannot display empty vectors.")
    )

    y1 isa AV || (y1 = fill(y1, length(x)))
    y2 isa AV || (y2 = fill(y2, length(x)))
    length(x) == length(y1) == length(y2) ||throw(
        DimensionMismatch("vectors x,y1,y2 must have matching lengths")
    )
    return (
        data = zip(x, y1, y2),
    )
end


"""
    hist_data(x)

I/ Preprocess data for a Hist2D.
Missing values are allowed but are not counted as observations.
"""
function hist_data(
            x::AV{<:CanMiss{<:Real}}
        )::NamedTuple

    isempty(x) && throw(
        ArgumentError("Cannot have a histogram with an empty vector.")
    )

    sx = skipmissing(x)
    isempty(sx) && throw(
        ArgumentError("Cannot have a histogram with only missing values")
    )
    return (
        data       = zip(x),
        hasmissing = (Missing <: eltype(x)),
        nobs       = sum(e -> 1, sx),
        range      = Float64.(extrema(sx))
    )
end


#################################################################################
#################################################################################


"""
    plot!(...)

E/ Add a plot. Keyword arguments can be passed to specify the linestyle(s),
label(s) and markerstyle(s).

## Example

    x = range(-2, 2, length=100)
    y = @. exp(-abs(x)+sin(x))
    plot(x, y,
         color  = "blue",
         lstyle = "--",
         marker = "o",
         lwidth = 0.05,
         label  = "First plot"
    )

"""
function plot!(
            x, ys...;
            #
            axes::Option{Axes2D} = nothing,
            overwrite::Bool      = false,
            o...
        )::DrawingHandle{<:Scatter2D}

    # are current axes empty?
    # -> if so don't do anything as the user may have pre-specified things
    #    like xlim etc and want the plot to appear with those
    # -> if it's not empty, reset the axes (will destroy xlim settings etc
    #    as it should)
    axes = check_axes(axes)
    if overwrite && !all(isempty, (axes.drawings, axes.objects))
        reset!(axes; parent=axes.parent)
    end

    # Form the scatter object
    pd      = plot_data(x, ys...)
    scatter = Scatter2D(pd.data, pd.hasmissing, pd.nobj)

    # Add properties & add scatter to axes
    set_properties!(scatter; o...)
    push!(axes.drawings, scatter)

    return DrawingHandle(scatter)
end

function plot!(
            f::Function,
            from::Real,
            to::Real;
            #
            length::Int = 100,
            o...
        )

    x = range(from, stop=to, length=length)
    plot!(x, f.(x); o...)
end

plot(a...; o...)     = plot!(a...;    overwrite=true, o...)
scatter!(a...; o...) = plot!(a...;    ls="none", marker=".", o...)
scatter(a...; o...)  = scatter!(a...; overwrite=true, o...)


"""
    fill_between!(...)

Add a fill plot between two lines. The arguments must not have missings but
`y1` and/or `y2` can be specified as single numbers (= horizontal line).
"""
function fill_between!(
            x, y1, y2;
            #
            axes::Option{Axes2D} = nothing,
            overwrite::Bool      = false,
            o...
        )::DrawingHandle{<:Fill2D}

    axes = check_axes(axes)
    if overwrite && !all(isempty, (axes.drawings, axes.objects))
        reset!(axes; parent=axes.parent)
    end

    # form the fill2d object
    fd   = fill_data(x, y1, y2)
    fill = Fill2D(fd)
    set_properties!(fill; o...)

    push!(axes.drawings, fill)
    return DrawingHandle(fill)
end

fill_between(a...; o...) = fill_between!(a...; overwrite=true, o...)


"""
    hist!(...)

Add a histogram of `x` on the current axes.
"""
function hist!(
            x;
            #
            axes::Option{Axes2D} = nothing,
            overwrite::Bool      = false,
            o...
        )::DrawingHandle{<:Hist2D}

    axes = check_axes(axes)
    if overwrite
        all(isempty, (axes.drawings, axes.objects)) || reset!(axes; parent=axes.parent)
    end

    hd   = hist_data(x)
    hist = Hist2D(hd.data, hd.hasmissing, hd.nobs, hd.range)
    set_properties!(hist; o...)

    push!(axes.drawings, hist)
    return DrawingHandle(hist)
end

hist(a...; o...)  = hist!(a...; overwrite=true, o...)


####
#### bar!, bar
####

"""
    bar!(...)

Add a bar plot.
"""
function bar!(
            x, ys...;
            #
            axes::Option{Axes2D} = nothing,
            overwrite::Bool      = false,
            o...
        )::DrawingHandle{<:Bar2D}

    axes = check_axes(axes)
    if overwrite
        all(isempty, (axes.drawings, axes.objects)) || reset!(axes; parent=axes.parent)
    end

    bd  = plot_data(x, ys...)
    bar = Bar2D(bd.data, bd.hasmissing, bd.nobj)
    set_properties!(bar; o...)

    push!(axes.drawings, bar)
    return DrawingHandle(bar)
end

bar(a...; o...) =  bar!(a...; overwrite=true, o...)


#################################################################################
#################################################################################
#
# Extra drawings that are not meant to be overlaid with anything
# else such as boxplot, heatmap, polarplot, pieplot
#

"""
    boxplot(...)

Erase previous drawings and add a boxplot. Missing values are allowed but not
Infinities or Nans.
"""
function boxplot(
            ys...;
            #
            axes::Option{Axes2D} = nothing,
            o...
        )::DrawingHandle{Boxplot}

    isempty(first(ys)) && throw(
        ArgumentError("Cannot display empty vectors.")
    )

    # always on fresh axes
    axes = check_axes(axes)
    reset!(axes; parent=axes.parent)

    # setting an empty struct first so that we can exploit the options
    # the actual data will be provided after analysis
    nobj = sum(size(y, 2) for y ∈ ys)
    bp = Boxplot(Matrix{Float64}(undef,0,0), nobj)
    set_properties!(bp; o...)

    # analyse data
    # 6 -> 1:wlow, 2:q25, 3:q50, 4:q75, 5:whigh, 6:mean
    stats    = Matrix{Float64}(undef, nobj, 6)
    outliers = Vector{Vector{Float64}}(undef, nobj)

    boxcounter = 1
    axmin      = Inf
    axmax      = -Inf

    for y ∈ ys
        for k ∈ Base.axes(y, 2)
            yk = collect(skipmissing(view(y, :, k)))
            if any(isnan, yk) || any(isinf, yk)
                throw(
                    ArgumentError("Inf or NaN values not allowed in boxplot.")
                )
            end

            q00, q25, q50, q75, q100 = quantile(yk, [.0, .25, .5, .75, 1.0])
            iqr = q75 - q25
            mu  = mean(yk)

            wrlength = bp.boxstyles[k].wrlength
            wlow  = q25 - wrlength * iqr
            whigh = q75 + wrlength * iqr
            if isinf(wrlength)
                wlow, whigh = q00, q100 # min/max values
            end

            stats[k, :] = [wlow, q25, q50, q75, whigh, mu]

            # outliers
            outliers[k] = filter(e->(e<wlow || whigh<e), yk)

            # Keep track of extremes to set axis limits afterwards
            axmin_ = min(q00, wlow)
            axmin_ -= 0.5abs(axmin_)
            axmin_ < axmin && (axmin = axmin_)
            axmax_ = max(q100, whigh)
            axmax_ += 0.5abs(axmax_)
            axmax_ > axmax && (axmax = axmax_)

            boxcounter += 1
        end
    end
    #
    bp.stats = stats
    push!(axes.drawings, bp)

    if bp.horiz # horizontal boxplot
        ylim(0, nobj+1)
        yticks(1:nobj)
        xlim(axmin, axmax)
        for k ∈ 1:nobj
            bp.boxstyles[k].oshow || continue
            nok = length(outliers[k])
            s = bp.boxstyles[k].omstyle # style of outliers
            if nok > 0
                scatter!(outliers[k], fill(k, nok); marker=s.marker, msize=s.msize, mcol=s.color)
            end
        end
    else # vertical boxplot
        xlim(0, nobj+1)
        xticks(1:nobj)
        ylim(axmin, axmax)
        for k ∈ 1:nobj
            bp.boxstyles[k].oshow || continue
            nok = length(outliers[k])
            s = bp.boxstyles[k].omstyle # style of outliers
            if nok > 0
                scatter!(fill(k, nok), outliers[k]; marker=s.marker, msize=s.msize, mcol=s.color)
            end
        end
    end
    return DrawingHandle(bp)
end


"""
    heatmap_ticks(ax)

Returns ticks position centered appropriately for a heatmap.

### Example

    heatmap(randn(2, 2))
    xticks(heatmap_ticks("x"), ["var1", "var2"]; angle=45)

"""
function heatmap_ticks(
            ax::String,
            axes::Axes2D
        )::Vector{F64}

    # it must necessarily be the first object since heatmap resets the axes
    (isempty(axes.drawings) || !(axes.drawings[1] isa Heatmap)) && throw(
        ArgumentError("No heatmap found.")
    )

    nrows, ncols = size(axes.drawings[1].data)
    ax_lc        = lowercase(ax)

    ax_lc ∈ ["x", "x2"] && return (collect(0:(ncols-1))    .+ 0.5) ./ ncols
    ax_lc ∈ ["y", "y2"] && return (collect((nrows-1):-1:0) .+ 0.5) ./ nrows

    throw(
        ArgumentError("""
            Unrecognised ax descriptor expected one of [x, x2, y, y2].
            """
        )
    )
end
heatmap_ticks(ax::String) = heatmap_ticks(ax, gca())


"""
    heatmap(X; opts...)

Creates a heatmap corresponding to matrix `X`. Doing this with matrices larger
than 100x100 with the GLE backend can be slow. As an indication, 500x500 takes
about 15-20 seconds on a standard laptop. Time scales with the number of elements
with, as a rough order of magnitude, around 10k elements per second.

You can provide ticks using `xticks(heatmap_ticks("x"), ["tick1", ...]; o...)`.
See also `heatmap_ticks`.

Note: handles missing values but not NaN or Inf.
"""
function heatmap(
            data::Matrix{<:CanMiss{Real}};
            #
            axes::Option{Axes2D} = nothing,
            o...
        )::DrawingHandle{Heatmap}

    nrows, ncols = size(data)
    min(nrows, ncols) <= 1000 || throw(
        ArgumentError(
            """
            The matrix is too large to be displayed as a heatmap.
            """
        )
    )

    # always on fresh axes
    axes = check_axes(axes)
    reset!(axes; parent=axes.parent)

    zmin, zmax = extrema(skipmissing(data))

    h = Heatmap(data=Matrix{Int}(undef, 0, 0), zmin=zmin, zmax=zmax)
    h.transpose = (nrows < ncols)
    set_properties!(h; o...)
    push!(axes.drawings, h)

    ncolors = length(h.cmap)

    minv, maxv = extrema(skipmissing(data))
    incr = (maxv - minv) / ncolors

    data2 = Matrix{Int}(undef, nrows, ncols)
    if iszero(incr)
        data2 .= ceil(ncols/2)
    else
        @inbounds for i=1:nrows, j=1:ncols
            dij = data[i,j]
            if ismissing(dij)
                data2[i,j] = ncolors + 1 # offset doesn't matter, anything ≥ 1 is fine
            else
                data2[i,j] = ceil(Integer, (dij - minv) / incr)
            end
        end
    end
    # NOTE: there may be a few 0 (min values), will be treated as 1 see add_sub_heatmap!

    # store the color assignments
    h.data = data2

    # set axis
    xlim(0,1); ylim(0,1)

    # add labels if provided to the heatmap object
    xplaces = heatmap_ticks("x")
    yplaces = heatmap_ticks("y")

    # used for sparse labelling in case ncols > 20
    stepx    = (ncols<=50)*10 + (50<ncols<=200)*50 + (200<ncols)*100
    lastx    = ncols - mod(ncols, stepx) + 1
    maskx    = collect(1:stepx:lastx) .- 1
    maskx[1] = 1
    stepy    = (nrows<=50)*10 + (50<nrows<=200)*50 + (200<nrows)*100
    lasty    = nrows - mod(nrows, stepy) + 1
    masky    = collect(1:stepy:lasty) .- 1
    masky[1] = 1

    if ncols <= 20
        xticks(xplaces, ["$i" for i ∈ 1:ncols]; axes=axes, fontsize=12)
    else
        xticks(xplaces[maskx], ["$i" for i ∈ maskx]; axes=axes, fontsize=12)
    end
    if nrows <= 20
        yticks(yplaces, ["$i" for i ∈ 1:nrows]; axes=axes, fontsize=12)
    else
        yticks(yplaces[masky], ["$i" for i ∈ masky]; axes=axes, fontsize=12)
    end
    x2ticks("off")
    y2ticks("off")
    return DrawingHandle(h)
end
