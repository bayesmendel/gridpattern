# gridpattern

[![Build Status](https://travis-ci.org/trevorld/gridpattern.png?branch=main)](https://travis-ci.org/trevorld/gridpattern)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/trevorld/gridpattern?branch=main&svg=true)](https://ci.appveyor.com/project/trevorld/gridpattern)
[![Coverage Status](https://img.shields.io/codecov/c/github/trevorld/gridpattern.svg)](https://codecov.io/github/trevorld/gridpattern?branch=main)
[![Project Status: WIP -- Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

`gridpattern` provides [grid.pattern() and
patternGrob()](http://trevorldavis.com/R/gridpattern/dev/reference/grid.pattern.html)
functions to use with R's grid graphics system. They fill in a
specified boundary bath with a pattern. These patterned grobs are
extracted from [Mike FC](https://github.com/coolbutuseless)'s awesome
[ggpattern](https://github.com/coolbutuseless/ggpattern) package (which
provides patterned ggplot2 "geom" functions but 
[does not provide exported access to the underlying grobs](https://github.com/coolbutuseless/ggpattern/issues/11) themselves).

We currently provide grob support for the following `ggpattern` patterns:

1.  [ambient](https://trevorldavis.com/R/gridpattern/dev/reference/grid.pattern_ambient.html):
    noise array patterns powered by the [ambient](https://cran.r-project.org/web/packages/ambient/index.html) package
2.  [circle](https://trevorldavis.com/R/gridpattern/dev/reference/grid.pattern_circle.html): circle geometry patterns
3.  [crosshatch](https://trevorldavis.com/R/gridpattern/dev/reference/grid.pattern_crosshatch.html): crosshatch geometry patterns
4.  [gradient](https://trevorldavis.com/R/gridpattern/dev/reference/grid.pattern_gradient.html): gradient array patterns
5.  [image](https://trevorldavis.com/R/gridpattern/dev/reference/grid.pattern_image.html): image array patterns
6.  [magick](https://trevorldavis.com/R/gridpattern/dev/reference/grid.pattern_magick.html): imagemagick array patterns
7.  none (equivalent to `grid::null()`)
8.  [placeholder](https://trevorldavis.com/R/gridpattern/dev/reference/grid.pattern_placeholder.html): placeholder image array patterns
9.  [plasma](https://trevorldavis.com/R/gridpattern/dev/reference/grid.pattern_plasma.html): plasma array patterns
10. [stripe](https://trevorldavis.com/R/gridpattern/dev/reference/grid.pattern_stripe.html): stripe geometry patterns
11. [Custom geometry-based patterns](https://coolbutuseless.github.io/package/ggpattern/articles/developing-patterns-2.html)
12. [Custom array-based patterns](https://coolbutuseless.github.io/package/ggpattern/articles/developing-patterns-3.html)

## Installation

To install the development version use the following command in R:



```r
remotes::install_github("trevorld/gridpattern")
```

## Examples




```r
library("ambient")
library("gridpattern")
x_hex <- 0.5 + 0.5 * cos(seq(2 * pi / 4, by = 2 * pi / 6, length.out = 6))
y_hex <- 0.5 + 0.5 * sin(seq(2 * pi / 4, by = 2 * pi / 6, length.out = 6))
```


```r
grid.pattern("ambient", x_hex, y_hex, fill = "green", fill2 = "blue")
```

![](man/figures/README-ambient-1.png)

```r
grid.pattern("circle", x_hex, y_hex, colour="blue", fill="yellow", size = 2, density = 0.5)
```

![](man/figures/README-circle-1.png)

```r
grid.pattern("crosshatch", x_hex, y_hex, colour="blue", fill="yellow", density = 0.5, angle = 135)
```

![](man/figures/README-crosshatch-1.png)

```r
grid.pattern("gradient", x_hex, y_hex, fill="blue", fill2="green", orientation="radial")
```

![](man/figures/README-gradient-1.png)

```r
logo_filename   <- system.file("img", "Rlogo.png" , package="png")
grid.pattern("image", filename=logo_filename, type="tile")
```

![](man/figures/README-image-1.png)

```r
grid.pattern("magick", x_hex, y_hex, type="octagons", fill="blue", scale=2)
```

![](man/figures/README-magick-1.png)

```r
grid.pattern("placeholder", x_hex, y_hex, type="bear")
```

![](man/figures/README-placeholder-1.png)

```r
grid.pattern("plasma", x_hex, y_hex, fill="green")
```

![](man/figures/README-plasma-1.png)

```r
grid.pattern("stripe", x_hex, y_hex, colour="blue", fill="yellow", density = 0.5, angle = 135)
```

![](man/figures/README-stripe-1.png)