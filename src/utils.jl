"""
    p1 / p2

Acts as joinpath.
"""
(/)(s...) = joinpath(s...)


isdef(el) = (el !== nothing)

# check if object `obj` has at least one field that is not "Nothing"
# this is useful when dealing with objects with lots of "Optional" fields
isanydef(obj) = any(isdef, (getfield(obj, f) for f ∈ fieldnames(typeof(obj))))

# see cla! (clear axes)
function reset!(
            obj::T;
            exclude=Symbol[],
            inits...
        )::T where T

    # create a new object of the same type, assumes there is
    # a constructor that accepts empty input
    fresh = T(; inits...)
    for fn ∈ fieldnames(T)
        fn ∈ exclude && continue
        # set all fields to the field value given by the default
        # constructor (but keeps the address of the parent object)
        setfield!(obj, fn, deepcopy(getfield(fresh, fn)))
    end
    return obj
end

#
# "robust" min/max which allow comparison with nothing
#

rmin(x,::Nothing)  = x
rmin(::Nothing, y) = y
rmin(x, y)         = min(x, y)

rmax(x,::Nothing)  = x
rmax(::Nothing, y) = y
rmax(x, y)         = max(x, y)

#
# return a number with 3 digits accuracy, useful in col2str
#
round3d(x::Real) = round(x, digits=3)

#
# takes a colorant and transform it to a standard string rgba(...)
#
function col2str(
            col::Colorant;
            str=false
        )::String

    crgba = convert(RGBA, col)
    r, g, b, α = round3d.([crgba.r, crgba.g, crgba.b, crgba.alpha])
    s  = "rgba($r,$g,$b,$α)"
    # used by str(markerstyle), remove things that confuse gle
    sr = replace(s, r"[\(\),\.]"=>"_")
    return ifelse(str, sr, s)
end

#
# takes a Float64 and output a short string representation
#
function fl2str(
            f::Float64;
            d::Int=4
        )::String

    return string(round(f, digits=d))
end

#
# unroll a vector into a string with the elements separated by a space
#
vec2str(v::AV{String}, sep=" ")     = join(("\"$vi\""  for vi in v), sep)
vec2str(v::AV; sep=" ")             = join((string(vi) for vi in v), sep)
vec2str(v::Base.Generator, sep=" ") = join((string(vi) for vi in v), sep)

dlist(rge::UnitRange, sep=" ")  = vec2str(("d$i" for i in rge), sep)

#
# call a constructor n times and return a vector of instances
#
nvec(n::Int, T) = [T() for _ ∈ 1:n]

#
# Materialise an array/matrix to file
#
function csv_writer(
            path::String,
            z::AVM,
            hasmissing::Bool
        )::Nothing

    dirpath = splitdir(path)[1]
    isdir(dirpath) || mkpath(dirpath)
    if hasmissing
        tempio = IOBuffer()
        writedlm(tempio, z)
        # NOTE assumes it's fine to materialize the buffer with huge arrays
        # it's probably not ideal but in general should be fine, huge arrays
        # are more likely to happen with 3D objects (mesh) which are somewhat
        # less likely to have missings
        temps = String(take!(tempio))
        write(path, replace(temps, r"missing|NaN|Inf"=>"?"))
    else
        writedlm(path, z)
    end
    return
end


"""
    tex_str(s)

Allows use of \$ and \\ while also allowing interpolation via `##name`. This is useful
for labels that contain tex-like expressions that may be generated in a sequence.

### Example

```julia
 i=5
t"\$x+##i\$" # amounts to "\$x+5\$"
```
"""
macro tex_str(s)
    m = match(r"##([_\p{L}](?:[\p{L}\d_]*))", s)
    m === nothing && return s
    v = Symbol(m.captures[1])
    esc(:(replace($s, r"##([_\p{L}](?:[\p{L}\d_]*))"=>string(eval($v)))))
end

@eval const $(Symbol("@t_str")) = $(Symbol("@tex_str"))
@eval const $(Symbol("@c_str")) = $(Symbol("@colorant_str"))


"""
    palette(v::Vector{Color})

Set the default palette. To see the current one, write `GPlot.GP_ENV["PALETTE"]` in the REPL.
"""
set_palette(v::Vector{<:Color}) = (GP_ENV["PALETTE"] = v;)

"""
    continuous_preview(b)

Set the continuous preview on (`b=true`, default value) or off.
"""
continuous_preview(b::Bool) = (GP_ENV["CONT_PREVIEW"] = b;)
