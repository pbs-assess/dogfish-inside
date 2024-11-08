fleets <- function (x = NULL) {
  .d <- c(
    "Bottom trawl landings",
    "Bottom trawl discards", 
    "Midwater trawl",
    # "Midwater trawl landings",
    # "Midwater trawl discards",    
    "Hook and line landings",
    "Hook and line discards",    
    "All gears landings",
    "HBLL survey",
    "Recreational landings"
  )
  if (is.null(x)) {
    tibble::tibble(fleet = seq_along(.d), fleet_name = .d)
  } else {
    match(x, .d)
  }
}