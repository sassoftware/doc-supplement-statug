/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCEX4                                             */
/*   TITLE: Documentation Example 4 for PROC MCMC               */
/*          Logistic Regression Model with Jeffreys' Prior      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC, EXAMPLE 4                                */
/*    MISC:                                                     */
/****************************************************************/

title 'Logistic Regression Model with Jeffreys Prior';
data vaso;
   input vol rate resp @@;
   lvol = log(vol);
   lrate = log(rate);
   ind = _n_;
   cnst = 1;
   datalines;
3.7  0.825  1  3.5  1.09  1  1.25  2.5   1  0.75  1.5  1
0.8  3.2    1  0.7  3.5   1  0.6   0.75  0  1.1   1.7  0
0.9  0.75   0  0.9  0.45  0  0.8   0.57  0  0.55  2.75 0
0.6  3.0    0  1.4  2.33  1  0.75  3.75  1  2.3  1.64  1
3.2  1.6    1  0.85 1.415 1  1.7   1.06  0  1.8  1.8   1
0.4  2.0    0  0.95 1.36  0  1.35  1.35  0  1.5  1.36  0
1.6  1.78   1  0.6  1.5   0  1.8   1.5   1  0.95 1.9   0
1.9  0.95   1  1.6  0.4   0  2.7   0.75  1  2.35 0.03  0
1.1  1.83   0  1.1  2.2   1  1.2   2.0   1  0.8  3.33  1
0.95 1.9    0  0.75 1.9   0  1.3   1.625 1
;

%let n = 39;
proc mcmc data=vaso nmc=10000 outpost=mcmcout seed=17;
   ods select PostSumInt;

   array beta[3] beta0 beta1 beta2;
   array m[&n, &n];
   array x[1] / nosymbols;
   array xt[3, &n];
   array xtm[3, &n];
   array xmx[3, 3];
   array p[&n];

   parms beta0 1 beta1 1 beta2 1;

   begincnst;
      if (ind eq 1) then do;
         rc = read_array("vaso", x, "cnst", "lvol", "lrate");
         call transpose(x, xt);
         call zeromatrix(m);
      end;
   endcnst;

   beginnodata;
   call mult(x, beta, p);              /* p = x * beta */
   do i = 1 to &n;
      p[i] = 1 / (1 + exp(-p[i]));     /* p[i] = 1/(1+exp(-x*beta)) */
      m[i,i] = p[i] * (1-p[i]);
   end;
   call mult (xt, m, xtm);             /* xtm = xt * m        */
   call mult (xtm, x, xmx);            /* xmx = xtm * x       */
   call det (xmx, lp);                 /* lp = det(xmx)       */
   lp = 0.5 * log(lp);                 /* lp = -0.5 * log(lp) */
   prior beta: ~ general(lp);
   endnodata;

   model resp ~ bern(p[ind]);
run;

proc genmod data=vaso descending;
   ods select PostSummaries PostIntervals;
   model resp = lvol lrate / d=bin link=logit;
   bayes seed=17 coeffprior=jeffreys nmc=20000 thin=2;
run;

