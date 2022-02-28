include("../utils.jl")

@testset "plotdata" begin
    # data / hasmissing / nobj
    x = [5.0, missing, missing, 3.0, 2.0]
    d, h, n = G.plotdata(x)
    @test h == true
    @test n == 1
    @test checkzip(d, hcat(1:length(x), x))

    y       = hcat([2.0, missing, 3.0, Inf, 2.0], [1.0, 2.0, NaN, 0, 1.0])
    d, h, n = G.plotdata(x, y)
    @test h == true
    @test n == 2
    @test checkzip(d, hcat(x, y))

    # -- errors --
    @test_throws ArgumentError G.plotdata([])
    @test_throws ArgumentError G.plotdata([], [1,2])
    @test_throws ArgumentError G.plotdata("hello")
    @test_throws ArgumentError G.plotdata([1,2], "hello")
    @test_throws DimensionMismatch G.plotdata([1,2],[3,4,5])
end

@testset "filldata" begin
end

@testset "histdata" begin
end

@testset "plot" begin
    p = plot([1,2],[3,4])
    @test p isa G.DrawingHandle{<:G.Scatter2D}
    s = p.drawing
    @test checkzip(s.data, [1 3; 2 4])
    @test s.nobj == 1
    @test s.hasmissing == false
end

@testset "fill_between" begin
end

@testset "hist" begin
end

@testset "bar" begin
end

@testset "boxplot" begin
end

@testset "heatmap_ticks" begin
end

@testset "heatmap" begin
end
