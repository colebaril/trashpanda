#' Get TidyTuesday Metadata from GitHub
#'
#' Returns a tibble of TidyTuesday posts with YAML metadata, code features, and plot image names.
#' @param owner GitHub username (default: "colebaril")
#' @param repo GitHub repository (default: "tidytuesday")
#' @param branch GitHub branch (default: "main")
#' @return A tibble with file_path, title, date, categories, image, code metrics
#' @export
get_tidytuesday_meta <- function(owner = "colebaril",
                                 repo = "tidytuesday",
                                 branch = "main") {
  require(pacman)
  p_load(gh, httr, stringr, yaml, tidyverse)
  
  repo_base <- paste0("https://raw.githubusercontent.com/", owner, "/", repo, "/", branch, "/")
  
  # --- 1. List all .qmd files in repo (excluding docs) ---
  all_files <- gh::gh(
    "GET /repos/{owner}/{repo}/git/trees/{branch}?recursive=1",
    owner = owner, repo = repo, branch = branch
  )
  
  file_paths <- sapply(all_files$tree, function(x) x$path)
  
  qmd_paths <- file_paths[str_detect(file_paths, "\\.qmd$") & 
                            !str_detect(file_paths, "^docs/|about.qmd|categories.qmd|index.qmd")]
  
  # --- Helper functions ---
  
  extract_yaml <- function(raw_url) {
    content <- readLines(raw_url, warn = FALSE)
    yaml_start <- which(content == "---")[1]
    yaml_end <- which(content == "---")[2]
    if(is.na(yaml_start) || is.na(yaml_end)) return(NULL)
    yaml_text <- content[(yaml_start + 1):(yaml_end - 1)]
    yaml::yaml.load(paste(yaml_text, collapse = "\n"))
  }
  
  extract_code_features <- function(raw_url) {
    content <- readLines(raw_url, warn = FALSE)
    yaml_end <- which(content == "---")[2]
    if(!is.na(yaml_end)) content <- content[(yaml_end + 1):length(content)]
    
    num_lines <- length(content)
    num_comments <- sum(str_detect(content, "^\\s*#"))
    
    functions_used <- str_extract_all(content, "\\b\\w+\\(") %>% unlist() %>% str_remove("\\(") %>% unique()
    
    packages <- c(
      str_extract_all(content, "(?<=library\\(|require\\()\\w+") %>% unlist(),
      str_extract_all(content, "(?<=p_load\\()[^)]*") %>% unlist() %>% 
        str_split(",") %>% unlist() %>% str_trim() %>% str_remove_all("'|\"")
    ) %>% unique()
    
    plot_types <- str_extract_all(content, "geom_\\w+") %>% unlist() %>% str_remove("geom_") %>% unique()
    
    tibble(
      num_lines = num_lines,
      num_comments = num_comments,
      functions_used = list(functions_used),
      packages = list(packages),
      plot_types = list(plot_types)
    )
  }
  
  extract_plot_name <- function(raw_url) {
    content <- readLines(raw_url, warn = FALSE)
    yaml_end <- which(content == "---")[2]
    if(!is.na(yaml_end)) content <- content[(yaml_end + 1):length(content)]
    
    line <- content[str_detect(content, "plot_name\\s*<-\\s*['\"]")]
    if(length(line) == 0) return(NA)
    
    str_match(line[1], "plot_name\\s*<-\\s*['\"]([^'\"]+)['\"]")[,2]
  }
  
  # --- 2. Build dataset ---
  map_df(qmd_paths, function(p) {
    raw_url <- paste0(repo_base, utils::URLencode(p))
    
    yaml_info <- extract_yaml(raw_url)
    if(is.null(yaml_info)) return(NULL)
    
    code_info <- extract_code_features(raw_url)
    plot_image <- extract_plot_name(raw_url)
    
    tibble(
      file_path = p,
      title = yaml_info$title %||% NA,
      date = yaml_info$date %||% NA,
      categories = list(yaml_info$categories %||% NA),
      image = plot_image
    ) %>% bind_cols(code_info)
  })
}
