/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCEX20                                            */
/*   TITLE: Documentation Example 20 for PROC MCMC              */
/*          Using a Transformation to Improve Mixing            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC, EXAMPLE 20                               */
/*    MISC:                                                     */
/****************************************************************/

data inputdata;
   input nobs grp y @@;
   ind = _n_;
   datalines;
1 1 24.80 2 1 26.90 3 1 26.65
4 1 30.93 5 1 33.77 6 1 63.31
1 2 23.96 2 2 28.92 3 2 28.19
4 2 26.16 5 2 21.34 6 2 29.46
1 3 18.30 2 3 23.67 3 3 14.47
4 3 24.45 5 3 24.89 6 3 28.95
1 4 51.42 2 4 27.97 3 4 24.76
4 4 26.67 5 4 17.58 6 4 24.29
1 5 34.12 2 5 46.87 3 5 58.59
4 5 38.11 5 5 47.59 6 5 44.67
;

ods graphics on;
proc mcmc data=inputdata nmc=50000 thin=10 ntu=2000
          outpost=m1 seed=17797 plot=trace;
   parms p;
   parms tau;
   parms mu;

   prior p ~ uniform(0,1);
   prior tau ~ gamma(shape=0.001,iscale=0.001);
   prior mu ~ normal(0,prec=0.00000001);
   beginnodata;
   taub = tau/p;
   tauw = taub-tau;
   endnodata;

   random theta ~ normal(mu, prec=taub) subject=grp monitor=(theta);
   model y ~ normal(theta,prec=tauw);
run;

title 'Scatter Plot of Parameters on Original Scales';

proc sgplot data=m1;
   yaxis label = 'p';
   xaxis label = 'tau' values=(0 to 0.4 by 0.1);
   scatter x = tau y = p;
run;

proc mcmc data=inputdata nmc=50000 thin=10 outpost=m2 seed=17
          monitor=(p tau mu) plot=trace;
   ods select ess tracepanel;
   parms ltau lgp mu ;

   prior ltau ~ egamma(shape=0.001,iscale=0.001);
   prior lgp ~ logistic(0,1);
   prior mu ~ normal(0,prec=0.00000001);

   beginnodata;
   tau = exp(ltau);
   p = logistic(lgp);
   taub = tau/p;
   tauw = taub-tau;
   endnodata;

   random theta ~ normal(mu, prec=taub) subject=grp monitor=(theta);
   model y ~ normal(theta,prec=tauw);
run;

title 'Scatter Plot of Parameters on Transformed Scales';

proc sgplot data=m2;
   yaxis label = 'logit(p)';
   xaxis label = 'log(tau)';
   scatter x = ltau y = lgp;
run;

title 'Scatter Plot of Parameters on Original Scales';

proc sgplot data=m2;
   yaxis label = 'p';
   xaxis label = 'tau' values=(0 to 5.0 by 1);
   scatter x = tau y = p;
run;
ods graphics off;

