/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCMVN                                             */
/*   TITLE: An Example that Uses Multivariate Distributions     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC                                           */
/*    MISC:                                                     */
/****************************************************************/

title 'An Example that Uses Multivariate Distributions';
proc iml;
   N = 100;
   Mean = {1 2};
   Cov =  {2.4 3, 3 8.1};
   call randseed(1);
   x = RANDNORMAL( N, Mean, Cov );

   SampleMean = x[:,];
   n = nrow(x);
   y = x - repeat( SampleMean, n );
   SampleCov = y`*y / (n-1);
   print SampleMean Mean, SampleCov Cov;

   cname = {"x1", "x2"};
   create inputdata from x [colname = cname];
   append from x;
   close inputdata;
quit;

proc mcmc data=inputdata seed=17 nmc=3000 diag=none;
   ods select PostSumInt;
   array data[2] x1 x2;
   array mu[2];
   array Sigma[2,2];
   array mu0[2] (0 0);
   array Sigma0[2,2] (100 0 0 100);
   array S[2,2] (1 0 0 1);
   parm mu Sigma;
   prior mu ~ mvn(mu0, Sigma0);
   prior Sigma ~ iwish(2, S);
   model data ~ mvn(mu, Sigma);
run;
