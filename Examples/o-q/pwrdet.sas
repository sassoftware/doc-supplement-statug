/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: pwrdet                                              */
/*   TITLE: Documentation Details Examples for PROC POWER       */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: power                                               */
/*          sample size                                         */
/*          power analysis                                      */
/*          error                                               */
/*          info                                                */
/*          information                                         */
/*   PROCS: POWER                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

proc power;
   twosamplefreq test=fm_rr
     relativerisk=1.0001
     refproportion=.4
     nullrelativerisk=1
     power=.9
     ntotal=.;
run;

proc power;
   twosamplemeans
      meandiff= 0 7
      stddev=2
      ntotal=2 5
      power=.;
   ods output output=Power;
run;

proc print noobs data=Power;
   var MeanDiff NominalNTotal NTotal Power Error Info;
run;

