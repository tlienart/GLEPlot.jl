abstract type Style end

@with_kw mutable struct TextStyle <: Style
    font ::Option{String}  = ∅
    hei  ::Option{F64}     = ∅
    color::Option{Color}   = ∅
end

@with_kw mutable struct LineStyle <: Style
    lstyle::Option{Int}   = ∅
    lwidth::Option{F64}   = ∅
    smooth::Option{Bool}  = ∅
    color ::Option{Color} = ∅
end

@with_kw mutable struct MarkerStyle <: Style
    marker::Option{String} = ∅
    msize::Option{F64}     = ∅
    color::Option{Color}   = ∅
end

@with_kw mutable struct BarStyle <: Style
    color::Option{Color}    = ∅
    fill::Colorant          = colorant"white"
#   pattern::Option{String}   =  .... see page 39 of manual, test first
end

@with_kw mutable struct FillStyle <: Style
    fill::Colorant = colorant"cornflowerblue"
end

@with_kw mutable struct BoxplotStyle <: Style
    # box and whisker styling
    bwidth::F64   = 0.6 # width of the box
    wwidth::F64   = 0.3 # width of the whiskers
    wrlength::F64 = 1.5 # whisker length is wrlength * IQR, if INF will be min-max
    blstyle::LineStyle = LineStyle(lstyle=1, lwidth=0, color=c"black")
    # median
    mlstyle::LineStyle = LineStyle(lstyle=1, lwidth=0, color=c"seagreen")
    # mean
    mshow::Bool          = true
    mmstyle::MarkerStyle = MarkerStyle(marker="fdiamond", msize=.4, color=c"dodgerblue")
    # outliers
    oshow::Bool          = true
    omstyle::MarkerStyle = MarkerStyle(marker="+", msize=.5, color=c"tomato")
end
