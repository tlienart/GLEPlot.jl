include("../utils.jl")


@testset "TextStyle" begin
    ts = G.TextStyle(
        font="hello",
        hei=0.5,
        color=c"red"
    )
    @test ts isa G.Style
    @test fieldnames(typeof(ts)) == (:font, :hei, :color)
    @test ts.font  == "hello"
    @test ts.hei   == 0.5
    @test ts.color == c"red"

    # Everything optional
    G.reset!(ts)
    @test !G.isanydef(ts)
end


@testset "LineStyle" begin
    # Everything optional
    ls = G.LineStyle(
        lstyle = 2,
        lwidth = 1.3,
        smooth = true,
        color = c"red"
    )
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
    ms = G.MarkerStyle(
        marker = "v",
        msize = 2.0,
        color = c"red"
    )
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
    bs = G.BarStyle(
        color = c"red",
        fill = c"green"
    )
    @test bs isa G.Style
    @test fieldnames(typeof(bs)) == (:color, :fill)
    @test bs.color == c"red"
    @test bs.fill == c"green"

    G.reset!(bs)
    @test G.isanydef(bs)
    @test bs.color === nothing
    @test bs.fill == c"white"
end


@testset "FillStyle" begin
    fs = G.FillStyle(
        fill = c"blue"
    )
    @test fs isa G.Style
    @test fieldnames(typeof(fs)) == (:fill,)
    @test fs.fill == c"blue"

    G.reset!(fs)
    @test fs.fill == c"cornflowerblue"
end


@testset "BoxplotStyle" begin
    bs = G.BoxplotStyle(
        bwidth = 0.5,
        wwidth = 0.5,
        wrlength = 0.5,
        blstyle = G.LineStyle(lstyle=2, lwidth=0.5, color=c"red"),
        mlstyle = G.LineStyle(lstyle=3, lwidth=1.5, color=c"green"),
        mmstyle = G.MarkerStyle(marker="v", msize=0.5, color=c"blue"),
        omstyle = G.MarkerStyle(marker="o", msize=0.6, color=c"yellow"),
        mshow = false,
        oshow = false,
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
    @test bs.bwidth == 0.6
    @test bs.wwidth == 0.3
    @test bs.wrlength == 1.5
    @test bs.blstyle.lstyle == 1
    @test bs.blstyle.lwidth == 0
    @test bs.blstyle.color == c"black"
    @test bs.mlstyle.lstyle == 1
    @test bs.mlstyle.color == c"seagreen"
    @test bs.mshow
    @test bs.oshow
    @test bs.mmstyle.marker=="fdiamond"
    @test bs.mmstyle.msize==0.4
    @test bs.mmstyle.color == c"dodgerblue"
    @test bs.omstyle.marker == "+"
    @test bs.omstyle.msize == 0.5
    @test bs.omstyle.color == c"tomato"
end
