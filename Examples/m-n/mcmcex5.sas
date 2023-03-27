/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCEX5                                             */
/*   TITLE: Documentation Example 5 for PROC MCMC               */
/*          Poisson Regression                                  */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC, EXAMPLE 5                                */
/*    MISC:                                                     */
/****************************************************************/

title 'Poisson Regression';
data insure;
   input n c car $ age;
   ln = log(n);
   datalines;
   500   42  small  0
   1200  37  medium 0
   100    1  large  0
   400  101  small  1
   500   73  medium 1
   300   14  large  1
;

proc transreg data=insure design;
   model class(car / zero=last);
   id n c age ln;
   output out=input_insure(drop=_: Int:);
   run;

proc mcmc data=input_insure outpost=insureout nmc=5000 propcov=quanew
          maxtune=0 seed=7;
   ods select PostSumInt;
   array data[4] 1 &_trgind age;
   array beta[4] alpha beta_car1 beta_car2 beta_age;
   parms alpha beta:;
   prior alpha beta: ~ normal(0, prec = 1e-6);
   call mult(data, beta, mu);
   model c ~ poisson(exp(mu+ln));
run;

proc genmod data=insure;
   ods select PostSummaries PostIntervals;
   class car age(descending);
   model c = car age / dist=poisson link=log offset=ln;
   bayes seed=17 nmc=5000 coeffprior=normal;
run;

