export @t_str, @tex_str, @c_str

const TEX_STR_PAT  = r"##([_\p{L}](?:[\p{L}\d_]*))"

"""
    tex_str(s)

E/ Allows use of \$ and \\ while also allowing interpolation via `##name`.
This is useful for labels that contain tex-like expressions that may be
generated in a sequence.
"""
macro tex_str(s)
    m = match(TEX_STR_PAT, s)
    m === nothing && return s
    v = Symbol(m.captures[1])
    esc(:(replace($s, $TEX_STR_PAT => string(eval($v)))))
end

@eval const $(Symbol("@t_str")) = $(Symbol("@tex_str"))
@eval const $(Symbol("@c_str")) = $(Symbol("@colorant_str"))


const BRACKETS_PAT = r"[\(\),\.]"

"""
    col2str(c; str)

I/ Return a GLE-compatible string representation of a color.
In the case of Markerstyle color with the relevant routine it is useful
to get a representation devoid of brackets, dots or dashes.
"""
function col2str(
            col::Colorant;
            str=false
        )::String

    crgba = convert(RGBA, col)
    r, g, b, α = fl2str.(Float64.((crgba.r, crgba.g, crgba.b, crgba.alpha)))
    s = "rgba($r,$g,$b,$α)"
    str || return s
    return replace(s, BRACKETS_PAT => "_")
end


"""
    fl2str(f; d)

I/ Round a float `f` to `d` digits after the decimals and return the string.
"""
function fl2str(
            f::Float64;
            d::Int=4
        )::String

    return string(round(f, digits=d))
end
fl2str(r::Real; kw...) = fl2str(Float64(r); kw...)


"""
    vec2str(v; sep)

I/ GLE-compatible string representation of a vector.
"""
vec2str(v::AV{String}; sep=" ") = join(("\"$vi\""  for vi in v), sep)
vec2str(v::AV{<:Real}; sep=" ") = join(fl2str.(v), sep)
dlist(rge::UnitRange;  sep=" ") = join(("d$i" for i in rge), sep)
