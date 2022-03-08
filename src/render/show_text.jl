_gs(s, s2) = "\n\t" * rpad(s, 15) * string(s2)

#
# Axes2D | show
#
function Base.show(
            io::IO,
            ::MIME"text/plain",
            a::Axes2D
        )::Nothing

    write(io,
        "GLEPlot.Axes2D"  *
        _gs("Title:",         isdef(a.title) ? "\"$(a.title.text)\"" : "none"   ) *
        _gs("N. drawings:",   length(a.drawings)                                ) *
        _gs("N. objects:",    length(a.objects)                                 ) *
        _gs("Math mode:",     a.math                                            ) *
        _gs("Layout origin:", isdef(a.origin) ? fl2str(a.origin, d=1) : "auto"  )
    )
    return
end

#
# Figure | show
#
function Base.show(
            io::IO,
            ::MIME"text/plain",
            f::Figure
        )::Nothing

    tbg = (f.bgcolor === nothing)
    wbg = (f.bgcolor == "white")
    write(io,
        "GLEPlot.Figure" *
        _gs("Name:",        f.id == "_fig_" ? "default (\"_fig_\")" : "\"$(f.id)\""  ) *
        _gs("Size:",        Float64.(f.size)                                         ) *
        _gs("Bg. color:",   tbg ? "none" : ifelse(wbg, "white", f.bgcolor)           ) *
        _gs("N. axes:",     length(f.axes)                                           ) *
        _gs("LaTeX:",       isdef(f.texlabels)    ? f.texlabels    : "false"         ) *
        _gs("Transparent:", isdef(f.transparency) ? f.transparency : "false"         )
    )
    return
end
