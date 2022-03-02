function Base.show(
            io::IO,
            ::MIME"image/svg+xml",
            f::Figure
        )::Nothing

    opath = savefig(f, tempname(); info=false)
    write(io, read(opath))
    flush(io)
    return
end
