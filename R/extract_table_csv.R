#' Look for and extract a table anywhere within a CSV file.
#'
#' @description
#' Searches a CSV file for a table using one of two strategies:
#' \itemize{
#'   \item By locating a marker row (e.g., "TABLE: RESULTS"), after which the
#'   next non-empty row is treated as the header.
#'   \item By locating a header row that contains a known column name
#'   (\code{start_column}), analogous to \code{extract_table()} for Excel files.
#' }
#'
#' Exactly one of \code{table_marker} or \code{start_column} must be supplied.
#'
#' @param path Path to CSV file
#' @param table_marker Optional string or regex identifying the table marker row
#' @param start_column Optional name of a known header column
#' @param header_regex Optional regex to validate header row contents
#' @param ignore_case Logical; ignore case when matching text
#' @param exact_match Logical; exact matching for table_marker. Default TRUE.
#' @param max_blank_rows Number of blank rows tolerated between marker and header. Default Inf.
#' @param na_values Values treated as NA
#' @param safely Logical; return NULL instead of error on failure
#' @param id_cols Logical; add file/table metadata columns
#' @param verbose Logical; emit detailed progress messages
#' @param ... Unused (for interface compatibility)
#'
#' @return A tibble, or NULL if safely = TRUE and no table found
#' @export
extract_table_csv <- function(
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
) {
  
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  trim <- function(x) trimws(x %||% "")
  
  if (is.null(table_marker) && is.null(start_column)) stop("Provide table_marker or start_column")
  if (!is.null(table_marker) && !is.null(start_column)) stop("Provide only one: table_marker or start_column")
  
  if (verbose) message("\nReading CSV file: ", basename(path))
  
  # Read CSV
  raw <- tryCatch(
    readr::read_csv(path, col_names = FALSE, na = na_values,
                    show_col_types = FALSE, progress = FALSE),
    error = function(e) if (safely) return(NULL) else stop(e)
  )
  
  raw_chr <- as.data.frame(lapply(raw, as.character), stringsAsFactors = FALSE)
  raw_chr[is.na(raw_chr)] <- ""  # replace all NAs with empty string
  n_rows <- nrow(raw_chr)
  n_cols <- ncol(raw_chr)
  
  header_row <- NA_integer_
  
  # ----------------------
  # Marker-based detection
  # ----------------------
  if (!is.null(table_marker)) {
    if (verbose) message("Searching for table marker: ", table_marker)
    
    marker_rows <- which(apply(raw_chr, 1, function(row) {
      row_vals <- trim(unlist(row))
      if (exact_match) {
        if (ignore_case) any(tolower(row_vals) == tolower(table_marker))
        else any(row_vals == table_marker)
      } else {
        if (ignore_case) any(grepl(table_marker, row_vals, ignore.case = TRUE))
        else any(grepl(table_marker, row_vals, fixed = TRUE))
      }
    }))
    
    if (length(marker_rows) == 0) {
      if (verbose) message("No table marker found.")
      return(if (safely) NULL else stop("No table marker found."))
    }
    
    marker_row <- marker_rows[1]
    if (verbose) message("Marker found at row ", marker_row)
    
    # --- Find header row after marker ---
    blanks_seen <- 0
    for (i in seq(marker_row + 1, n_rows)) {
      row_vals <- trim(unlist(raw_chr[i, ]))
      if (any(row_vals != "")) {
        header_row <- i
        if (verbose) message("Header row detected at row ", header_row)
        break
      }
      blanks_seen <- blanks_seen + 1
      if (blanks_seen > max_blank_rows) break
    }
    
    if (is.na(header_row)) {
      if (verbose) message("No header row found after marker.")
      return(if (safely) NULL else stop("Header row not found after table marker."))
    }
  }
  
  # ----------------------
  # Header-based detection
  # ----------------------
  if (!is.null(start_column)) {
    header_candidates <- which(apply(raw_chr, 1, function(row) {
      row_vals <- trim(unlist(row))
      any(row_vals == start_column)
    }))
    if (length(header_candidates) == 0) return(if (safely) NULL else stop("start_column not found"))
    header_row <- header_candidates[1]
    if (verbose) message("Header row detected at row ", header_row)
  }
  
  # ----------------------
  # Parse header
  # ----------------------
  raw_header <- unlist(raw_chr[header_row, ])
  raw_header[is.na(raw_header)] <- ""
  keep_cols <- raw_header != ""
  headers <- trim(raw_header[keep_cols])
  
  if (length(headers) == 0) return(if (safely) NULL else stop("Header row invalid"))
  
  if (!is.null(header_regex) && !any(grepl(header_regex, headers))) {
    return(if (safely) NULL else stop("Header regex validation failed"))
  }
  
  # ----------------------
  # Extract data
  # ----------------------
  data_start <- header_row + 1
  data_end <- n_rows
  for (i in seq(data_start, n_rows)) {
    row_vals <- trim(unlist(raw_chr[i, keep_cols]))
    if (all(row_vals == "")) {
      data_end <- i - 1
      break
    }
  }
  
  if (data_end < data_start) return(if (safely) NULL else stop("No data rows found"))
  
  data <- raw_chr[data_start:data_end, keep_cols, drop = FALSE]
  colnames(data) <- headers
  
  out <- tibble::as_tibble(data)
  
  if (id_cols) {
    out <- dplyr::mutate(
      out,
      .file = basename(path),
      .table_id = 1,
      .before = 1
    )
  }
  
  out
}
