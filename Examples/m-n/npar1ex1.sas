/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: NPAR1EX1                                            */
/*   TITLE: Documentation Example 1 for PROC NPAR1WAY           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: nonparametric methods, categorical data analysis,   */
/*    KEYS: Wilcoxon test, Wilcoxon scores box plot,            */
/*    KEYS: median test, median plot                            */
/*   PROCS: NPAR1WAY                                            */
/*     REF: PROC NPAR1WAY, Example 1                            */
/****************************************************************/

data Arthritis;
   input Treatment $ Response Freq @@;
   datalines;
Active 5 5 Active 4 11 Active 3 5 Active 2 1 Active 1 5
Placebo 5 2 Placebo 4 4 Placebo 3 7 Placebo 2 7 Placebo 1 12
;

ods graphics on;
proc npar1way data=Arthritis wilcoxon median
              plots=(wilcoxonboxplot medianplot);
   class Treatment;
   var Response;
   freq Freq;
run;
ods graphics off;

