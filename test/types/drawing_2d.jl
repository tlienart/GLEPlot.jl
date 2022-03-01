include("../utils.jl")


@testset "Scatter2D" begin
    d = [1 1; 2 2]
    s = G.Scatter2D(d, false, 1)
    @test s isa G.Drawing2D
    @test s isa G.Drawing
    @test s isa G.Scatter2D{Matrix{T}} where T
    @test s.hasmissing == false
    @test s.nobj == 1
    @test length(s.linestyles) == 1
    @test length(s.markerstyles) == 1
    @test isempty(s.labels)

    dh = G.DrawingHandle(s)
    @test dh isa G.DrawingHandle{G.Scatter2D{T}} where T
end


@testset "Fill2D" begin
    d = [1 1; 2 2]
    s = G.Fill2D(data=d, xmin=0.5)
    @test s isa G.Fill2D{Matrix{T}} where T
    @test s.xmin == 0.5
    @test !G.isdef(s.xmax)
    @test isempty(s.label)
end


@testset "Hist2D" begin
    d = [1 1; 2 2]
    s = G.Hist2D(data=d, hasmissing=false, nobs=3, range=(0.5,0.7))
    @test s isa G.Hist2D{Matrix{T}} where T
    @test s.hasmissing == false
    @test s.nobs == 3
    @test s.range == (0.5, 0.7)

    @test s.horiz == false
    @test s.bins == nothing
    @test s.scaling == "none"
    @test s.label == ""
end


@testset "Bar2D" begin
    d = [1 1; 2 2]
    s = G.Bar2D(d, false, 2)
    @test s isa G.Bar2D{Matrix{T}} where T
    @test length(s.barstyles) == 2
    @test s.stacked == false
    @test s.horiz == false
    @test s.bwidth === nothing
    @test isempty(s.labels)
end


@testset "Boxplot" begin
    d = [0.1 0.2; 0.3 0.4]
    b = G.Boxplot(d, 2)
    @test b isa G.Boxplot
    @test length(b.boxstyles) == b.nobj == 2
    @test b.horiz == false
end


@testset "Heatmap" begin
    d = [1 2; 1 2]
    h = G.Heatmap(data=d, zmin=0.1, zmax=0.2)
    @test h isa G.Heatmap
    @test h.zmin == 0.1
    @test h.zmax == 0.2
    @test length(h.cmap) == 10
    @test h.cmiss == c"white"
    @test h.transpose == false
end
