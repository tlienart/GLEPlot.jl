const GLE_DEFAULTS = LittleDict{Symbol,Any}(
    :palette => [ # imitated from tableau 10 - 2
        RGB(0.33, 0.47, 0.64),
        RGB(0.90, 0.57, 0.26),
        RGB(0.82, 0.37, 0.36),
        RGB(0.51, 0.70, 0.69),
        RGB(0.42, 0.62, 0.35),
        RGB(0.91, 0.79, 0.37),
        RGB(0.66, 0.49, 0.62),
        RGB(0.95, 0.63, 0.66),
        RGB(0.59, 0.46, 0.38),
        RGB(0.72, 0.69, 0.67)
    ],
    #
    :textstyle_font  => "texcmss",
    :textstyle_hei   => 0.35,
    :textstyle_color => nothing,
    #
    :linestyle_lstyle => nothing,
    :linestyle_lwidth => nothing,
    :linestyle_smooth => nothing,
    :linestyle_color  => nothing,
    #
    :markerstyle_marker => nothing,
    :markerstyle_msize  => nothing,
    :markerstyle_color  => nothing,
    #
    :barstyle_color => nothing,
    :barstyle_fill  => c"white",
    #
    :fillstyle_fill   => c"cornflowerblue",
    #
    :boxplotstyle_bwidth         => 0.6,
    :boxplotstyle_wwidth         => 0.3,
    :boxplotstyle_wrlength       => 1.5,
    :boxplotstyle_blstyle_lstyle => 1,
    :boxplotstyle_blstyle_lwidth => 0.0,
    :boxplotstyle_blstyle_color  => c"seagreen",
    :boxplotstyle_mlstyle_lstyle => 1,
    :boxplotstyle_mlstyle_lwidth => 0.0,
    :boxplotstyle_mlstyle_color  => c"seagreen",
    :boxplotstyle_mmstyle_marker => "fdiamond",
    :boxplotstyle_mmstyle_msize  => 0.4,
    :boxplotstyle_mmstyle_color  => c"dodgerblue",
    :boxplotstyle_omstyle_marker => "+",
    :boxplotstyle_omstyle_msize  => 0.5,
    :boxplotstyle_omstyle_color  => c"tomato",
    :boxplotstyle_mshow          => true,
    :boxplotstyle_oshow          => true,
    #
    :text2d_position  => "cc",
    :text2d_textstyle => :default_TextStyle,
    #
    :straightline2d_linestyle => :default_LineStyle,
    #
    :box2d_position  => "bl",
    :box2d_nobox     => true,
    :box2d_linestyle => :default_LineStyle,
    :box2d_fillstyle => nothing,
    #
    :colorbar_size     => nothing,
    :colorbar_pixels   => 100,
    :colorbar_nobox    => true,
    :colorbar_position => "right",
    :colorbar_offset   => (0.3, 0.0),
    #
    :title_textstyle => :default_TextStyle,
    :title_dist      => nothing,
    #
    :tickslabels_textstyle => :default_TextStyle,
    :tickslabels_angle     => nothing,
    :tickslabels_format    => nothing,
    :tickslabels_shift     => nothing,
    :tickslabels_dist      => nothing,
    :tickslabels_off       => false,
    #
    :ticks_linestyle => :default_LineStyle,
    :ticks_length    => nothing,
    :ticks_symticks  => false,
    :ticks_off       => false,
    :ticks_grid      => false,
    #
    :legend_position  => nothing,
    :legend_textstyle => :default_TextStyle,
    :legend_offset    => (0.0, 0.0),
    :legend_bgcolor   => nothing,
    :legend_margins   => nothing,
    :legend_nobox     => false,
    :legend_off       => false,
    #
    :axis_ticks     => :default_Ticks,
    :axis_textstyle => :default_TextStyle,
    :axis_title     => nothing,
    :axis_base      => nothing,
    :axis_lwidth    => nothing,
    :axis_min       => nothing,
    :axis_max       => nothing,
    :axis_off       => false,
    :axis_log       => false,
    #
    :axes2d_title  => nothing,
    :axes2d_size   => nothing,
    :axes2d_legend => nothing,
    :axes2d_origin => nothing,
    :axes2d_math   => false,
    :axes2d_off    => false,
    :axes2d_scale  => "auto",
    #
    :scatter2d_linestyles_lstyle => 0,
    :scatter2d_linestyles_lwidth => 0.05,
    :scatter2d_linestyles_smooth => true,
    #
    :hist2d_horiz    => false,
    :hist2d_bins     => nothing,
    :hist2d_scaling  => "none",
    :hist2d_label    => "",
    #
    :bar2d_stacked => false,
    :bar2d_horiz   => false,
    :bar2d_bwidth  => nothing,
    :bar2d_labels  => String[],
    #
    :boxplot_horiz => false,
    #
    :heatmap_cmap      => colormap("RdBu", 10),
    :heatmap_cmiss     => c"white",
    :heatmap_transpose => false,
    #
    :scatter3d_linestyle => :default_LineStyle,
    :scatter3d_markerstyle => :default_MarkerStyle,
    :scatter3d_label => "",
)


"""
    default(T)

Default constructor for an object.
"""
function default(::Type{T}, a...) where T
    tname = T.name.name
    return T(a...,
        (
            begin
                s = Symbol(lowercase("$(tname)_$(fn)"))
                v = get(GLE_DEFAULTS, s, nothing)
                if v isa Symbol
                    sv = string(v)
                    if startswith(sv, "default")
                        T2 = Symbol(split(sv, '_')[2])
                        v  = eval(quote
                            $T2()
                        end)
                    end
                end
                v
            end
            for fn in fieldnames(T)[length(a)+1:end]
        )...
    )
end
