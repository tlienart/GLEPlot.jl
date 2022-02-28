# GLEPlot

## Path

```
plot(a...; opts...)  | calls/drawing_2d
> d = plotdata(a...)
> s = Scatter2D(d, ...)
> set_properties!(s; opts...)
> DrawingHandle(s)

apply_axes(g, a, ...)
> set origin
> begin graph
> apply elements
> end graph

assemble_figure(f) (write GLE script)
> apply size
> apply background
> apply tex preamble
> apply axes
> write to file

savefig(f, fn, ...)
> assemble_figure(f)
> glecom = pipeline(`...`)
```
