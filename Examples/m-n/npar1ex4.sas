/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: NPAR1EX4                                            */
/*   TITLE: Documentation Example 4 for PROC NPAR1WAY           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: nonparametric methods, categorical data analysis,   */
/*    KEYS: Hodges-Lehmann estimation                           */
/*   PROCS: NPAR1WAY                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC NPAR1WAY, Example 4                            */
/*    MISC:                                                     */
/****************************************************************/
data React;
   input Stim Time @@;
   datalines;
1 1.94   1 1.94   1 2.92   1 2.92   1 2.92   1 2.92   1 3.27
1 3.27   1 3.27   1 3.27   1 3.70   1 3.70   1 3.74
2 3.27   2 3.27   2 3.27   2 3.70   2 3.70   2 3.74
;
proc npar1way hl alpha=.02 data=React;
   class Stim;
   var Time;
   exact hl;
   ods select WilcoxonScores HodgesLehmann;
run;
