mutable struct Figure
    # NOTE: couldn't use @kw_args here, clashed with the format of the base constructor.
    g ::GS     # description buffer
    id::String # id of the figure
    # ---
    axes     ::Vector{Axes}   # subplots
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
Figure(g::GS, id::String) =
    Figure(
        g, id,
        # --
        Vector{Axes}(),
        (12., 9.),
        TextStyle(),
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
function reset!(f::Figure)
    take!(f.g) # empty the buffer
    f.axes         = Vector{Axes}() # clean axes
    f.textstyle    = TextStyle(font="texcmss", hei=0.35) # default fontstyle
    f.bgcolor      = c"white" # default bg color
    f.texlabels    = ∅
    f.texscale     = ∅
    f.texpreamble  = ∅
    f.transparency = ∅
    f.subroutines  = Dict{String,String}()
    GP_ENV["CUR_FIG"]  = f
    GP_ENV["CUR_AXES"] = nothing
    return f
end
