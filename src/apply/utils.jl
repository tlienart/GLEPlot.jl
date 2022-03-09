# add(f, obj, s) --> | s obj.s |
function add(f::Figure, o, s::Symbol)
    v = getfield(o, s)
    val2str(s, v) |> f
    return
end

# add(f, obj, s1, s2,..) --> | s1 obj.s1 s2 obj.s2 ... |
function add(f::Figure, o, ss...)
    for s in ss
        add(f, o, s)
    end
    return
end

# add(f; s1=v1, s2=v2,...) --> | s1 v1 s2 v2 |
function add(f; kw...)
    for (k, v) in kw
        val2str(k, v) |> f
    end
    return
end

val2str(s, x)         = "$s $(val2str(x))"
val2str(s, ::Nothing) = ""
val2str(s, b::Bool)   = ifelse(b, "$s", "")

val2str(x::F64)    = fl2str(x)
val2str(x::Int)    = string(x)
val2str(x::String) = x
