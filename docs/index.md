+++
page_title = "GLEPlot.jl"
+++

# GLEPlot

@@lead
Foo bar
@@

```!
using GLEPlot
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
