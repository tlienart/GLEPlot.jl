"""
    set_properties!(dict, obj; opts...)
    set!(...)

Set properties of an object `obj` given options (`opts`) of the form
`optname=value`, and applying it through an appropriate application function
stored in the dictionary `dict`.
Note that the dictionary of property-setting-functions also contains
"pre-conditioners" which are functions that check that the values passed to
properties are sensible and convert them to sensible types if relevant.
This reduces code duplication and allows to reduce specialization.

Note: `set_properties!` (to avoid ambiguities in the code) is used internally,
    `set!` is exported (less verbose and not ambiguous).
"""
function set_properties!(
            dict::LittleDict{Symbol, Pair{Function, Function}},
            obj;
            opts...
        )::Nothing

    for optname in keys(opts)
        optvalue = opts[optname]
        argcheck, setprop! = get(dict, get(PROP_ALIAS, optname, optname)) do
            throw(
                UnknownOptionError(optname, obj)
            )
        end
        setprop!(obj, argcheck(optvalue, optname))
    end
    return
end
set!(obj; opts...) = set_properties!(obj; opts...)


####
#### Value checkers for set_properties functions the symbol corresponds to the name
#### of the option that is being modified
####

# No Check
I(x, ::Symbol) = x

# Bool
bool(x::Bool,      ::Symbol) = x
bool(x::Int,       ::Symbol) = !iszero(x)
bool(x::Listable, o::Symbol) = b.(x, o)
bool(x,           o::Symbol) = throw(
    OptionValueError(o, x, "((List of) Bool)")
)

# Reversal of input (e.g. legend box/nobox)
not(x::Bool,  ::Symbol) = !x
not(x,       o::Symbol) = throw(
    OptionValueError(o, x, "((List of) Bool)")
)

# string or vector
str(x::String,    ::Symbol)    = x
str(x::Listable, o::Symbol) = str.(x, o)
str(x,           o::Symbol) = throw(
    OptionValueError(o, x, "((List of) String)")
)

# Lowercase string or strings
lc(x::String,    ::Symbol) = lowercase(x)
lc(x::Listable, o::Symbol) = lc.(x, o)
lc(x,           o::Symbol) = throw(
    OptionValueError(o, x, "((List of) String)")
)

# Cast to float
fl(x::Real,      ::Symbol) = Float64(x)
fl(x::Listable, o::Symbol) = fl.(x, o)
fl(x,           o::Symbol) = throw(
    OptionValueError(o, x, "((List of) Real)")
)

pos(x::Real, o::Symbol) = (x < 0 && throw(
    OptionValueError(o, x, "(positive)")
);)

# Check positive and cast to float
posfl(x::Real,     o::Symbol) = (pos(x, o); Float64(x))
posfl(x::Listable, o::Symbol) = posfl.(x, o)
posfl(x,           o::Symbol) = throw(
    OptionValueError(o, x, "((List of) positive Real)")
)

# check positive + integer
posint(x::Int, o::Symbol) = (pos(x, o); x)
posint(x,      o::Symbol) = throw(
    OptionValueError(o, x, "(positive integer)")
)

# color
col(c::Color,     ::Symbol) = c
col(s::String,    ::Symbol) = parse(Color, s)
col(v::Listable, o::Symbol) = col.(v, o)
col(x,           o::Symbol) = throw(
    OptionValueError(o, x, "((List of) Color or String-Color)")
)


"""
    opcol(x, o)

Internal function to process an optional color, i.e. `"none"` can be passed
resulting in `nothing` being passed.
This is relevant for instance when setting the background color of a figure
to "none" (transparent figure). If `"none"` is passed, the current figure
is checked for transparency properties if set to false, a warning will be
raised and the color will be defaulted to `"white"` if the transparency
setting is unset, it will be set to `true`.
"""
function opcol(x::String, o::Symbol)::Option{Color}
    if lowercase(x) == "none"
        isdef(gcf().transparency) || (gcf().transparency = true)
        if !gcf().transparency
            @warn """
                Transparent background is only supported when the figure
                has its transparency property set to 'true'.
                """
            return col("white", o) # fully opaque
        end
        return nothing
    end
    return col(x, o)
end
opcol(c, o) = col(c, o)


