"""
    Drawing

Overarching type for drawings displayable on `Axes`.
"""
abstract type Drawing end


"""
    DrawingHandle{C<:Drawing}

Container object for a drawing returned by any plotting function.
"""
struct DrawingHandle{D<:Drawing}
    drawing::D
end


"""
    Drawing

Overarching type for drawings displayable on `Axes2D`.
"""
abstract type Drawing2D <: Drawing end


#
# Scatter2D, Fill2D, ...
#


"""
    Scatter2D <: Drawing2D

2D Line plot(s) or scatter plot(s).
See also `plot!`, `line!` and `scatter!`.
"""
mutable struct Scatter2D{T} <: Drawing2D
    data        ::T                   # data container (zip; T = trick to avoid failure on 1.0)
    hasmissing  ::Bool                # whether there are missing|inf|nan data
    nobj        ::Int                 # number of objects
    linestyles  ::Vector{LineStyle}   # line style (color, width, ...)
    markerstyles::Vector{MarkerStyle} # marker style (color, size, ...)
    labels      ::Vector{String}      # plot labels (to go in the legend)
end
Scatter2D(d, m, n) = Scatter2D(
    d, m, n,
    nvec(n, LineStyle,   "scatter2d_linestyles"),
    nvec(n, MarkerStyle, "scatter2d_markerstyles"),
    String[]
)


"""
    Fill2D <: Drawing2D

Fill-plot between two 2D curves. Missing values are not allowed.
See `fill_between!`.
"""
mutable struct Fill2D{T} <: Drawing2D
    data     ::T  # data iterator
    #
    xmin     ::Option{F64}  # left most anchor
    xmax     ::Option{F64}  # right most anchor
    fillstyle::FillStyle    # describes the area between the curves
    label    ::String
end
Fill2D(d, xmin=nothing, xmax=nothing) = Fill2D(
    d, xmin, xmax,
    FillStyle(),
    ""
)


"""
    Hist2D <: Drawing2D

Histogram.
"""
mutable struct Hist2D{T} <: Drawing2D
    data      ::T     # data container
    hasmissing::Bool  # whether has missing|inf|nan data
    nobs      ::Int   # number of non-missing entries
    range     ::T2F   # (minvalue, maxvalue)
    #
    barstyle::BarStyle     #
    horiz   ::Bool         # horizontal histogram?
    bins    ::Option{Int}  # number of bins
    scaling ::String       # scaling (pdf, count=none, probability)
    label   ::String
end
Hist2D(d, m, n, r) = Hist2D(
    d, m, n, r, BarStyle(),
    DEFAULTS[:hist2d_horiz],
    DEFAULTS[:hist2d_bins],
    DEFAULTS[:hist2d_scaling],
    DEFAULTS[:hist2d_label],
)


"""
    Bar2D <: Drawing2D

Bar plot(s).
"""
mutable struct Bar2D{T} <: Drawing2D
    data      ::T               # data container
    hasmissing::Bool            # whether has missing|inf|nan
    nobj      ::Int
    barstyles ::Vector{BarStyle}
    #
    stacked::Bool
    horiz  ::Bool
    bwidth ::Option{F64}  # general bar width
    labels ::Vector{String}
end
Bar2D(d, m, n) = Bar2D(
    d, m, n, nvec(n, BarStyle),
    DEFAULTS[:bar2d_stacked],
    DEFAULTS[:bar2d_horiz],
    DEFAULTS[:bar2d_bwidth],
    DEFAULTS[:bar2d_labels],
)


"""
    Boxplot <: Drawing2D

Boxplot(s).
"""
mutable struct Boxplot <: Drawing2D
    stats    ::Matrix{F64}  # quantile etc
    nobj     ::Int
    boxstyles::Vector{BoxplotStyle}
    #
    horiz::Bool # vertical boxplots by default
end
Boxplot(d, n) = default(Boxplot, d, n, nvec(n, BoxplotStyle))


"""
    Heatmap <: Drawing2D

Heatmap of a matrix.
"""
mutable struct Heatmap <: Drawing2D
    data::Matrix{Int}
    zmin::F64
    zmax::F64
    #
    cmap::Vector{String}
    cmiss::String # box filling for missing values
    # transpose
    # whether to write the matrix as a transpose
    # this is useful because GLE can deal only with 1000-cols
    # files at most (at least with the way we do the heatmap now)
    transpose::Bool
end
Heatmap(d, zmin, zmax) = default(Heatmap, d, zmin, zmax)
