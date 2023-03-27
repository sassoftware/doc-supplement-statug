/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIXEX7                                              */
/*   TITLE: Documentation Example 7 for PROC MIXED              */
/*          Influence in Heterogeneous Variance Model           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mixed Linear Models ODS Graphics                    */
/*   PROCS: MIXED, PRINT                                        */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Tianlin Wang                                        */
/*     REF:                                                     */
/*    MISC: Influence diagnostics                               */
/*                                                              */
/****************************************************************/

*---Influence in Heterogeneous Variance Model (Experimental)---*
| A one-way classification model with heterogeneous            |
| variances is fit. Data from Snedecor and Cochran (1980),p216 |
*--------------------------------------------------------------*;

data absorb;
   input FatType Absorbed @@;
   datalines;
 1 164  1 172  1 168  1 177  1 156  1 195
 2 178  2 191  2 197  2 182  2 185  2 177
 3 175  3 193  3 178  3 171  3 163  3 176
 4 155  4 166  4 149  4 164  4 170  4 168
;

ods graphics on;

proc mixed data=absorb asycov;
   class FatType;
   model Absorbed = FatType / s
                    influence(iter=10 estimates);
   repeated / group=FatType;
   ods output Influence=inf;
run;

ods graphics off;

proc print data=inf label;
   var parm1-parm5 covp1-covp4;
run;

proc print data=inf label;
   var observed predicted residual pressres
       student Rstudent;
run;

proc print data=inf label;
   var leverage observed CookD DFFITS CovRatio RLD;
run;

proc print data=inf label;
   var iter CookDCP CovRatioCP;
run;

