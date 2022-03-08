include("../utils.jl")


@testset "plot_data" begin
    # data / hasmissing / nobj
    x = [5.0, missing, missing, 3.0, 2.0]
    d, h, n = G.plot_data(x)
    @test h == true
    @test n == 1
    @test checkzip(d, hcat(1:length(x), x))

    y       = hcat([2.0, missing, 3.0, Inf, 2.0], [1.0, 2.0, NaN, 0, 1.0])
    d, h, n = G.plot_data(x, y)
    @test h == true
    @test n == 2
    @test checkzip(d, hcat(x, y))

    # -- errors --
    @test_throws ArgumentError G.plot_data([])
    @test_throws ArgumentError G.plot_data([], [1,2])
    @test_throws ArgumentError G.plot_data("hello")
    @test_throws ArgumentError G.plot_data([1,2], "hello")
    @test_throws DimensionMismatch G.plot_data([1,2],[3,4,5])
end


@testset "fill_data" begin
    x = 1:1:10
    y1 = @. exp(x)
    y2 = @. sin(x)
    d, = G.fill_data(x,y1,y2)
    @test checkzip(d, hcat(x,y1,y2))

    # -- errors --
    @test_throws ArgumentError G.fill_data(Real[], Real[], Real[])
    @test_throws DimensionMismatch G.fill_data([0.1,0.2],[0.1,0.2],[0.2])
end


@testset "hist_data" begin
    x = [1, 2, missing, 5]
    d, h, n, r = G.hist_data(x)
    @test checkzip(d, x)
    @test h == true
    @test n == 3
    @test r == (1.0, 5.0)

    @test_throws ArgumentError G.hist_data(Real[])
    @test_throws ArgumentError G.hist_data([missing, missing])
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
