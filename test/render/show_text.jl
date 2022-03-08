include("../utils.jl")


@testset "Axes2D" begin
    p = plot([1,2],[3,4])

    a  = gca()
    io = IOBuffer()
    show(io, MIME("text/plain"), a)
    s  = String(take!(io))

    @test isapproxstr(s, """
        GLEPlot.Axes2D
            Title:         none
            N. drawings:   1
            N. objects:    0
            Math mode:     false
            Layout origin: auto
        """)
end

@testset "Figure" begin
    p  = plot([1,2],[3,4])
    f  = gcf()

    io = IOBuffer()
    show(io, MIME("text/plain"), f)
    s  = String(take!(io))

    @test isapproxstr(s, """
        GLEPlot.Figure
            Name:          default ("_fig_")
            Size:          (12.0, 9.0)
            Bg. color:     white
            N. axes:       1
            LaTeX:         false
            Transparent:   false
        """
    )
end
