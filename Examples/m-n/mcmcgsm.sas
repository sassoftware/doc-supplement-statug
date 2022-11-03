/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCGSM                                             */
/*   TITLE: Simulation of Gamma and Inverse-Gamma Priors        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC                                           */
/*    MISC:                                                     */
/****************************************************************/
data a;
run;

ods graphics on;
ods select DensityPanel;
proc mcmc data=a stats=none diag=none nmc=10000 outpost=gout
   plots=density seed=1;
   parms gamma_3_is2 gamma_001_sc4 igamma_12_sc001 igamma_2_is01;
   prior gamma_3_is2     ~  gamma(shape=3, iscale=2);
   prior gamma_001_sc4   ~  gamma(shape=0.01, scale=4);
   prior igamma_12_sc001 ~ igamma(shape=12, scale=0.01);
   prior igamma_2_is01   ~ igamma(shape=2, iscale=0.1);
   model general(0);
run;
ods graphics off;
