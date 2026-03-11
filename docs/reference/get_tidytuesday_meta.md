# Get TidyTuesday Metadata from GitHub

Returns a tibble of TidyTuesday posts with YAML metadata, code features,
and plot image names.

## Usage

``` r
get_tidytuesday_meta(
  owner = "colebaril",
  repo = "tidytuesday",
  branch = "main"
)
```

## Arguments

- owner:

  GitHub username (default: "colebaril")

- repo:

  GitHub repository (default: "tidytuesday")

- branch:

  GitHub branch (default: "main")

## Value

A tibble with file_path, title, date, categories, image, code metrics
