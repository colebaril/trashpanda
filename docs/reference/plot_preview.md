# Save Plot and Generate Preview Card

Saves a ggplot to disk, optionally creates a 16:9 preview image, and
optionally includes the full-size image in a knitr document. This
function is specifically designed to work inside of R Markdown and
Quarto during rendering.

## Usage

``` r
plot_preview(
  plot,
  filename = "plot.png",
  preview_name = "preview.png",
  path = NULL,
  width = 10,
  height = 12,
  dpi = 300,
  preview = TRUE,
  preview_width = 1200,
  preview_height = 675,
  include = FALSE,
  device = ragg::agg_png
)
```

## Arguments

- plot:

  A ggplot object

- filename:

  Name of the output image file (default: "plot.png")

- preview_name:

  Name of preview image (default: "preview.png")

- path:

  Directory to save files (default: current knitr dir)

- width:

  Width of saved plot (in inches)

- height:

  Height of saved plot (in inches)

- dpi:

  Resolution in dots per inch

- preview:

  Logical; create 16:9 preview image?

- preview_width:

  Width of preview in pixels (default: 1200)

- preview_height:

  Height of preview in pixels (default: 675)

- include:

  Logical; include full-size image in document?

- device:

  Graphics device (default: ragg::agg_png)

## Value

Invisibly returns list of file paths
