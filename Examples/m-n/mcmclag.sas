/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCLAG                                             */
/*   TITLE: Simple Dynamic Linear Model                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC                                           */
/*    MISC:                                                     */
/****************************************************************/

data dlm;
   input time y;
   datalines;
1   1.353412529
2   4.840739953
3   1.604892523
4   6.8947921
5   3.509644288
6   4.020173553
7   3.842884451
8   4.49057276
9   2.204570502
10   4.007351323
11   2.005515044
12   2.781756057
;

proc mcmc data=dlm outpost=dlmO nmc=20000 seed=23;
   ods select PostSumInt;
   parms alpha 0;
   parms var_y 1 var_mu 1;
   prior alpha ~ n(0, sd=10);
   prior var_y var_mu ~ igamma(shape=3, scale=2);
   random mu ~ n(mu.l1,var=var_mu) s=time icond=(alpha) monitor=(mu);
   model y~n(mu, var=var_y);
run;
