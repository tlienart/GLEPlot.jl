export @t_str, @tex_str

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


"""
    nosp(s)

I/ Remove all spaces, e.g. for rgba representation this is needed otherwise
GLE doesn't understand the string.
"""
nosp(s::String) = replace(s, " "=>"")


const BRACKETS_PAT = r"[\(\),\.]"

"""
    col2str(c, o; str)

I/ Return a GLE-compatible string representation of a color.
In the case of Markerstyle color with the relevant routine it is useful
to get a representation devoid of brackets, dots or dashes.
"""
function col2str(
            col::T,
            o::Option{Symbol} = nothing;
            #
            str::Bool =false
        )::String where T

    fnT = fieldnames(T)
    if fnT != (:r, :g, :b) && fnT != (:r, :g, :b, :alpha)
        op = isdef(o) ? " (given for option $o)" : ""
        @error """
            Given color '$col' does not match a known type. Expected a string or
            an object with :r, :g, :b (:alpha) fields$op.
            """
    end
    r, g, b  = Float64.((col.r, col.g, col.b))
    alpha    = :alpha in fnT ? Float64(col.alpha) : 1.0
    gle_rgba = "rgba($r,$g,$b,$alpha)"
    str || return gle_rgba
    return replace(gle_rgba, BRACKETS_PAT => "_")
end
col2str(col::String, o::Option{Symbol} = nothing; kw...) = lowercase(nosp(col))
col2str(::Nothing, o::Option{Symbol} = nothing; kw...)   = nothing

alpha(s::String)::Float64 =
    startswith(s, "rgba(") ?
    parse(Float64, split(strip(s, ')'), ',')[end]) :
    1.0


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
