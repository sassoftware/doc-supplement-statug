/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gmpgs2                                              */
/*   TITLE: Getting Started Example 2 for PROC GLMPOWER         */
/*          (Incorporating Contrasts, Unbalanced Designs, and   */
/*          Multiple Means Scenarios)                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: power                                               */
/*          power analysis                                      */
/*          sample size                                         */
/*          general linear models                               */
/*          analysis of variance                                */
/*   PROCS: GLMPOWER                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/


data Exemplary;
   input Variety $ Exposure $ HeightOrig HeightNew Weight;
   datalines;
         1   1   14  15  1
         1   2   16  16  2
         1   3   21  20  2
         2   1   10  11  1
         2   2   15  14  2
         2   3   16  15  2
;

proc glmpower data=Exemplary;
   class Variety Exposure;
   model HeightOrig HeightNew = Variety | Exposure;
   weight Weight;
   contrast 'Exposure=1 vs Exposure=3' Exposure 1 0 -1;
   power
      stddev = 5
      ntotal = 60
      power  = .;
run;

