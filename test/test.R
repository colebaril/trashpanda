
file <- "extract_table_test_sheets.xlsx"

test <- map_df(
  excel_sheets(file),
  ~ extract_table(
    path = file,
    sheet = .x,
    start_column = "Sample ID",
    table_mode = "all"
  )
)

require(pacman)
p_load(here, trashpanda, tidyverse)

t <- read_data_tree(
  path = here(),
  ext = "xlsx",
  recursive = TRUE,
  reader = extract_table,
  start_column = "Sample ID",
  table_mode = "all",
  search_until_empty_header = TRUE,
  max_empty_rows = 10,
  sheet_pattern = "merge",
  anti_sheet_pattern = "all",
  safely = TRUE,
  id_cols = TRUE,
  verbose = TRUE
)


t <- read_data_tree(
  path = here(),
  ext = "xlsx",
  recursive = TRUE,
  reader = extract_table,
  start_column = "Sample ID",
  table_mode = "all",

)

# csv

t <- read_data_tree(
  path = here("test"),
  ext = "csv",
  recursive = TRUE,
  reader = extract_table_csv,
  table_marker = "THE MARKER TABLE",
  exact_match = TRUE,
  verbose = TRUE,
  safely = TRUE,
  id_cols = TRUE
)


path = here("test/CSV TEST.csv")
ext = "csv"
recursive = TRUE
reader = extract_table_csv
table_marker = "THE MARKER TABLE"
verbose = TRUE
safely = TRUE
id_cols = TRUE


