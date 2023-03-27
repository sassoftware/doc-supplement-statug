/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: NPAR1EX2                                            */
/*   TITLE: Documentation Example 2 for PROC NPAR1WAY           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: nonparametric methods, categorical data analysis,   */
/*    KEYS: empirical distribution function (EDF) statistics,   */
/*    KEYS: Kolmogorov-Smirnov test, EDF plot                   */
/*   PROCS: NPAR1WAY                                            */
/*     REF: PROC NPAR1WAY, Example 2                            */
/****************************************************************/

data Arthritis;
   input Treatment $ Response Freq @@;
   datalines;
Active 5 5 Active 4 11 Active 3 5 Active 2 1 Active 1 5
Placebo 5 2 Placebo 4 4 Placebo 3 7 Placebo 2 7 Placebo 1 12
;

ods graphics on;
proc npar1way edf plots=edfplot data=Arthritis;
   class Treatment;
   var Response;
   freq Freq;
run;
ods graphics off;

