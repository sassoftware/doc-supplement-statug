/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SVMEX6                                              */
/*   TITLE: Documentation Example 6 for PROC SURVEYMEANS        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: domain means, survey sampling, mean comparison      */
/*    KEYS: domain analysis, domain mean comparison             */
/*   PROCS: SURVEYMEANS                                         */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SURVEYMEANS, Example 6                         */
/*                                                              */
/*    MISC: Domain Mean Comparison                              */
/*                                                              */
/****************************************************************/

data IceCreamDataDomain;
   input Grade Spending Gender$ @@;
   datalines;
7   7  M   7   7  F   8  12  F
9  10  M   7   1  M   7  10  M
7   3  M   8  20  F   8  19  M
7   2  M   7   2  F   9  15  F
8  16  F   7   6  F   7   6  M
7   6  M   9  15  M   8  17  F
8  14  M   9   8  M   9   8  F
9   7  F   7   3  F   7  12  M
7   4  M   9  14  F   8  18  M
9   9  F   7   2  F   7   1  M
7   4  M   7  11  M   9   8  M
8  10  M   8  13  F   7   2  F
9   6  F   9  11  M   7   2  F
7   9  F
;
data IceCreamDataDomain;
   set IceCreamDataDomain;
   if Grade=7 then Prob=20/1824;
   if Grade=8 then Prob=9/1025;
   if Grade=9 then Prob=11/1151;
   Weight=1/Prob;
run;
data StudentTotals;
   input Grade _TOTAL_;
   datalines;
7 1824
8 1025
9 1151
;

ods graphics on;
proc surveymeans data=IceCreamDataDomain total=StudentTotals;
   strata Grade;
   var spending;
   domain Grade / diffmeans adjust=bon;
   domain Gender*Grade('8') / diffmeans;
   weight Weight;
run;
