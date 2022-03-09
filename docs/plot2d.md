+++
page_title = "Plot (2D)"
+++

# Plot (2D)

```!
using GLEPlot, Colors
x = range(-2, 2, length=100);
```

### Line style

```!
opts = ("-", "--", "-.")
Figure()
for (α, o) in enumerate(opts)
    y = @. sinc(α * x)
    plot!(x, y, lstyle=o)
end
gcf()
```

### Line width

```!
opts = (0.001, 0.01, 0.05, 0.1, 0)
Figure()
for (α, o) in enumerate(opts)
    y = @. sinc(α * x)
    plot!(x, y, lwidth=o)
end
gcf()
```

### Line colour

```!
opts = ("cornflowerblue", "forestgreen", "indigo", RGB(.5,.7,.2))
Figure()
for (α, o) in enumerate(opts)
    y = @. sinc(α * x)
    plot!(x, y, col=o)
end
gcf()
```

### Smooth

Reduce the resolution a lot

```!
x = range(-2, 2, length=20)

opts = (true, false)
Figure()
for (α, o) in enumerate(opts)
    y = @. sinc(α * x)
    plot!(x, y, smooth=o)
end
gcf()
```

### Marker type

```!
# there's a bunch of other ones like diamond etc
opts = ("circle", "fcircle", "triangle", "ftriangle", "cross", "plus")
Figure()
for (α, o) in enumerate(opts)
    y = @. sinc(α * x)
    plot!(x, y, marker=o)
end
gcf()
```

### Marker size

```!
opts = (0.1, 0.25, 0.5)
Figure()
for (α, o) in enumerate(opts)
    y = @. sinc(α * x)
    plot!(x, y, marker="fcircle", msize=o)
end
gcf()
```

<!--
XXX

### Marker colour

```!
opts = ("red", "green", "blue")
Figure()
for (α, o) in enumerate(opts)
    y = @. sinc(α * x)
    plot!(x, y, marker="fcircle", msize=0.25, mcol=o)
end
gcf()
```
-->

### Missing, NaN or Inf values

```!
y = [1,2,3,missing,3,2,1,NaN,0,1]
plot(y, marker="o", smooth=false)
gcf()
```

### Modifying the data in place

```!
y = collect(1:6)
plot(y, marker=".", smooth=false)
y[3] = 0
gcf()
```


### Data Formats

Single vector → $(i, x_i)$

```!
x = randn(5)
plot(x, smooth=false)
gcf()
```

Two vectors → $(x_i, y_i)$

```!
x = 0:0.1:3
y = @. sinc(x)
plot(x, y)
gcf()
```

Multiple vectors → $\left\{(x_i, y^{(1)}_i), (x_i, y^{(2)}_i), \dots\right\}$

```!
x = range(-1,1,length=100)
y1 = @. sinc(x)
y2 = @. sinc(2x)
y3 = @. sinc(3x)
plot(x, y1, y2, y3)
gcf()
```

Single matrix → $\left\{(i, Z_{i1}), (i, Z_{i2}), \dots\right\}$

```!
x = range(-1,1,length=100)
z = hcat(sin.(x), cos.(x))
plot(z)
gcf()
```

Vector and vectors or matrices → pairs between the first vector and subsequent "columns":

```!
x = range(-1,1,length=100)
z = hcat(sin.(x), cos.(x))
z2 = @. x^2 - 1
plot(x, z, z2)
gcf()
```

Function with range (and optionally a number of points):

```!
plot(sin, 0, 2pi, length=150)
gcf()
```

### Styling a group

When multiple lines are shown jointly, you can pass vectors for option values or single values,
in the first case, the vector must have length corresponding to the number of plots, in the second case, the option is applied to all plots:

```!
plot(randn(10, 3), colors=["violet", "navy", "orange"], lwidth=0.1, smooth=false)
gcf()
```
