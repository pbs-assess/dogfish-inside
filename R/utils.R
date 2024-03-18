#' Write An Object And Return The Path
#'
#' @param path [character()] folder path
#' @param ... Unquoted name of an existing object to write to \code{data/}.
#'
#' @return [character()] file path
#' @export
#'
write_data <- function (..., path = "data") {
  if (...length() != 1) stop("write_data() takes exactly 1 argument")
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
