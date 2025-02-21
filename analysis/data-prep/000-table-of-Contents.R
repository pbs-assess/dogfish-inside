#TOC to keep up clear on what script does what

# Notes
# SURVEY_SERIES_ID == 48) #comp work 2004, 2019, 2022, 2023
# SURVEY_SERIES_ID == 93) #circle hook dog surveys 2005 onwards (2005, 2008, 2011, 2014, 2019)
# SURVEY_SERIES_ID == 76) #all jhook and circle hook dog surveys 1986 onwards does not include 2004 (1986, 1989, 2005, 2008, 2011, 2014, 2019)
# SURVEY_SERIES_ID == 92) #j hook dog surveys 1986, 1989 only

# yelloweye rockfish were not sampled in earlier years. 1986/1989 maybe not 2004?
# 2004 comparison work had two gear types per set
# 2019 comparison work dropped separate lines per gear type
# 2022 comparison work has two gear types per set
# 2023 comparison work has two gear types per set  and was completed during the HBLL and DOG survey

# Pull data analysis/data-prep folder:
01-pull-gfdata.R #pulls in the survey sets, samples, and commercial data, for hbll, dogfish survey and comp work also removes data with privacy concerns
01a-collate-commercial-landings-discards.R #pulls the estimated commercial data prior to 2000/2006 and converting  to .rds
01b-pull-rec-and-fsc-data.R #pulls the excel sheets of creel, irec, and fsc catches

# Cleaning and generating summary plots for the document
02-gen-catch-commercial.R #cleans and bind the reconstructed discards and landings for the commercial sector. Generates some nice ggplots, use this to generate summary plots of commercial catches
02-gen-samples-commercial.R #summary plots of length comps for sexes and unsorted, sorted discards and landings. Use this code for generating the figures/outputs needed for length comps
02-gen-catch-recreational-creel.R
02-gen-catch-recreational-irec.R
02-gen-index-design
02-gen-samples-commerical.R
#02-gen-samples.survey.R #not sure this is needed may be in the 02a-data-clean-sets.R
#02-gen-catch-survey.R #not sure this is needed...
02-gen-catch-fsc.R

# Pulling and cleaning the dogfish-survey and HBLL data with the comp work
03-data-clean-sets.R #clean and identify the get_all hbll, dogfish, and comp work sets data
03-data-clean-samples.R
03a-wrangle-hbll-dogs-sets.R #includes hook competition calc
03a-wrangle-hbll-dog-samples.R

#analysis folder
01-hbll-dog-index-generation #generates index for HBLL N, S, N and S, dogfish survey, and all together

#ss3 folder
02-ss3-maturity
02-ss3-length
02-ss3-index
02-ss3-catch