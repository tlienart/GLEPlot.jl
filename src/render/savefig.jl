export savefig


const OUTPUT_FORMATS = ("eps", "ps", "pdf", "svg", "jpg", "png")
const OUTPUT_FORMATS_RASTER = ("jpg", "png")

# XXX
# --> make a "path" function
# --> make a "glecom" function


"""
    savefig
"""
function savefig(
            fig::Figure,
            fpath::String = "";
            #
            format::String  = "svg",
            resolution::Int = 200,
            res::Int        = resolution,
            info::Bool      = true
        )::String

    #
    # 1. check name and extension. If an extension is given
    #    it takes precedence over the 'format' keyword.
    #
    odir, fname = splitdir(fpath)
    fname       = ifelse(isempty(fname), fig.id, fname)
    fext        = splitext(fname)[2]
    fext        = ifelse(isempty(fext), format, fext)

    #
    # 2. check format and resolution.
    #
    format = lowercase(strip(fext))
    format in OUTPUT_FORMATS || throw(
        ArgumentError("Unknown output format $format.")
    )
    50 <= res <= 500 || throw(
        ArgumentError("Resolution $res outside of the expected [50, 500] range.")
    )

    #
    # 3. form temporary paths for GLE
    #
    base_path   = GP_ENV["TMP_PATH"] / fig.id
    script_path = base_path * ".gle"
    log_path    = base_path * ".log"

    #
    # 4. form the output path, creating dirs if necessary
    #
    isdir(odir) || mkpath(odir)
    output_dir  = odir
    output_path = output_dir / fname * "." * format

    #
    # 5. assemble the figure proper and write it to script_path
    #
    write_figure(fig, script_path)

    #
    # 6. gle command
    #
    # XXX
    cairo       = ifelse(isdef(fig.transparency), `-cairo`, ``)
    texlabels   = ifelse(isdef(fig.texlabels),    `-tex`,   ``)
    transparent = ifelse(
        isnothing(fig.bgcolor) || alpha(fig.bgcolor) < 1,
        `-transparent`, ``
    )

    glex  = Cmd([get(ENV, "GLE", "gle")])
    cext  = `-d $format`
    cres  = ifelse(format in OUTPUT_FORMATS_RASTER, `-r $res`, ``)
    copt  = `$cairo $texlabels $transparent`
    cverb = `-vb 0`
    cout  = `-o $output_path $script_path`
    com   = pipeline(
        `$glex $cext $cres $copt $cverb $cout`,
        stdout = log_path,
        stderr = log_path
    )

    start = time()

    if !success(com)
        log = read(log_path, String)
        # XXX GP_ENV["CLEAN_TMP"] && cleanup(fig)
        @error """
            GLE error: ...
            $log
            """
    end

    δt     = time() - start
    δt_str = ceil(Int, δt * 1e3)
    info && @info """
        Saved figure $(fig.id) at '$output_path' in $(δt_str)ms.
        """

    return output_path
end
