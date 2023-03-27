/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCDES                                             */
/*   TITLE: Create Design Matrix for Bayesian Analysis          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC                                           */
/*    MISC:                                                     */
/****************************************************************/

title 'Create Design Matrix';
data categorical;
   input City$ G$ x resp @@;
   datalines;
Chicago F 69.0 112.5  Chicago F 56.5  84.0
Chicago M 65.3  98.0  Chicago M 59.8  84.5
NewYork M 62.8 102.5  NewYork M 63.5 102.5
NewYork F 57.3  83.0  NewYork M 57.5  85.0
;

proc transreg data=categorical design;
   model class(city g city*g / zero=last);
   id x resp;
   output out=input_mcmc(drop=_: Int:);
run;

proc print data=input_mcmc;
run;

