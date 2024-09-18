#C written by ssio::write_control()
0 # use weight at age
1 # n morphs
1 # n platoons per morph
4 # recruitment method
1 # recruitment spatial
1 # n recruitment settle
0 # recruitment unused
# recruitment info
# growth_pattern month area age_at_settlement name
1 1 1 0 # Growth pattern 1
0 # n block patterns
1 # time varying method
0 0 0 0 0 # time varying auto generation
0 # natural mortality option
1 # growth method
0 # growth age at l1
40 # growth age at l2
-999 # growth exp decay
0 # growth feature
0 # growth add sd
0 # growth cv option
3 # maturity option
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.163 0.18 0.199 0.219 0.24 0.263 0.287 0.313 0.339 0.367 0.396 0.425 0.455 0.485 0.515 0.545 0.575 0.604 0.633 0.661 0.687 0.713 0.737 0.76 0.781 0.801 0.82 0.837 0.853 0.867 0.881 0.893 0.904 0.914 0.923 0.931 0.939 0.945 0.951 0.956 0.961 0.966 0.969 0.973 0.976 0.978 0.981 0.983 0.985 0.987 0.988 0.989 0.991 # maturity data
18 # maturity first age
4 # fecundity option
0 # hermaphroditism option
2 # parameter offset method
# mortality growth parameters
# lower upper initial prior_mean prior_sd prior_type phase env_link dev_link dev_year_min dev_year_max dev_phase block block_fn name
0.01 0.11 0.074 0 0 0 -50 0 0 0 0 0 0 0 # NatM_p_1_Fem_GP_1
1 55 28 0 0 0 -50 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
30 100 91 0 0 0 -50 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
0.01 0.2 0.058 0 0 0 -50 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
0.01 0.3 0.25 0 0 0 -50 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
0.01 0.3 0.075 0 0 0 -50 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
0 0.1 1.9e-6 0 0 0 -50 0 0 0 0 0 0 0 # Wtlen_1_Fem_GP_1
2 4 3.2 0 0 0 -50 0 0 0 0 0 0 0 # Wtlen_2_Fem_GP_1
0 100 98 0 0 0 -50 0 0 0 0 0 0 0 # Mat50%_Fem_GP_1 
-1 0 -0.17 0 0 0 -50 0 0 0 0 0 0 0 # Mat_slope_Fem_GP_1
-14.7 3 -10 0 0 0 -50 0 0 0 0 0 0 0 # Eggs_alpha_Fem_GP_1
-3 3 0.18 0 0 0 -50 0 0 0 0 0 0 0 # Eggs_beta_Fem_GP_1
0 0 0 0 0 0 -50 0 0 0 0 0 0 0 # NatM_p_1_Mal_GP_1
-2 2 0.039 0 0 0 -50 0 0 0 0 0 0 0 # L_at_Amin_Mal_GP_1
-1 1 -0.093 0 0 0 -50 0 0 0 0 0 0 0 # L_at_Amax_Mal_GP_1
-2 2 0.43 0 0 0 -50 0 0 0 0 0 0 0 # VonBert_K_Mal_GP_1
-1 1 0 0 0 0 -50 0 0 0 0 0 0 0 # CV_young_Mal_GP_1
-1 1 0.29 0 0 0 -50 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
0 0.1 3.5e-6 0 0 0 -50 0 0 0 0 0 0 0 # Wtlen_1_Mal_GP_1
2 4 3 0 0 0 -50 0 0 0 0 0 0 0 # Wtlen_2_Mal_GP_1
-5 5 1 0 0 0 -50 0 0 0 0 0 0 0 # CohortGrowDev
0 2 1 0 0 0 -50 0 0 0 0 0 0 0 # Catch_Mult:_1
0 2 1 0 0 0 -50 0 0 0 0 0 0 0 # Catch_Mult:_2
0 2 1 0 0 0 -50 0 0 0 0 0 0 0 # Catch_Mult:_3
0 2 1 0 0 0 -50 0 0 0 0 0 0 0 # Catch_Mult:_4
0 1 0.5 0 0 0 -50 0 0 0 0 0 0 0 # FracFemale_GP_1
# seasonality info
# wt_len_fem_1 wt_len_fem_2 maturity_1 maturity_2 fecundity_1 fecundity_2 wt_len_mal_1 wt_len_mal_2 l1 von_bert_k name
0 0 0 0 0 0 0 0 0 0 # seasonality
7 # spawner recruitment option
1 # use steepness
0 # spawner recruitment feature
# spawner recruitment parameters
# lower upper initial prior_mean prior_sd prior_type phase env_link dev_link dev_year_min dev_year_max dev_phase block block_fn name
5 15 10 0 0 0 1 0 0 0 0 0 0 0 # SR_LN(R0)
0 1 0.4 0.5 0.28 2 1 0 0 0 0 0 0 0 # SR_surv_Sfrac
0.2 5 1 0 0 0 -50 0 0 0 0 0 0 0 # SR_surv_Beta
0.2 1 0.4 0 0 0 -50 0 0 0 0 0 0 0 # SR_sigmaR
-1 1 0 0 0 0 -50 0 0 0 0 0 0 0 # SR_regime
-1 1 0 0 0 0 -50 0 0 0 0 0 0 0 # SR_autocorr
1 # recruitment deviation option
1954 # recruitment deviation year start
2015 # recruitment deviation year end
-3 # recruitment deviation phase
0 # recruitment deviation advanced
0.05 # fishing ballpark
-1 # fishing ballpark year
3 # fishing method
4 # fishing maximum
4 # fishing iterations
# catchability info
# fleet link_type link_info extra_se bias_adjust float name
4 1 0 0 0 1 # HBLL
-9999 0 0 0 0 0 # terminal line
# catchability parameters
# lower upper initial prior_mean prior_sd prior_type phase env_link dev_link dev_year_min dev_year_max dev_phase block block_fn name
-5 5 -2.65 0 0 0 -50 0 0 0 0 0 0 0 # LnQ_base_HBLL
# selectivity size info
# pattern discard male special name
24 0 0 0 # Bottom trawl
24 0 0 0 # Midwater trawl
24 0 0 0 # Hook and line
24 0 0 0 # HBLL
# selectivity age info
# pattern discard male special name
0 0 0 0 # Bottom trawl
0 0 0 0 # Midwater trawl
0 0 0 0 # Hook and line
0 0 0 0 # HBLL
# selectivity parameters
# lower upper initial prior_mean prior_sd prior_type phase env_link dev_link dev_year_min dev_year_max dev_phase block block_fn name
35 150 106 100 30 6 3 0 0 0 0 0 0 0 # size_p_1_Bottom_trawl
-10 50 -10 0 0 0 -50 0 0 0 0 0 0 0 # size_p_2_Bottom_trawl
-10 10 5.4 5 0.3 6 3 0 0 0 0 0 0 0 # size_p_3_Bottom_trawl
-10 50 15 0 0 0 -50 0 0 0 0 0 0 0 # size_p_4_Bottom_trawl
-999 70 -999 0 0 0 -50 0 0 0 0 0 0 0 # size_p_5_Bottom_trawl
-999 999 -999 0 0 0 -50 0 0 0 0 0 0 0 # size_p_6_Bottom_trawl
35 110 53 55 17 6 3 0 0 0 0 0 0 0 # size_p_1_Midwater_trawl
-10 50 -10 0 0 0 -50 0 0 0 0 0 0 0 # size_p_2_Midwater_trawl
-10 10 5.4 4.6 0.3 6 3 0 0 0 0 0 0 0 # size_p_3_Midwater_trawl
-10 10 5.2 4 0.3 6 3 0 0 0 0 0 0 0 # size_p_4_Midwater_trawl
-999 70 -999 0 0 0 -50 0 0 0 0 0 0 0 # size_p_5_Midwater_trawl
-999 70 -999 0 0 0 -50 0 0 0 0 0 0 0 # size_p_6_Midwater_trawl
35 110 101 95 28 6 3 0 0 0 0 0 0 0 # size_p_1_Hook_and_line
-10 50 -10 0 0 0 -50 0 0 0 0 0 0 0 # size_p_2_Hook_and_line
-10 10 4.7 4 0.3 6 3 0 0 0 0 0 0 0 # size_p_3_Hook_and_line
-10 50 15 0 0 0 -50 0 0 0 0 0 0 0 # size_p_4_Hook_and_line
-999 70 -999 0 0 0 -50 0 0 0 0 0 0 0 # size_p_5_Hook_and_line
-999 999 -999 0 0 0 -50 0 0 0 0 0 0 0 # size_p_6_Hook_and_line
35 200 150 95 28 6 3 0 0 0 0 0 0 0 # size_p_1_HBLL
-10 50 -10 0 0 0 -50 0 0 0 0 0 0 0 # size_p_2_HBLL
-10 10 6.2 5.7 0.3 6 3 0 0 0 0 0 0 0 # size_p_3_HBLL
-10 50 15 0 0 0 -50 0 0 0 0 0 0 0 # size_p_4_HBLL
-999 70 -999 0 0 0 -50 0 0 0 0 0 0 0 # size_p_5_HBLL
-999 999 -999 0 0 0 -50 0 0 0 0 0 0 0 # size_p_6_HBLL
0 # use selectivity 2d
0 # use tag recapture
# variance info
# factor fleet value name
4 1 1 # Bottom trawl
4 2 1 # Midwater trawl
4 3 1 # Hook and line
4 4 1 # HBLL
-9999 0 0 # terminal line
1 # lambda max phase
0 # lambda sd offset
# lambda info
# component fleet phase value method name
-9999 0 0 0 0 # terminal line
0 # sd report option
999
