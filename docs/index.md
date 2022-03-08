+++
page_title = "GLEPlot.jl"
+++

# GLEPlot

@@lead
Foo bar baz
@@

```!
using GLEPlot, Colors
```

## Explicit arrays

```!
x = range(-1, 1, length=250)
y = @. exp(-x^2) * sinc(5x)
plot(x, y)
gcf()
```

## Implicit arrays

```!
plot(x -> exp(-x^2) * sinc(5x), -1, 1)
gcf()
```

## Multi curves

```!
x  = range(-1, 1, length=250)
y1 = @. exp(-x^2) * sinc(5x)
y2 = @. exp(-x^3) * sinc(3x)
y3 = @. exp(-x^4) * sinc(2x)
plot(x, y1, y2, y3)
gcf()
```

## Adding curves

```!
x  = range(-3, 3, length=250)
y  = @. exp(-x^2)
x2 = range(-3, 3, length=50)
y2  = @. -abs(x2/3) + 1
plot(x, y)
plot!(x2, y2)
gcf()
```

## Smooth / non-smooth

```!
x = range(-3, 3, length=10)
y = @. sin(x)
plot(x, y)
plot!(x, y .+ 1, smooth=false)
gcf()
```

## Fill

<!-- ```!
x  = range(-3, 3, length=50)
y1 = @. sin(x)
y2 = @. cos(x)
fill_between(x, y1, y2)
gcf()
``` -->


## 2D plot and properties

**Note**: add legend to stuff.

```!
x = range(-2, 2, length=100)
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
