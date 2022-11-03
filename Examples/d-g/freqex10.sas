/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: FREQEX10                                            */
/*   TITLE: Documentation Example 10 for PROC FREQ              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis,                          */
/*    KEYS: measures of agreement, McNemar's test,              */
/*    KEYS: kappa statistics, Cochran's Q                       */
/*   PROCS: FREQ                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC FREQ, Example 10                               */
/*    MISC:                                                     */
/****************************************************************/
/* Cochran's Q Test --------------------------------------------*/
proc format;
   value $ResponseFmt 'F'='Favorable'
                      'U'='Unfavorable';
run;
data drugs;
   input Drug_A $ Drug_B $ Drug_C $ Count @@;
   datalines;
F F F  6   U F F  2
F F U 16   U F U  4
F U F  2   U U F  6
F U U  4   U U U  6
;
proc freq data=Drugs;
   tables Drug_A Drug_B Drug_C / nocum;
   tables Drug_A*Drug_B*Drug_C / agree noprint;
   format Drug_A Drug_B Drug_C $ResponseFmt.;
   weight Count;
   title 'Study of Three Drug Treatments for a Chronic Disease';
run;
