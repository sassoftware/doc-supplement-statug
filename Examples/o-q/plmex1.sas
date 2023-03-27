/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: plmex1                                              */
/*   TITLE: Example 1 for PROC PLM                              */
/*    DESC: Simulated Data                                      */
/*     REF:                                                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: LOGISTIC,PLM                                        */
/*                                                              */
/****************************************************************/

%let nObs   = 5000;
%let nVars  = 100;
data SimuData;
   array x{&nVars};
   do obsNum=1 to &nObs;
      do j=1 to &nVars;
         x{j}=ranuni(1);
      end;

      linp =  10 + 11*x1 - 10*sqrt(x2) + 2/x3 - 8*exp(x4) + 7*x5*x5
             - 6*x6**1.5 + 5*log(x7) - 4*sin(3.14*x8) + 3*x9 - 2*x10;
      TrueProb = 1/(1+exp(-linp));

      if ranuni(1) < TrueProb then y=1;
                              else y=0;
      output;
   end;
run;

proc logistic data=SimuData;
   effect splines = spline(x1-x&nVars/separate);
   model y = splines/selection=stepwise;
   store sasuser.SimuModel;
run;

data test;
   array x{&nVars};
   do j=1 to &nVars;
      x{j}=0.15;
   end;
   drop j;
   output;
run;

proc plm restore=sasuser.SimuModel;
   score data=test out=testout predicted / ilink;
run;

data testout;
   set testout(drop=x1-x&nVars);
run;
proc print data=testout;
run;

