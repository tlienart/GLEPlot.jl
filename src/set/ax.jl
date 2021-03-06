"""
    set_title!(axis, t)

Internal function to set the title of an Axis object.
"""
set_title!(a::Union{Axis, Axes}, t::String) = (a.title = Title(text=t);)


"""
    set_title!(axis, s)

Internal function to set the base scale of an Axis object relative
to the parent font size.
"""
set_base!(a::Axis, s::F64) = (a.base = s;)


"""
    set_min!(axis, m)

Internal function to set the minimum value of the `axis`. Note that
`[x|y|x2|y2]lim!` is preferred.
"""
set_min!(a::Axis, m::F64) = (a.min = m;)


"""
    set_max!(axis, m)

Internal function to set the maximum value of the `axis`. Note that
`[x|y|x2|y2]lim!` is preferred.
"""
set_max!(a::Axis, m::F64) = (a.max = m;)


"""
    set_log!(axis, b)

Internal function to toggle the log option of the `axis` object.
Note that `[x|y|x2|y2]scale!` is peferred.
"""
set_log!(a::Axis, b::Bool) = (a.log = b;)
