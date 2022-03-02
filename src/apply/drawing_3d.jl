# """
#     apply_drawing!(f, hm, ...)
#
# Apply Scatter3D.
# """
# function apply_drawing!(
#             f::Figure,
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
#     "\ngsave"    |> f
#
#     # apply linestyle
#     apply_linestyle!(f, ls; nosmooth=true, addset=true)
#     showline = Int(ls.lstyle != -1)
#
#     "\nplot3 \"$faux\" $xmin $xspan $ymin $yspan $showline" |> f
#
#     # apply markerstyle
#     ms = scatter3.markerstyle
#     if isanydef(ms)
#         "1"  |> f # showmarker
#         # fill default values
#         isdef(ms.marker) || (ms.marker = "fcircle")
#         isdef(ms.color)  || (ms.color  = ls.color)
#         isdef(ms.msize)  || (ms.msize  = 0.1)
#         if (ms.color != ls.color)
#             add_sub_marker!(fig, ms)
#             str(ms) |> f
#             # see also boxplot for an explanation of the scaling
#             "$(2 * ms.msize / fig.textstyle.hei)" |> f
#         else
#             ms.marker |> f
#             "$(2 * ms.msize)" |> f
#         end
#     else
#         # don't show marker, default fields (won't be read)
#         "-1 xxx 0" |> f
#     end
#
#     # end of scatter3d, restore style
#     "\ngrestore" |> f
#
#     return el_cntr + 1
# end
