/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCEX1                                             */
/*   TITLE: Documentation Example 1 for PROC MCMC               */
/*          Simulating Samples From a Known Density             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC, EXAMPLE 1                                */
/*    MISC:                                                     */
/****************************************************************/

/****************************************************************/
/*              Sampling from a Normal Density                  */
/****************************************************************/

title 'Simulating Samples from a Normal Density';
data x;
run;

ods graphics on;
proc mcmc data=x outpost=simout seed=23 nmc=10000 diagnostics=none;
   ods exclude nobs;
   parm alpha 0;
   prior alpha ~ normal(0, sd=1);
   model general(0);
run;

proc kde data=simout;
   ods exclude inputs controls;
   univar alpha /out=sample;
run;

data den;
   set sample;
   alpha = value;
   true  = pdf('normal', alpha, 0, 1);
   keep alpha density true;
run;

proc sgplot data=den;
   yaxis label="Density";
   series y=density x=alpha / legendlabel = "MCMC Kernel";
   series y=true x=alpha / legendlabel = "True Density";
   discretelegend;
run;

/****************************************************************/
/*  Simple Macro that Generates Samples from a Distribution.    */
/****************************************************************/

%macro density(dist=, seed=0);
   %let savenote = %sysfunc(getoption(notes));
   options nonotes;
   title "&dist distribution.";
   data _a;
   run;

   ods select densitypanel postsumint;
   proc mcmc data=_a nmc=10000 diag=none nologdist
      plots=density seed=&seed;
      parms alpha;
      prior alpha ~ &dist;
      model general(0);
   run;

   proc datasets nolist;
      delete _a;
   run;
   options &savenote;
%mend;

%density(dist=beta(4, 12), seed=1);

proc mcmc data=x outpost=simout seed=23 nmc=10000 nologdist
   monitor=(int) diagnostics=none;
   ods select postsumint;
   parm alpha 0;
   prior alpha ~ normal(0, sd=1);
   int = (0 <= alpha <= 1.3);
   model general(0);
run;

data _null_;
   int = cdf("normal", 1.3, 0, 1) - cdf("normal", 0, 0, 1);
   put int=;
run;

/****************************************************************/
/*        Sampling from a Mixture of Normal Densities           */
/****************************************************************/

title 'Simulating Samples from a Mixture of Normal Densities';
data x;
run;

proc mcmc data=x outpost=simout seed=1234 nmc=30000;
   ods select TADpanel;
   parm alpha 0.3;
   lp = logpdf('normalmix', alpha, 3, 0.3, 0.4, 0.3, -3, 2, 10, 2, 1, 4);
   prior alpha  ~ general(lp);
   model general(0);
run;

proc mcmc data=x outpost=simout_m seed=1234 nmc=30000;
   array p[3] (0.3 0.4 0.3);
   array mu[3] (-3 2 10);
   array sd[3] (2 1 4);
   parm z alpha;
   prior z ~ table(p);
   prior alpha ~ normal(mu[z], sd=sd[z]);
   model general(0);
run;

proc kde data=simout_m;
   ods exclude inputs controls;
   univar alpha /out=sample;
run;

data den;
   set sample;
   alpha = value;
   true  = pdf('normalmix', alpha, 3, 0.3, 0.4, 0.3, -3, 2, 10, 2, 1, 4);
   keep alpha density true;
run;

proc sgplot data=den;
   yaxis label="Density";
   series y=density x=alpha /
      legendlabel = "MCMC Kernel - Latent Variable Approach";
   series y=true x=alpha / legendlabel = "True Density";
   discretelegend;
run;

