/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCEX13                                            */
/*   TITLE: Documentation Example 13 for PROC MCMC              */
/*          Exponential and Weibull Survival Analysis           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC, EXAMPLE 13                               */
/*    MISC:                                                     */
/****************************************************************/

data e1684;
   input t t_cen treatment @@;
   if t = . then do;
      t = t_cen;
      v = 0;
   end;
   else
      v = 1;
   ifn = treatment - 1;
   et = exp(t);
   lt = log(t);
   drop t_cen;
   datalines;
 1.57808  0.00000  2   1.48219  0.00000  2    .       7.33425  1
 2.23288  0.00000  1    .       9.38356  2   3.27671  0.00000  1
  .       9.64384  1   1.66575  0.00000  2   0.94247  0.00000  1
 1.68767  0.00000  2   2.34247  0.00000  2   0.89863  0.00000  1
  .       9.03288  2    .       9.63014  2   0.52603  0.00000  1
 1.82192  0.00000  2   0.93425  0.00000  1    .       8.98630  2
 3.35068  0.00000  1   8.67397  0.00000  1   0.41096  0.00000  2
 2.78630  0.00000  1   2.56438  0.00000  1    .       8.75342  2
 0.56986  0.00000  2    .       8.40000  1    .       7.25205  1
 4.38630  0.00000  2    .       8.36712  2    .       8.99178  2
 0.86575  0.00000  2    .       4.76986  1   1.15616  0.00000  2
  .       7.28767  1   3.13151  0.00000  1    .       8.55068  2
  .       8.45753  2   4.59452  0.00000  1   2.88219  0.00000  2
 0.89589  0.00000  1   1.76164  0.00000  2   .        7.81370  1
 .        8.33425  2   2.62192  0.00000  1   0.16164  0.00000  2
 .        8.24658  1   1.52603  0.00000  1   5.30959  0.00000  1
 0.87123  0.00000  2   0.41644  0.00000  1   4.24110  0.00000  1
 0.13699  0.00000  1   7.07671  0.00000  2   0.13151  0.00000  2
 .        8.02740  1   .        6.16164  2   1.29863  0.00000  2
 1.29041  0.00000  2   .        7.99726  1   .        8.34795  1
 .        7.30137  2   2.32877  0.00000  2   0.56438  0.00000  1
 5.62740  0.00000  2   1.23014  0.00000  1   .        7.94521  1
 5.06301  0.00000  1   3.27671  0.00000  2   .        0.60822  2
 0.65753  0.00000  1   0.84110  0.00000  2   .        8.40000  2
 0.18356  0.00000  1   2.62466  0.00000  2   .        7.96438  2
 .        7.77808  1   0.22192  0.00000  1   2.33973  0.00000  1
 0.52329  0.00000  1   .        8.04110  2   .        7.83288  1
 0.64110  0.00000  1   0.38356  0.00000  1   .        7.82192  2
 0.51781  0.00000  2   .        8.09863  2   .        8.16712  2
 4.42740  0.00000  1   0.88493  0.00000  1   2.78356  0.00000  1
 2.64658  0.00000  2   .        8.21370  2   .        7.41918  2
 0.99726  0.00000  1   5.88493  0.00000  2   0.41644  0.00000  1
 3.53699  0.00000  1   .        7.56164  1   .        7.53151  1
 0.27671  0.00000  1   0.76986  0.00000  2   .        7.62192  2
 .        7.79726  1   0.64110  0.00000  1   1.14521  0.00000  2
 2.01644  0.00000  1   2.84384  0.00000  1   .        7.00000  2
 1.27397  0.00000  2   .        7.09589  1   2.04110  0.00000  1
 0.83562  0.00000  1   0.92329  0.00000  1   0.07397  0.00000  1
  .       7.30685  2   2.07671  0.00000  2   .        7.70959  2
 .        6.15890  1   .        6.89315  2   3.30685  0.00000  1
 0.36164  0.00000  1   1.97808  0.00000  2   1.23836  0.00000  2
 0.10685  0.00000  1   .        7.63836  1   2.06301  0.00000  1
 .        7.42466  2   0.50959  0.00000  1   0.65753  0.00000  1
 .        6.93151  1   .        7.23288  2   6.01096  0.00000  1
 0.33699  0.00000  1   .        6.47123  2   0.94795  0.00000  1
 2.91781  0.00000  2   1.59726  0.00000  2   0.84932  0.00000  2
 1.38356  0.00000  1   3.81644  0.00000  2   .        7.06849  1
 .        7.04110  2   1.00274  0.00000  2   .        6.34795  2
 1.18082  0.00000  1   0.97534  0.00000  1   2.16712  0.00000  1
 .        6.85479  1   1.38356  0.00000  1   1.71507  0.00000  2
 0.79452  0.00000  2   .        6.86301  2   .        6.50411  1
 0.42466  0.00000  2   0.98630  0.00000  1   .        6.13699  2
 3.80000  0.00000  2   .        6.48493  1   .        6.96438  2
 .        6.78082  2   0.56164  0.00000  2   2.67123  0.00000  1
 1.56712  0.00000  2   2.07397  0.00000  2   0.33973  0.00000  1
 3.37808  0.00000  2   3.15068  0.00000  1    .       6.81096  2
 3.20822  0.00000  2   0.62740  0.00000  1   1.64384  0.00000  1
 1.40822  0.00000  1    .       6.06575  1   1.66301  0.00000  2
 1.36986  0.00000  2   5.46849  0.00000  1   0.42740  0.00000  1
 1.13973  0.00000  2   1.73699  0.00000  2   .        5.54521  2
 0.85205  0.00000  1   0.43014  0.00000  1   1.20822  0.00000  2
 4.36164  0.00000  1   0.52877  0.00000  2    .       6.51507  1
 2.89863  0.00000  2    .       6.20274  2   1.21644  0.00000  2
  .       6.00000  2    .       6.25479  1    .       6.49863  1
 1.13699  0.00000  2   1.69589  0.00000  1    .       6.41096  2
  .       6.02192  1   3.04932  0.00000  2    .       5.62740  2
 0.72603  0.00000  1   0.73425  0.00000  2   1.47945  0.00000  2
 0.37808  0.00000  2    .       5.75890  2   1.48219  0.00000  2
  .       5.88493  1    .       1.80274  1   1.40548  0.00000  2
  .       4.74795  1    .       5.24658  1   0.29041  0.00000  1
  .       5.83836  1    .       5.32055  2   5.16712  0.00000  2
  .       5.59178  2    .       5.77808  1   0.53425  0.00000  2
  .       2.22466  1   3.59726  0.00000  1   .        5.32329  1
 1.78630  0.00000  2   0.70411  0.00000  2    .       4.94795  2
  .       5.45479  2   4.32877  0.00000  1   1.16164  0.00000  2
  .       5.20274  2    .       4.40822  1   1.41096  0.00000  1
  .       4.92877  2    .       5.42192  2   0.98904  0.00000  1
 0.36438  0.00000  1    .       4.38082  1   0.77260  0.00000  2
 4.90959  0.00000  2   1.26849  0.00000  1   0.58082  0.00000  2
 .        4.95616  1   .        5.12329  1   .        4.74795  1
 .        4.90685  2   1.41918  0.00000  1   0.44110  0.00000  1
 .        4.29863  2   .        4.63836  2   .        4.81370  1
 4.50137  0.00000  2   3.92329  0.00000  2   .        4.86027  2
 0.52603  0.00000  1   2.10685  0.00000  2   .        4.24384  1
 3.39178  0.00000  1   .        4.36164  2   .        4.81918  2
