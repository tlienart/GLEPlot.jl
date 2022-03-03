"""
    mstr(m::MarkerStyle)

Internal function to help in the specific case where a line with markers of
different color than the line is required.
See `add_sub_marker!` below.
"""
mstr(m::MarkerStyle) = "mk_$(m.marker)_$(col2str(m.color; str=true))"


"""
    add_sub_marker!(f, m)

Internal function to add a subroutine to the GLE script to deal with markers
that  must have a different color than the line they are associated with.
For instance if you want a blue line with red markers, you need to define a
specific subroutine for red-markers otherwise both line and markers are going
to be of the same color.
"""
function add_sub_marker!(
            f::Figure,
            m::MarkerStyle
        )::Nothing

    mstr(m) ∈ keys(f.subroutines) && return
    f.subroutines[str(m)] = """
        sub _$(mstr(m)) size mdata
        gsave
        set color $(m.color)
        marker $(m.marker) size
        grestore
        end sub
        define marker $(mstr(m)) _$(mstr(m))
        """
    return
end
