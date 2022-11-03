/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SIMNGS                                              */
/*   TITLE: Getting Started Section for PROC SIMNORMAL          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Simulation, Normal Random variates                  */
/*   PROCS: SIMNORMAL, CORR                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SIMNORMAL, GETTING STARTED.                    */
/*    MISC:                                                     */
/****************************************************************/

data scov(type=COV) ;
   input _TYPE_ $ 1-4 _NAME_ $ 9-10 S1 S2 ;
   datalines ;
COV     S1      1.915  0.3873
COV     S2      0.3873 4.321
MEAN            1.305  2.003
;

proc simnormal data=scov outsim=ssim
               numreal = 5000
               seed = 54321 ;
   var s1 s2 ;
run;

proc corr data=ssim cov ;
   var s1 s2 ;
   title "Statistics for PROC SIMNORMAL Sample Using NUMREAL=5000" ;
run;