;

/****************************************************************/
/*            Exponential Survival Model                        */
/****************************************************************/

title 'Exponential Survival Model';
ods graphics on;
proc mcmc data=e1684 outpost=expsurvout nmc=10000 seed=4861
   diag=(mcse ess);
   ods select PostSumInt TADpanel
              ess mcse;
   parms (beta0 beta1) 0;
   prior beta: ~ normal(0, sd = 10000);
   /*****************************************************/
   /* (1) the logpdf and logsdf functions are not used  */
   /*****************************************************/
   /*     nu = 1/exp(beta0 + beta1*ifn);
          llike = v*logpdf("exponential", t, nu) +
                  (1-v)*logsdf("exponential", t, nu);
   */
   /****************************************************/
   /* (2) the simplified likelihood formula is used    */
   /****************************************************/
   l_h = beta0 + beta1*ifn;
   llike = v*(l_h) -  t*exp(l_h);
   model general(llike);
run;

/****************************************************************/
/*            Weibull Survival Model                            */
/****************************************************************/

title 'Weibull Survival Model';
proc mcmc data=e1684 outpost=weisurvout nmc=10000 seed=1234
          monitor=(_parms_ surv_ifn surv_noifn) stats=(summary intervals);
   ods select PostSummaries;
   ods output PostSummaries=ds PostIntervals=is;
   array surv_ifn[10];
   array surv_noifn[10];
   parms alpha 1 (beta0 beta1) 0;
   prior beta: ~ normal(0, var=10000);
   prior alpha ~ gamma(0.001,is=0.001);

   beginnodata;
      do t1 = 1 to 10;
         surv_ifn[t1] = exp(-exp(beta0+beta1)*t1**alpha);
         surv_noifn[t1] = exp(-exp(beta0)*t1**alpha);
      end;
   endnodata;

   lambda = beta0 + beta1*ifn;
   /*****************************************************/
   /* (1) the logpdf and logsdf functions are not used  */
   /*****************************************************/
   /*     gamma =  exp(-lambda /alpha);
          llike = v*logpdf('weibull', t, alpha, gamma) +
                  (1-v)*logsdf('weibull', t, alpha, gamma);
   */
   /****************************************************/
   /* (2) the simplified likelihood formula is used    */
   /****************************************************/
   llike  = v*(log(alpha) + (alpha-1)*log(t) + lambda) -
            exp(lambda)*(t**alpha);
   model general(llike);
