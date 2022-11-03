/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCGS3                                             */
/*   TITLE: Getting Started Example 3 for PROC MCMC             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: random-effects model                                */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC, GETTING STARTED EXAMPLE 3                */
/*    MISC:                                                     */
/****************************************************************/

title 'Random-Effects Model';

data heights;
   input Family G$ Height @@;
   datalines;
1 F 67   1 F 66   1 F 64   1 M 71   1 M 72   2 F 63
2 F 63   2 F 67   2 M 69   2 M 68   2 M 70   3 F 63
3 M 64   4 F 67   4 F 66   4 M 67   4 M 67   4 M 69
;

data input;
   set heights;
   if g eq 'F' then gf = 1;
   else gf = 0;
   drop g;
run;

ods graphics on;
proc mcmc data=input outpost=postout nmc=50000 seed=7893 plots=trace;
   ods select Parameters REparameters PostSumInt tracepanel;
   parms b0 0 b1 0 s2 1 s2g 1;

   prior b: ~ normal(0, var = 10000);
   prior s: ~ igamma(0.01, scale = 0.01);
   random gamma ~ normal(0, var = s2g) subject=family monitor=(gamma);
   mu = b0 + b1 * gf + gamma;
   model height ~ normal(mu, var = s2);
run;
ods graphics off;
