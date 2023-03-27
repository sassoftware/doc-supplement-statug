/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: pwrex05                                             */
/*   TITLE: Documentation Example 5 for PROC POWER              */
/*          (Multiple Regression and Correlation)               */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: power                                               */
/*          sample size                                         */
/*          power analysis                                      */
/*          linear regression                                   */
/*          least squares                                       */
/*          Pearson correlation                                 */
/*          Fisher's z                                          */
/*          graphs                                              */
/*   PROCS: POWER                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;

proc power;
   multreg
      model = random
      nfullpredictors = 7
      ntestpredictors = 1
      partialcorr = 0.35
      ntotal = 100
      power = .;
   plot x=n min=50 max=150;
run;

ods graphics off;

proc power;
   onecorr dist=fisherz
      npvars = 6
      corr = 0.35
      nullcorr = 0.2
      sides = 1
      ntotal = 100
      power = .;
run;

proc power;
   onecorr dist=fisherz
      npvars = 6
      corr = 0.35
      nullcorr = 0.2
      sides = 1
      ntotal = .
      power = 0.85 0.95;
run;

