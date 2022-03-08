function add(f::Figure, o, s::Symbol)
    v = getfield(o, s)
    val2str(s, v) |> f
    return
end

function add(f::Figure, o, ss...)
    for s in ss
        add(f, o, s)
    end
end


val2str(s, x)         = "$s $(val2str(x))"
val2str(s, ::Nothing) = ""
val2str(s, b::Bool)   = ifelse(b, "$s", "")

val2str(x::F64)    = fl2str(x)
val2str(x::Int)    = string(x)
val2str(x::String) = x
