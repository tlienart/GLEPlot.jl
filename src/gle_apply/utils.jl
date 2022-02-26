function add(g::GS, o, s::Symbol)
    v = getfield(o, s)
    v2str(s, v) |> g
    return
end

function add(g::GS, o, ss...)
    for s in ss
        add(g, o, s)
    end
end

v2str(s, x)         = "$s $(v2str(x))"
v2str(s, ::Nothing) = ""
v2str(s, b::Bool)   = ifelse(b, "$s", "")

v2str(x::Color)  = "\"col2str(x)\""
v2str(x::F64)    = fl2str(x)
v2str(x::Int)    = string(x)
v2str(x::String) = x
