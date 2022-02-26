using GLEPlot, Test
const G = GLEPlot

(//)(s1::String, s2::String) = strip(s1) == strip(s2)

isapproxstr(s1::AbstractString, s2::AbstractString) =
    isequal(map(s->replace(s, r"\s|\n"=>""), String.((s1, s2)))...)
