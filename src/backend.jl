abstract type Backend end

struct GLE <: Backend
    io::IOBuffer
end
GLE() = GLE(IOBuffer())

struct Gnuplot <: Backend
    io::IOBuffer
end
Gnuplot() = Gnuplot(IOBuffer())

# write to buffer (or buffer encapsulating object) with form (s |> b)
|>(s::String, b::Backend)   = write(b.io, s, " ")
|>(s::String, tio::Tuple)   = @. |>(s, tio)

# read buffer encapsulated by `b`
take!(b::Backend) = take!(b.io)

|>(bin::Backend, bout::Backend) = write(bout.io, take!(bin))
