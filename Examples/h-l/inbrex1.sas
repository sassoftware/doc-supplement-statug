/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: INBREX1                                             */
/*   TITLE: Documentation Example 1 for PROC INBREED            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: inbreed, covariance                                 */
/*   PROCS: INBREED                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC INBREED, DOCUMENTATION EXAMPLE 1               */
/*    MISC:                                                     */
/****************************************************************/

data Monoecious;
   input Generation Individual Parent1 Parent2 Covariance @@;
   datalines;
1 1 . .  .     1 2 . .  .      1 3 . .  .
2 1 1 1  .     2 2 1 2  .      2 3 2 3  .
3 1 1 2  .     3 2 1 3  .      3 3 2 1  .
3 4 1 3  .     3 . 2 3 0.50    3 . 4 3 1.135
;

title 'Inbreeding within Nonoverlapping Generations';
proc inbreed ind covar matrix data=Monoecious;
   class Generation;
run;

