"""
   set_position!(legend, s)

Internal function to set the position of the legend using a describer like
"tl" (top-left).
See `GLE_POSITION`.
"""
function set_position!(o::Union{Legend,Box2D}, v::String)
   o.position = get(GLE_POSITION, v) do
      throw(OptionValueError("position", v))
   end
   return
end

"""
   set_nobox!(o, b)

Internal function to toggle nobox on or off for an object.
"""
set_nobox!(o::Union{Legend,Box2D,Colorbar}, b::Bool) = (o.nobox = b)

"""
   set_margins!(legend, m)

Internal function to set the margins of the legend (internal distance from legend box to elements).
"""
set_margins!(o::Legend, m::T2F) = (o.margins = m)

"""
   set_offset!(obj, m)

Internal function to set the offset of the object (external distance from object to axis).
"""
set_offset!(o::Legend, v::T2F) = (o.offset = v)