"""
    alpha(α, s)

Internal function to process an alpha parameter (transparency). The current
figure is checked for transparency properties, if set to false, a warning will
be raised and the `α` will be ignored (fully opaque). If the transparency
setting is unset, it will be set to `true`.
Accepted values are strictly between `0` and `1`.
For completely transparent, see using `"none"` in the color description
(for instance `Figure(bgcol="none")`).
"""
function alpha(α::Float64, optname::Symbol)::Float64
    isdef(gcf().transparency) || (gcf().transparency=true)
    if !gcf().transparency
        @warn """
            Transparent colors are only supported when the figure
            has its transparency property set to 'true'. Ignoring α.
            """
        return 1.0 # fully opaque
    end
    0 < α <= 1 || throw(
        OptionValueError("alpha", α, "(number in (0, 1])")
    )
    return α
end
alpha(α::Real, o::Symbol) = alpha(fl(α), o)
alpha(α,       o::Symbol) = throw(
    OptionValueError("alpha", α, "(number in (0, 1])")
)


####
#### Pickers for GROUPED objects
#### --> gline, gbar, scatter, boxplot, bar
####

# this behaves like ∘ except it splats the output of g, this is useful in
# set_properties when wanting to use a set function but it has to be applied
# on a subfield of the object, then we apply a "selector" first to pick that
# subfield before applying the setter.
# The effect would be something like setter(picker(obj), value) and is
# written (setter ⊙ picker)
⊙(f::Function, g::Function) = (args...) -> f(g(args...)...)

###############################################################
####
#### Options for STYLE
####
###############################################################

pick_lstyles(o, v) = (o.linestyles,   v)
pick_mstyles(o, v) = (o.markerstyles, v)
pick_bstyles(o, v) = (o.barstyles,    v)
pick_blstyle(b, v) = (b.boxstyles,    v, :blstyle)
pick_mlstyle(b, v) = (b.boxstyles,    v, :mlstyle)
pick_mmstyle(b, v) = (b.boxstyles,    v, :mmstyle)
pick_omstyle(b, v) = (b.boxstyles,    v, :omstyle)

# style.jl
# --------
# set_color! <- color (option for Figure/Legend)
# set_font! <- string
# set_hei!  <- F64, positive

const PROP_ALIAS = LittleDict(
    :color              => :col,
    :colour             => :col,
    :colors             => :col,
    :colours            => :col,
    #
    :textcol            => :tc,
    :textcolor          => :tc,
    :textcolour         => :tc,
    #
    :lc                 => :col,
    :linecol            => :col,
    :linecolor          => :col,
    :linecolors         => :col,
    :linecolour         => :col,
    :linecolours        => :col,
    #
    :mcol               => :mc,
    :markercol          => :mc,
    :markercolor        => :mc,
    :markercolour       => :mc,
    #
    :ecol               => :ec,
    :edgecol            => :ec,
    :edgecolor          => :ec,
    :edgecolour         => :ec,
    :edgecolors         => :ec,
    :edgecolours        => :ec,
    #
    :fill               => :col,
    :fills              => :col,
    #
    :lstyle             => :ls,
    :linestyle          => :ls,
    :lstyles            => :ls,
    :linestyles         => :ls,
    #
    :lwidth             => :lw,
    :linewidth          => :lw,
    :lwidths            => :lw,
    :linewidths         => :lw,
    #
    :smooths            => :smooth,
    #
    :markers            => :marker,
    #
    :msize              => :ms,
    :markersize         => :ms,
    :msizes             => :ms,
    :markersizes        => :ms,
    #
    :bwidth             => :width,
    :barwidth           => :width,
    #
    :position           => :pos,
    #
    :bgcolor            => :bgcol,
    :bgcolour           => :bgcol,
    :background         => :bgcol,
    #
    :length             => :len,
    #
    :symticks           => :sym,
    #
    :distance           => :dist,
    #
    :tickscol           => :tcol,
    :tickscolor         => :tcol,
    :tickscolour        => :tcol,
    #
    :key                => :label,
    :keys               => :label,
    :labels             => :label,
    #
    :from               => :xmin,
    :to                 => :xmax,
    #
    :norm               => :scaling,
    :nbins              => :bins,
    :horizontal         => :horiz,
    #
    :box_width          => :bw,
    :box_widths         => :bw,
    #
    :whisker_width      => :ww,
    :whisker_widths     => :ww,
    :box_wwidth         => :ww,
    :box_wwidths        => :ww,
    :box_whisker_width  => :ww,
    :box_whisker_widths => :ww,
    #
    :whisker            => :wl,
    :whisker_length     => :wl,
    :whiskers_length    => :wl,
    :whisker_lengths    => :wl,
    :whiskers_lengths   => :wl,
    #
    :box_ls             => :bls,
    :box_lstyle         => :bls,
    :box_lstyles        => :bls,
    :box_linestyle      => :bls,
    :box_linestyles     => :bls,
    #
    :box_lw             => :blw,
    :box_lwidth         => :blw,
    :box_lwidths        => :blw,
    :box_linewidths     => :blw,
    #
    :box_col            => :bc,
    :box_cols           => :bc,
    :box_color          => :bc,
    :box_colour         => :bc,
    :box_colors         => :bc,
    :box_colours        => :bc,
    #
    :med_ls             => :medls,
    :med_lstyle         => :medls,
    :med_lstyles        => :medls,
    :med_linestyle      => :medls,
    :med_linestyles     => :medls,
    #
    :med_lw             => :medlw,
    :med_lwidth         => :medlw,
    :med_lwidths        => :medlw,
    :med_linewidth      => :medlw,
    :med_linewidths     => :medlw,
    #
    :med_col            => :medc,
    :med_cols           => :medc,
    :med_color          => :medc,
    :med_colors         => :medc,
    #
    :mean_marker        => :mm,
    :mean_markers       => :mm,
    #
    :mean_msize         => :mms,
    :mean_markersize    => :mms,
    :mean_markersizes   => :mms,
    #
    :mean_mcol          => :mmc,
    :mean_mcols         => :mmc,
    :mean_markercol     => :mmc,
    :mean_markercolor   => :mmc,
    :mean_markercolors  => :mmc,
    :mean_markercolour  => :mmc,
    :mean_markercolours => :mmc,
    #
    :out_marker         => :om,
    :out_markers        => :om,
    #
    :out_msize          => :oms,
    :out_msizes         => :oms,
    :out_markersize     => :oms,
    :out_markersizes    => :oms,
    #
    :out_mcol           => :omc,
    :out_mcols          => :omc,
    :out_markercol      => :omc,
    :out_markercolor    => :omc,
    :out_markercolors   => :omc,
    :out_markercolour   => :omc,
    :out_markercolours  => :omc,
    #
    :colormap           => :cmap,
    :colourmap          => :cmap,
    #
    :res                => :pixels,
    :resolution         => :pixels,
    #
    :hastex => :tex,
    :latex => :tex,
    :haslatex => :tex,
    #
    :transparency => :alpha,
    :transparent  => :alpha,
    #
    :texpreamble => :preamble,
)

