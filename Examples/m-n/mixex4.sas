/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIXEX4                                              */
/*   TITLE: Documentation Example 4 for PROC MIXED              */
/*          Known G and R                                       */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mixed Linear Models                                 */
/*   PROCS: MIXED, PRINT                                        */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

*--------------------Known G and R------------------*
| Data represent a genetic example from Henderson   |
| (1984, p.53). The data are artificial and consist |
| of measurements of two traits on three animals.   |
| Both G and R are known.                           |
*---------------------------------------------------*;
data h;
   input Trait Animal Y;
   datalines;
1 1 6
1 2 8
1 3 7
2 1 9
2 2 5
2 3 .
;
data g;
   input Row Col1-Col6;
   datalines;
1  2  1  1  2   1     1
2  1  2 .5  1   2    .5
3  1 .5  2  1    .5  2
4  2  1  1  3   1.5  1.5
5  1  2 .5  1.5 3     .75
6  1 .5  2  1.5  .75 3
;
proc mixed data=h mmeq mmeqsol;
   class Trait Animal;
   model Y = Trait / noint s outp=predicted;
   random Trait*Animal / type=un gdata=g g gi s;
   repeated / type=un sub=Animal r ri;
   parms (4) (1) (5) / noiter;
run;
proc print data=predicted;
run;
