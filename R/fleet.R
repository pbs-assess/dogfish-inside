fleet <- function (x = NULL) {
  .d <- c(
    "All gears landings",
    "Bottom trawl landings",
    "Bottom trawl discards",    
    "Midwater trawl landings",
    "Midwater trawl discards",    
    "Hook and line landings",
    "Hook and line discards",    
    "Recreational",
    "HBLL"
  )
  if (is.null(x)) {
    tibble::tibble(fleet = seq_along(.d), fleet_name = .d)
  } else {
    match(x, .d)
  }
}
