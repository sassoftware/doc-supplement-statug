/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCEX8                                             */
/*   TITLE: Documentation Example 8 for PROC MCMC               */
/*          Nonlinear Poisson Multilevel Random-Effects Model   */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC, EXAMPLE 8                                */
/*    MISC:                                                     */
/****************************************************************/

title 'Nonlinear Poisson Regression Random-Effects Model';
data pump;
   input y t group @@;
   pump = _n_;
   logtstd = log(t) - 2.4564900;
   datalines;
 5  94.320 1   1  15.720 2    5  62.880 1
14 125.760 1   3   5.240 2   19  31.440 1
 1   1.048 2   1   1.048 2    4   2.096 2
22  10.480 2
;


ods graphics on;
proc mcmc data=pump outpost=postout seed=248601 nmc=10000
   plots=trace stats=none diag=none;
   ods select tracepanel;
   array u[2] alpha beta;
   array mu[2] (0 0);
   parms s2;
   prior s2 ~ igamma(0.01, scale=0.01);
   random u ~ MVNAR(mu, sd=1e6, rho=0) subject=group monitor=(u);
   random e ~ normal(0, var=s2) subject=pump monitor=(random(1));
   w = alpha + beta * logtstd;
   lambda = exp(w+e);
   model y ~ poisson(lambda);
run;

proc mcmc data=pump outpost=postout_c seed=248601 nmc=10000
   plots=trace diag=none;
   ods select tracepanel postsumint;
   array u[2] alpha beta;
   array mu[2] (0 0);
   parms s2 1;
   prior s2 ~ igamma(0.01, scale=0.01);
   random u ~ MVNAR(mu, sd=1e6, rho=0) subject=group monitor=(u);
   w = alpha + beta * logtstd;
   random llambda ~ normal(w, var = s2) subject=pump monitor=(random(1));
   lambda = exp(llambda);
   model y ~ poisson(lambda);
run;

%CATER(data=postout_c, var=llambda_:);
ods graphics off;