run;

proc format;
   value alphafmt low-<1 = 'alpha < 1' 1-high = 'alpha >= 1';
run;

proc freq data=weisurvout;
   tables alpha /nocum;
   format alpha alphafmt.;
run;

/* define macro stackdata */
%macro StackData(dataset,output,vars);
   data &output;
      length var $ 32;
      if 0 then set &dataset nobs=nnn;
      array lll[*] &vars;
      do jjj=1 to dim(lll);
         do iii=1 to nnn;
            set &dataset point=iii;
            value = lll[jjj];
            call vname(lll[jjj],var);
            output;
         end;
      end;
      stop;
      keep var value;
   run;
%mend;

/* stack the surv_ifn variables and saved them to survifn. */
%StackData(weisurvout, survifn, surv_ifn1-surv_ifn10);

proc sgplot data=survifn;
   yaxis label='Survival Probability' values=(0 to 1 by 0.2);
   xaxis label='Time' discreteorder=data;
   vbox value / category=var;
run;

data surv;
   set ds;
   if _n_ >= 4 then do;
      set is point=_n_;
      group = 'with interferon   ';
      time = _n_ - 3;
      if time > 10 then do;
         time = time - 10;
         group = 'without interferon';
      end;
      output;
   end;
   keep time group mean hpdlower hpdupper;
run;

proc sgplot data=surv;
   yaxis label="Survival Probability" values=(0 to 1 by 0.2);
   series x=time y=mean / group = group name='i';
   band x=time lower=hpdlower upper=hpdupper / group = group transparency=0.7;
   keylegend 'i';
run;
ods graphics off;

/****************************************************************/
/*      Model Comparison between Weibull and Exponential        */
/****************************************************************/

title 'Model Comparison between Weibull and Exponential';
proc mcmc data=e1684 outpost=weisurvout nmc=10000 seed=4861 dic;
   ods select dic;
   parms alpha 1 (beta0 beta1) 0;
   prior beta: ~ normal(0, var=10000);
   prior alpha ~ gamma(0.001,is=0.001);

   lambda = beta0 + beta1*ifn;
   llike  = v*(log(alpha) + (alpha-1)*log(t) + lambda) -
            exp(lambda)*(t**alpha);
   model general(llike);
run;

proc mcmc data=e1684 outpost=expsurvout nmc=10000 seed=4861 dic;
   ods select dic;
   parms beta0 beta1 0;
   prior beta: ~ normal(0, var=10000);
   begincnst;
      alpha = 1;
   endcnst;

   lambda = beta0 + beta1*ifn;
   llike  = v*(log(alpha) + (alpha-1)*log(t) + lambda) -
            exp(lambda)*(t**alpha);
   model general(llike);
run;

proc mcmc data=e1684 outpost=expsurvout1 nmc=10000 seed=4861 dic;
   ods select none;
   parms (beta0 beta1) 0;
   prior beta: ~ normal(0, sd = 10000);
   l_h = beta0 + beta1*ifn;
   llike = v*(l_h) -  t*exp(l_h);
   model general(llike);
run;

proc compare data=expsurvout compare=expsurvout1;
   var beta0 beta1;
run;
