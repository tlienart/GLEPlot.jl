struct GLEScript
    io::IOBuffer
end
GLEScript() = GLEScript(IOBuffer())

const GS = GLEScript

# write to buffer (or buffer encapsulating object) with form (s |> b)
|>(s::String, g::GS)      = write(g.io, s, " ")  # writing to g
|>(s::String, tio::Tuple) = @. |>(s, tio)        # writing to (g1, g2, ...)

# read buffer encapsulated by `b`
take!(g::GS) = take!(g.io)

|>(gi::GS, go::GS) = write(go.io, take!(gi))

gsave(g)    = "\ngsave"    |> g
grestore(g) = "\ngrestore" |> g
