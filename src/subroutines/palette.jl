"""
    add_sub_palette!(f, vc)

Internal function to add a subroutine to the GLE script to generate a palette.
"""
function add_sub_palette!(
            f::Figure,
            vc::Vector{String}
        )::Nothing

    nc   = length(vc) - 1
    incr = 1.0 / nc
    bot  = vc[1]
    top  = vc[2]

    core = """
        local r = 0
        \tlocal g = 0
        \tlocal b = 0
        \tif (z <= $incr) then
        \t    r = $(round3d(bot.r))*(1-z*$nc)+$(round3d(top.r))*z*$nc
        \t    g = $(round3d(bot.g))*(1-z*$nc)+$(round3d(top.g))*z*$nc
        \t    b = $(round3d(bot.b))*(1-z*$nc)+$(round3d(top.b))*z*$nc
        """

    for i ∈ 2:length(vc)-1
        bot = vc[i]     # bottom color
        top = vc[i+1]   # top color
        core *= """
            \telse if ($(incr*(i-1)) < z) and (z <= $(incr*i)) then
            \t    r = $(round3d(bot.r))*(1-(z-$(incr*(i-1)))*$nc)+$(round3d(top.r))*(z-$(incr*(i-1)))*$nc
            \t    g = $(round3d(bot.g))*(1-(z-$(incr*(i-1)))*$nc)+$(round3d(top.g))*(z-$(incr*(i-1)))*$nc
            \t    b = $(round3d(bot.b))*(1-(z-$(incr*(i-1)))*$nc)+$(round3d(top.b))*(z-$(incr*(i-1)))*$nc
            """
    end
    core *= """\tend if"""

    pname = "cmap_$(hash(vc))"
    pname ∈ keys(f.subroutines) && return nothing
    f.subroutines[pname] = """
        sub $pname z
            $core
            return rgb(r,g,b)
        end sub
        """
    return
end
