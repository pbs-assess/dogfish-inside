#TOC to keep up clear on what script does what

01-pull-gfdata.R #pulls in the survey sets, samples, and commercial data, also removes data with privacy concerns
01a-collate-commercial-landings-discards.R #this is pulling in the estimate commercial data prior to 2000/2006 and converting  to .rds
00-raw-samples-survey.R #likely get rid of this as this should now be in the 
00-raw-samples-commercial.R #likely get rid of this as it should be in the 
00-raw-catch-commercial.R #likely get rid of this
00-raw-index-hbll.R #likely get rid of this
00-raw-catch-commercial.R  #likely get rid of this should be in the gfdata.R script

#collate these three scripts
00-raw-catch-recreational-irec.R
00-raw-catch-recreational-creel.R
00-raw-catch.fsc.R