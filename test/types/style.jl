include("../utils.jl")

@testset "TextStyle" begin
    ts = G.TextStyle(
        font="hello",
        hei=0.5,
        color=colorant"red"
    )
    @test ts isa G.Style
    @test fieldnames(typeof(ts)) == (:font, :hei, :color)
    @test ts.font  == "hello"
    @test ts.hei   == 0.5
    @test ts.color == colorant"red"

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
        color = colorant"red"
    )
    @test ls isa G.Style
    @test fieldnames(typeof(ls)) == (:lstyle, :lwidth, :smooth, :color)
    @test ls.lstyle == 2
    @test ls.lwidth == 1.3
    @test ls.smooth === true
    @test ls.color == colorant"red"

    # Everything optional
    G.reset!(ls)
    @test !G.isanydef(ls)
end

@testset "MarkerStyle" begin
    ms = G.MarkerStyle(
        marker = "v",
        msize = 2.0,
        color = colorant"red"
    )
    @test ms isa G.Style
    @test fieldnames(typeof(ms)) == (:marker, :msize, :color)
    @test ms.marker == "v"
    @test ms.msize == 2.0
    @test ms.color == colorant"red"

    # Everything optional
    G.reset!(ms)
    @test !G.isanydef(ms)
end

@testset "BarStyle" begin
    bs = G.BarStyle(
        color = colorant"red",
        fill = colorant"green"
    )
    @test bs isa G.Style
    @test fieldnames(typeof(bs)) == (:color, :fill)
    @test bs.color == colorant"red"
    @test bs.fill == colorant"green"

    G.reset!(bs)
    @test G.isanydef(bs)
    @test bs.color === nothing
    @test bs.fill == colorant"white"
end

@testset "FillStyle" begin
    fs = G.FillStyle(
        fill = colorant"blue"
    )
    @test fs isa G.Style
    @test fieldnames(typeof(fs)) == (:fill,)
    @test fs.fill == colorant"blue"

    G.reset!(fs)
    @test fs.fill == colorant"cornflowerblue"
end

@testset "BoxplotStyle" begin
    bs = G.BoxplotStyle(
        bwidth = 0.5,
        wwidth = 0.5,
        wrlength = 0.5,
        blstyle = G.LineStyle(lstyle=2, lwidth=0.5, color=colorant"red"),
        mlstyle = G.LineStyle(lstyle=3, lwidth=1.5, color=colorant"green"),
        mshow = false,
        mmstyle = G.MarkerStyle(marker="v", msize=0.5, color=colorant"blue"),
        oshow = false,
        omstyle = G.MarkerStyle(marker="o", msize=0.6, color=colorant"yellow")
    )
    @test bs isa G.Style
    @test fieldnames(typeof(bs)) == (:bwidth, :wwidth, :wrlength, :blstyle, :mlstyle,
                                     :mshow, :mmstyle, :oshow, :omstyle)
    @test bs.bwidth == 0.5
    @test bs.wwidth == 0.5
    @test bs.wrlength == 0.5
    @test bs.blstyle.lstyle == 2
    @test bs.blstyle.lwidth == 0.5
    @test bs.blstyle.color == colorant"red"
    @test bs.mlstyle.lstyle == 3
    @test bs.mlstyle.lwidth == 1.5
    @test bs.mlstyle.color == colorant"green"
    @test bs.mshow == false
    @test bs.mmstyle.marker == "v"
    @test bs.mmstyle.msize == 0.5
    @test bs.mmstyle.color == colorant"blue"
    @test bs.oshow == false
    @test bs.omstyle.marker == "o"
    @test bs.omstyle.msize == 0.6
    @test bs.omstyle.color == colorant"yellow"

    G.reset!(bs)
    @test bs.bwidth == 0.6
    @test bs.wwidth == 0.3
    @test bs.wrlength == 1.5
    @test bs.blstyle.lstyle == 1
    @test bs.blstyle.lwidth == 0
    @test bs.blstyle.color == colorant"black"
    @test bs.mlstyle.lstyle == 1
    @test bs.mlstyle.color == colorant"seagreen"
    @test bs.mshow
    @test bs.oshow
    @test bs.mmstyle.marker=="fdiamond"
    @test bs.mmstyle.msize==0.4
    @test bs.mmstyle.color == colorant"dodgerblue"
    @test bs.omstyle.marker == "+"
    @test bs.omstyle.msize == 0.5
    @test bs.omstyle.color == colorant"tomato"
end
