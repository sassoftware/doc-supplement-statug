
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LIFEREX4                                            */
/*   TITLE: Example 4 for PROC LIFEREG                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: survival data analysis, arbitrary censoring         */
/*   PROCS: LIFEREG                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC LIFEREG, EXAMPLE 4.                            */
/*    MISC:                                                     */
/****************************************************************/


title 'Natural Recovery Time';
data mice;
   input sex age time1 time2;
   datalines;
1  57  631   631
1  45  .     170
1  54  227   227
1  43  143   143
1  64  916   .
1  67  691   705
1  44  100   100
1  59  730   .
1  47  365   365
1  74  1916  1916
2  79  1326  .
2  75  837   837
2  84  1200  1235
2  54  .     365
2  74  1255  1255
2  71  1823  .
2  65  537   637
2  33  583   683
2  77  955   .
2  46  577   577
;

data xrow1;
   input sex age time1 time2;
   datalines;
1  50  .  .
;

data xrow2;
   input sex age time1 time2;
   datalines;
2  60.6  .  .
;

ods graphics on;
proc lifereg data=mice xdata=xrow1;
   class sex;
   model (time1, time2) = age sex age*sex / dist=Weibull;

   probplot  / nodata
       plower=.5
       vref(intersect) = 75
       vreflab = '75 Percent';
   inset;
run;

proc lifereg data=mice xdata=xrow2;
   class sex;
   model (time1, time2) = age sex age*sex / dist=Weibull;

   probplot  / nodata
       plower=.5
       vref(intersect) = 75
       vreflab = '75 Percent';
   inset;
run;
title;
