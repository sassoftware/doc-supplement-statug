/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: INBRGS1                                             */
/*   TITLE: Getting Started Example 1 for PROC INBREED          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: inbreed, covariance                                 */
/*   PROCS: INBREED                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC INBREED, GETTING STARTED EXAMPLE 1             */
/*    MISC:                                                     */
/****************************************************************/

data Population;
   input Individual $ Parent1 $ Parent2 $
         Covariance Sex $ Generation;
   datalines;
Mark   George Lisa    .    M  1
Kelly  Scott  Lisa    .    F  1
Mike   George Amy     .    M  1
.      Mark   Kelly  0.50  .  1
David  Mark   Kelly   .    M  2
Merle  Mike   Jane    .    F  2
Jim    Mark   Kelly  0.50  M  2
Mark   Mike   Kelly   .    M  2
;

proc inbreed data=Population covar matrix init=0.25;
run;

proc inbreed data=Population covar matrix init=0.25;
   class Generation;
run;

proc inbreed data=Population covar average init=0.25;
   class Generation;
   gender Sex;
run;
