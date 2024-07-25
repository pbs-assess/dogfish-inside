fleet_index <- function (.fleet_name = NULL) {
  .n <- fleet_name()
  if (is.null(.fleet_name)) {
    .d <- seq_along(.n)
  } else {
    .d <- which(.n == .fleet_name)
  }
  return(.d)
}

fleet_name <- function (.fleet_index = NULL) {
  .d <- c(
    "Bottom trawl landings",
    "Bottom trawl discards",
    "Midwater trawl",
    "Hook and line landings",
    "Hook and line discards",
    "HBLL"
  )
  if (is.null(.fleet_index)) {
    .fleet_index <- seq_along(.d)
  }
  return(.d[.fleet_index])
}

fleet <- function () {
  tibble::tibble(
    fleet_index = fleet_index(),
    fleet_name = fleet_name()
  )
}


#' Write An Object And Return The Path
#'
#' @param filename [character()] The file name
#' @param plot [ggplot2::ggplot()] The plot object
#' @param device [character()] The file type
#' @param path [character()] The directory path
#' @param scale [numeric()] Multiplicative scaling factor
#' @param width [numeric()] Plot width in units
#' @param height [numeric()] Plot height in units
#' @param units [character()] Plot size units
#' @param dpi [numeric()] Plot resolution
#' @param limitsize [logical()] Prevent saving large files?
#' @param bg [character()] Background colour
#' @param create.dir [logical()] Create directory if none exists?
#' @param ... Other arguments passed to ggplot2::ggsave()
#' 
#' @return [character()] file path
#'
#'
save_plot <- function (filename,
                       plot = ggplot2::last_plot(),
                       device = "png",
                       path = "report/figure",
                       scale = 1,
                       width = 190,
                       height = 120,
                       units = c("mm"),
                       dpi = 600,
                       limitsize = TRUE,
                       bg = NULL,
                       create.dir = FALSE,
                       ...) {
  # Save ggplot
  ggplot2::ggsave(
    filename = fs::path_ext_set(filename, device),
    plot = plot,
    device = NULL,
    path = path,
    scale = scale,
    width = width,
    height = height,
    units = units,
    dpi = dpi,
    limitsize = limitsize,
    bg = bg,
    create.dir = create.dir,
    ...
  )
  # Return
  file.path(path, fs::path_ext_set(filename, device))
}

#' Write An Object And Return The Path
#'
#' @param path [character()] folder path
#' @param ... Unquoted name of an existing object to write to \code{data/}.
#'
#' @return [character()] file path
#'
#'
write_data <- function (..., path = "data") {
  if (...length() != 1) stop("write_data() takes one '...' argument maximum")
  args <- list(...)
  if (is.null(names(args))) {
    name <- as.character(substitute(...))
  } else {
    name <- names(args)[1]
  }
  name <- gsub("_", "-", name)
  assign(x = name, value = ..1)
  saveRDS(..., file = paste0(path, "/", name, ".rds"), compress = TRUE)
  file.path(path, fs::path_ext_set(name, ".rds"))
}
