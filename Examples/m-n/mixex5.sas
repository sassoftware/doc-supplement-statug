/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIXEX5                                              */
/*   TITLE: Documentation Example 5 for PROC MIXED              */
/*          Random Coefficients                                 */
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

*-----------------Random Coefficients---------------*
| Data represent a random coefficients example      |
| from a pharmaceutical stability data simulation   |
| performed by Obenchain (1990).                    |
*---------------------------------------------------*;

data rc;
   input Batch Month @@;
   Monthc = Month;
   do i = 1 to 6;
      input Y @@;
      output;
   end;
   datalines;
 1   0  101.2 103.3 103.3 102.1 104.4 102.4
 1   1   98.8  99.4  99.7  99.5    .     .
 1   3   98.4  99.0  97.3  99.8    .     .
 1   6  101.5 100.2 101.7 102.7    .     .
 1   9   96.3  97.2  97.2  96.3    .     .
 1  12   97.3  97.9  96.8  97.7  97.7  96.7
 2   0  102.6 102.7 102.4 102.1 102.9 102.6
 2   1   99.1  99.0  99.9 100.6    .     .
 2   3  105.7 103.3 103.4 104.0    .     .
 2   6  101.3 101.5 100.9 101.4    .     .
 2   9   94.1  96.5  97.2 95.6     .     .
 2  12   93.1  92.8  95.4 92.2   92.2  93.0
 3   0  105.1 103.9 106.1 104.1 103.7 104.6
 3   1  102.2 102.0 100.8  99.8    .     .
 3   3  101.2 101.8 100.8 102.6    .     .
 3   6  101.1 102.0 100.1 100.2    .     .
 3   9  100.9  99.5 102.2 100.8    .     .
 3  12   97.8  98.3  96.9  98.4  96.9  96.5
;

proc mixed data=rc;
   class Batch;
   model Y = Month / s;
   random Int Month / type=un sub=Batch s;
run;

proc mixed data=rc;
   class Batch Monthc;
   model Y = Month / s;
   random Int Month Monthc / sub=Batch s;
run;

