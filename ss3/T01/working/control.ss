#V3.30
#C file created using the SS_writectl function in the R package r4ss
#C file write time: 2024-08-13 16:56:50.399762
#
0 # 0 means do not read wtatage.ss; 1 means read and usewtatage.ss and also read and use growth parameters
1 #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern
4 # recr_dist_method for parameters
1 # not yet implemented; Future usage:Spawner-Recruitment; 1=global; 2=by area
1 # number of recruitment settlement assignments 
0 # unused option
# for each settlement assignment:
#_growth_pattern	month	area	age_at_settlement
1	1	1	0	#_1
#
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
0 #_Nblock_Patterns
#_Cond 0 #_blocks_per_pattern
# begin and end years of blocks
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
0 0 0 0 0 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate;_5=Maunder_M;_6=Age-range_Lorenzen
#_no additional input for selected M option; read 1P per morph
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr;5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
0 #_Age(post-settlement)_for_L1;linear growth below this
40 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0 #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
3 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
# Age Maturity or Age fecundity:
#_Age_0	Age_1	Age_2	Age_3	Age_4	Age_5	Age_6	Age_7	Age_8	Age_9	Age_10	Age_11	Age_12	Age_13	Age_14	Age_15	Age_16	Age_17	Age_18	Age_19	Age_20	Age_21	Age_22	Age_23	Age_24	Age_25	Age_26	Age_27	Age_28	Age_29	Age_30	Age_31	Age_32	Age_33	Age_34	Age_35	Age_36	Age_37	Age_38	Age_39	Age_40	Age_41	Age_42	Age_43	Age_44	Age_45	Age_46	Age_47	Age_48	Age_49	Age_50	Age_51	Age_52	Age_53	Age_54	Age_55	Age_56	Age_57	Age_58	Age_59	Age_60	Age_61	Age_62	Age_63	Age_64	Age_65	Age_66	Age_67	Age_68	Age_69	Age_70
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0.163	0.18	0.199	0.219	0.24	0.263	0.287	0.313	0.339	0.367	0.396	0.425	0.455	0.485	0.515	0.545	0.575	0.604	0.633	0.661	0.687	0.713	0.737	0.76	0.781	0.801	0.82	0.837	0.853	0.867	0.881	0.893	0.904	0.914	0.923	0.931	0.939	0.945	0.951	0.956	0.961	0.966	0.969	0.973	0.976	0.978	0.981	0.983	0.985	0.987	0.988	0.989	0.991	#_Age_Maturity1
18 #_First_Mature_Age
4 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
2 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
 0.01	0.114	   0.074	0	0	0	-50	0	0	0	0	0	0	0	#_NatM_p_1_Fem_GP_1  
    1	   55	    28.4	0	0	0	-50	0	0	0	0	0	0	0	#_L_at_Amin_Fem_GP_1 
   30	  100	   90.87	0	0	0	-50	0	0	0	0	0	0	0	#_L_at_Amax_Fem_GP_1 
 0.01	  0.2	   0.058	0	0	0	-50	0	0	0	0	0	0	0	#_VonBert_K_Fem_GP_1 
 0.01	  0.3	    0.25	0	0	0	-50	0	0	0	0	0	0	0	#_CV_young_Fem_GP_1  
 0.01	  0.3	   0.075	0	0	0	-50	0	0	0	0	0	0	0	#_CV_old_Fem_GP_1    
    0	  0.1	1.89e-06	0	0	0	-50	0	0	0	0	0	0	0	#_Wtlen_1_Fem_GP_1   
    2	    4	    3.19	0	0	0	-50	0	0	0	0	0	0	0	#_Wtlen_2_Fem_GP_1   
    0	  100	    97.6	0	0	0	-50	0	0	0	0	0	0	0	#_Mat50%_Fem_GP_1    
   -1	    0	  -0.168	0	0	0	-50	0	0	0	0	0	0	0	#_Mat_slope_Fem_GP_1 
