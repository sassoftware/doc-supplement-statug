/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: svmgs                                               */
/*   TITLE: Getting Started Examples for PROC SURVEYMEANS       */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: descriptive statistics, survey sampling             */
/*    KEYS: stratification                                      */
/*    KEYS: unequal weighting, categorical data analysis        */
/*   PROCS: SURVEYMEANS                                         */
/*     REF: PROC SURVEYMEANS, Getting Started                   */
/*                                                              */
/****************************************************************/

data IceCream;
   input Grade Spending @@;
   if (Spending < 10) then Group='less';
   else Group='more';
   datalines;
7 7  7  7  8 12  9 10  7  1  7 10  7  3  8 20  8 19  7 2
7 2  9 15  8 16  7  6  7  6  7  6  9 15  8 17  8 14  9 8
9 8  9  7  7  3  7 12  7  4  9 14  8 18  9  9  7  2  7 1
7 4  7 11  9  8  8 10  8 13  7  2  9  6  9 11  7  2  7 9
;

ods graphics on;
title1 'Analysis of Ice Cream Spending';
title2 'Simple Random Sample Design';
proc surveymeans data=IceCream total=4000;
   var Spending Group;
run;

data StudentTotals;
   input Grade _total_;
   datalines;
7 1824
8 1025
9 1151
;

data IceCream;
   set IceCream;
   if Grade=7 then Prob=20/1824;
   if Grade=8 then Prob=9/1025;
   if Grade=9 then Prob=11/1151;
   Weight=1/Prob;
run;

title1 'Analysis of Ice Cream Spending';
title2 'Stratified Sample Design';
proc surveymeans data=IceCream total=StudentTotals;
   stratum Grade / list;
   var Spending Group;
   weight Weight;
run;

title1 'Analysis of Ice Cream Spending';
title2 'Stratified Sample Design';
proc surveymeans data=IceCream total=StudentTotals;
   stratum Grade / list;
   var Spending Group;
   weight Weight;
   ods output Statistics=MyStat;
run;


proc print data=MyStat;
run;

data new;
   input sex$ x;
   datalines;
M 12
F 5
M 13
F 23
F 11
;


proc surveymeans data=new mean;
   ods output statistics=rectangle;
run;

proc print data=rectangle;
run;

title 'Rectangular Structure in the Output Data Set';
proc print data=rectangle;
run;


proc surveymeans data=new mean stacking;
   ods output statistics=stacking;
run;

proc print data=stacking;
run;

title 'Stacking Structure in the Output Data Set';
proc print data=stacking;
run;

