#' Cole's favourite plot theme
#'
#' A `ggplot2` theme styled to resemble old parchment and ink, giving plots
#' a vintage, manuscript-like appearance.
#' @param remove_grid Logical. If TRUE, removes all grid lines.
#' @param base_size Base text size. Default 12.
#' @param base_family Base font family. Default "sans".
#' @param dark Logical. If TRUE, plot is transformed to a dark theme.
#' @param transparent Logical. If TRUE, plot background is transparent.
#' @return A `ggplot2` theme object that can be added to ggplot plots.
#' @details
#' This theme adjusts panel backgrounds, grid lines, and text colors to
#' evoke the look of old parchment and handwritten ink. Works with `ggplot2` plots.
#'
#' @examples
#' library(ggplot2)
#' library(trashpanda)
#' library(palmerpenguins)
#' 
#' ggplot(penguins, aes(flipper_length_mm, bill_length_mm, fill = species, group = species)) +
#'   geom_point(shape = 21) +
#'   labs(title = "Flipper Length vs. Bill Length",
#'        subtitle = "Lorem ipsum") +
#'   theme_cole(remove_grid = TRUE, dark = TRUE) +
#'   add_caption_cwb() 
#'   
#'   
#' ggplot(penguins, aes(flipper_length_mm, bill_length_mm, fill = species, group = species)) +
#'   geom_point(shape = 21) +
#'   labs(title = "Flipper Length vs. Bill Length",
#'        subtitle = "Lorem ipsum") +
#'   theme_cole(remove_grid = FALSE) +
#'   add_caption_cwb() 
#'
#' @export
#' @import ggplot2

theme_cole <- function(base_size = 12, 
                       base_family = "sans", 
                       remove_grid = FALSE, 
                       dark = FALSE,
                       transparent = FALSE) {
  
  th <- theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.title.position = "plot",
      plot.title = ggplot2::element_text(face = "bold", size = base_size * 1.5, hjust = 0.5),
      plot.subtitle = ggplot2::element_text(margin = ggplot2::margin(b = 8), hjust = 0.5),
      axis.title = ggplot2::element_text(face = "bold"),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(b = 8)),
      strip.text = ggplot2::element_text(face = "bold"),
      plot.margin = ggplot2::margin(12, 12, 12, 12),
      legend.title = ggplot2::element_text(face = "bold", size = base_size * 1.2),
      legend.text = ggplot2::element_text(size = base_size * 1.1)
    )
  
  if (remove_grid) {
    th <- th + theme(
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.grid.minor.y = element_blank()
    )
  }
  
  if (dark) {
    th <- th + ggplot2::theme(
      plot.background = element_rect(fill = "#222222", color = NA),
      panel.background = element_rect(fill = "#222222", color = NA),
      panel.grid.major = element_line(color = "#555555"),
      panel.grid.minor = element_line(color = "#444444"),
      axis.text = element_text(color = "white"),
      axis.title = element_text(color = "white"),
      plot.title = element_text(color = "white"),
      plot.subtitle = element_text(color = "white"),
      strip.text = element_text(color = "white"),
      legend.background = element_blank(),
      legend.key = element_blank(),
      legend.text = element_text(color = "white"),
      legend.title = element_text(color = "white")
    )
  } else if (transparent) {
    # Transparent backgrounds in light mode
    th <- th + theme(
      plot.background   = element_rect(fill = "transparent", color = NA),
      panel.background  = element_rect(fill = "transparent", color = NA),
      legend.background = element_rect(fill = "transparent", color = NA),
      legend.key        = element_rect(fill = "transparent", color = NA),
      strip.background  = element_rect(fill = "transparent", color = NA)
    )
  }
  
  return(th)
}

