fleet <- function (x = NULL) {
  .d <- c(
    "Bottom trawl",
    "Midwater trawl",
    "Hook and line",
    "HBLL"
  )
  if (is.null(x)) {
    tibble::tibble(fleet = seq_along(.d), fleet_name = .d)
  } else {
    match(x, .d)
  }
}
