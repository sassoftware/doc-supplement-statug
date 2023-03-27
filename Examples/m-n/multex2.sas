/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MULTEX2                                             */
/*   TITLE: Example 2 for PROC MULTTEST                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple test,                                      */
/*          multiple comparisons                                */
/*   PROCS: MULTTEST                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC MULTTEST chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*----------------------------------------------------------------
Each observation represents an animal.  S1 and S2 are two tumor
types with 0=no tumor, 1=tumor.  Dose is the grouping variable,
T is the time of death of the animal.

Example provided by Keith Soper, Merck.
----------------------------------------------------------------*/

title 'Freeman-Tukey and t Tests with Bootstrap Resampling';

data a;
   input S1 S2 T Dose @@;
   datalines;
0 1 104 1   1 0  80 1   0 1 104 1
0 1 104 1   0 1 100 1   1 0 104 1
1 0  85 2   1 0  60 2   0 1  89 2
1 0  96 2   0 1  96 2   1 0  99 2
1 0  60 3   1 0  50 3   1 0  80 3
0 1  98 3   0 1  99 3   1 0  50 3
;

proc multtest data=a bootstrap nsample=10000 seed=37081 outsamp=res;
   test ft(S1 S2 / lowertailed) mean(T / lowertailed);
   class Dose;
   contrast 'Linear Trend' 0 1 2;
run;

proc print data=res(obs=36);
run;

