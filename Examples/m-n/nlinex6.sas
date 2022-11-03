
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlinex6                                             */
/*   TITLE: Documentation Example 6 for PROC NLIN               */
/*          ODS Graphics and diagnostics                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics                                        */
/*          Diagnostics                                         */
/*   PROCS: NLIN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data contrived;
   input x1 x2 y;
   datalines;
-4.0   -2.5  -10.0
-3.0   -2.0   -5.0
-2.0   -1.5   -2.0
-1.0   -1.0   -1.0
 0.0    0.0    1.5
 1.0    1.0    4.0
 2.0    1.5    5.0
 3.0    2.0    6.0
 4.0    2.5    7.0
-3.5   -2.2   -7.1
-3.5   -1.7   -5.1
 3.5    0.7    6.1
 2.5    1.2    7.5
;


ods graphics on;
proc nlin data=contrived bias hougaard
        NLINMEASURES plots(stats=all)=(diagnostics);
   parms alpha=2.0
         gamma=0.0;
   model y = alpha*x1 + exp(gamma*x2);
run;
ods graphics off;
