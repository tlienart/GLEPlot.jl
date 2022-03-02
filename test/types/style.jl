include("../utils.jl")


@testset "TextStyle" begin
    ts = G.TextStyle("hello", 0.5, c"red")
    @test ts isa G.Style
    @test fieldnames(typeof(ts)) == (:font, :hei, :color)
    @test ts.font  == "hello"
    @test ts.hei   == 0.5
    @test ts.color == c"red"

    # Everything optional
    G.reset!(ts)
    @test ts.font  == GLEPlot.GLE_DEFAULTS[:textstyle_font]
    @test ts.hei   == GLEPlot.GLE_DEFAULTS[:textstyle_hei]
    @test ts.color == GLEPlot.GLE_DEFAULTS[:textstyle_color]
end


@testset "LineStyle" begin
    # Everything optional
    ls = G.LineStyle(2, 1.3, true, c"red")
    @test ls isa G.Style
    @test fieldnames(typeof(ls)) == (:lstyle, :lwidth, :smooth, :color)
    @test ls.lstyle == 2
    @test ls.lwidth == 1.3
    @test ls.smooth === true
    @test ls.color == c"red"

    # Everything optional
    G.reset!(ls)
    @test !G.isanydef(ls)
end


@testset "MarkerStyle" begin
    ms = G.MarkerStyle("v", 2.0, c"red")
    @test ms isa G.Style
    @test fieldnames(typeof(ms)) == (:marker, :msize, :color)
    @test ms.marker == "v"
    @test ms.msize == 2.0
    @test ms.color == c"red"

    # Everything optional
    G.reset!(ms)
    @test !G.isanydef(ms)
end


@testset "BarStyle" begin
    bs = G.BarStyle(c"red", c"green")
    @test bs isa G.Style
    @test fieldnames(typeof(bs)) == (:color, :fill)
    @test bs.color == c"red"
    @test bs.fill == c"green"

    G.reset!(bs)
    @test G.isanydef(bs)
    @test bs.color === nothing
    @test bs.fill == G.GLE_DEFAULTS[:barstyle_fill]
end


@testset "FillStyle" begin
    fs = G.FillStyle(c"blue")
    @test fs isa G.Style
    @test fieldnames(typeof(fs)) == (:fill,)
    @test fs.fill == c"blue"

    G.reset!(fs)
    @test fs.fill == G.GLE_DEFAULTS[:fillstyle_fill]
end


@testset "BoxplotStyle" begin
    bs = G.BoxplotStyle(0.5, 0.5, 0.5,
            G.LineStyle(2, 0.5, false, c"red"),
            G.LineStyle(3, 1.5, false, c"green"),
            G.MarkerStyle("v", 0.5, c"blue"),
            G.MarkerStyle("o", 0.6, c"yellow"),
            false,
            false,
    )
    @test bs isa G.Style
    @test fieldnames(typeof(bs)) == (:bwidth, :wwidth, :wrlength, :blstyle, :mlstyle,
                                     :mmstyle, :omstyle, :mshow, :oshow)
    @test bs.bwidth == 0.5
    @test bs.wwidth == 0.5
    @test bs.wrlength == 0.5
    @test bs.blstyle.lstyle == 2
    @test bs.blstyle.lwidth == 0.5
    @test bs.blstyle.color == c"red"
    @test bs.mlstyle.lstyle == 3
    @test bs.mlstyle.lwidth == 1.5
    @test bs.mlstyle.color == c"green"
    @test bs.mshow == false
    @test bs.mmstyle.marker == "v"
    @test bs.mmstyle.msize == 0.5
    @test bs.mmstyle.color == c"blue"
    @test bs.oshow == false
    @test bs.omstyle.marker == "o"
    @test bs.omstyle.msize == 0.6
    @test bs.omstyle.color == c"yellow"

    G.reset!(bs)
    @test bs.bwidth == G.GLE_DEFAULTS[:boxplotstyle_bwidth]
    @test bs.wwidth == G.GLE_DEFAULTS[:boxplotstyle_wwidth]
    @test bs.wrlength == G.GLE_DEFAULTS[:boxplotstyle_wrlength]
    @test bs.blstyle.lstyle == G.GLE_DEFAULTS[:boxplotstyle_blstyle_lstyle]
    @test bs.blstyle.lwidth == G.GLE_DEFAULTS[:boxplotstyle_blstyle_lwidth]
    @test bs.blstyle.color == G.GLE_DEFAULTS[:boxplotstyle_blstyle_color]
    @test bs.mlstyle.lstyle == G.GLE_DEFAULTS[:boxplotstyle_mlstyle_lstyle]
    @test bs.mlstyle.color == G.GLE_DEFAULTS[:boxplotstyle_mlstyle_color]
    @test bs.mshow == G.GLE_DEFAULTS[:boxplotstyle_mshow]
    @test bs.oshow == G.GLE_DEFAULTS[:boxplotstyle_oshow]
    @test bs.mmstyle.marker==G.GLE_DEFAULTS[:boxplotstyle_mmstyle_marker]
    @test bs.mmstyle.msize==G.GLE_DEFAULTS[:boxplotstyle_mmstyle_msize]
    @test bs.mmstyle.color == G.GLE_DEFAULTS[:boxplotstyle_mmstyle_color]
    @test bs.omstyle.marker == G.GLE_DEFAULTS[:boxplotstyle_omstyle_marker]
    @test bs.omstyle.msize == G.GLE_DEFAULTS[:boxplotstyle_omstyle_msize]
    @test bs.omstyle.color == G.GLE_DEFAULTS[:boxplotstyle_omstyle_color]
end
