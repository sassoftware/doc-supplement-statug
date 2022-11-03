/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCEX21                                            */
/*   TITLE: Documentation Example 21 for PROC MCMC              */
/*          Gelman-Rubin Diagnostics                            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC, EXAMPLE 21                               */
/*    MISC:                                                     */
/****************************************************************/

title 'Simple Linear Regression, Gelman-Rubin Diagnostics';

data init;
   input Chain beta0 beta1 sigma2;
   datalines;
   1   10  -5   1
   2  -15  10  20
   3    0   0  50
;

/* define constants */
%let nchain = 3;
%let nparm = 3;
%let nsim = 50000;
%let var = beta0 beta1 sigma2;

%macro gmcmc;
   %do i=1 %to &nchain;
      data _null_;
         set init;
         if Chain=&i;
         %do j = 1 %to &nparm;
            call symputx("init&j", %scan(&var, &j));
         %end;
         stop;
      run;

      proc mcmc data=sashelp.class outpost=out&i init=reinit nbi=0 nmc=&nsim
                stats=none seed=7;
         parms beta0 &init1 beta1 &init2;
         parms sigma2 &init3 / n;
         prior beta0 beta1 ~ normal(0, var = 1e6);
         prior sigma2 ~ igamma(3/10, scale = 10/3);
         mu = beta0 + beta1*height;
         model weight ~ normal(mu, var = sigma2);
      run;
   %end;
%mend;

ods exclude all;
%gmcmc;
ods exclude none;

data all;
   set out1(in=in1) out2(in=in2) out3(in=in3);
   if in1 then Chain=1;
   if in2 then Chain=2;
   if in3 then Chain=3;
run;

%gelman(all, &nparm, &var, &nsim);

data GelmanRubin(label='Gelman-Rubin Diagnostics');
   merge _Gelman_Parms _Gelman_Ests;
run;

proc print data=GelmanRubin;
run;


/* plot the trace plots of three Markov chains. */
%macro trace;
   %do i = 1 %to &nparm;
      proc sgplot data=all cycleattrs;
         series x=Iteration y=%scan(&var, &i) / group=Chain;
      run;
   %end;
%mend;
%modstyle(name=linestyle, linestyles=Solid)
ods listing style=linestyle;
%trace;

/* define sliding window size */
%let nwin = 200;
data PSRF;
run;

%macro PSRF(nsim);
   %do k = 1 %to %sysevalf(&nsim/&nwin, floor);
      %gelman(all, &nparm, &var, nsim=%sysevalf(&k*&nwin));
      data GelmanRubin;
         merge _Gelman_Parms _Gelman_Ests;
      run;

      data PSRF;
         set PSRF GelmanRubin;
      run;
   %end;
%mend PSRF;

options nonotes;
%PSRF(&nsim);
options notes;

data PSRF;
   set PSRF;
   if _n_ = 1 then delete;
run;

proc sort data=PSRF;
   by Parameter;
run;

%macro sepPSRF(nparm=, var=, nsim=);
   %do k = 1 %to &nparm;
      data save&k; set PSRF;
         if _n_ > %sysevalf(&k*&nsim/&nwin, floor) then delete;
         if _n_ < %sysevalf((&k-1)*&nsim/&nwin + 1, floor) then delete;
         Iteration + &nwin;
      run;

      proc sgplot data=save&k(firstobs=10) cycleattrs;
         series x=Iteration y=Estimate;
         series x=Iteration y=upperbound;
         yaxis label="%scan(&var, &k)";
      run;
   %end;
%mend sepPSRF;

%sepPSRF(nparm=&nparm, var=&var, nsim=&nsim);
