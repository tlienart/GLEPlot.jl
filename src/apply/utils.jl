function add(g::GS, o, s::Symbol)
    v = getfield(o, s)
    val2str(s, v) |> g
    return
end

function add(g::GS, o, ss...)
    for s in ss
        add(g, o, s)
    end
end


val2str(s, x)         = "$s $(val2str(x))"
val2str(s, ::Nothing) = ""
val2str(s, b::Bool)   = ifelse(b, "$s", "")

val2str(x::Color)  = "\"$(col2str(x))\""
val2str(x::F64)    = fl2str(x)
val2str(x::Int)    = string(x)
val2str(x::String) = x
