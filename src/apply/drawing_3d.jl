# """
#     apply_drawing!(g, hm, ...)
#
# Apply Scatter3D.
# """
# function apply_drawing!(
#             g::GS,
#             scatter3::Scatter3D,
#             el_cntr::Int,
#             figid::String,
#             axidx::Int
#         )::Int
#
#     faux = auxdata(scatter3, figid, axidx; nomiss=true)
#
#     # find the figure and axes
#     fig = Figure(figid; _noreset=true)
#     ax  = fig.axes[axidx]
#     # retrieve limits, which are needed to get the scale right
#     xmin  = ax.xaxis.min
#     xspan = ax.xaxis.max - xmin
#     ymin  = ax.yaxis.min
#     yspan = ax.yaxis.max - ymin
#
#     # add the GLE sub (if not already there)
#     add_sub_plot3!(fig)
#
#     # if there's no color, get one from palette
#     ls = scatter3.linestyle
#     if !isdef(scatter3.linestyle.color)
#         ls.color = palette(el_cntr)
#     end
#
#     # start of scatter3d, store
#     "\ngsave"    |> g
#
#     # apply linestyle
#     apply_linestyle!(g, ls; nosmooth=true, addset=true)
#     showline = Int(ls.lstyle != -1)
#
#     "\nplot3 \"$faux\" $xmin $xspan $ymin $yspan $showline" |> g
#
#     # apply markerstyle
#     ms = scatter3.markerstyle
#     if isanydef(ms)
#         "1"  |> g # showmarker
#         # fill default values
#         isdef(ms.marker) || (ms.marker = "fcircle")
#         isdef(ms.color)  || (ms.color  = ls.color)
#         isdef(ms.msize)  || (ms.msize  = 0.1)
#         if (ms.color != ls.color)
#             add_sub_marker!(fig, ms)
#             str(ms) |> g
#             # see also boxplot for an explanation of the scaling
#             "$(2 * ms.msize / fig.textstyle.hei)" |> g
#         else
#             ms.marker |> g
#             "$(2 * ms.msize)" |> g
#         end
#     else
#         # don't show marker, default fields (won't be read)
#         "-1 xxx 0" |> g
#     end
#
#     # end of scatter3d, restore style
#     "\ngrestore" |> g
#
#     return el_cntr + 1
# end
