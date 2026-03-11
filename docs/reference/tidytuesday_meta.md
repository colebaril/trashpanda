# TidyTuesday Metadata

A dataset of TidyTuesday posts with YAML metadata, code metrics, and
plot image names.

## Usage

``` r
tidytuesday_meta
```

## Format

A tibble with columns:

- file_path:

  Path to the .qmd file in the repo

- title:

  Title from YAML

- date:

  Date of the post

- categories:

  Categories from YAML

- image:

  Plot image file name from plot_name object

- num_lines:

  Number of code lines

- num_comments:

  Number of comment lines

- functions_used:

  List of functions called in the code

- packages:

  List of packages loaded

- plot_types:

  List of geom types used

## Source

<https://github.com/colebaril/tidytuesday>
