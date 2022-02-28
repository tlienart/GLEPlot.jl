using GLEPlot, Test, Colors
const G = GLEPlot

import Base: (//)

(//)(s1::String, s2::String) = strip(s1) == strip(s2)

isapproxstr(s1::AbstractString, s2::AbstractString) =
    isequal(map(s->replace(s, r"\s|\n"=>""), String.((s1, s2)))...)


function m2b(a,b)
    ismissing(a) && ismissing(b) && return true
    isinf(a) && isinf(b) && return true
    isnan(a) && isnan(b) && return true
    return (a == b)
end

function checkzip(z, v::VecOrMat)
    for (zi, vi) ∈ zip(z, eachrow(v))
      all(m2b(zi[j], vi[j]) for j ∈ eachindex(vi)) || begin
            @show zi
            @show vi
            return false
        end
    end
    return true
end
