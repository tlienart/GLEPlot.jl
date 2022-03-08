include("../utils.jl")


@testset "GLEScript" begin
    g = G.GS()
    G.gsave(g)
    G.grestore(g)
    @test isapproxstr(String(take!(g)), "gsave grestore")

    "foo" |> g
    @test String(take!(g)) // "foo"

    g2 = G.GS()
    "foo" |> (g, g2)
    @test String(take!(g)) // String(take!(g2))

    "bar" |> g2
    g2 |> g
    @test String(take!(g)) // "bar"
end
