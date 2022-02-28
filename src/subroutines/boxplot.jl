#=
NOTE: the outliers are drawn separately (see the boxplot function)

    =====   y: whigh
      |
     +=+    y: q75
     | |
     | |
     +=+    y: q25
      |
    =====   y: wlow

x-axis:
    box:      p-bwidth/2  <>  p+bwidth/2
    whisker:  p-wwidth/2  <>  p+wwidth/2
=#

const boxplot_box_lstyle  = "set lstyle blstyle lwidth blwidth color blcolor\$"
const boxplot_med_lstyle  = "set lstyle medlstyle lwidth medlwidth color medcolor\$"
const boxplot_mean_mstyle = """
    gsave
    \tset color mmcol\$
    \tmarker mmarker\$ mmsize
    \tgrestore
    """
const boxplot_core_vertical = """
    ! -----------------------------------------
    \t! SET LINE STYLE THEN DRAW BOX AND WHISKERS
    \t! -----------------------------------------
    \tgsave
    \tset cap round
    \t$boxplot_box_lstyle
    \t!
    \t! >> LOWER WHISKER
    \tamove xg(p-wwidth/2) yg(wlow)
    \taline xg(p+wwidth/2) yg(wlow)
    \t!
    \t! >> CONNECTION LOWER WHISKER-BOX
    \tamove xg(p) yg(wlow)
    \t!
    \t! >> BOX
    \taline xg(p) yg(q25)
    \tamove xg(p-bwidth/2) yg(q25)
    \tbox xg(p+bwidth/2)-xg(p-bwidth/2) yg(q75)-yg(q25)
    \t!
    \t! >> CONNECTION BOX-UPPER WHISKER
    \tamove xg(p) yg(q75)
    \taline xg(p) yg(whigh)
    \t!
    \t! >> UPPER WHISKER
    \tamove xg(p-wwidth/2) yg(whigh)
    \taline xg(p+wwidth/2) yg(whigh)
    \tgrestore
    \t!
    \t! ------------------------------------
    \t! SET LINE STYLE THEN DRAW MEDIAN LINE
    \t! ------------------------------------
    \tgsave
    \t$boxplot_med_lstyle
    \tamove xg(p-bwidth/2) yg(q50)
    \taline xg(p+bwidth/2) yg(q50)
    \tgrestore
    \t!
    \t! --------------------------------------
    \t! SET MARKER STYLE THEN DRAW MEAN MARKER
    \t! --------------------------------------
    \tif (mshow > 0) then
    \t    amove xg(p) yg(mean)
    \t$boxplot_mean_mstyle
    \tend if"""
const boxplot_core_horizontal = """
    ! -----------------------------------------
    \t! SET LINE STYLE THEN DRAW BOX AND WHISKERS
    \t! -----------------------------------------
    \tgsave
    \tset cap round
    \t$boxplot_box_lstyle
    \tamove xg(wlow) yg(p-wwidth/2)
    \taline xg(wlow) yg(p+wwidth/2)
    \tamove xg(wlow) yg(p)
    \taline xg(q25) yg(p)
    \tamove xg(q25) yg(p-bwidth/2)
    \tbox xg(q75)-xg(q25) yg(p+bwidth/2)-yg(p-bwidth/2)
    \tamove xg(q75) yg(p)
    \taline xg(whigh) yg(p)
    \tamove xg(whigh) yg(p-wwidth/2)
    \taline xg(whigh) yg(p+wwidth/2)
    \tgrestore
    \t!
    \t! ------------------------------------
    \t! SET LINE STYLE THEN DRAW MEDIAN LINE
    \t! ------------------------------------
    \tgsave
    \t$boxplot_med_lstyle
    \tamove xg(q50) yg(p-bwidth/2)
    \taline xg(q50) yg(p+bwidth/2)
    \tgrestore
    \t!
    \t! --------------------------------------
    \t! SET MARKER STYLE THEN DRAW MEAN MARKER
    \t! --------------------------------------
    \tif (mshow > 0) then
    \t    amove xg(mean) yg(p)
    \t    $boxplot_mean_mstyle
    \tend if"""
const boxplot_args = ( # NOTE: leave space at end of string
    "p wlow q25 q50 q75 whigh mean ",
    "bwidth wwidth blstyle blwidth blcolor\$ ",
    "medlstyle medlwidth medcolor\$ ",
    "mshow mmarker\$ mmsize mmcol\$ "
)


GLE_DRAW_SUB["bp_vert"] = """
    sub bp_vert $(prod(boxplot_args))
        $boxplot_core_vertical
    end sub
    """

GLE_DRAW_SUB["bp_horiz"] = """
    sub bp_horiz $(prod(boxplot_args))
        $boxplot_core_horizontal
    end sub
    """
