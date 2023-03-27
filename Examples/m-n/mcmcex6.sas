/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCEX6                                             */
/*   TITLE: Documentation Example 6 for PROC MCMC               */
/*          Nonlinear Poisson Regression Models                 */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC, EXAMPLE 6                                */
/*    MISC:                                                     */
/****************************************************************/

title 'Nonlinear Poisson Regression';
data calls;
   input weeks calls @@;
   datalines;
1   0   1   2   2   2   2   1   3   1   3   3
4   5   4   8   5   5   5   9   6  17   6   9
7  24   7  16   8  23   8  27
;

ods graphics on;
proc mcmc data=calls outpost=callout seed=53197 ntu=1000 nmc=20000
       propcov=quanew stats=none diag=ess;
   ods select TADpanel ess;
   parms alpha -4 beta 1 gamma 2;
   prior gamma ~ gamma(3.5, scale=12);
   prior alpha ~ normal(-5, sd=0.25);
   prior beta  ~ normal(0.75, sd=0.5);
   lambda = gamma*logistic(alpha+beta*weeks);
   model calls ~ poisson(lambda);
run;

proc sgscatter data=callout;
   matrix alpha beta gamma;
run;

proc mcmc data=calls outpost=tcallout seed=53197 ntu=1000 nmc=20000
       propcov=quanew diag=ess plots=(trace) monitor=(alpha beta gamma);
   ods select PostSumInt ESS TRACEpanel;
   parms alpha -4 beta 1 delta 2;
   prior alpha ~ normal(-5, sd=0.25);
   prior beta  ~ normal(0.75, sd=0.5);
   prior delta ~ egamma(3.5, scale=12);
   gamma = exp(delta);
   lambda = gamma*logistic(alpha+beta*weeks);
   model calls ~ poisson(lambda);
run;

proc sgscatter data=tcallout;
   matrix alpha beta delta;
run;

proc mcmc data=calls outpost=tcallout seed=53197 ntu=1000 nmc=20000
       propcov=quanew diag=ess plots=trace
       monitor=(alpha beta gamma);
   parms alpha -4 kappa 1 delta 2;
   prior alpha ~ normal(-5, sd=0.25);
   lp = logpdf("normal", exp(kappa), 0.75, 0.5) + kappa;
   prior kappa ~ general(lp);
   prior delta ~ egamma(3.5, scale=12);
   gamma = exp(delta);
   beta = exp(kappa);
   lambda = gamma*logistic(alpha+beta*weeks);
   model calls ~ poisson(lambda);
run;

proc sgscatter data=tcallout;
   matrix alpha kappa delta;
run;
ods graphics off;

