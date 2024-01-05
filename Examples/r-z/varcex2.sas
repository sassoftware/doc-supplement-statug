/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: VARCEX2                                             */
/*   TITLE: Example 2 for PROC VARCOMP                          */
/*          Using the GRR Method                                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Gauge repeatability and reproducibility, GRR,       */
/*          Generalized confidence limits                       */
/*   PROCS: VARCOMP                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC VARCOMP, EXAMPLE 2.                            */
/*    MISC:                                                     */
/****************************************************************/

data Houf;
   input a b y @@;
   datalines;
1  1 37    1  1 38    1 1 37
1  2 41    1  2 41    1 2 40
1  3 41    1  3 42    1 3 41
2  1 42    2  1 41    2 1 43
2  2 42    2  2 42    2 2 42
2  3 43    2  3 42    2 3 43
3  1 30    3  1 31    3 1 31
3  2 31    3  2 31    3 2 31
3  3 29    3  3 30    3 3 28
4  1 42    4  1 43    4 1 42
4  2 43    4  2 43    4 2 43
4  3 42    4  3 42    4 3 42
5  1 28    5  1 30    5 1 29
5  2 29    5  2 30    5 2 29
5  3 31    5  3 29    5 3 29
6  1 42    6  1 42    6 1 43
6  2 45    6  2 45    6 2 45
6  3 44    6  3 46    6 3 45
7  1 25    7  1 26    7 1 27
7  2 28    7  2 28    7 2 30
7  3 29    7  3 27    7 3 27
8  1 40    8  1 40    8 1 40
8  2 43    8  2 42    8 2 42
8  3 43    8  3 43    8 3 41
9  1 25    9  1 25    9 1 25
9  2 27    9  2 29    9 2 28
9  3 26    9  3 26    9 3 26
10 1 35   10  1 34   10 1 34
10 2 35   10  2 35   10 2 34
10 3 35   10  3 34   10 3 35
;

proc varcomp data=Houf method=grr (speclimits=(18,58) ratio);
   class a b;
   model y=a|b/cl;
run;

proc varcomp data=Houf method=grr (speclimits=(18,58) ratio) seed=104;
   class a b;
   model y=a|b/cl=gcl;
run;

