"""
    apply_objects!(f, objects)

Internal function to apply a vector of `Object` contained in an `Axes`
container in a GLE context.
"""
function apply_objects!(
            f::Figure,
            objects::Vector{<:Object},
            figid::String
        )::Nothing

    for o in objects
        apply_object!(f, o, figid)
    end
    return
end

"""
    apply_object!(f, text2d, fid)

Apply a Text2D object.
"""
function apply_object!(
            f::Figure,
            obj::Text2D,
            ::String
        )::Nothing

    gsave(f)
    "\nset just $(obj.position)"                        |> f
    apply_textstyle!(f, obj.textstyle, addset=true)
    "\namove xg($(obj.anchor[1])) yg($(obj.anchor[2]))" |> f
    "\nwrite \"$(obj.text)\""                           |> f
    grestore(g)
    return
end


"""
    apply_object!(f, straightline2d, fid)

Apply a StraightLine2D object.
"""
function apply_object!(
            f::Figure,
            obj::StraightLine2D,
            ::String
        )::Nothing

    gsave(f)
    apply_linestyle!(f, obj.linestyle; addset=true)
    if obj.horiz
        "\namove xg(xgmin) yg($(obj.anchor))" |> f
        "\naline xg(xgmax) yg($(obj.anchor))" |> f
    else
        "\namove xg($(obj.anchor)) yg(ygmin)" |> f
        "\naline xg($(obj.anchor)) yg(ygmax)" |> f
    end
    grestore(g)
    return
end


"""
    apply_object!(f, box2d, fid)

Apply a Box2D object.
"""
function apply_object!(
            f::Figure,
            obj::Box2D,
            ::String
        )::Nothing

    gsave(f)
    obj.position == "bl" || "\nset just $(obj.position)"      |> f
    apply_linestyle!(f, obj.linestyle; addset=true)
    # move to the corner of the box and draw it
    "\namove xg($(obj.anchor[1])) yg($(obj.anchor[2]))"       |> f
    "\nbox xg($(obj.size[1]))-xg(0) yg($(obj.size[2]))-yg(0)" |> f
    # discard bounding box if nobox
    obj.nobox && "nobox"                    |> f
    # apply fill
    fs = obj.fillstyle
    isdef(fs) && "fill $(col2str(fs.fill))" |> f
    grestore(g)
    return
end


