"""
    apply_axis!(f, a)

Internal function to apply an `Axis` object `a` in a GLE context.
"""
function apply_axis!(
            f::Figure,
            a::Axis,
            parent_font::String
        )::Nothing

    parent_font = ifelse(
        isdef(a.textstyle.font),
        a.textstyle.font,
        parent_font
    )
    apply_ticks!(f, a.ticks, a.prefix, parent_font)
    if isdef(a.title)
        apply_title!(f, a.title, a.prefix, parent_font)
    end
    # XXX subticks disabled for now
    "\n\t$(a.prefix)subticks off" |> f
    "\n\t$(a.prefix)axis"         |> f
    if a.off
        "off" |> f
        return
    end
    add(f, a, :log, :base, :lwidth, :min, :max)
    a.ticks.grid && "grid" |> f
    apply_textstyle!(f, a.textstyle, parent_font)
    return
end


"""
    apply_axes!(f, a, figid)

Internal function to apply an `Axes2D` object `a` in a GLE context.
The `figid` is useful to keep track of the figure the axes belong to
which is required in the `apply_drawings` subroutine that is called.
"""
function apply_axes!(
            f::Figure,
            a::Axes2D,
            figid::String,
            axidx::Int
        )::Nothing

    a.off && return

    isdef(a.origin) && "\namove $(a.origin[1]) $(a.origin[2])" |> f
    if a.scale != ""
        scale = ifelse(isdef(a.origin), "fullsize", "scale $(a.scale)")
    end

    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "\nbegin graph\n\t$scale"   |> f

    # graph >> math mode (crossing axis)
    a.math && "\n\tmath" |> f
    # -- size of the axes, see also layout
    isdef(a.size) && "\n\tsize $(a.size[1]) $(a.size[2])" |> f

    # graph >> apply axis (ticks, ...), passing the figure font as parent font (see issue #76)
    parent_font = Figure(figid; _noreset=true).textstyle.font
    for axis in (a.xaxis, a.x2axis, a.yaxis, a.y2axis)
        apply_axis!(f, axis, parent_font)
    end

    # graph >> apply axes title, passing the figure font as parent font
    isdef(a.title) && apply_title!(f, a.title, "", parent_font)

    # graph >> apply drawings
    apply_drawings!(f, a.drawings, figid, axidx)

    "\nend graph" |> f
    # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    # apply  legend and other floating objects
    isdef(a.legend)    && apply_legend!(f, a.legend, parent_font, figid)
    isempty(a.objects) || apply_objects!(f, a.objects, figid)
    return
end

#
# function apply_axes!(
#             f::Figure,
#             a::Axes3D,
#             figid::String,
#             axidx::Int
#         )::Nothing
#
#     a.off && return
#     axid = "a3d_$(hash(a))"
#
#     #
#     # begin object ax3d_hash
#     #   begin surface
#     #       size x y
#     #       cube xlen 10 ylen 10 zlen 10 lstyle 9 color blue
#     #       xaxis ...
#     #       xtitle ...
#     #       yaxis ...
#     #       ytitle ...
#     #       zaxis ...
#     #       ztitle ...
#     #       (surface)
#     #   end surface
#     #   (objects)
#     # end object
#     #
#     # amove (appropriate location)
#     # draw ax3d_hash.cc
#     #
#
#     "\nbegin object $axid" |> f
#     "\n\tbegin surface"    |> f
#     "\n\t\tsize $(a.size[1]) $(a.size[2])" |> f
#     # ------------------------------------------
#     # CUBE
#     "\n\t\tcube"      |> f
#     a.nocube && "off" |> f
#     "xlen $(a.cubedims[1]) ylen $(a.cubedims[2]) zlen $(a.cubedims[3])"   |> f
#     a.nocube || apply_linestyle!(f, a.linestyle)
#
#     # TODO should become apply_axis3 or something
#     δx = round((a.xaxis.max - a.xaxis.min)/5, digits=1)
#     "\n\t\txaxis min $(a.xaxis.min) max $(a.xaxis.max) dticks $δx" |> f
#     δy = round((a.yaxis.max - a.yaxis.min)/5, digits=1)
#     "\n\t\tyaxis min $(a.yaxis.min) max $(a.yaxis.max) dticks $δy" |> f
#     δz = round((a.zaxis.max - a.zaxis.min)/5, digits=1)
#     "\n\t\tzaxis min $(a.zaxis.min) max $(a.zaxis.max) dticks $δz" |> f
#
#     # ROTATION
#     if isdef(a.rotate)
#         "\n\t\trotate $(a.rotation[1]) $(a.rotation[2]) 0" |> f
#     else
#         "\n\t\trotate 65 20 0" |> f
#     end
#
#     # XXX AXIS
#     # parent_font = Figure(figid; _noreset=true).textstyle.font
#     # for axis in (a.xaxis, a.yaxis, a.zaxis)
#     #     apply_axis!(f, axis, parent_font)
#     # end
#
#     # SURFACE
#     if isempty(a.drawings) || all(d->!isa(d, Surface), a.drawings)
#         # NOTE if there is no surface, we MUST add dummy data otherwise ghostscript crashes.
#         fd = joinpath(GP_ENV[:tmp_path], "$(figid)_dummy.z")
#         write(fd, "! nx 2 ny 2 xmin 1 xmax 2 ymin 1 ymax 2\n1 2\n2 2\n")
#         "\n\t\tdata \"$fd\""   |> f
#         "\n\t\ttop off"        |> f
#         "\n\t\tunderneath off" |> f
#     end
#     surfs = [i for i ∈ 1:length(a.drawings) if a.drawings[i] isa Surface]
#     apply_drawings!(f, a.drawings[surfs], figid, axidx)
#     # -----------------------------------------
#     "\n\tend surface"      |> f
#     apply_drawings!(f, a.drawings[setdiff(1:length(a.drawings), surfs)], figid, axidx)
#     # OBJECTS
#     apply_objects!(f, a.objects, figid)
#
#     "\nend object"         |> f
#
#     if isdef(a.origin)
#         # move to center of container
#         cx = a.origin[1] + a.size[1]/2
#         cy = a.origin[2] + a.size[2]/2
#         "\namove $cx $cy" |> f
#     else
#         # move to center of page
#         "\namove pagewidth()/2 pageheight()/2" |> f
#     end
#     # draw the overall container centered
#     "\ndraw $axid.cc" |> f
# end
