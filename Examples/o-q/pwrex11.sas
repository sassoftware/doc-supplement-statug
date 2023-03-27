/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: pwrex11                                             */
/*   TITLE: Documentation Example 11 for PROC POWER             */
/*          (Logistic Regression with the CUSTOM Statement)     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: power                                               */
/*          sample size                                         */
/*          power analysis                                      */
/*          noncentrality                                       */
/*          logistic regression                                 */
/*   PROCS: POWER                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

* Compute P(Yj|Xi) values from conjectured betas;
data Exemplary;
   _B0 = 0; _B1 = -1.5; _B2 = 0.5; _B3 = 2;
   do X1 = 0 to 1;
      do X2 = 0 to 1;
         _pi = logistic(_B0 + _B1*X1 + _B2*X2 + _B3*X1*X2);
         do Y = 0 to 1;
            PY = _pi**Y * (1-_pi)**(1-Y);
            output;
         end;
      end;
   end;
   keep X1 X2 Y PY;
run;

proc print data=Exemplary;
run;

* Expand according to relative allocations of design profiles;
data Exemplary;
   set Exemplary;
   if      (X1 = 0 and X2 = 0) then _alloc=4;
   else if (X1 = 0 and X2 = 1) then _alloc=5;
   else if (X1 = 1 and X2 = 0) then _alloc=5;
   else                             _alloc=6;
   do _i = 1 to _alloc;
      output;
   end;
   keep X1 X2 Y PY;
run;

proc print data=Exemplary;
run;

* Run full model;
proc logistic data=Exemplary;
   ods output parameterestimates=fitFull fitstatistics=statsFull;
   weight PY;
   model Y(event='1') = X1 X2 X1*X2;
run;

* Fetch Wald chi-square statistic for test of X1*X2;
data fitFull;
   set fitFull;
   where Variable = "X1*X2";
   keep DF WaldChiSq;
run;

* Fetch -2LogL for full model;
data statsFull;
   set statsFull;
   where Criterion = "-2 Log L";
   Neg2LogLFull = InterceptAndCovariates;
   keep Neg2LogLFull;
run;

* Run reduced model;
proc logistic data=Exemplary;
   ods output fitstatistics=statsRed;
   weight PY;
   model Y = X1 X2;
run;

* Fetch -2LogL for reduced model;
data statsRed;
   set statsRed;
   where Criterion = "-2 Log L";
   Neg2LogLRed = InterceptAndCovariates;
   keep Neg2LogLRed;
run;

* Compute primary noncentralities for Wald and LR tests;
data PrimNC;
   merge fitFull statsFull statsRed;
   WaldPrimNC = WaldChiSq / 20;
   LRPrimNC = -(Neg2LogLFull-Neg2LogLRed) / 20;
   keep DF WaldPrimNC LRPrimNC;
   call symput ("DF", DF);
   call symput ("WaldPrimNC", WaldPrimNC);
   call symput ("LRPrimNC", LRPrimNC);
run;

proc print data=PrimNC;
run;

proc power;
   custom
      dist   = chisquare
      primnc = &WaldPrimNC &LRPrimNC
      testdf = &DF
      ntotal = 100
      power  = .;
run;

data Power;
   set PrimNC;
   Crit = quantile("chisq", 1-0.05, DF);
   WaldPower = sdf("chisq", Crit, DF, 100 * WaldPrimNC);
   LRPower = sdf("chisq", Crit, DF, 100 * LRPrimNC);
   keep WaldPower LRPower;
run;

proc print data=Power;
run;

