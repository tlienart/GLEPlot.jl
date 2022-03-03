abstract type Style end


mutable struct TextStyle <: Style
    font ::Option{String}
    hei  ::Option{F64}
    color::Option{String}
end
TextStyle() = default(TextStyle)


mutable struct LineStyle <: Style
    lstyle::Option{Int}
    lwidth::Option{F64}
    smooth::Option{Bool}
    color ::Option{String}
end
LineStyle() = default(LineStyle)


mutable struct MarkerStyle <: Style
    marker::Option{String}
    msize ::Option{F64}
    color ::Option{String}
end
MarkerStyle() = default(MarkerStyle)


mutable struct BarStyle <: Style
    color::Option{String}
    fill ::String
#   pattern::Option{String}   =  .... see page 39 of manual, test first
end
BarStyle() = default(BarStyle)


mutable struct FillStyle <: Style
    fill::String
end
FillStyle() = default(FillStyle)


mutable struct BoxplotStyle <: Style
    bwidth  ::F64          # width of the box
    wwidth  ::F64          # width of the whiskers
    wrlength::F64          # whisker length is wrlength * IQR, if INF will be min-max
    blstyle ::LineStyle    # box line style
    mlstyle ::LineStyle    # median line style
    mmstyle ::MarkerStyle  # mean marker style
    omstyle ::MarkerStyle  # outlier marker style
    mshow   ::Bool         # show the mean
    oshow   ::Bool         # show outliers
end
BoxplotStyle() = BoxplotStyle(
    GLE_DEFAULTS[:boxplotstyle_bwidth],
    GLE_DEFAULTS[:boxplotstyle_wwidth],
    GLE_DEFAULTS[:boxplotstyle_wrlength],
    LineStyle(
        GLE_DEFAULTS[:boxplotstyle_blstyle_lstyle],
        GLE_DEFAULTS[:boxplotstyle_blstyle_lwidth],
        false,
        GLE_DEFAULTS[:boxplotstyle_blstyle_color]
    ),
    LineStyle(
        GLE_DEFAULTS[:boxplotstyle_mlstyle_lstyle],
        GLE_DEFAULTS[:boxplotstyle_mlstyle_lwidth],
        false,
        GLE_DEFAULTS[:boxplotstyle_mlstyle_color]
    ),
    MarkerStyle(
        GLE_DEFAULTS[:boxplotstyle_mmstyle_marker],
        GLE_DEFAULTS[:boxplotstyle_mmstyle_msize],
        GLE_DEFAULTS[:boxplotstyle_mmstyle_color]
    ),
    MarkerStyle(
        GLE_DEFAULTS[:boxplotstyle_omstyle_marker],
        GLE_DEFAULTS[:boxplotstyle_omstyle_msize],
        GLE_DEFAULTS[:boxplotstyle_omstyle_color]
        ),
    GLE_DEFAULTS[:boxplotstyle_mshow],
    GLE_DEFAULTS[:boxplotstyle_oshow]
)
