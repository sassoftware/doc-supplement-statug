/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlmex6                                              */
/*   TITLE: Documentation Example 6 for PROC NLMIXED            */
/*          Simulated nested linear random effects model        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: NLMIXED                                             */
/*    DATA: Little et al(2006)                                  */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

%let na = 100;
%let nb = 5;
%let nr = 2;
data nested;
   do A = 1 to &na;
      err1 = 3*rannor(339205);
      do B = 1 to &nb;
         err2 = 2*rannor(0);
         do rep = 1 to &nr;
            err3 = 1*rannor(0);
            resp = 10 + err1 + err2 + err3;
            output;
         end;
      end;
   end;
run;

proc nlmixed data = nested;
   bounds vara >=0, varb_a >=0;
   mean = intercept + aeffect + beffect;
   model resp ~ normal (mean, s2);
   random aeffect ~ normal(0,vara) subject = A;
   random beffect ~ normal(0,varb_a) subject = B(A);
run;