"""
    apply_object!(f, cbar, fid)

Apply a ColorBar object.
"""
function apply_object!(
            f::Figure,
            obj::Colorbar,
            figid::String
        )::Nothing

    # add the palette subroutine
    add_sub_palette!(Figure(figid; _noreset=true), obj.cmap)

    dx, dy        = obj.offset
    width, height = 0.0, 0.0
    if isdef(obj.size)
        width, height = obj.size
    else
        if obj.position ∈ ("left", "right")
            width, height = "0.25", "abs(yg(ygmax)-yg(ygmin))"
        else
            width, height = "abs(xg(xgmax)-xg(xgmin))", "0.25"
        end
    end

    if obj.position == "right"
        "\namove xg(xgmax)+$dx yg(ygmin)+$dy"             |> f
    elseif obj.position == "left"
        "\namove xg(xgmin)-$dx-0.3-$width yg(ygmin)+$dy"  |> f
    elseif obj.position == "bottom"
        "\namove xg(xgmin)+$dx yg(ygmin)-$dy-0.3-$height" |> f
    else
        "\namove xg(xgmin)+$dx yg(ygmax)+$dy"             |> f
    end

    "\nbegin box name cmap" |> f
    obj.nobox && "nobox"    |> f

    #
    # colormap "y" 0 1 0 1 1 pixels width height palette palette$
    #
    "\n\tcolormap" |> f
    if obj.position ∈ ["right", "left"]
        "\"y\" 0 1 0 1 1 $(obj.pixels)"     |> f
    else
        "\"x\" 0 1 0 1 $(obj.pixels) 1"     |> f
    end
    "$width $height palette cmap_$(hash(obj.cmap))" |> f
    "\nend box" |> f

    # ticks (not axis elem this time)
    # map the ticks from 0.0 to 1.0
    ticks   = collect(obj.ticks.places)
    ticks .-= obj.zmin
    ticks ./= (obj.zmax - obj.zmin)

    if obj.position == "right"

        # apply ticks as straight lines of the right length
        if !(obj.ticks.off)
            tlength = isdef(obj.ticks.length) ?
                        fl2str(obj.ticks.length) :
                        "$width/3"
            gsave(f)
            apply_linestyle!(f, obj.ticks.linestyle; nosmooth=true, addset=true)
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmax)+$dx+$width yg(ygmin)+$dy+$height*$tick" |> f
                "\nrline $tlength 0" |> f # draw tick
            end
            grestore(g)
        end

        # apply ticks labels
        if !(obj.ticks.labels.off)
            offset = isdef(obj.ticks.labels.dist) ?
                        fl2str(obj.ticks.labels.dist) :
                        "$width/3"
            shift  = isdef(obj.ticks.labels.shift) ?
                        fl2str(obj.ticks.labels.shift) : "0"
            gsave(f)
            apply_textstyle!(f, obj.ticks.labels.textstyle; addset=true)
             # justify center wrt anchor
            "\nset just lc" |> f

            # retrieve the labels
            labels = obj.ticks.labels.names
            if isempty(labels)
                # between 0 and 1, see ticks above
                labels = [
                    "$(round(ticks[i]*(obj.zmax-obj.zmin)+obj.zmin, digits=1))"
                    for i ∈ 1:length(ticks)
                ]
            end

            # write the labels
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmax)+$dx+$width yg(ygmin)+$dy+$height*$tick" |> f
                "\nrmove $offset*1.3 0"             |> f  # move a bit more to write the label
                iszero(shift) || "\nrmove 0 $shift" |> f  # shift vertical
                "\nwrite $(labels[i])"              |> f  # write label
            end
            grestore(g)
        end

    elseif obj.position == "left"

        # draw ticks
        if !(obj.ticks.off)
            tlength = isdef(obj.ticks.length) ?
                        fl2str(obj.ticks.length) :
                        "$width/3"
            gsave(f)
            apply_linestyle!(f, obj.ticks.linestyle; nosmooth=true, addset=true)
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)-$dx yg(ygmin)+$dy" |> f
                "\nrline -$tlength 0"                 |> f
            end
            grestore(g)
        end

        # draw labels
        if !(obj.ticks.labels.off)
            offset = isdef(obj.ticks.labels.dist) ? obj.ticks.labels.dist : "$width/3"
            shift  = isdef(obj.ticks.labels.shift) ? obj.ticks.labels.shift : 0
            "\ngsave"       |> f
            "\nset just lc" |> f # justify center wrt anchor
            apply_textstyle!(f, obj.ticks.labels.textstyle; addset=true)
            # retrieve the labels
            labels = obj.ticks.labels.names
            if isempty(labels)
                labels = [
                    "$(round(obj.ticks.places[i], digits=1))"
                    for i ∈ 1:length(ticks)
                ]
            end
            # write them
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)-$dx yg(ygmin)+$dy" |> f
                "\nrmove -$offset*1.3 0"    |> f # move a bit more to write the label
                iszero(shift) || "\nrmove 0 $shift"   |> f # shift vertical
                "\nset just lc"         |> f # justify center wrt anchor
                "\nwrite $(labels[i])"  |> f # write label
            end
            "\ngrestore" |> f
        end

    elseif obj.position == "bottom"

        # draw ticks
        if !(obj.ticks.off)
            tlength = isdef(obj.ticks.length) ?
                        fl2str(obj.ticks.length) :
                        "$height/3"
            gsave(f)
            apply_linestyle!(f, obj.ticks.linestyle; nosmooth=true, addset=true)
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)+$dx yg(ygmin)-$dy-0.3-$height" |> f
                "\nrline 0 -$tlength"                             |> f
            end
            grestore(g)
        end

        # write labels
        if !(obj.ticks.labels.off)
            offset = isdef(obj.ticks.labels.dist) ?
                        fl2str(obj.ticks.labels.dist) :
                        "$width/3"
            shift  = isdef(obj.ticks.labels.shift) ?
                        fl2str(obj.ticks.labels.shift) : "0"
            gsave(f)
            apply_textstyle!(f, obj.ticks.labels.textstyle; addset=true)
            "\nset just lc" |> f # justify center wrt anchor
            # retrieve the labels
            labels = obj.ticks.labels.names
            if isempty(labels)
                labels = [
                    "$(round(obj.ticks.places[i], digits=1))"
                    for i ∈ 1:length(ticks)
                ]
            end
            # write them
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)+$dx yg(ygmin)-$dy-0.3-$height" |> f
                "\nrmove 0 -$offset*1.3"            |> f
                iszero(shift) || "\nrmove $shift 0" |> f
                "\nset just lc"                     |> f
                "\nwrite $(labels[i])"              |> f
            end
            "\ngrestore" |> f
        end

    # top
    else
        #draw ticks
        if !(obj.ticks.off)
            tlength = isdef(obj.ticks.length) ?
                        fl2str(obj.ticks.length) :
                        "$height/3"
            gsave(f)
            apply_linestyle!(f, obj.ticks.linestyle; nosmooth=true, addset=true)
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)+$dx yg(ygmax)+$dy" |> f
                "\nrline 0 $tlength"                  |> f
            end
            grestore(g)
        end
        # write label
        if !(obj.ticks.labels.off)
            offset = isdef(obj.ticks.labels.dist) ?
                        fl2str(obj.ticks.labels.dist) :
                        "$width/3"
            shift  = isdef(obj.ticks.labels.shift) ?
                        fl2str(obj.ticks.labels.shift) : 0
            gsave(f)
            apply_textstyle!(f, obj.ticks.labels.textstyle; addset=true)
            "\nset just lc" |> f # justify center wrt anchor
            # retrieve the labels
            labels = obj.ticks.labels.names
            if isempty(labels)
                labels = [
                    "$(round(obj.ticks.places[i], digits=1))"
                    for i ∈ 1:length(ticks)
                ]
            end
            # write them
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)+$dx yg(ygmax)+$dy" |> f
                "\nrmove 0 $offset*1.3"               |> f
                iszero(shift) || "\nrmove $shift 0"   |> f
                "\nset just lc"                       |> f
                "\nwrite $(labels[i])"                |> f
            end
            grestore(g)
        end
    end
    return
end
