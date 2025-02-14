# Length and catch composition differences between the DOG and HBLL surveys
# 2004 and some 2005 are missing deployment times
# soak2005 <- 2
bccrs <- 32609
latitude_cutoff <- 50.34056 #<- not sure what the "best" boundary to pick for separating n and s is I used the largest latitude in the hbll_ins_s grid at the line

# library(gfdata)
library(ggplot2)
library(tidyverse)
library(here)
# library(sdmTMB)
# library(sf)
# library(sp)

# load data ---------------------------------------------------------------
samps <- readRDS("data/raw/dogfish_samples_cleaned.rds")
sampshb <- samps |> filter(survey_abbrev %in% c("HBLL INS S", "HBLL INS N")) # drop hbll samps not included in the gfdata pull.
sampsgf <- readRDS("data/raw/dogfish_samples_gfdata.rds") |>
  filter(survey_abbrev %in% c("HBLL INS S", "HBLL INS N"))

sampshb <- sampshb |>
  filter(fishing_event_id %in% c(sampsgf$fishing_event_id)) |>
  drop_na(total_length) |>
  filter(total_length > 10) # i suspect these smaller ones are pups that were measured

ggplot(sampshb, aes(longitude, latitude, colour = total_length)) +
  geom_point()

# check the databases are returning the same <- looks good
# sampsgf <- readRDS("data-raw/dogfish_samples_gfdata.rds") |>
#   filter(!survey_abbrev %in% c("HBLL INS S", "HBLL INS N")) |>
#   filter(length >0 )
# sampsga <- samps |>
#   filter(!survey_abbrev %in% c("HBLL INS S", "HBLL INS N")) |>
#   filter(length >0 ) |>
#   filter(fishing_event_id %in% c(sampsgf$fishing_event_id))
# length(unique(sampsga$fishing_event_id))
# length(unique(sampsgf$fishing_event_id))
# length(unique(sampsga$year))
# length(unique(sampsgf$year))
# x <- ggplot(sampsgf, aes(year, length)) + geom_point()
# ggplot(sampsga, aes(year, length)) + geom_point()
# x + geom_point(data = sampsga, aes(year, total_length), colour = "red")

# remove two survey years that extended along the west coast VI
hbll1 <- filter(sampshb, (latitude < 48.5 & longitude < -123.3)) # only two years have the sampling around the strait
hbll2 <- filter(sampshb, (latitude < 48.75 & longitude < -124.25))
hbllrm <- bind_rows(hbll1, hbll2)
unique(hbllrm$fishing_event_id) # rm these

test <- filter(sampshb, survey_abbrev == "HBLL INS S")

x <- ggplot(test) +
  geom_point(aes(longitude, latitude))
x + geom_point(data = hbllrm, aes(longitude, latitude), col = "red")


# wrangle -----------------------------------------------------------------
sampsdog <- readRDS("data/raw/dogfish_samples_cleaned.rds") |>
  filter(!survey_abbrev %in% c("HBLL INS S", "HBLL INS N"))

hsamps <- sampshb |>
  filter(!fishing_event_id %in% c(hbllrm$fishing_event_id))

samps <- bind_rows(sampsdog, hsamps)
saveRDS(samps, "output/samps_joined.rds")


# summary plot ------------------------------------------------------------

ggplot(samps, aes(year, length, col = survey_abbrev)) +
  geom_jitter() +
  facet_wrap(~survey_abbrev)

ggplot(samps, aes(year, maturity_code, col = survey_abbrev)) +
  geom_jitter() +
  facet_wrap(~survey_abbrev)

ggplot(samps, aes(year, maturity_code, col = survey_abbrev)) +
  geom_jitter() +
  facet_wrap(~survey_abbrev)

ggplot(samps, aes(year, length, col = survey_abbrev)) +
  geom_jitter() +
  facet_wrap(~sex)

ggplot(samps, aes(year, length, col = hook_desc)) +
  geom_jitter() +
  facet_wrap(~sex)
