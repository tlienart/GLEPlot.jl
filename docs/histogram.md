+++
page_title = "Histogram"
+++

# Histogram

```!
using GLEPlot, Colors, Distributions
x = 3 .+ 2 * randn(5_000);
```

```!
Figure()
hist(x)
gcf()
```

### Scaling

Base one is to just use count. You can pass the scaling as a string or a symbol, case doesn't matter.

* \{`none`\}: raw count per bin,
* \{`freq`, `frequency`, `prob`, `probability`\}: each bin count is scaled by the total number of observations,
* \{`pdf`, `density`\}: each bin count is scaled by the total number of observations and the width of each bin
so that the total area covered by the histogram equals one.

```!
Figure()
hist(x, scaling=:freq)
gcf()
```

The PDF/Density one is what you want if you want to compare with a distribution:

```!
Figure()
hist(x, scaling=:pdf)

nd = Normal(3, 2)
xx = range(-4, 12, length=100)
yy = pdf.(nd, xx)
plot!(xx, yy)

gcf()
```
