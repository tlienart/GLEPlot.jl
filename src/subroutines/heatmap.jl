"""
    add_sub_heatmap!(f, m)

Internal function to add a heatmap subroutine to the GLE script.
This subroutine only generates one column (resp. one row) of boxes, not the
full grid (that is done by calling the routine repeatedly).
"""
function add_sub_heatmap!(f::Figure, hm::Heatmap, hashid::UInt)
    #=
    zij = 0
    cij = ""
    for i = 1 to ndata(ds)
        zij = datayvalue(ds, i)
        if zij <= 1 then
            cij = firstcolor
        else if zij <=2 then
            cij = secondcolor
        ...
        else
            cij = missingcolor
        end

        move and  draw box(zij, cij)
    end
    =#
    ifpart = """
        if zij <= 1 then
        \t\t    cij\$ = \"$(hm.cmap[1])\"
        """
    for k ∈ 2:length(hm.cmap)-1
        ifpart *= """
            \n\t\telse if zij <= $k then
            cij\$ = \"$(hm.cmap[k])\"
            """
    end
    ifpart *= """
        \n\t\telse
            cij\$ = \"$(hm.cmiss)\"
        end if"""

    box_default = """
        amove xg((j-1)*bw) yg(1-i*bh)
        \t\tbox xg(bw)-xg(0) yg(bh)-yg(0) nobox fill cij\$
        """
    box_transpose = """
        amove xg((i-1)*bh) yg(1-j*bw)
        \t\tbox xg(bh)-xg(0) yg(bw)-yg(0) nobox fill cij\$
        """
    boxpart = ifelse(hm.transpose, box_transpose, box_default)

    f.subroutines["hm_$hashid"] = """
        sub hm_$hashid j ds\$ bw bh
            local zij = 0
            local cij = \"\"
            for i = 1 to ndata(ds\$)
                zij = datayvalue(ds\$,i)
                $ifpart
                $boxpart
            next i
        end sub
        """
    return
end
