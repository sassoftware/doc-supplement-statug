/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlings                                              */
/*   TITLE: Getting Started Example for PROC NLIN               */
/*          Estimating the Parameters in the Nonlinear Model    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Nonlinear regression                                */
/*          Enzyme reaction model                               */
/*   PROCS: NLIN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data Enzyme;
   input Concentration Velocity @@;
   datalines;
0.26 124.7   0.30 126.9
0.48 135.9   0.50 137.6
0.54 139.6   0.68 141.1
0.82 142.8   1.14 147.6
1.28 149.8   1.38 149.4
1.80 153.9   2.30 152.5
2.44 154.5   2.48 154.7
;

proc nlin data=Enzyme method=marquardt hougaard;
   parms theta1=155
         theta2=0 to 0.07 by 0.01;
   model Velocity = theta1*Concentration / (theta2 + Concentration);
run;

proc nlin data=Enzyme method=newton listcode;
   parms x1=4 x2=2;
   model Velocity = x1 * exp (x2 * Concentration);
run;

