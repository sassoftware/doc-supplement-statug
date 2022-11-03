/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: regex4                                              */
/*   TITLE: Example 4 for PROC REG                              */
/*    DATA: Insurance                                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Qualitative variables                               */
/*   PROCS: REG                                                 */
/*                                                              */
/****************************************************************/

title 'Regression with Quantitative and Qualitative Variables';

data insurance;
   input time size type @@;
   sizetype=size*type;
   datalines;
17 151 0   26  92 0   21 175 0   30  31 0   22 104 0   0  277 0   12 210 0
19 120 0    4 290 0   16 238 0   28 164 1   15 272 1   11 295 1   38  68 1
31  85 1   21 224 1   20 166 1   13 305 1   30 124 1   14 246 1
;

proc reg data=insurance;
   model time = size type sizetype;
run;
   delete sizetype;
   print;
run;
   output out=out r=r p=p;
run;

proc sgplot data=out;
   scatter x=p y=r / markerchar = type group=type;
run;

proc sgplot data=out;
   scatter x=size y=p / markerchar=type group=type;
run;
