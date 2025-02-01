library(sf)
library(ggplot2)
library(tidyverse)
library(sp)

sets <- readRDS("data/raw/survey-sets-getall.rds")

# QA/QC
unique(sets$grouping_depth_id) # note different grouping depths, that's ok not using in this model

x <- sets |>
  filter(is.na(grouping_desc) == TRUE)
x$depth_m #<- grouping depth is NA but depths are there

d <- sets |>
  mutate(
    deployhr = lubridate::hour(time_end_deployment),
    deploymin = lubridate::minute(time_end_deployment),
    retrieve = as.Date(time_begin_retrieval, format = "%Y-%m-%d h:m:s"),
    month = lubridate::month(retrieve),
    retrievehr = lubridate::hour(time_begin_retrieval),
    retrievemin = lubridate::minute(time_begin_retrieval),
    dmy = lubridate::ymd(retrieve),
    julian = lubridate::yday(dmy)
  ) |>
  mutate(
    hr_diff = (retrievehr - deployhr) * 60,
    min_diff = abs(retrievemin - deploymin),
    soak = (hr_diff + min_diff) / 60
  )

# some soaks are NA - fix this!
d |>
  filter(is.na(soak) == TRUE) |> # mostly 2004
  group_by(year) |>
  tally()

d |>
  filter(is.na(soak) == TRUE) |>
  distinct(fishing_event_id, .keep_all = TRUE) |>
  tally() # 66 fishing events are missing soak times as the deployment time wasnt recorded
# most are in 2004 when fishing times were between 1.5 - 3 hours.

d |>
  filter(is.na(soak) == TRUE) |>
  distinct(fishing_event_id, .keep_all = TRUE) |>
  group_by(year) |>
  tally() # lots of 2005s missing too soak time should have been consistently 2 hours at this time, the time_end_deployment was not recorded in 2005

# Add grouping code for survey ---------------------------------------------

# this is so I can look at trends through time, designed based, that don't include the comp work
final <- d |>
  mutate(survey_sep = case_when(
    survey_abbrev == "HBLL INS S" ~ "HBLL INS S",
    survey_abbrev == "HBLL INS N" ~ "HBLL INS N",
    year %in% c(1986, 1989) ~ "dog-jhook",
    year %in% c(2005, 2008, 2011, 2014) & survey_abbrev == "DOG" ~ "dog",
    year == 2019 & survey_abbrev == "DOG" ~ "dog",
    year == 2019 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "13/0" ~ "hbll comp",
    year == 2019 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "14/0" ~ "dog comp",
    # year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "14/0" ~ "dog",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "12/0" ~ "dog-jhook",
    # year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "13/0" ~ "hbll comp",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "14/0" & month == 9 & day >= 27 ~ "dog comp",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "13/0" & month == 9 & day >= 27 ~ "hbll comp",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "13/0" & month == 9 & day < 27 ~ "hbll comp",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "14/0" & month == 9 & day < 27 ~ "dog comp",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "13/0" & month == 8 ~ "hbll comp",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "14/0" & month == 8 ~ "dog comp",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "13/0" & month == 10 ~ "hbll comp",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "14/0" & month == 10 ~ "dog comp",
    year == 2022 & hooksize_desc == "13/0" & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" ~ "hbll comp",
    year == 2022 & hooksize_desc == "14/0" & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" ~ "dog comp",
    year == 2004 & hooksize_desc == "14/0" & survey_abbrev == "OTHER" ~ "dog comp",
    year == 2004 & hooksize_desc == "12/0" & survey_abbrev == "OTHER" ~ "dog-jhook"
  ))

final <- final |>
  mutate(survey_timing = case_when(
    survey_abbrev == "HBLL INS S" ~ "summer",
    survey_abbrev == "HBLL INS N" ~ "summer",
    year %in% c(1986, 1989) ~ "fall",
    year %in% c(2005, 2008, 2011, 2014) & survey_abbrev == "DOG" ~ "fall",
    year == 2019 & survey_abbrev == "DOG" ~ "fall",
    year == 2019 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "13/0" ~ "summer",
    year == 2019 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "14/0" ~ "summer",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "12/0" ~ "fall",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "14/0" & month == 9 & day >= 27 ~ "fall",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "13/0" & month == 9 & day >= 27 ~ "fall",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "13/0" & month == 9 & day < 27 ~ "summer",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "14/0" & month == 9 & day < 27 ~ "summer",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "13/0" & month == 8 ~ "summer",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "14/0" & month == 8 ~ "summer",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "13/0" & month == 10 ~ "fall",
    year == 2023 & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" & hooksize_desc == "14/0" & month == 10 ~ "fall",
    year == 2022 & hooksize_desc == "13/0" & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" ~ "summer",
    year == 2022 & hooksize_desc == "14/0" & activity_desc == "DOGFISH GEAR/TIMING COMPARISON SURVEYS" ~ "summer",
    year == 2004 & hooksize_desc == "14/0" & survey_abbrev == "OTHER" ~ "fall",
    year == 2004 & hooksize_desc == "12/0" & survey_abbrev == "OTHER" ~ "fall"
  ))

# so I can put the different surveys into a model and account for julian date after (the seasonal component of the comparison work)
final <- final |>
  mutate(survey_lumped = case_when(
    survey_sep == "HBLL INS S" ~ "hbll",
    survey_sep == "HBLL INS N" ~ "hbll",
    survey_sep == "dog-jhook" ~ "dog-jhook",
    survey_sep == "dog" ~ "dog",
    survey_sep == "hbll comp" ~ "hbll",
    survey_sep == "dog comp" ~ "dog",
    survey_sep == "hbll" ~ "hbll"
  ))


final <- final |> mutate(cpue = catch_count / (lglsp_hook_count * soak))
# final <- filter(final, usability_code != 0) #you lose the jhook is you do this
final <- filter(final, lglsp_hook_count != 0)
# final <- filter(final, soak != 0) #will lose all the 2004s do this later
final <- final |>
  mutate(soak = ifelse(year %in% c(2005) & survey_abbrev == "DOG", 2, soak)) # safe to assume these are ~2 hours
final$offset <- log(final$lglsp_hook_count * final$soak) # nas created, thats ok
final$log_botdepth <- log(final$depth_m)
saveRDS(final, "data/generated/dogfish_sets_cleaned_getall.rds")
