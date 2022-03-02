"""
    Drawing3D

Overarching type for drawings displayable on `Axes3D`.
"""
abstract type Drawing3D <: Drawing end


# NOTE missing inf or nan NOT allowed
# NOTE one at a time, syntax for multiple would be confusing
mutable struct Scatter3D{T} <: Drawing3D
    data       ::T  # data container
    linestyle  ::LineStyle     # line style (color, width, ...)
    markerstyle::MarkerStyle   # marker style (color, size, ...)
    label      ::String        # plot labels (to go in the legend)
end
Scatter3D(d) = default(Scatter3D, d)

#
#
# mutable struct Surface <: Drawing3D
#
# end
