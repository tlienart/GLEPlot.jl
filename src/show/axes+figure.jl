_gs(s) = "\n\t" * rpad(s, 15)

function Base.show(io::IO, ::MIME"text/plain", a::Axes2D{GLE})
    write(io,
        "GPlot.Axes2D{GLE}"  *
        _gs("Title:")         * (isdef(a.title) ? "\"$(a.title.text)\"" : "none") *
        _gs("N. drawings:")   * "$(length(a.drawings))" *
        _gs("N. objects:")    * "$(length(a.objects))" *
        _gs("Math mode:")     * "$(a.math)" *
        _gs("Layout origin:") * (isdef(a.origin) ? "$(round.(a.origin, digits=1))" : "auto")
    )
    return
end


function Base.show(io::IO, ::MIME"text/plain", f::Figure{GLE})
    tbg = (f.bgcolor === nothing)
    wbg = (f.bgcolor == RGB(1,1,1))
    write(io,
        "GPlot.Figure{GLE}" *
        _gs("Name:")        * (f.id == "_fig_" ? "default (\"_fig_\")" : "\"$(f.id)\"") *
        _gs("Size:")        * "$(round.(f.size, digits=1))" *
        _gs("Bg. color:")   * (tbg ? "none" : ifelse(wbg, "white", col2str(f.bgcolor))) *
        _gs("N. axes:")     * "$(length(f.axes))" *
        _gs("LaTeX:")       * (isdef(f.texlabels)    ? "$(f.texlabels)"    : "false") *
        _gs("Transparent:") * (isdef(f.transparency) ? "$(f.transparency)" : "false")
    )
    return
end
