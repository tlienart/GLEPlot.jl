"""
    add_sub_plot3!(f)

Internal function to add a subroutine to the GLE script to enable plot3.
"""
function add_sub_plot3!(
            f::Figure
         )::Nothing

    "plot3" ∈ keys(f.subroutines) && return
    xs = "(xo-xmin)/xspan"
    ys = "(yo-ymin)/yspan"
    f.subroutines["plot3"] = """
        sub plot3 data\$ xmin xspan ymin yspan showline showmarker marker\$ mscale
            xo = 0
            yo = 0
            zo = 0
            io = 0
            fopen data\$ file read
            until feof(file)
                fread file x y z
                xo = x
                yo = y
                zo = z
                io = io+1
                if (io<=1) then
                    amove xg3d($xs,$ys,zo) yg3d($xs,$ys,zo)
                    if (showmarker > 0) then
                        marker marker\$ mscale
                    end if
                else
                    if (showline >= 1) then
                        aline xg3d($xs,$ys,zo) yg3d($xs,$ys,zo)
                    else
                        amove xg3d($xs,$ys,zo) yg3d($xs,$ys,zo)
                    end if
                    if (showmarker > 0) then
                        marker marker\$ mscale
                    end if
                end if
            next
            fclose file
        end sub
        """
    return nothing
end
