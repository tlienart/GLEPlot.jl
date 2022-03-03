include("../utils.jl")


@testset "tex_str" begin
    i = 5
    s = t"\$x+##i\$"
    @test s // "\\\$x+5\\\$"
end


@testset "col2str" begin
    c = "red"
    s = G.col2str(c)
    @test s // "red"
    c = colorant"red"
    s = G.col2str(c)
    @test s // "rgba(1.0,0.0,0.0,1.0)"
    s = G.col2str(c, str=true)
    @test s // "rgba_1_0_0_0_0_0_1_0_"
end


@testset "fl2str" begin
    s = G.fl2str(0.5555555)
    @test s // "0.5556"
    s = G.fl2str(Rational(1, 2))
    @test s // "0.5"
end


@testset "vec2str, dlist" begin
    s = G.vec2str(["ab", "cd"])
    @test s // "\"ab\" \"cd\""
    s = G.vec2str(["ab", "cd"]; sep=",")
    @test s // "\"ab\",\"cd\""

    @test G.vec2str([pi,pi,pi]) // "3.1416 3.1416 3.1416"

    @test G.dlist(1:3) // "d1 d2 d3"
end
