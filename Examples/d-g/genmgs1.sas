
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GENMGS1                                             */
/*   TITLE: Getting Started Example 1 for PROC GENMOD           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: generalized linear models, categorical data analysis*/
/*   PROCS: GENMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GENMOD, INTRODUCTORY EXAMPLE 1.                */
/*    MISC:                                                     */
/****************************************************************/


data insure;
   input n c car$ age;
   ln = log(n);
   datalines;
500   42  small  1
1200  37  medium 1
100    1  large  1
400  101  small  2
500   73  medium 2
300   14  large  2
;

proc genmod data=insure;
   class car age;
   model c = car age / dist   = poisson
                       link   = log
                       offset = ln;
run;

proc genmod data=insure;
   class car age;
   model c = car age / dist   = poisson
                       link   = log
                       offset = ln
                       type1
                       type3;
run;

