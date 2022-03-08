include("../utils.jl")


@testset "TextStyle" begin
    ts = G.TextStyle("hello", 0.5, "red")
    @test ts isa G.Style
    @test fieldnames(typeof(ts)) == (:font, :hei, :color)
    @test ts.font  == "hello"
    @test ts.hei   == 0.5
    @test ts.color == "red"

    # Everything optional
    G.reset!(ts)
    @test ts.font  == GLEPlot.DEFAULTS[:textstyle_font]
    @test ts.hei   == GLEPlot.DEFAULTS[:textstyle_hei]
    @test ts.color == GLEPlot.DEFAULTS[:textstyle_color]
end


@testset "LineStyle" begin
    # Everything optional
    ls = G.LineStyle(2, 1.3, true, "red")
    @test ls isa G.Style
    @test fieldnames(typeof(ls)) == (:lstyle, :lwidth, :smooth, :color)
    @test ls.lstyle == 2
    @test ls.lwidth == 1.3
    @test ls.smooth === true
    @test ls.color == "red"

    # Everything optional
    G.reset!(ls)
    @test !G.isanydef(ls)
end


@testset "MarkerStyle" begin
    ms = G.MarkerStyle("v", 2.0, "red")
    @test ms isa G.Style
    @test fieldnames(typeof(ms)) == (:marker, :msize, :color)
    @test ms.marker == "v"
    @test ms.msize == 2.0
    @test ms.color == "red"

    # Everything optional
    G.reset!(ms)
    @test !G.isanydef(ms)
end


@testset "BarStyle" begin
    bs = G.BarStyle("red", "green")
    @test bs isa G.Style
    @test fieldnames(typeof(bs)) == (:color, :fill)
    @test bs.color == "red"
    @test bs.fill == "green"

    G.reset!(bs)
    @test G.isanydef(bs)
    @test bs.color === nothing
    @test bs.fill == G.DEFAULTS[:barstyle_fill]
end


@testset "FillStyle" begin
    fs = G.FillStyle("blue")
    @test fs isa G.Style
    @test fieldnames(typeof(fs)) == (:fill,)
    @test fs.fill == "blue"

    G.reset!(fs)
    @test fs.fill == G.DEFAULTS[:fillstyle_fill]
end


@testset "BoxplotStyle" begin
    bs = G.BoxplotStyle(0.5, 0.5, 0.5,
            G.LineStyle(2, 0.5, false, "red"),
            G.LineStyle(3, 1.5, false, "green"),
            G.MarkerStyle("v", 0.5, "blue"),
            G.MarkerStyle("o", 0.6, "yellow"),
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
    @test bs.blstyle.color == "red"
    @test bs.mlstyle.lstyle == 3
    @test bs.mlstyle.lwidth == 1.5
    @test bs.mlstyle.color == "green"
    @test bs.mshow == false
    @test bs.mmstyle.marker == "v"
    @test bs.mmstyle.msize == 0.5
    @test bs.mmstyle.color == "blue"
    @test bs.oshow == false
    @test bs.omstyle.marker == "o"
    @test bs.omstyle.msize == 0.6
    @test bs.omstyle.color == "yellow"

    G.reset!(bs)
    @test bs.bwidth == G.DEFAULTS[:boxplotstyle_bwidth]
    @test bs.wwidth == G.DEFAULTS[:boxplotstyle_wwidth]
    @test bs.wrlength == G.DEFAULTS[:boxplotstyle_wrlength]
    @test bs.blstyle.lstyle == G.DEFAULTS[:boxplotstyle_blstyle_lstyle]
    @test bs.blstyle.lwidth == G.DEFAULTS[:boxplotstyle_blstyle_lwidth]
    @test bs.blstyle.color == G.DEFAULTS[:boxplotstyle_blstyle_color]
    @test bs.mlstyle.lstyle == G.DEFAULTS[:boxplotstyle_mlstyle_lstyle]
    @test bs.mlstyle.color == G.DEFAULTS[:boxplotstyle_mlstyle_color]
    @test bs.mshow == G.DEFAULTS[:boxplotstyle_mshow]
    @test bs.oshow == G.DEFAULTS[:boxplotstyle_oshow]
    @test bs.mmstyle.marker==G.DEFAULTS[:boxplotstyle_mmstyle_marker]
    @test bs.mmstyle.msize==G.DEFAULTS[:boxplotstyle_mmstyle_msize]
    @test bs.mmstyle.color == G.DEFAULTS[:boxplotstyle_mmstyle_color]
    @test bs.omstyle.marker == G.DEFAULTS[:boxplotstyle_omstyle_marker]
    @test bs.omstyle.msize == G.DEFAULTS[:boxplotstyle_omstyle_msize]
    @test bs.omstyle.color == G.DEFAULTS[:boxplotstyle_omstyle_color]
end
