/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlinex7                                             */
/*   TITLE: Documentation Example 7 for PROC NLIN               */
/*          Parameter Profiling and bootstrap                   */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Parameter Profiling                                 */
/*          Bootstrap                                           */
/*          ODS Graphics                                        */
/*          Diagnostics                                         */
/*   PROCS: NLIN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data clarke1987a;
   input  x y;
   datalines;
1    3.183
2    3.059
3    2.871
4    2.622
5    2.541
6    2.184
7    2.110
8    2.075
9    2.018
10   1.903
11   1.770
12   1.762
13   1.550
;

ods graphics on;
proc nlin data=clarke1987a plots(stats=none)=diagnostics;
   parms theta1=-0.15
         theta2=2.0
         theta3=0.80;
   profile theta1 theta3 / range = -6 to 2 by 0.2 all;
   bootstrap / nsamples = 2000 seed=123 bootplots bootci bootcov;
   model y = theta3 + theta2*exp(theta1*x);
run;
ods graphics off;
