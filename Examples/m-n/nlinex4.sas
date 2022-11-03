
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlinex4                                             */
/*   TITLE: Documentation Example 4 for PROC NLIN               */
/*          Affecting Curvature Through Parameterization        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Reparameterization                                  */
/*          Log-logistic model                                  */
/*          Smoothness condition                                */
/*   PROCS: NLIN, SGPLOT                                        */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data logistic;
   input dose y;
   logdose = log(dose);
   datalines;
0.009  106.56
0.035   94.12
0.07    89.76
0.15    60.21
0.20    39.95
0.28    21.88
0.50     7.46
;


proc sgplot data=logistic;
   scatter y=y x=dose;
   xaxis type=log logstyle=linear;
run;

proc nlin data=logistic bias hougaard nlinmeasures;
   parameters alpha=100 beta=3 gamma=300;
   delta = 0;
   Switch = 1/(1+gamma*exp(beta*log(dose)));
   model y = delta + (alpha - delta)*Switch;
run;

proc nlin data=logistic bias hougaard;
   parameters alpha=100 beta=3 LD50=0.15;
   delta = 0;
   Switch = 1/(1+exp(beta*log(dose/LD50)));
   model y = delta + (alpha - delta)*Switch;
   output out=nlinout pred=p lcl=lcl ucl=ucl;
run;

proc nlin data=logistic bias hougaard nlinmeasures;
   parameters alpha=100 mustar=20 LD50=0.15;
   delta   = 0;
   xstar   = 0.3;
   beta    = log((alpha - mustar)/(mustar - delta)) / log(xstar/LD50);
   Switch  = 1/(1+exp(beta*log(dose/LD50)));
   model y = delta + (alpha - delta)*Switch;
   output out=nlinout pred=p lcl=lcl ucl=ucl;
run;