const OptsDict = LittleDict{Symbol,Pair{Function,Function}}


const TEXTSTYLE_OPTS = OptsDict(
    :font     => lc    => set_font!,
    :fontsize => posfl => set_hei!,
    :tc       => col   => set_textcolor!,
    )

const LINESTYLE_OPTS = OptsDict(
    :ls     => I     => set_lstyle!,
    :lw     => posfl => set_lwidth!,
    :smooth => bool  => set_smooth!,
    :col    => col   => set_color!,
    )

const GLINESTYLE_OPTS = OptsDict(
    :ls     => I     => set_lstyles! ⊙ pick_lstyles,
    :lw     => posfl => set_lwidths! ⊙ pick_lstyles,
    :smooth => bool  => set_smooths! ⊙ pick_lstyles,
    :col    => col   => set_colors!  ⊙ pick_lstyles,
    )

const MARKERSTYLE_OPTS = OptsDict(
    :marker => lc    => set_marker!,
    :ms     => posfl => set_msize!,
    :mc     => col   => set_mcol!,
    )

const GMARKERSTYLE_OPTS = OptsDict(
    :marker => lc    => set_markers! ⊙ pick_mstyles,
    :ms     => posfl => set_msizes!  ⊙ pick_mstyles,
    :mc     => col   => set_mcols!   ⊙ pick_mstyles,
    )

const BARSTYLE_OPTS = OptsDict(
    :ec => col => set_color!, # color
    )

const GBARSTYLE_OPTS = OptsDict(
    :col   => col   => set_fills!  ⊙ pick_bstyles,
    :ec    => col   => set_colors! ⊙ pick_bstyles,
    :width => posfl => set_bwidth!,
    )

const FILLSTYLE_OPTS = OptsDict(
    :col   => col   => set_fill!,
    :alpha => alpha => set_alpha!,
    )


###############################################################
####
#### Options for AX_ELEMS
####
###############################################################

const TITLE_OPTS = OptsDict(
    :dist => posfl => set_dist!
    )
