
# Define FSC path on DFO laptop drive
path <- "C:/Users/rogersl/data/fsc/"
fsc_path <- paste0(
  path, 
  "LingcodDogfishGroundfishFSCforallyears_BasicEstimate_21-Feb-24.xlsx"
)
# Read FSC dogfish catch from KREST survey for area 4B
catch_fsc <- readxl::read_xlsx(
  path = fsc_path,
  sheet = "Interview Data_LingcodDogfishGr"
) |>
  dplyr::rename_with(.fn = tolower) |>
  dplyr::filter(
    species %in% c("NORTH PACIFIC SPINY DOGFISH", "UNIDENTIFIED GROUNDFISH"),
    estimation_area %in% c(paste("PFMA", 12:20), paste("PFMA", 28:29))
  ) |>
  dplyr::mutate(
    pfma = estimation_area,
    year = lubridate::year(start_time),
    month = lubridate::month(start_time),
    catch = catch_count,
    units = tolower(units),
    comment = catch_data_comment
  ) |>
  dplyr::select(
    purpose,
    pfma,
    gear_type,
    year,
    month,
    disposition,
    species,
    catch,
    units,
    comment
  )
# View catch
tibble::view(catch_fsc)
## Write catch
write_data(catch_fsc, path = "data/raw")
