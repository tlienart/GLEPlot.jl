mutable struct Figure{B<:Backend}
    # NOTE: couldn't use @kw_args here, clashed with the format of the base constructor.
    g ::B      # description buffer
    id::String # id of the figure
    # ---
    axes     ::Vector{Axes{B}}   # subplots
    size     ::T2F               # (width, heigth)
    textstyle::TextStyle         # parent font etc
    bgcolor  ::Option{Colorant}  # background col, nothing=transparent
    # ---
    texlabels   ::Option{Bool}   # true if has tex
    texscale    ::Option{String} # scale latex * hei (def=1)
    texpreamble ::Option{String} # latex preamble
    transparency::Option{Bool}   # if true, use cairo device
    # ---
    subroutines::Dict{String,String}
end
Figure(g::Backend, id::String) =
    Figure(
        g, id,
        # --
        Vector{Axes{B}}(),
        (12., 9.),
        TextStyle(font="texcmss", hei=0.35),
        c"white",
        # --
        ∅,
        ∅,
        ∅,
        ∅,
        # --
        Dict{String,String}()
    )

"""
    reset!(f)

Internal function to completely refresh the figure `f` only keeping its id and size.
"""
function reset!(f::Figure{B}) where B
    take!(f.g) # empty the buffer
    f.axes         = Vector{Axes{B}}() # clean axes
    f.textstyle    = TextStyle(font="texcmss", hei=0.35) # default fontstyle
    f.bgcolor      = c"white" # default bg color
    f.texlabels    = ∅
    f.texscale     = ∅
    f.texpreamble  = ∅
    f.transparency = ∅
    f.subroutines  = Dict{String,String}()
    GP_ENV["CURFIG"]  = f
    GP_ENV["CURAXES"] = nothing
    return f
end
