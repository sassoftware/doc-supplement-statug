/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIXEX8                                              */
/*   TITLE: Documentation Example 8 for PROC MIXED              */
/*          Influence Analysis for Repeated Measures Data       */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mixed linear models, ODS Graphics                   */
/*   PROCS: MIXED, PRINT                                        */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC: Influence diagnostics                               */
/*                                                              */
/****************************************************************/

*--Influence Analysis for Repeated Measures Data (Experimental)--*
| Growth measurements for 11 girls and 16 boys at ages 8, 10, 12,|
| and 14. variances is fit. Data from Pothoff and Roy (1964)     |
*----------------------------------------------------------------*;

data pr;
   input Person Gender $ y1 y2 y3 y4;
   y=y1; Age=8;  output;
   y=y2; Age=10; output;
   y=y3; Age=12; output;
   y=y4; Age=14; output;
   drop y1-y4;
   datalines;
   1   F   21.0    20.0    21.5    23.0
   2   F   21.0    21.5    24.0    25.5
   3   F   20.5    24.0    24.5    26.0
   4   F   23.5    24.5    25.0    26.5
   5   F   21.5    23.0    22.5    23.5
   6   F   20.0    21.0    21.0    22.5
   7   F   21.5    22.5    23.0    25.0
   8   F   23.0    23.0    23.5    24.0
   9   F   20.0    21.0    22.0    21.5
  10   F   16.5    19.0    19.0    19.5
  11   F   24.5    25.0    28.0    28.0
  12   M   26.0    25.0    29.0    31.0
  13   M   21.5    22.5    23.0    26.5
  14   M   23.0    22.5    24.0    27.5
  15   M   25.5    27.5    26.5    27.0
  16   M   20.0    23.5    22.5    26.0
  17   M   24.5    25.5    27.0    28.5
  18   M   22.0    22.0    24.5    26.5
  19   M   24.0    21.5    24.5    25.5
  20   M   23.0    20.5    31.0    26.0
  21   M   27.5    28.0    31.0    31.5
  22   M   23.0    23.0    23.5    25.0
  23   M   21.5    23.5    24.0    28.0
  24   M   17.0    24.5    26.0    29.5
  25   M   22.5    25.5    25.5    26.0
  26   M   23.0    24.5    26.0    30.0
  27   M   22.0    21.5    23.5    25.0
;
proc mixed data=pr method=ml;
   class person gender;
   model y = gender age gender*age /
                    influence(effect=person);
   repeated / type=un subject=person;
   ods select influence;
run;
ods graphics on;

proc mixed data=pr method=ml;
   class person gender;
   model y = gender age gender*age /
                    influence(effect=person iter=5);
   repeated / type=un subject=person;
run;
proc mixed data=pr method=ml
           plots(only)=InfluenceEstPlot;
   class person gender;
   model y = gender age gender*age /
         influence(iter=5 effect=person est);
   random intercept age / type=un subject=person;
run;
ods graphics on;
proc mixed data=pr method=ml
       plot=boxplot(observed marginal conditional subject);
   class person gender;
   model y = gender age gender*age;
   random intercept age / type=un subject=person;
run;
ods graphics off;
