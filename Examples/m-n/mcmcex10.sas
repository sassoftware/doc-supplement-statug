/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCEX10                                            */
/*   TITLE: Documentation Example 10 for PROC MCMC              */
/*          Missing At Random Analysis                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC, EXAMPLE 10                               */
/*    MISC:                                                     */
/****************************************************************/


title 'Missing at Random Analysis';
data air;
   input y x1 x2 @@;
   datalines;
 0  0  0   0  0  0   0  1  0   0  0  0   0  0 11   0  1  7
 0  0  8   0  1 10   0  1  9   0  0  0   1  1  6   0  1 10
 0  1 12   0  0  .   0  0  0   0  1  0   0  1  7   1  1 15
 0  0  8   0  0  0   1  1  0   1  0  6   0  0  0   1  1 11
 0  0  0   1  0  0   1  0  5   0  0  8   0  0  0   0  1  9
 0  1 16   0  0  0   1  1  9   1  0  0   1  1  8   1  0  9
 0  0  7   0  0  0   0  1  8   0  0  0   1  0  .   0  1  0
 0  0 11   1  1  0   0  1 10   0  0  9   0  1 13   1  1  0
 0  0 12   0  .  .   1  1 11   0  0 11   1  0  0   0  0  0
 0  0  .   1  0 16   0  1  8   0  1  9   0  1  .   0  0  0
 0  1  8   1  1  5   0  0  0   0  1 10   0  0  6   0  1  .
 1  1 12   0  1  0   0  1  3   0  0  0   0  1  .   0  0 12
 1  0  0   1  1  0   0  0  7   1  0  9   1  1  0   0  0 13
 1  0  0   1  1 11   0  0 12   1  1  0   1  1  .   0  0  0
 0  1  0   0  1 10   0  1 14   0  1  .   0  0  9   0  0  .
 0  1 10   0  .  0   0  .  0   1  1  6   0  0  0   0  1  0
 0  1 11   0  0 12   0  0 11   0  0  5   0  0  0   1  0  0
 0  0  7   1  1 15   0  1 10   0  0  0   0  0  0   0  0  6
 0  0  0   1  1  0   1  0  0   0  0  6   0  0  0   0  0  8
 0  1 15   0  1  0   0  1 10   1  0  .   0  1 12   0  1  0
 0  0  0   1  1  0   0  0  0   0  1  7   0  1  0   0  0  0
 0  1 10   0  0  7   1  0  0   0  0  4   0  0  0   1  0  0
 0  1 13   0  0 11   0  0  0   0  1  5   0  1  0   0  0  9
 1  0 11   0  1  7   0  0  6   0  0 14   0  0  0   1  0  0
 1  0  0   1  0 10   0  1  0   0  0 13   0  1  0   1  0 13
 1  1  6   1  1  0   1  1  0   0  0 14   0  0  0   0  0 12
 0  1  0   0  0  .   0  0  0   0  1  0   0  1  9   0  0  0
 0  1  0   0  0  0   0  1 12   0  1  9   1  . 10   0  0  0
 0  0  3   0  1  0   1  0 13   1  0  0   1  1  0   0  0  .
 0  0  .   0  0  0   0  1  7   0  0  .   1  1  0   0  1  0
 0  1 10   1  0 13   0  0  .   0  1  0   1  0  9   0  1  0
 0  1  0   0  0 10   1  1  0   0  0  0   0  0  0   0  1  0
 0  0  0   0  .  0   0  0  0   0  0  .   0  1  9   0  0  0
 0  1  0   0  0 13   1  1  5   0  1  9   1  1  .   0  0  0
 0  0  0   0  0  2   0  1 14   0  1  0   0  1  0   0  0  .
 0  0  7   1  0  .   1  1  0   0  0  0   0  1  0   0  1  0
 0  1  0   1  1  0   0  0 10   1  1 11   0  0  0   0  1  5
 0  1  6   1  1 15   0  1  0   1  0  0   0  0  0   0  1 11
 0  1  6   0  0  9   0  .  8   0  1  0   1  1  7   1  1  0
 1  1 11   0  0  7   1  1 12   0  0  7   0  1  0   0  1  0
 1  1  0   0  0 14   0  1  0   0  0  0   0  0  .   0  0  0
 1  0  9   0  0  .   0  0 14   0  1  0   1  0 13   1  1  0
 0  1  0   0  0  9   1  0  6   0  1  0   0  0  1   0  0  0
 1  0  0   0  1  0   0  0 10   0  1  0   0  1  0   1  0  0
 0  1  0   1  1  .   0  1 12   1  1  6   1  0 11   0  0  0
 1  1  .   0  1  0   0  .  0   1  1  0   0  0  0   1  0  7
 0  0  0   0  0  0   1  1  0   0  0  6   1  1 13   0  1  0
 0  1  0   0  0 13   0  0  0   0  0  0   0  1  8   0  0  0
 1  0  0   0  1 12   1  1  0   0  0  8   0  0  0   0  1 16
 0  0  0   0  .  0   0  0  0   0  0  .   0  1  0   0  1 12
 1  1  .   0  0  0   1  .  0   0  . 12   0  1  7   0  1  7
 0  0  .   1  .  0   0  0  0   0  1 14   0  1  0   1  0  8
 0  1  9   1  0  0   0  0  0   0  1  8   0  0  0   0  1  0
 1  0 14   0  0  .   1  1  0   1  0  9   0  0 13   1  1  0
 0  0 13   0  0  .   0  0  5   0  1  0   0  1  0   0  .  5
 0  0 13   0  1  0   0  0  0   1  1  0   0  0  0   0  1  0
 0  0  0   0  0 10   0  0  0   0  0  0   0  0  0   0  0  9
 0  1  0   0  0  0   0  1  0   0  0 17   0  0 13   0  0  0
 0  .  0   0  1  6   0  1  9   0  0  9   1  1  .   0  1  0
 1  0  0   1  0 13   1  0 10   0  0 12   0  1  7   0  0  8
 0  0 11   0  0  0   0  0  6   0  0 12   0  0 10   0  1 10
 0  1 11   0  0  9   1  0 11   0  1  7   0  0  7   0  0  0
 0  . 11   1  1  6   0  0  8   0  0  0   0  1 12   0  0  0
 0  1  0   1  1  8   0  0  0   0  1 11   0  1  0   0  1  8
 0  .  0   1  0  0   1  1 10   0  .  4   1  1 16   0  . 13
;

proc mcmc data=air seed=1181 nmc=10000 monitor=(_parms_ orx1 orx2)
   diag=none plots=none;
   parms beta0 -1 beta1 0.1 beta2 .01;
   parms alpha10 0 alpha11 0 alpha20 0;

   prior beta: alpha1: ~ normal(0,var=10);
   prior alpha20 ~ normal(0,var=2);

   beginnodata;
   pm = exp(alpha20);
   orx1 = exp(beta1);
   orx2 = exp(beta2);
   endnodata;
   model x2 ~ poisson(pm) monitor=(1 3 10);
   p1 = logistic(alpha10 + alpha11 * x2);
   model x1 ~ binary(p1) monitor=(random(3));
   p = logistic(beta0 + beta1*x1 + beta2*x2);
   model y ~ binary(p);
run;

