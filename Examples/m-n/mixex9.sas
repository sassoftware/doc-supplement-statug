/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIXEX9                                              */
/*   TITLE: Documentation Example 9 for PROC MIXED              */
/*          Examining Individual Test Components                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mixed Linear Models                                 */
/*   PROCS: MIXED                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Tianlin Wang                                        */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

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

proc mixed data=sp;
   class a b block;
   model y = a b a*b / LComponents e3;
   random block a*block;
run;

proc mixed data=sp;
   class a b block ;
   model y = a b a*b;
   random block a*block;
   estimate 'a    1' a 1 0 -1;
   estimate 'a    2' a 0 1 -1;
   estimate 'b    1' b   1 -1;
   estimate 'a*b  1' a*b 1 -1 0  0 -1 1;
   estimate 'a*b  2' a*b 0  0 1 -1 -1 1;
   ods select Estimates;
run;

data polynomial;
   do x=1 to 20; input y@@; output; end;
   datalines;
1.092   1.758   1.997   3.154   3.880
3.810   4.921   4.573   6.029   6.032
6.291   7.151   7.154   6.469   7.137
6.374   5.860   4.866   4.155   2.711
;

proc mixed data=polynomial;
   model y = x x*x x*x*x / s lcomponents htype=1,3;
run;

