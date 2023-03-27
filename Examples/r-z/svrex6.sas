/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: svrex6                                              */
/*   TITLE: Documentation Example 6 for PROC SURVEYREG          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: regression, survey sampling,                        */
/*          stratification, regression estimator,               */
/*          unequal weighting, linear model                     */
/*   PROCS: SURVEYREG                                           */
/*     REF: PROC SURVEYREG, Example 6                           */
/*    MISC: Stratum Collapse                                    */
/*                                                              */
/****************************************************************/

data Sample;
   input Stratum X Y W;
   datalines;
10 0 0 5
10 1 1 5
11 1 1 10
11 1 2 10
12 3 3 16
33 4 4 45
14 6 7 50
12 3 4 16
;

data StratumTotals;
   input Stratum _TOTAL_;
   datalines;
10 10
11 20
12 32
33 40
33 45
14 50
15  .
66 70
;

title1 'Stratified Sample with Single Sampling Unit in Strata';
title2 'With Stratum Collapse';
proc surveyreg data=Sample total=StratumTotals;
   strata Stratum/list;
   model Y=X;
   weight W;
run;

title1 'Stratified Sample with Single Sampling Unit in Strata';
title2 'Without Stratum Collapse';
proc surveyreg data=Sample total=StratumTotals;
   strata Stratum/list nocollapse;
   model Y = X;
   weight W;
run;

