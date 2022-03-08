+++
page_title = "GLEPlot.jl"
+++

# GLEPlot

@@lead
Foo bar baz
@@

## Installation

### Mac OS

Get latest from sourceforge. At the time of writing it's `4.3.2` [here](https://sourceforge.net/projects/glx/files/gle/4.3.2/gle-4.3.2-Darwin.zip/download).
Once downloaded, copy paste the content (except the `Applications` symlink) to a `gle` folder somewhere on your computer.
Say for instance `~/Desktop/gle` so that its structure looks like

```plain
gle
├── bin
├── doc
├── font
├── gleinc
├── glerc
├── init.tex
└── inittex.ini
```

then make `bin/gle` executable

```plain
$> sudo chmod +x bin/gle
```

Mac OS will try to block you from using it because it's un-indentified software.
To trigger this, run

```plain
$> bin/gle -v
```

a popup like the following may appears

@@img-small
![](/assets/popup.png)
@@

go to your System Preferences, click on _Security \& Privacy_ and click on the button "Allow Anyway" then close the popup and try again.
You might again see a popup but this time can click on "Open"
(and it will be the last time you'll get a popup for GLE).
The result should be something like:

```plain
$> bin/gle -v
GLE version 4.3.2
Usage: gle [options] filename.gle
More information: gle -help
```

Finally, you can add the `gle` executable to your global `PATH`.
For instance if you put the `gle` folder on your Desktop:

```plain
$> export PATH=$HOME/Desktop/gle/bin:$PATH
```

you might want to put this in your `~/.bashrc` file (or `~/.zshrc` if you're using ZSH etc.).
Following this, you should be able to just do

```plain
$> gle -v
GLE version 4.3.2
Usage: gle [options] filename.gle
More information: gle -help
```

### Linux

This is also what we use on CI:

```plain
curl -L https://sourceforge.net/projects/glx/files/gle/4.3.2/gle-4.3.2-Linux.zip/download > gle.zip
unzip gle.zip
```

Here as well you might want to add `gle/bin/` to the PATH.

### Setting the path

You don't have to set the `PATH`, in fact we don't on CI (where it's not straightforward).
You can specify explicitly to GLEPlot where the executable is by doing

```julia
ENV["GLE"] = "..."
```

replacing `...` by the path to the `gle` executable.

# Stuff


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


<!--
==============================================================================
==============================================================================
==============================================================================
==============================================================================
-->

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
