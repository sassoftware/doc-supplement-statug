/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCREN                                             */
/*   TITLE: Regenerating Diagnostics Plots                      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC                                           */
/*    MISC:                                                     */
/****************************************************************/

ods select none;
proc mcmc data=sashelp.class nmc=50000 thin=5 outpost=classout seed=246810;
   parms beta0 0 beta1 0;
   parms sigma2 1;
   prior beta0 beta1 ~ normal(0, var = 1e6);
   prior sigma2 ~ igamma(3/10, scale = 10/3);
   mu = beta0 + beta1*height;
   model weight ~ normal(mu, var = sigma2);
run;
ods select all;

ods graphics on;
%tadplot(data=classout, var=beta0 logpost);
ods graphics off;

