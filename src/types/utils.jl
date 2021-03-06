export gcf, gca


GP_ENV["ALL_FIGS"] = LittleDict{String, Figure}()


"""
    gcf()

Return the current active Figure or a new figure if there isn't one.
"""
gcf()::Figure = isdef(GP_ENV["CUR_FIG"]) ? GP_ENV["CUR_FIG"] : Figure()


"""
    gca()

Return the current active Axes and `nothing` if there isn't one.
"""
gca()::Option{Axes} = GP_ENV["CUR_AXES"] # if nothing, whatever called it will create


"""
    check_axes(a)

I/ Check if Axes object `a` is defined, if not, call `gca`.
If `gca` also returns `nothing`, add new axes.
Used in `plot!` etc.
"""
function check_axes(
            a::Option{Axes};
            dims=2
        )::Option{Axes}

    isdef(a) || (a = gca())
    if isdef(a)
        # check if has the right dims otherwise overwrite
        if dims == 3
            if isa(a, Axes3D)
                return a
            else
                f  = parent(a)
                ha = hash(a)
                i  = findlast(e -> hash(e) === ha, f.axes)
                f.axes[i] = Axes3D(parent=f.id)
                return f.axes[i]
            end
        else
            if isa(a, Axes2D)
                return a
            else
                f  = parent(a)
                ha = hash(a)
                i  = findlast(e->hash(e) === ha, f.axes)
                f.axes[i] = Axes2D(parent=f.id)
                return f.axes[i]
            end
        end
    end
    # if not def, generate
    dims == 3 && return add_axes3d!()
    return add_axes2d!()
end
