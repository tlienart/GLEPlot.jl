"""
    p1 / p2

I/ Acts as joinpath.
"""
(/)(s...) = joinpath(s...)


"""
    isdef(el)
    isanydef(obj)

I/ Check if something is defined (not nothing). Check if any field of an
object is defined.
"""
isdef(el)     = (el !== nothing)
isanydef(obj) = any(isdef, (getfield(obj, f) for f ∈ fieldnames(typeof(obj))))


"""
    reset!(obj; exclude, inits...)

I/ Reset a mutable object of type `T` by creating a "fresh" object calling the
constructor `T(; inits...)` and copying the fields of that fresh object into
the from those in `exclude`
"""
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


"""
    nvec(n, T)

I/ Create a `Vector{T}` with `n`
"""
nvec(n::Int, T) = [T() for _ ∈ 1:n]


const GLE_INVALID_PAT = r"missing|NaN|Inf"

"""
    csv_writer(path, z)

I/ Write data `z` to `path`.
"""
function csv_writer(
            path::String,
            z,
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
        write(path, replace(temps, GLE_INVALID_PAT => "?"))
    else
        writedlm(path, z)
    end
    return
end



# #
# # "robust" min/max which allow comparison with nothing
# #
#
# rmin(x,::Nothing)  = x
# rmin(::Nothing, y) = y
# rmin(x, y)         = min(x, y)
#
# rmax(x,::Nothing)  = x
# rmax(::Nothing, y) = y
# rmax(x, y)         = max(x, y)
#
# #
# # return a number with 3 digits accuracy, useful in col2str
# #
# round3d(x::Real) = round(x, digits=3)
#
# #
# # takes a colorant and transform it to a standard string rgba(...)
# #
#
# #


#
#
# """
#     palette(v::Vector{Color})
#
# Set the default palette. To see the current one, write `GPlot.GP_ENV["PALETTE"]` in the REPL.
# """
# set_palette(v::Vector{<:Color}) = (GP_ENV["PALETTE"] = v;)
#
# """
#     continuous_preview(b)
#
# Set the continuous preview on (`b=true`, default value) or off.
# """
# continuous_preview(b::Bool) = (GP_ENV["CONT_PREVIEW"] = b;)
