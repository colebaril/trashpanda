#' Save Plot and Generate Preview Card
#'
#' Saves a ggplot to disk, optionally creates a 16:9 preview image,
#' and optionally includes the full-size image in a knitr document.
#' This function is specifically designed to work inside of R Markdown
#' and Quarto during rendering.
#'
#' @param plot A ggplot object
#' @param filename Name of the output image file (default: "plot.png")
#' @param preview_name Name of preview image (default: "preview.png")
#' @param path Directory to save files (default: current knitr dir)
#' @param width Width of saved plot (in inches)
#' @param height Height of saved plot (in inches)
#' @param dpi Resolution in dots per inch
#' @param preview Logical; create 16:9 preview image?
#' @param preview_width Width of preview in pixels (default: 1200)
#' @param preview_height Height of preview in pixels (default: 675)
#' @param include Logical; include full-size image in document?
#' @param device Graphics device (default: ragg::agg_png)
#'
#' @return Invisibly returns list of file paths
#' @export
plot_preview <- function(
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
) {
  
  # Resolve path
  if (is.null(path)) {
    path <- tryCatch(
      dirname(knitr::current_input()),
      error = function(e) getwd()
    )
  }
  
  file_path <- file.path(path, filename)
  preview_path <- file.path(path, preview_name)
  
  # Save main plot
  ggplot2::ggsave(
    plot = plot,
    filename = file_path,
    width = width,
    height = height,
    dpi = dpi,
    device = device
  )
  
  # Generate preview card
  if (preview) {
    img <- magick::image_read(file_path)
    
    geometry <- paste0(preview_width, "x", preview_height)
    
    img_card <- magick::image_scale(img, geometry)
    img_card <- magick::image_extent(
      img_card,
      geometry = geometry,
      gravity = "center"
    )
    
    magick::image_write(img_card, path = preview_path)
  }
  
  # Optionally include large image in document
  if (include && knitr::is_html_output()) {
    knitr::include_graphics(file_path)
  }
  
  invisible(list(
    plot = file_path,
    preview = if (preview) preview_path else NULL
  ))
}