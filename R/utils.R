fleet <- function (x = NULL) {
  .d <- c(
    "All gears",
    "Bottom trawl",
    "Midwater trawl",
    "Hook and line",
    "Recreational",
    "HBLL"
  )
  if (is.null(x)) {
    tibble::tibble(fleet = seq_along(.d), fleet_name = .d)
  } else {
    match(x, .d)
  }
}
