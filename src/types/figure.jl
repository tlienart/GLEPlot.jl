mutable struct Figure
    # NOTE: couldn't use @kw_args here, clashed with the format of the base constructor.
    script::GS     # description buffer
    id    ::String # id of the figure
    # ---
    axes     ::Vector{Axes}      # subplots
    size     ::T2F               # (width, heigth)
    textstyle::TextStyle         # parent font etc
    bgcolor  ::Option{String}    # background col, nothing=transparent
    # ---
    texlabels   ::Option{Bool}   # true if has tex
    texscale    ::Option{String} # scale latex * hei (def=1)
    texpreamble ::Option{String} # latex preamble
    transparency::Option{Bool}   # if true, use cairo device
    # ---
    subroutines::LittleDict{String,String}
end
Figure(g::GS, id::String) =
    Figure(
        g, id,
        # --
        Vector{Axes}(),
        (12., 9.),
        TextStyle(),
        "white",
        # --
        nothing,
        nothing,
        nothing,
        nothing,
        # --
        LittleDict{String,String}()
    )


|>(s::String, f::Figure)   = s |> f.script
|>(fi::Figure, fo::Figure) = fi.script |> fo.script
take!(f::Figure) = take!(f.script)


"""
    reset!(f)

Internal function to completely refresh the figure `f` only keeping its id and size.
"""
function reset!(f::Figure)
    take!(f.script)  # empty the buffer
    f.axes         = Vector{Axes}() # clean axes
    f.textstyle    = TextStyle(font="texcmss", hei=0.35) # default fontstyle
    f.bgcolor      = "white" # default bg color
    f.texlabels    = nothing
    f.texscale     = nothing
    f.texpreamble  = nothing
    f.transparency = nothing
    f.subroutines  = Dict{String,String}()
    GP_ENV["CUR_FIG"]  = f
    GP_ENV["CUR_AXES"] = nothing
    return f
end
