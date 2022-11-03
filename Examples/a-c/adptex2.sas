/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: adptex2                                             */
/*   TITLE: Example 2 for PROC ADAPTIVEREG                      */
/*    DESC: Simulated Data                                      */
/*     REF:                                                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: ADAPTIVEREG                                         */
/*                                                              */
/****************************************************************/

data Mixture;
   drop i;
   do i=1 to 1000;
      X1 = ranuni(1);
      C1 = int(3*ranuni(1));
      if C1=0 then Y=exp(5*(X1-0.3)**2)+rannor(1);
      else if C1=1 then Y=log(X1*(1-X1))+rannor(1);
      else Y=7*X1+rannor(1);
      output;
   end;
run;

ods graphics on;
proc adaptivereg data=Mixture plots=fit;
   class c1;
   model y=c1 x1;
run;

proc adaptivereg data=Mixture details=bases;
   class c1;
   model y=c1 x1;
run;
