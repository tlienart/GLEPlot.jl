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
