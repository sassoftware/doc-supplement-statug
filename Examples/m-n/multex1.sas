/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MULTEX1                                             */
/*   TITLE: Example 1 for PROC MULTTEST                         */
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
types with 0=no tumor, 1=tumor.  Dose is the grouping variable.
Example provided by Keith Soper, Merck.
----------------------------------------------------------------*/

title 'Cochran-Armitage Test with Permutation Resampling';

data a;
   input S1 S2 Dose @@;
   datalines;
0 1 1   1 0 1   0 1 1
0 1 1   0 1 1   1 0 1
1 0 2   1 0 2   0 1 2
1 0 2   0 1 2   1 0 2
1 0 3   1 0 3   1 0 3
0 1 3   0 1 3   1 0 3
;

proc multtest data=a permutation nsample=10000 seed=36607 outperm=pmt;
   test ca(S1 S2 / permutation=10 uppertailed);
   class Dose;
   contrast 'CA Linear Trend' 0 1 2;
run;
proc print data=pmt;
run;
