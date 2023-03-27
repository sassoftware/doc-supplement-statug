/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: tteex05                                             */
/*   TITLE: Documentation Example 5 for PROC TTEST              */
/*          (Equivalence Testing with Lognormal Data)           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: TOST equivalence test                               */
/*          graphs                                              */
/*   PROCS: TTEST                                               */
/*    DATA: AUC data from                                       */
/*          Wellek, S. (2003), Testing Statistical Hypotheses   */
/*          of Equivalence, Boca Raton, FL: Chapman & Hall/CRC  */
/*          Press LLC, p. 212.                                  */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data auc;
   input TestAUC RefAUC @@;
   datalines;
103.4 90.11  59.92 77.71  68.17 77.71  94.54 97.51
69.48 58.21  72.17 101.3  74.37 79.84  84.44 96.06
96.74 89.30  94.26 97.22  48.52 61.62  95.68 85.80
;

proc print data=auc;
run;

ods graphics on;

proc ttest data=auc dist=lognormal tost(0.8, 1.25);
   paired TestAUC*RefAUC;
run;

ods graphics off;

