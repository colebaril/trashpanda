# Look for and extract a table anywhere within a CSV file.

Searches a CSV file for a table using one of two strategies:

- By locating a marker row (e.g., "TABLE: RESULTS"), after which the
  next non-empty row is treated as the header.

- By locating a header row that contains a known column name
  (`start_column`), analogous to
  [`extract_table()`](https://colebaril.github.io/trashpanda/reference/extract_table.md)
  for Excel files.

Exactly one of `table_marker` or `start_column` must be supplied.

## Usage

``` r
extract_table_csv(
  path,
  table_marker = NULL,
  start_column = NULL,
  header_regex = NULL,
  ignore_case = TRUE,
  exact_match = TRUE,
  max_blank_rows = Inf,
  na_values = c("", NA),
  safely = TRUE,
  id_cols = FALSE,
  verbose = FALSE,
  ...
)
```

## Arguments

- path:

  Path to CSV file

- table_marker:

  Optional string or regex identifying the table marker row

- start_column:

  Optional name of a known header column

- header_regex:

  Optional regex to validate header row contents

- ignore_case:

  Logical; ignore case when matching text

- exact_match:

  Logical; exact matching for table_marker. Default TRUE.

- max_blank_rows:

  Number of blank rows tolerated between marker and header. Default Inf.

- na_values:

  Values treated as NA

- safely:

  Logical; return NULL instead of error on failure

- id_cols:

  Logical; add file/table metadata columns

- verbose:

  Logical; emit detailed progress messages

- ...:

  Unused (for interface compatibility)

## Value

A tibble, or NULL if safely = TRUE and no table found
