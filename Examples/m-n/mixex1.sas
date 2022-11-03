/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIXEX1                                              */
/*   TITLE: Documentation Example 1 for PROC MIXED              */
/*          Split-Plot Design                                   */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mixed Linear Models                                 */
/*   PROCS: MIXED                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

*---------------Split-Plot Example------------------*
| Data represent a balanced split-plot example and  |
| were reported by Stroup (1989).                   |
*---------------------------------------------------*;
data sp;
   input Block A B Y @@;
   datalines;
1 1 1  56  1 1 2  41
1 2 1  50  1 2 2  36
1 3 1  39  1 3 2  35
2 1 1  30  2 1 2  25
2 2 1  36  2 2 2  28
2 3 1  33  2 3 2  30
3 1 1  32  3 1 2  24
3 2 1  31  3 2 2  27
3 3 1  15  3 3 2  19
4 1 1  30  4 1 2  25
4 2 1  35  4 2 2  30
4 3 1  17  4 3 2  18
;
proc mixed;
   class A B Block;
   model Y = A B A*B;
   random Block A*Block;
run;
proc mixed data=sp;
   class A B Block;
   model Y = A B A*B;
   random Block A*Block;
   estimate 'a1 mean narrow'
             intercept 1 A 1 B .5 .5 A*B .5 .5 |
             Block     .25 .25 .25 .25
             A*Block   .25 .25 .25 .25 0 0 0 0 0 0 0 0;

   estimate 'a1 mean intermed'
             intercept 1 A 1 B .5 .5 A*B .5 .5 |
             Block     .25 .25 .25 .25;
   estimate 'a1 mean broad'
             intercept 1 a 1 b .5 .5 A*B .5 .5;
run;
