/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: svrex2                                              */
/*   TITLE: Documentation Example 2 for PROC SURVEYREG          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: regression, survey sampling, clustering,            */
/*          unequal weighting, linear model                     */
/*   PROCS: SURVEYREG                                           */
/*     REF: PROC SURVEYREG, Example 2                           */
/*                                                              */
/****************************************************************/

data Municipalities;
   input Municipality Cluster Population85 Population75;
   datalines;
205   37    5    5
206   37   11   11
207   37   13   13
208   37    8    8
209   37   17   19
  6    2   16   15
  7    2   70   62
  8    2   66   54
  9    2   12   12
 10    2   60   50
 94   17    7    7
 95   17   16   16
 96   17   13   11
 97   17   12   11
 98   17   70   67
 99   17   20   20
100   17   31   28
101   17   49   48
276   50    6    7
277   50    9   10
278   50   24   26
279   50   10    9
280   50   67   64
281   50   39   35
282   50   29   27
283   50   10    9
284   50   27   31
 52   10    7    6
 53   10    9    8
 54   10   28   27
 55   10   12   11
 56   10  107  108
;

title1 'Regression Analysis for Swedish Municipalities';
title2 'Cluster Sampling';
proc surveyreg data=Municipalities total=50;
   cluster Cluster;
   model Population85=Population75;
run;

title1 'Regression Analysis for Swedish Municipalities';
title2 'Simple Random Sampling';
proc surveyreg data=Municipalities total=284;
   model Population85=Population75;
run;

