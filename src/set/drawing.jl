####
#### Scatter2D
####

"""
   set_label!(obj, v)

Internal function to set the label associated with an object `obj` to
string `v`.
"""
set_label!(o::Union{Hist2D, Fill2D, Scatter3D}, v::String) =
    (o.label = v;)


# label of a drawing (cf legend)
function set_labels!(o::Union{Scatter2D, Bar2D}, v::Vector{String})
    length(v) == o.nobj || throw(
        DimensionMismatch("labels // dimensions don't match")
    )
    o.labels = v
    return
end
# unusual calls...
set_labels!(o::Scatter2D, s::String) = set_labels!(o, fill(s, length(o.linestyles)))
set_labels!(o::Bar2D,     s::String) = set_labels!(o, fill(s, length(o.barstyles)))


####
#### Hist2D / Bar
####

set_bins!(o::Hist2D, v::Int) = (o.bins = v;)

function set_scaling!(o::Hist2D, v::String)
   o.scaling = get(HIST2D_SCALING, v) do
      throw(
            OptionValueError("scaling", v)
      )
   end
   return
end

set_horiz!(o::Union{Hist2D,Bar2D,Boxplot}, v::Bool) = (o.horiz = v)

####
#### Fill2D
####

set_xmin!(o::Fill2D, v::F64) = (o.xmin = v;)
set_xmax!(o::Fill2D, v::F64) = (o.xmax = v;)

####
#### Bar2D
####

set_stacked!(o::Bar2D, v::Bool) = (o.stacked = v;)


####
#### Heatmap
####

set_cmap!(h::Heatmap, c::Vector{<:Color}) = (h.cmap = c;)