-14.7	    3	   -9.96	0	0	0	-50	0	0	0	0	0	0	0	#_Eggs_alpha_Fem_GP_1
   -3	    3	   0.176	0	0	0	-50	0	0	0	0	0	0	0	#_Eggs_beta_Fem_GP_1 
    0	    0	       0	0	0	0	-50	0	0	0	0	0	0	0	#_NatM_p_1_Mal_GP_1  
   -2	    2	  -0.039	0	0	0	-50	0	0	0	0	0	0	0	#_L_at_Amin_Mal_GP_1 
   -1	    1	  -0.093	0	0	0	-50	0	0	0	0	0	0	0	#_L_at_Amax_Mal_GP_1 
   -2	    2	   0.428	0	0	0	-50	0	0	0	0	0	0	0	#_VonBert_K_Mal_GP_1 
   -1	    1	       0	0	0	0	-50	0	0	0	0	0	0	0	#_CV_young_Mal_GP_1  
   -1	    1	   0.287	0	0	0	-50	0	0	0	0	0	0	0	#_CV_old_Mal_GP_1    
    0	  0.1	3.54e-06	0	0	0	-50	0	0	0	0	0	0	0	#_Wtlen_1_Mal_GP_1   
    2	    4	    3.03	0	0	0	-50	0	0	0	0	0	0	0	#_Wtlen_2_Mal_GP_1   
   -5	    5	       1	0	0	0	-50	0	0	0	0	0	0	0	#_CohortGrowDev      
    0	    2	       1	0	0	0	-50	0	0	0	0	0	0	0	#_Catch_Mult:_1      
    0	    2	   3.333	0	0	0	-50	0	0	0	0	0	0	0	#_Catch_Mult:_2      
    0	    2	       1	0	0	0	-50	0	0	0	0	0	0	0	#_Catch_Mult:_3      
    0	    2	       1	0	0	0	-50	0	0	0	0	0	0	0	#_Catch_Mult:_4      
    0	    1	     0.5	0	0	0	-50	0	0	0	0	0	0	0	#_FracFemale_GP_1    
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
7 #_Spawner-Recruitment; 2=Ricker; 3=std_B-H; 4=SCAA;5=Hockey; 6=B-H_flattop; 7=survival_3Parm;8=Shepard_3Parm
1 # 0/1 to use steepness in initial equ recruitment calculation
0 # future feature: 0/1 to make realized sigmaR a function of SR curvature
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn # parm_name
  5	15	9.34396	  0	       0	0	  1	0	0	0	0	0	0	0	#_SR_LN(R0)    
  0	 1	    0.4	0.5	0.287717	2	  1	0	0	0	0	0	0	0	#_SR_surv_Sfrac
0.2	 5	      1	  0	       0	0	-50	0	0	0	0	0	0	0	#_SR_surv_Beta 
0.2	 1	    0.4	  0	       0	0	-50	0	0	0	0	0	0	0	#_SR_sigmaR    
 -1	 1	      0	  0	       0	0	-50	0	0	0	0	0	0	0	#_SR_regime    
 -1	 1	      0	  0	       0	0	-50	0	0	0	0	0	0	0	#_SR_autocorr  
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1954 # first year of main recr_devs; early devs can preceed this era
2015 # last year of main recr_devs; forecast devs start in following year
-3 #_recdev phase
0 # (0/1) to read 13 advanced options
#
#Fishing Mortality info
0.05 # F ballpark
-1920 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
4 # max F or harvest rate, depends on F_Method
4 # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 0
#
#_Q_setup for fleets with cpue or survey data
#_fleet	link	link_info	extra_se	biasadj	float  #  fleetname
    4	1	0	0	0	1	#_1         
-9999	0	0	0	0	0	#_terminator
#_Q_parms(if_any);Qunits_are_ln(q)
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
-5	5	-2.65	0	0	0	-50	0	0	0	0	0	0	0	#_LnQ_base_HBLL
#_no timevary Q parameters
#
#_size_selex_patterns
#_pattern	discard	male	special
24	0	0	0	#_1 1
24	0	0	0	#_2 2
24	0	0	0	#_3 3
24	0	0	0	#_4 4
#
#_age_selex_patterns
#_pattern	discard	male	special
0	0	0	0	#_1 1
0	0	0	0	#_2 2
0	0	0	0	#_3 3
0	0	0	0	#_4 4
#
#_SizeSelex
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
  35	150	106.6	 100	  30	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_1_Bottom_trawl  
 -10	 50	  -10	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_2_Bottom_trawl  
 -10	 10	  5.4	5.05	 0.3	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_3_Bottom_trawl  
 -10	 50	   15	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_4_Bottom_trawl  
-999	 70	 -999	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_5_Bottom_trawl  
-999	999	 -999	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_6_Bottom_trawl  
  35	110	 52.6	  55	16.5	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_1_Midwater_trawl
 -10	 50	  -10	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_2_Midwater_trawl
 -10	 10	  5.4	 4.6	 0.3	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_3_Midwater_trawl
 -10	 10	  5.2	   4	 0.3	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_4_Midwater_trawl
-999	 70	 -999	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_5_Midwater_trawl
-999	 70	 -999	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_6_Midwater_trawl
  35	110	101.4	  95	28.5	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_1_Hook_and_line 
 -10	 50	  -10	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_2_Hook_and_line 
 -10	 10	  4.7	   4	 0.3	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_3_Hook_and_line 
 -10	 50	   15	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_4_Hook_and_line 
-999	 70	 -999	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_5_Hook_and_line 
-999	999	 -999	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_6_Hook_and_line 
  35	200	  150	  95	28.5	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_1_HBLL          
 -10	 50	  -10	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_2_HBLL          
 -10	 10	  6.2	 5.7	 0.3	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_3_HBLL          
 -10	 50	   15	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_4_HBLL          
-999	 70	 -999	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_5_HBLL          
-999	999	 -999	   0	   0	0	-50	0	0	0	0	0	0	0	#_SizeSel_P_6_HBLL          
#_AgeSelex
#_No age_selex_parm
#_no timevary selex parameters
#
0 #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
# Tag loss and Tag reporting parameters go next
0 # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# Input variance adjustments factors: 
#_data_type	fleet	value
    4	1	1	#_1         
    4	2	1	#_2         
    4	3	1	#_3         
    4	4	1	#_4         
-9999	0	0	#_terminator
#
1 #_maxlambdaphase
0 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
-9999 0 0 0 0 # terminator
#
0 # 0/1 read specs for more stddev reporting
#
999
