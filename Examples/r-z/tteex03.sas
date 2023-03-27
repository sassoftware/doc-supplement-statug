/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: tteex03                                             */
/*   TITLE: Documentation Example 3 for PROC TTEST              */
/*          (Paired Comparisons)                                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: paired t test                                       */
/*          graphs                                              */
/*   PROCS: TTEST                                               */
/*    DATA: Systolic blood pressure data from                   */
/*          SAS Institute Inc. (1986), SUGI Supplemental        */
/*          Library User's Guide, Version 5 Edition, Cary, NC:  */
/*          SAS Institute Inc.                                  */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data pressure;
   input SBPbefore SBPafter @@;
   datalines;
120 128   124 131   130 131   118 127
140 132   128 125   140 141   135 137
126 118   130 132   126 129   127 135
;

ods graphics on;

proc ttest;
   paired SBPbefore*SBPafter;
run;

ods graphics off;