merge!(TITLE_OPTS, TEXTSTYLE_OPTS)
set_properties!(t::Title; opts...) = set_properties!(TITLE_OPTS, t; opts...)


const LEGEND_OPTS = OptsDict(
    # position of the legend
    :pos     => lc    => set_position!, # set_legend
    # toggle legend on/off
    :off     => bool  => set_off!,      # .
    :on      => not   => set_off!,      # .
    # toggle surrounding box on/off
    :nobox   => bool  => set_nobox!,    # .
    :box     => not   => set_nobox!,    # .
    # specify margins (internal) and offset (external)
    :margins => fl    => set_margins!,  # .
    :offset  => fl    => set_offset!,   # .
    # background color and alpha
    :bgcol   => opcol => set_color!,    # set_style
    :bgalpha => alpha => set_alpha!,    # .
    )
merge!(LEGEND_OPTS, TEXTSTYLE_OPTS)
set_properties!(l::Legend; opts...) = set_properties!(LEGEND_OPTS, l; opts...)


const TICKS_OPTS = OptsDict(
    # ticks
    :off        => bool => set_off!,
    :on         => not  => set_off!,
    :len        => fl   => set_length!,
    :sym        => bool => set_symticks!,
    :tcol       => col  => set_color!,
    # grid mode
    :grid       => bool => set_grid!,
    # labels
    :hidelabels => bool => set_labels_off!,
    :showlabels => not  => set_labels_off!,
    :angle      => fl   => set_angle!,
    :format     => lc   => set_format!,
    :shift      => fl   => set_shift!,
    :dist       => fl   => set_dist!,
    )
merge!(TICKS_OPTS, LINESTYLE_OPTS)  # ticks line
merge!(TICKS_OPTS, TEXTSTYLE_OPTS)  # labels
set_properties!(t::Ticks; opts...) = set_properties!(TICKS_OPTS, t; opts...)


###############################################################
####
#### Options for DRAWINGS
####
###############################################################

const SCATTER2D_OPTS = OptsDict(
    :label  => str => set_labels!,
    )
merge!(SCATTER2D_OPTS, GLINESTYLE_OPTS)
merge!(SCATTER2D_OPTS, GMARKERSTYLE_OPTS)
set_properties!(s::Scatter2D; opts...) = set_properties!(SCATTER2D_OPTS, s; opts...)


const FILL2D_OPTS = OptsDict(
    :xmin  => fl  => set_xmin!,
    :xmax  => fl  => set_xmax!,
    :label => str => set_label!,
    )
merge!(FILL2D_OPTS, FILLSTYLE_OPTS)
set_properties!(f::Fill2D; opts...) = set_properties!(FILL2D_OPTS, f; opts...)


const HIST2D_OPTS = OptsDict(
    :bins    => posint => set_bins!,
    :scaling => lc     => set_scaling!,
    :horiz   => bool   => set_horiz!,
    :label   => str    => set_label!,
    )
merge!(HIST2D_OPTS, BARSTYLE_OPTS)
merge!(HIST2D_OPTS, FILLSTYLE_OPTS)
set_properties!(h::Hist2D; opts...) = set_properties!(HIST2D_OPTS, h; opts...)


const BAR2D_OPTS = OptsDict(
    :stacked => bool => set_stacked!,
    :horiz   => bool => set_horiz!,
    :label   => str  => set_labels!,
    )
merge!(BAR2D_OPTS, GBARSTYLE_OPTS)
set_properties!(gb::Bar2D; opts...) = set_properties!(BAR2D_OPTS, gb; opts...)


const BOXPLOT_OPTS = OptsDict(
    # -- global toggle
    :horiz     => bool  => set_horiz!,
    # -- now inside BOXSTYLES
    # box styling
    :bw        => posfl => set_bwidths!,
    :ww        => posfl => set_wwidths!,
    # how long should the whiskers be
    :wl        => posfl => set_wrlengths!,
    # what line style should be used to draw the boxes
    :bls       => I     => set_lstyles! ⊙ pick_blstyle,
    :blw       => posfl => set_lwidths! ⊙ pick_blstyle,
    :bc        => col   => set_colors!  ⊙ pick_blstyle,
    # median line
    :medls     => I     => set_lstyles! ⊙ pick_mlstyle,
    :medlw     => posfl => set_lwidths! ⊙ pick_mlstyle,
    :medc      => col   => set_colors!  ⊙ pick_mlstyle,

    # mean marker
    :mean_show => bool  => set_mshow!,
    :mm        => str   => set_markers! ⊙ pick_mmstyle,
    :mms       => posfl => set_msizes!  ⊙ pick_mmstyle,
    :mmc       => col   => set_mcols!   ⊙ pick_mmstyle,
    # outliers
    :out_show  => bool  => set_mshow!,
    :om        => str   => set_markers! ⊙ pick_omstyle,
    :oms       => posfl => set_msizes!  ⊙ pick_omstyle,
    :omc       => col   => set_mcols!   ⊙ pick_omstyle,
    )
