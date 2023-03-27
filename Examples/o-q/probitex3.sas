/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: probitex3                                           */
/*   TITLE: Documentation Example 3 for PROC PROBIT             */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*                                                              */
/*   PROCS: PROBIT                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data news;
   input sex $ age subs @@;
   datalines;
Female     35    0   Male       44    0
Male       45    1   Female     47    1
Female     51    0   Female     47    0
Male       54    1   Male       47    1
Female     35    0   Female     34    0
Female     48    0   Female     56    1
Male       46    1   Female     59    1
Female     46    1   Male       59    1
Male       38    1   Female     39    0
Male       49    1   Male       42    1
Male       50    1   Female     45    0
Female     47    0   Female     30    1
Female     39    0   Female     51    0
Female     45    0   Female     43    1
Male       39    1   Male       31    0
Female     39    0   Male       34    0
Female     52    1   Female     46    0
Male       58    1   Female     50    1
Female     32    0   Female     52    1
Female     35    0   Female     51    0
;

proc format;
   value subscrib 1 = 'accept' 0 = 'reject';
run;

proc probit data=news;
   class sex;
   model subs(event="accept")=sex age / d=logistic itprint;
   format subs subscrib.;
   store out=LogitModel;
run;

data test;
   input sex $ age;
   datalines;
Female     35
;

proc plm restore=LogitModel;
   score data=test out=testout predicted / ilink;
run;

proc print data=testout;
run;

