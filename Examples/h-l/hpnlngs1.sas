/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: HPNLNGS1                                            */
/*   TITLE: Getting Started Example for PROC HPNLMOD            */
/* PRODUCT: HPSTAT                                              */
/*    KEYS: Nonlinear regression, Enzyme reaction model         */
/*   PROCS: HPNLMOD                                             */
/*    MISC: Estimating the Parameters in the Nonlinear Model    */
/*                                                              */
/****************************************************************/

data enzyme;
   input conc rate @@;
   datalines;
0.26 124.7   0.30 126.9
0.48 135.9   0.50 137.6
0.54 139.6   0.68 141.1
0.82 142.8   1.14 147.6
1.28 149.8   1.38 149.4
1.80 153.9   2.30 152.5
2.44 154.5   2.48 154.7
;

proc hpnlmod data=enzyme;
   parms theta1=0 theta2=0;
   model rate ~ residual(theta1*conc / (theta2 + conc));
run;