set_properties!(bp::Boxplot; opts...) = set_properties!(BOXPLOT_OPTS, bp; opts...)


const HEATMAP_OPTS = OptsDict(
    :cmap     => col => set_cmap!,
    )
set_properties!(h::Heatmap; opts...) = set_properties!(HEATMAP_OPTS, h; opts...)


const SCATTER3D_OPTS = OptsDict(
    :label  => str => set_label!, # .
    )
merge!(SCATTER3D_OPTS, LINESTYLE_OPTS)
merge!(SCATTER3D_OPTS, MARKERSTYLE_OPTS)
set_properties!(s::Scatter3D; opts...) = set_properties!(SCATTER3D_OPTS, s; opts...)


###############################################################
####
#### Options for OBJECTS
####
###############################################################

const TEXT2D_OPTS = OptsDict(
    :pos => str => set_position!,
    )
merge!(TEXT2D_OPTS, TEXTSTYLE_OPTS)
set_properties!(t::Text2D; opts...) = set_properties!(TEXT2D_OPTS, t; opts...)


const STRAIGHTLINE2D_OPTS = OptsDict(
    )
merge!(STRAIGHTLINE2D_OPTS, LINESTYLE_OPTS)
set_properties!(t::StraightLine2D; opts...) = set_properties!(STRAIGHTLINE2D_OPTS, t; opts...)


const BOX2D_OPTS = OptsDict(
    :pos      => str   => set_position!,
    :nobox    => bool  => set_nobox!,
    :box      => not   => set_nobox!,
    :fill     => opcol => set_fill!,
    :alpha    => alpha => set_alpha!,
    )
merge!(BOX2D_OPTS, LINESTYLE_OPTS)
set_properties!(b::Box2D; opts...) = set_properties!(BOX2D_OPTS, b; opts...)


const COLORBAR_OPTS = OptsDict(
    :pixels     => posint => set_pixels!,
    :nobox      => bool   => set_nobox!,
    :box        => not    => set_nobox!,
    :pos        => str    => set_position!,
    :offset     => fl     => set_offset!,
    :size       => posfl  => set_size!,
    :ticks      => fl     => set_ticks!,
    :labels     => str    => set_labels!,
    )
merge!(COLORBAR_OPTS, TICKS_OPTS)
merge!(COLORBAR_OPTS, TEXTSTYLE_OPTS)
set_properties!(b::Colorbar; opts...) = set_properties!(COLORBAR_OPTS, b; opts...)


###############################################################
####
#### Options for AX*
####
###############################################################

const  AXES_OPTS = OptsDict(
    :size  => fl   => set_size!,
    :title => str  => set_title!,
    :off   => bool => set_off!,
    )
set_properties!(a::Axes; opts...) = set_properties!(AXES_OPTS, a; opts...)


const AXIS_OPTS = OptsDict(
    :title  => str   => set_title!,
    :base   => posfl => set_base!,
    :min    => fl    => set_min!,
    :max    => fl    => set_max!,
    :log    => bool  => set_log!,
    :lw     => posfl => set_lwidth!,
    :off    => bool  => set_off!,
    )
merge!(AXIS_OPTS, TEXTSTYLE_OPTS)
set_properties!(a::Axis; opts...) = set_properties!(AXIS_OPTS, a; opts...)


###############################################################
####
#### Options for FIGURE
####
###############################################################

const FIGURE_OPTS = OptsDict(
    :size     => posfl => set_size!,
    :tex      => bool  => set_texlabels!,
    :texscale => lc    => set_texscale!,
    :alpha    => bool  => set_transparency!,
    :preamble => str   => set_texpreamble!,
    :col      => opcol => set_color!,
    :bgcol    => opcol => set_color!,
    :bgalpha  => alpha => set_alpha!,
    )
merge!(FIGURE_OPTS, TEXTSTYLE_OPTS)
set_properties!(f::Figure; opts...) = set_properties!(FIGURE_OPTS, f; opts...)
